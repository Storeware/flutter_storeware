import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';
import 'package:controls_extensions/extensions.dart' hide DynamicExtension;
import 'package:controls_data/odata_firestore.dart';

/*

 Resumo para Dashboard

 */

class Sigcaut1HoraItem extends DataItem {
  String? codigo;
  DateTime? data;
  String? hora;
  double? qtde;
  String? grupo;
  double? filial;
  double? total;
  int? itens;

  Sigcaut1HoraItem(
      {this.codigo,
      this.data,
      this.hora,
      this.qtde,
      this.grupo,
      this.filial,
      this.total});

  Sigcaut1HoraItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }
  @override
  fromMap(Map<String, dynamic> json) {
    codigo = json['codigo'];
    data = toDateTime(json['data']);
    hora = json['hora'];
    qtde = toDouble(json['qtde']);
    grupo = json['grupo'];
    filial = toDouble(json['filial']);
    total = toDouble(json['total']);
    itens = toInt(json['itens']);
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['codigo'] = this.codigo;
    data['data'] = this.data;
    data['hora'] = this.hora;
    data['qtde'] = this.qtde;
    data['grupo'] = this.grupo;
    data['filial'] = this.filial;
    data['total'] = this.total;
    data['itens'] = this.itens; // é virtual;
    data['id'] = '$filial-${this.data.format('yyyyMMdd')}$hora';
    return data;
  }
}

class Sigcaut1HoraItemModel extends ODataModelClass<Sigcaut1HoraItem> {
  Sigcaut1HoraItemModel() {
    collectionName = 'sigcaut1_hora';
    super.API = ODataInst();
    super.CC = CloudV3().client;
  }
  Sigcaut1HoraItem newItem() => Sigcaut1HoraItem();

  Future<ODataResult?> resumoDiaHora({DateTime? data, filial}) {
    String dt = ((data ?? DateTime.now())).toIso8601String().substring(0, 10);
    String qry =
        "select data,hora, sum(qtde) qtde,sum(total) total, count(*) itens from sigcaut1_hora " +
            "where data = '$dt' ${(filial != null) ? ' and filial=$filial' : ''} " +
            "group by data,hora ";
    return API!.openJson(qry).then((rsp) {
      return ODataResult(json: rsp);
    });
  }

  Future<ODataResult> resumoDia({DateTime? inicio, DateTime? fim, filial}) {
    DateTime? _de = inicio;
    if (_de == null) {
      _de = DateTime.now().startOfMonth();
    }
    DateTime? _ate = fim;
    if (_ate == null) _ate = DateTime.now().endOfMonth();
    String qry =
        "select data, sum(qtde) qtde,sum(total) total, count(*) itens from sigcaut1_hora " +
            "where data between '${_de.toIso8601String().substring(0, 10)}' and '${_ate.toIso8601String().substring(0, 10)}' ${(filial != null) ? ' and filial=$filial' : ''} " +
            "group by data ";
    return API!.openJson(qry).then((rsp) {
      return ODataResult(json: rsp);
    });
  }

  rankDoDia({DateTime? data, top = 10, skip = 0}) {
    DateTime? dt = data;
    String ini = toDateSql(dt.startOfMonth());
    String hoje = toDateSql(dt.toDate());
    String ontem = toDateSql(dt.toDate().add(Duration(days: -1)));
    String qry;
    if (API!.driver == 'mssql')
      qry = "select " +
          "max(data) data,  " +
          "sum(case when data = '$ontem' then total else 0 end) ontem,  " +
          "sum(case when data = '$hoje' then total else 0 end) subtotal,  " +
          "sum(total) total ,sum(qtde) qtde from SIGCAUT1_HORA " +
          "where data>='$ini' " +
          "order by total desc " +
          "OFFSET $skip ROWS FETCH NEXT $top ROWS ONLY";
    else
      qry = "select " +
          "max(data) data,  " +
          "sum(case when data = '$ontem' then total else 0 end) ontem,  " +
          "sum(case when data = '$hoje' then total else 0 end) subtotal,  " +
          "sum(total) total ,sum(qtde) qtde from SIGCAUT1_HORA " +
          "where data>='$ini' " +
          "order by total desc " +
          "rows ${skip + 1} to ${top + skip}";
    return API!.openJson(qry).then((rsp) => rsp['result']);
  }

  produtosMaisVendidos(
      {String? filter,
      DateTime? dataDe,
      DateTime? dataAte,
      top = 30,
      skip = 0}) {
    DateTime dt = dataDe ?? DateTime.now();
    dataAte = dataAte ?? dt;
    String ini = toDateSql(dt.startOfMonth());
    String hoje = toDateSql(dataAte.toDate());
    String qry =
        "select b.*, (select sum(qestfin) from ctprodsd s where s.codigo=b.codigo) estoque from ("
                "select a.data,a.codigo,b.nome , a.qtde, a.total, rank() over (order by total desc ) rank from  " +
            "(" +
            "select data,codigo,sum(qtde) qtde, sum(total) total  from SIGCAUT1_HORA " +
            "where data between '$ini' and '$hoje' " +
            "group by codigo,data " +
            "order by total desc " +
            ") a, ctprod b " +
            "where a.codigo=b.codigo   " +
            "rows ${skip + 1} to ${top + skip} ) b " +
            "${(filter != null) ? 'where ' + filter : ''} ";

    return API!.openJson(qry).then((rsp) => rsp['result']);
  }

