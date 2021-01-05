import 'dart:async';

import 'package:flutter/cupertino.dart';

import 'cube_dimensions.dart';

class CubeStreamNotifier {
  var _stream = StreamController<bool>.broadcast();

  dispose() {
    _stream.close();
  }

  notify(bool value) {
    _stream.sink.add(value);
  }

  get stream => _stream.stream;
}

class CubeController {
  String id;
  List<CubeDimension> dimensionOptions;
  List<CubeDimension> rows;
  List<CubeDimension> columns;
  List<CubeDimension> values;
  List<dynamic> sources;
  List<Map<String, dynamic>> dataView = [];
  List<CubeDimension> aggrs = [];
  //List<CubeDimension> dataDim = [];
  CubeController() {
    dataStream = StreamController<dynamic>.broadcast();
  }
  StreamController<dynamic> dataStream;
  dispose() {
    dataStream.close();
  }

  get stream => dataStream.stream;

  get dimensions {
    return [...rows, ...columns, ...values, ...dimensionOptions, ...aggrs];
  }

  findByName(String name) {
    var it;
    dimensions.forEach((item) {
      if (item.name == name) it = item;
    });
    return it;
  }

  valueAdd(item, {index = -1}) {
    values.remove(item);
    if (index < 0)
      values.add(item);
    else
      values.insert(index, item);
    dimensionOptions.remove(item);
    columns.remove(item);
    rows.remove(item);
    optionChange();
  }

  rowAdd(item, {index = -1}) {
    rows.remove(item);
    if (index < 0)
      rows.add(item);
    else
      rows.insert(index, item);
    dimensionOptions.remove(item);
    columns.remove(item);
    values.remove(item);
    optionChange();
  }

  optionsAdd(item, {index = -1}) {
    if (dimensionOptions.contains(item)) return;
    begin();
    try {
      if (index < 0)
        dimensionOptions.add(item);
      else
        dimensionOptions.insert(index, item);
      rows.remove(item);
      columns.remove(item);
      values.remove(item);
    } finally {
      end();
    }
  }

  optionChange() {
    calculate();
  }

  columnAdd(item, {index = -1}) {
    columns.remove(item);
    if (index < 0)
      columns.add(item);
    else
      columns.insert(index, item);
    dimensionOptions.remove(item);
    rows.remove(item);
    values.remove(item);
    optionChange();
  }

  revisar() {
    // remove se estiver em um item
    rows.forEach((item) => dimensionOptions.remove(item));
    columns.forEach((item) => dimensionOptions.remove(item));
    values.forEach((item) => dimensionOptions.remove(item));
  }

  var _bloq = 0;
  Map<String, int> keyPosition = {};
  calculate() {
    if (_bloq > 0) return;

    /// monta a lista do data view
    dataView = [];
    aggrs = [];
    keyPosition = {};

    // crias as linhas
    // monta as chaves
    if (rows.length > 0)
      sources.forEach((item) {
        // construir as colunas de chave
        var key = _calcVKey(item, '');
        if (!keyPosition.containsKey(key)) {
          Map<String, dynamic> data = {};
          rows.forEach((row) {
            data[row.name] = item[row.name];
          });

          /// nao tem valores, adicionar as colunas como linhas simples
          if ((values.length == 0)) {
            columns.forEach((row) {
              data[row.name] = item[row.name];
            });
          }
          dataView.add(data);
          keyPosition[key] = dataView.length - 1;
        } // stub para mostrar alguma coisa.
      });

    // ordenar as colunas
    dataView.sort((a, b) {
      var ka = a.values.join(',');
      var kb = b.values.join(',');
      return ka.compareTo(kb);
    });

    /// cria as agregações de colunas

    columns.forEach((item) => _incluirColumn(item));
    if (aggrs.length == 0) _incluirColumnSumario();

    /// calcular o valor aggregados
    _obterValues(); //);
    if (aggrs.length > 0) _totalAdd();

    _incluirColunaTotal();

    dataStream.sink.add(dataView);
  }

