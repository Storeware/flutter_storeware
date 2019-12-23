import 'package:flutter/material.dart';
import 'dart:async';
import 'package:controls_web/controls/rounded_button.dart';
import 'package:controls_web/controls/home_elements.dart';
import 'package:controls_web/controls/defaults.dart';

class DataGridPageColumn {
  String label;
  String name;
  final Function(dynamic) onClick;
  dynamic controller;
  bool required = true;
  bool readOnly;
  final Function canChangeEvent;
  final double width;
  bool hide;
  final Function(dynamic) onGetValue;
  final Function(dynamic) onGetChild;
  final Function(dynamic) onEditChild;
  DataGridPageColumn(
      {this.label,
      this.name,
      this.width,
      this.hide,
      this.onClick,
      this.readOnly,
      this.canChangeEvent,
      this.onGetValue,
      this.onGetChild,
      this.onEditChild});
}

class DataGridPage extends StatefulWidget {
  final Function onNewClick;
  final Function onColumnCreate;
  final Function onRowCreate;
  final dataSnap;
  final List<DataGridPageColumn> columns;
  final Function(Map<String, dynamic>) onEdit;
  final onSelectedChange;
  final Function(String, Map<String, dynamic>) onColumnClick;
  final bool canChange;
  final Function onDeleteClick;
  final Function onInactive;
  final bool inactive;
  final Map<String, dynamic> initialValues;
  final onRowEdit;
  DataGridPage(
      {Key key,
      this.initialValues,
      this.onRowEdit,
      this.dataSnap,
      this.canChange,
      this.onColumnCreate,
      this.onRowCreate,
      this.onInactive,
      this.inactive = false,
      this.onNewClick,
      this.onDeleteClick,
      this.columns,
      this.onEdit,
      this.onColumnClick,
      this.onSelectedChange})
      : super(key: key);
  _DataGridPageState createState() => _DataGridPageState();
}

class _DataGridPageState extends State<DataGridPage> {
  var inactive;
  @override
  Widget build(BuildContext context) {
    return _createBody(context);
  }

  @override
  initState() {
    inactive = widget.inactive;
    super.initState();
  }

  var _notifier = StreamController<bool>.broadcast();