  toDateSql(DateTime data) {
    // print(data);
    return data.toIso8601String().substring(0, 10);
  }

  toDateTimeSql(DateTime data) {
    return data.toIso8601String().substring(0, 19).replaceAll('T', ' ');
  }

  contaProdutoSemVendas({DateTime? data}) {
    String d =
        toDateSql(data ?? DateTime.now().toDate().add(Duration(days: -30)));
    String qry = "select count(*) conta " +
        "from ctprod a " +
        "where " +
        "  a.publicaweb='S' " +
        "  and " +
        "  ( " +
        "  not exists  (select codigo from sigcaut1_hora b where a.codigo=b.codigo and b.data>='$d'  ) " +
        "  ) ";
    return API!.openJson(qry).then((rsp) => rsp['result']);
  }

  produtosSemVenda(
      {DateTime? data, filter, top, skip, double filialEstoque = 1}) {
    String d =
        toDateSql(data ?? DateTime.now().toDate().add(Duration(days: -30)));
    String qry;
    if (API!.driver == 'mssql') {
      /// TODO: refazer o select para MSSQL
      qry = "select x.*, (select sum(qestfin) from ctprodsd s where s.codigo=x.codigo) estoque  from ("
              "select codigo,nome,precoweb,unidade  " +
          "from ctprod a " +
          "where " +
          "  ${(filter != null) ? filter + ' and ' : ''}" +
          "  a.publicaweb='S' " +
          "  and " +
          "  ( " +
          "  not exists  (select codigo from sigcaut1_hora b where a.codigo=b.codigo and b.data>='$d'  ) " +
          "  ) ROWS ${skip + 1} to ${top + skip} ) x   " +
          "  ";
    } else
      qry = "select x.*, (select sum(qestfin) from ctprodsd s where s.codigo=x.codigo) estoque  from ("
              "select codigo,nome,precoweb,unidade  " +
          "from ctprod a " +
          "where " +
          "  ${(filter != null) ? filter + ' and ' : ''}" +
          "  a.publicaweb='S' " +
          "  and " +
          "  ( " +
          "  not exists  (select codigo from sigcaut1_hora b where a.codigo=b.codigo and b.data>='$d'  ) " +
          "  ) rows ${skip + 1} to ${top + skip} ) x   " +
          "  ";
    return API!.openJson(qry).then((rsp) => rsp['result']);
  }

  resumoPorAtalho({DateTime? inicio, DateTime? fim, filial}) {
    DateTime? _de = inicio;
    if (_de == null) {
      _de = DateTime.now().startOfMonth();
    }
    DateTime? _ate = fim;
    if (_ate == null) _ate = DateTime.now().endOfMonth();
    var qry = "select t.nome, x.total, x.itens from " +
        "(" +
        "select b.CODTITULO,  " +
        "  sum(a.total) total, count(*) itens " +
        "from sigcaut1_hora a join CTPROD_ATALHO_ITENS b on (b.CODPROD=a.codigo)" +
        "          where data between '${_de.toIso8601String().substring(0, 10)}' and '${_ate.toIso8601String().substring(0, 10)}' ${(filial != null) ? ' and filial=$filial' : ''} " +
        "group by b.CODTITULO " +
        ") x , CTPROD_ATALHO_TITULO t " +
        "where x.codtitulo = t.codigo order by 2 desc";
    return API!.openJson(qry).then((rsp) {
      return rsp['result'];
    });
  }

  evolucao({DateTime? inicio, DateTime? fim, filial}) {
    DateTime? _de = inicio;
    if (_de == null) {
      _de = DateTime.now().startOfMonth();
    }
    DateTime? _ate = fim;
    if (_ate == null) _ate = DateTime.now().endOfMonth();
    var qry = "select data, sum(total) total, count(*) itens " +
        "from sigcaut1_hora " +
        "          where data between '${_de.toIso8601String().substring(0, 10)}' and '${_ate.toIso8601String().substring(0, 10)}' ${(filial != null) ? ' and filial=$filial' : ''} " +
        "group by data ";
    return API!.openJson(qry).then((rsp) {
      return rsp['result'];
    });
  }

  evolucaoPorVendedor(
      {String? vendedor, DateTime? inicio, DateTime? fim, filial}) {
    DateTime? _de = inicio;
    if (_de == null) {
      _de = DateTime.now().startOfMonth();
    }
    DateTime? _ate = fim;
    if (_ate == null) _ate = DateTime.now().endOfMonth();
    var qry = "select data, sum(total) total, count(*) itens " +
        "from sigcauth " +
        "          where vendedor eq '$vendedor' and data between '${_de.toIso8601String().substring(0, 10)}' and '${_ate.toIso8601String().substring(0, 10)}' ${(filial != null) ? ' and filial=$filial' : ''} " +
        "group by data ";
    return API!.openJson(qry).then((rsp) {
      return rsp['result'];
    });
  }
}