  _incluirColunaTotal() {
    var k;
    int conta = aggrs.length;
    int position = 0;
    var result;
    int x = 0;
    for (var i = 0; i < conta; i++) {
      var agg = aggrs[i + position];
      result ??= agg;
      k ??= agg.dataName;
      if (k != agg.dataName) {
        _incluirSum(agg);
        position++;
        k = agg.dataName;
        result = agg;
      }
    }

    aggrs.forEach((agg) {
      if (agg.aggrType != CubeViewAggrType.none) x++;
    });
    if (x > 1) {
      if (result != null) _incluirSum(result);
      _somarColunas();
    }
  }

  _kSum(agg) {
    return 'soma_${agg.dataName}';
  }

  _incluirSum(agg) {
    var k = 'Soma|${agg.aggrName}';
    var col = findByName(agg.aggrName);
    if (col != null) k = 'Soma|${col.label ?? col.name}';
    aggrs.add(CubeDimension(
      name: _kSum(agg),
      label: k,
      aggrType: CubeViewAggrType.virtual,
    )
      ..aggrName = agg.aggrName
      ..dataName = agg.dataName);
  }

  _somarColunas() {
    dataView.forEach((row) {
      double v = 0.0;
      //double x = 0;
      String k;
      aggrs.forEach((agg) {
        if (agg.aggrType != CubeViewAggrType.none) {
          k ??= agg.dataName;
          if (agg.aggrType == CubeViewAggrType.virtual) {
            // resultado
            row[agg.name] = v;
            v = 0;
            //x = 0;
            k = null;
          } else {
            //x++;
            v = v + row[agg.name] + 0.0;
          }
        }
      });
    });
  }

  _incluirColumn(item) {
    Map<String, dynamic> cols = {};
    // cria a lista de colunas
    sources.forEach((row) {
      var key = '${item.name}_${row[item.name]}';
      if (!cols.containsKey(key)) cols[key] = row[item.name];
    });
    cols.forEach((k, v) {
      values.forEach((aggr) {
        var split = k.split('_');
        var name = '${k}_${aggr.name}';
        var col = findByName(split[0]);
        String vv;
        if (col.onGetValue != null) vv = col.onGetValue(v);
        vv ??= '$v';
        var l = (col != null) ? '${col.label}_$vv' : k;
        aggrs.add(CubeDimension(
          name: name,
          label: '$l'.replaceAll('_', '|'), //_${aggr.name}
          viewType: CubeViewType.data,
          onGetValue: aggr.onGetValue,
          builder: aggr.builder,
        )
          ..dataName = split[0]
          ..data = v
          ..aggrName = aggr.name
          ..aggrType = aggr.aggrType);
      });
    });
  }

  _incluirColumnSumario() {
    // quando não tem colunas, incluir somente o Totalizador
    values.forEach((item) {
      aggrs.add(CubeDimension(
        name: item.name,
        label: item.label,
        viewType: item.viewType,
        onGetValue: item.onGetValue,
        builder: item.builder,
        aggrType: item.aggrType,
      )..aggrName = item.name);
    });
  }

  int _calcGap() {
    return (rows.length > 1) ? 1 : 1;
  }

  _obterTotaisSimples() {
    Map<String, dynamic> data = {"total": "Total"};
    aggrs.forEach((item) {
      _aplicarFormula(data, null, item.aggrType, item, item.aggrName);
    });
    dataView.add(data);
    aggrs.insert(
        0,
        CubeDimension(
          aggrType: CubeViewAggrType.none,
          name: 'total',
          label: 'Total',
        ));
  }