  _createBody(context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            RoundedButton(
              height: 30,
              color: Theme.of(context).primaryColor,
              buttonName: 'Novo', //Translate.string('Novo'),
              onTap: () {
                if (widget.onRowEdit != null) widget.onRowEdit({});
                if (widget.canChange) widget.onNewClick();
              },
            ),
            if (widget.onInactive != null)
              Row(children: [
                Text(inactive ? 'inativos' : 'disponíveis'),
                Switch(
                    value: inactive,
                    //activeTrackColor: Colors.red,
                    activeColor: Colors.red,
                    inactiveThumbColor: Theme.of(context).primaryColor,
                    //inactiveTrackColor: Theme.of(context).primaryColor,
                    onChanged: (b) {
                      inactive = !inactive;
                      widget.onInactive(inactive);
                    }),
              ])
          ],
        ),
        FutureBuilder(
            // alterado de stream para future -
            future: widget.dataSnap,
            builder: (x, d) {
              print('grid->dataTable ${d.hasData} ${d.data}');
              _createDataSource(d.data);
              return StreamBuilder<bool>(
                  initialData: true,
                  stream: _notifier.stream,
                  builder: (x, s) {
                    var col = widget.columns[dataSortIndex - 1];
                    dataSource.sort((a, b) {
                      return a[col.name].compareTo(b[col.name]) *
                          (ascendent ? 1 : -1);
                    });

                    return DataTable(
                      sortAscending: ascendent,
                      sortColumnIndex: dataSortIndex,
                      columns: (widget.columns != null)
                          ? _columns(d.data)
                          : widget.onColumnCreate(d.data),
                      rows: (widget.columns != null)
                          ? _rows(d.data)
                          : widget.onRowCreate(d.data),
                    );
                  });
            }),
      ],
    );
  }

  bool ascendent = true;
  int dataSortIndex = 1;

  List<DataColumn> _columns(data) => <DataColumn>[
        if (widget.onDeleteClick != null) DataColumn(label: Container()),
        for (var item in widget.columns)
          if (!(item.hide ?? false))
            DataColumn(
                label: Text(item.label /*Translate.string(item.label)*/),
                onSort: (colIdx, asc) {
                  ascendent = asc;
                  dataSortIndex = colIdx;
                  _notifier.sink.add(true);
                }),
      ];

  generateValue(DataGridPageColumn item, d, index) {
    var v = d[item.name];
    if (item.onGetValue != null) v = item.onGetValue(v);
    Widget g;
    if (item.onGetChild != null) g = item.onGetChild(v);
    if (g == null) g = Text(v.toString() ?? '');
    return DataCell(
      Container(
        width: item.width,
        child: g,
      ),
      onTap: () {
        if (widget.onColumnClick != null) widget.onColumnClick(item.name, d);
      },
    );
  }

  List<Map<String, dynamic>> dataSource = [];
  _createDataSource(snaps) {
    dataSource = [];
    if (snaps == null) return dataSource;
    if (snaps.runtimeType.toString().contains('QuerySnapshot')) {
      snaps.forEach((docs) {
        docs.forEach((f) {
          var d = f.data();
          d['id'] = f.id;
          dataSource.add(d);
        });
      });
    } else
      snaps.docs.forEach((f) {
        print('doc f: $f');
        var d = f.data();
        d['id'] = f.id;
        dataSource.add(d);
      });
    return dataSource;
  }

  List<DataRow> _rows(snaps) {
    List<DataRow> rows = [];
    // lopping
    var index = -1;
    dataSource.forEach((d) {
      index++;
      List<DataCell> rt = [
        if (widget.onDeleteClick != null)
          DataCell(
            Container(
              width: 70,
              child: Stack(//direction: Axis.horizontal,
                  children: [
                IconButton(
                  icon: Icon(inactive
                      ? Icons.add_circle_outline
                      : Icons.remove_circle_outline),
                  onPressed: () {
                    widget.onDeleteClick(d);
                  },
                ),
                Positioned(
                    left: 35,
                    child: IconButton(
                      icon: Icon(Icons.mode_edit),
                      onPressed: () {
                        if (widget.onRowEdit != null) widget.onRowEdit(d);
                        if (widget.canChange) widget.onEdit(d);
                      },
                    ))
              ]),
            ),
          ),
        for (var item in widget.columns)
          if (!(item.hide ?? false)) generateValue(item, d, index),
      ];
      rows.add(DataRow(
          key: UniqueKey(),
          cells: rt,
          onSelectChanged: widget.onSelectedChange));
    });

    return rows;
  }
/*
  BoxDecoration _kSelectedDecoration() => BoxDecoration(
        //border: new Border(bottom: Divider.createBorderSide(context, width: 1.0)),
        color: selectedRowBackgroundColor,
      );
  BoxDecoration _kUnselectedDecorationEven() => BoxDecoration(
        //border: new Border(bottom: Divider.createBorderSide(context, width: 1.0)),
        color: alternateRowBackgroundColorEven,
      );
  BoxDecoration _kUnselectedDecorationOdd() => BoxDecoration(
        //border: new Border(bottom: Divider.createBorderSide(context, width: 1.0)),
        color: alternateRowBackgroundColorOdd,
      );
*/
}

var selectedRowBackgroundColor = Colors.red; // Colors.grey[300];
var alternateRowBackgroundColorOdd = Colors.transparent;
var alternateRowBackgroundColorEven = Colors.grey[300];