  _obterValues() {
    /// reset nos valores
    aggrs.forEach((aggr) {
      aggr.partKeyValue = null;
      aggr.curKeyValue = null;
      aggr.partValue = 0;
      aggr.totalValue = 0;
    });
    // cruza os valores;
    var position = 0;
    var conta = dataView.length;
    if (conta == 0) return _obterTotaisSimples();
    for (var iRow = 0; iRow < (conta); iRow++) {
      var row = dataView[position];
      if (!'${row[rows[0].name]}'.contains('Sub-Total')) {
        aggrs.forEach((aggr) {
          var key = _calcVKey(row, '', gap: _calcGap());
          if (_subtotalAdd(position, key, false)) {
            // n++;
            position++;
          }
          var formula = aggr.aggrType;
          var vKey = aggr.aggrName;
          _aplicarFormula(row, key, formula, aggr, vKey);
        });
      }
      position++;
    }
    if (aggrs.length > 0) _subtotalAdd(position, '', true);
  }

  _aplicarFormula(Map<String, dynamic> row, String key,
      CubeViewAggrType formula, CubeDimension aggr, String vKey) {
    /// obter valores com base na formula indicada.
    dynamic v = 0.0;
    switch (formula) {
      case CubeViewAggrType.sum:

        /// coluna de somatorios.
        v = _sumValues(row, _calcVKey(row, ''), vKey, aggr.data, aggr.dataName);
        aggr.partValue += v;
        aggr.totalValue += v;
        aggr.partKeyValue ??= key;
        aggr.curKeyValue = key;
        row[aggr.name] = v;
        break;
      case CubeViewAggrType.none:

        /// não tem nenhuma formula, é uma coluna de visualização simples.
        row[aggr.name] = row[aggr.name];
        aggr.curKeyValue = key;
        break;
      default:
    }
  }

  bool _subtotalAdd(position, String curKey, bool fim) {
    var n = 0;
    if (!fim)
      aggrs.forEach((item) {
        if ((item.partKeyValue ?? curKey) != curKey) n++;
      });
    if ((n > 0) || fim) {
      // incluir subtotal;
      Map<String, dynamic> st = {};
      st[rows[0].name] = '   Sub-Total';
      aggrs.forEach((item) {
        st[item.name] = item.partValue;
        item.partValue = 0;
        item.partKeyValue = curKey;
        item.curKeyValue = curKey;
      });
      if (fim)
        dataView.add(st);
      else
        dataView.insert(position, st);
      return true;
    }
    return n > 0;
  }

  bool _totalAdd() {
    if (rows.isEmpty) return false;
    var n = aggrs.length;

    if ((n > 0)) {
      Map<String, dynamic> st = {};
      st[rows[0].name] = ' Total';
      aggrs.forEach((item) {
        st[item.name] = item.totalValue;
      });
      dataView.add(st);
      return true;
    }
    return n > 0;
  }

  _sumValues(row, key, vKey, data, dataKey) {
    var v = 0.0;
    sources.forEach((r) {
      if (_calcVKey(r, '') == key) {
        // e a linha procurada; para a coluna do cubo.
        if ((data == null) || (r[dataKey] == data))
          v = v + (((r[vKey] ?? 0) + 0.0) ?? 0.0);
      }
    });

    return v;
  }

  _calcVKey(Map<String, dynamic> row, String aggr, {int gap}) {
    String r = '';

    for (var i = 0; i < (gap ?? rows.length); i++) {
      var item = rows[i];
      r += ((r != '') ? '-' : '') + '${row[item.name] ?? ''}';
    }

    if (aggr != '') r += aggr;
    return r;
  }

  begin() {
    _bloq++;
  }

  end() {
    _bloq--;
    if (_bloq < 0) _bloq = 0;
    if (_bloq <= 0) optionChange();
  }

  notifyChange() {
    dataStream.sink.add(dataView);
  }

  double get rowsWidth {
    double r = 0;
    rows.forEach((item) => r += item.width);
    if (r == 0) r = 100;
    return r;
  }

  double get columnsWidth {
    double r = 0;
    columns.forEach((item) => r += item.width);
    return r;
  }
}

class DefaultCube extends InheritedWidget {
  final CubeController controller;

  DefaultCube({Key key, Widget child, @required this.controller})
      : super(key: key, child: child);
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }

  static DefaultCube of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<DefaultCube>();
}