class DataGridScaffold extends StatefulWidget {
  final Widget title;
  final double cardElevation;
  final List<Widget> actions;
  final Function onNewClick;
  final Function onDeleteClick;
  final Function onGetValues;
  final Function(String) onStateChange;
  final Function onColumnCreate;
  final Function onRowCreate;
  final dataSnap;
  final List<DataGridPageColumn> columns;
  final Function(Map<String, dynamic>) onEdit;
  final Function(int) onNext;
  final Function onFirst;
  final Function onLast;
  final bool readOnly;
  final bool canChange;
  final onSelectedChange;
  final onColumnClick;
  final Function onSave;
  final Function onInactive;
  final bool inactive;
  final Map<String, dynamic> initialValues;
  final Function(Map<String, dynamic>) onRowEdit;
  DataGridScaffold(
      {Key key,
      this.initialValues,
      this.title,
      this.actions,
      this.onColumnCreate,
      this.readOnly = false,
      this.canChange = true,
      this.onGetValues,
      this.onNext,
      this.onFirst,
      this.onLast,
      this.columns,
      this.dataSnap,
      this.onRowEdit,
      this.onEdit,
      this.onSave,
      this.onDeleteClick,
      this.cardElevation = 0.0,
      this.onNewClick,
      this.onStateChange,
      this.onInactive,
      this.inactive = false,
      this.onRowCreate,
      this.onColumnClick,
      this.onSelectedChange})
      : super(key: key);
  _DataGridScaffoldState createState() => _DataGridScaffoldState();
}

class _DataGridScaffoldState extends State<DataGridScaffold> {
  @override
  Widget build(BuildContext context) {
    print('scaffold - grid create');
    return Scaffold(
      backgroundColor: defaultScaffoldBackgroudColor,
      appBar: _createAppBar(),
      body: _createBody(),
    );
  }

  _createAppBar() {
    print('createAppBar');
    return AppBar(title: widget.title, actions: widget.actions);
  }

  createNavigationBar() => Container(
      //color: Colors.red,
      height: 40,
      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        if (widget.onFirst != null)
          IconButton(
              icon: Icon(Icons.first_page),
              onPressed: () {
                widget.onFirst();
              }),
        if (widget.onNext != null)
          IconButton(
              icon: Icon(Icons.navigate_before),
              onPressed: () {
                widget.onNext(-1);
              }),
        if (widget.onNext != null)
          IconButton(
              icon: Icon(Icons.navigate_next),
              onPressed: () {
                widget.onNext(1);
              }),
        if (widget.onLast != null)
          IconButton(
              icon: Icon(Icons.last_page),
              onPressed: () {
                widget.onLast();
              }),
      ]));

  _createBody() {
    print('createBody');
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SliverContents(children: [
        Card(
            elevation: widget.cardElevation,
            child: DataGridPage(
              onRowEdit: widget.onRowEdit,
              initialValues: widget.initialValues,
              onInactive: widget.onInactive,
              inactive: widget.inactive,
              canChange: widget.canChange,
              dataSnap: widget.dataSnap,
              onNewClick: widget.readOnly
                  ? () {}
                  : widget.onNewClick ??
                      () {
                        //print('onClick');
                        _onNewClick();
                      },
              onDeleteClick: widget.onDeleteClick,
              onEdit: widget.readOnly
                  ? (x) {}
                  : widget.onEdit ??
                      (x) {
                        _onEditClick(x);
                      },
              columns: widget.columns,
              onColumnClick: widget.onColumnClick,
              onSelectedChange: widget.onSelectedChange,
            )),
        createNavigationBar()
      ]),
    );
  }

  _onGetValues() {
    var r = (widget.onGetValues != null) ? widget.onGetValues() : {};
    print('onGetValues->$r');
    return r;
  }

  _onNewClick() {
    Navigator.of(context).push(MaterialPageRoute(builder: (x) {
      print('DataNew');
      if (widget.onStateChange != null) widget.onStateChange('new');
      print('loading GridItemView');
      return DataGridItemView(
        title: Row(children: [
          Text('Novo - ' /*Translate.string('Novo - ')*/),
          widget.title
        ]),
        data: _onGetValues(),
        columns: widget.columns,
        onSave: widget.onSave,
      );
    }));
  }

  _onEditClick(Map<String, dynamic> data) {
    Navigator.of(context).push(MaterialPageRoute(builder: (x) {
      print('DataEdit');
      if (widget.onStateChange != null) widget.onStateChange('edit');
      //print(data);
      return DataGridItemView(
        title: Row(children: [
          Text('Alteração - ' /*Translate.string('Alteração - ')*/),
          widget.title
        ]),
        data: data,
        columns: widget.columns,
        onSave: widget.onSave,
      );
    }));
  }
}

class DataGridItemView extends StatefulWidget {
  final data;
  final Widget title;
  final List<DataGridPageColumn> columns;
  final Function onSave;
  DataGridItemView({Key key, this.title, this.data, this.columns, this.onSave})
      : super(key: key) {
    print('DataGridItemView->created');
  }
  _DataGridItemViewState createState() => _DataGridItemViewState();
}

class _DataGridItemViewState extends State<DataGridItemView> {
  @override
  void initState() {
    super.initState();
    print('_DataGridItemViewState - initState');
    _loadValues();
  }

  @override
  Widget build(BuildContext context) {
    print('_DataGridItemViewState');
    return Scaffold(
      appBar: _createAppBar(),
      body: SingleChildScrollView(child: _createBody()),
    );
  }

  _createAppBar() {
    return AppBar(title: widget.title, actions: [
      IconButton(
        icon: Icon(Icons.save),
        onPressed: () {
          _salvar();
        },
      ),
      IconButton(
          icon: Icon(Icons.undo),
          onPressed: () {
            setState(() {
              _loadValues();
            });
          })
    ]);
  }

  Map<String, TextFormField> formControls = {};
  Map<String, dynamic> values = {};

  int _currentIndex = -1;
  _createItem(DataGridPageColumn item) {
    _currentIndex++;
    if (item.onEditChild != null) {
      return item.onEditChild(values[item.name]);
    } else {
      var frm = TextFormField(
        autofocus: _currentIndex == 0,
        obscureText: item.hide ?? false,
        enabled: (item.canChangeEvent != null)
            ? item.canChangeEvent()
            : !(item.readOnly ?? false),
        initialValue: (values[item.name] ?? '').toString(),
        decoration: InputDecoration(
          labelText: item.label, // Translate.string(item.label),
        ),
        validator: (value) {
          if (item.required && value.isEmpty) {
            return 'Falta informar: ' + item.label;
          }
          return null;
        },
        onSaved: (x) {
          values[item.name] = x;
        },
      );
      formControls.addAll({item.name: frm});
      return frm;
    }
  }

  _loadValues() {
    print('_loadValues()');
    for (var key in widget.data.keys) {
      var v = widget.data[key];
      values[key] = v;
    }
  }

  _createFormControls() {
    if (formControls.length > 0) {
      return [for (var key in formControls.keys) formControls[key]];
    }
    _currentIndex = -1;
    List<Widget> rt = [];
    for (var item in widget.columns) rt.add(_createItem(item));

    rt.add(Divider());
    rt.add(SizedBox(
      height: 12,
    ));
    rt.add(RoundedButton(
      buttonName: 'Guardar',
      onTap: () {
        _salvar();
      },
    ));

    return rt;
  }

  final _formKey = GlobalKey<FormState>();
  _createBody() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
          key: _formKey,
          child: Column(
            children: _createFormControls(),
          )),
    );
  }

  _salvar() {
    print('_salvar-init');
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        var s = Scaffold.of(context);
        if (s != null)
          s.showSnackBar(SnackBar(
              content:
                  Text('Processando' /*Translate.string('Processando')*/)));
      } catch (x) {
        //
      }
      if (widget.onSave != null) {
        print('_salvar-onSave');
        var r = widget.onSave(values);
        if (r == null) {
          try {
            var scaff = Scaffold.of(context);
            if (scaff != null) Navigator.of(context).pop();
          } catch (x) {
            //
          }
        }
      }
    }
  }
}

createDataGridPageColumn(Map<String, dynamic> map, {bool showId = false}) {
  return [
    for (var item in map.keys)
      if (item != 'inativo')
        if ((item != 'id' || showId))
          DataGridPageColumn(label: item, name: item)
  ];
}
