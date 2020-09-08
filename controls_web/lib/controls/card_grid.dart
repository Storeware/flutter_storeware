import 'package:controls_web/drivers/bloc_model.dart';
import 'package:flutter/material.dart';

import 'dialogs_widgets.dart';

class CardGridController {
  var widget;
  BlocModel<dynamic> subscribeChanges = BlocModel<dynamic>();
  List<CardGridColumn> columns;
  List<dynamic> source = [];
  Map<String, dynamic> data;

  int _semaforo = 0;
  changeRow(Map<String, dynamic> row, CardGridChangeEvent event) {
    if (widget.onChangeEvent != null) {
      return widget.onChangeEvent(this, row, event).then((rsp) {
        bool b = (rsp is bool) ? rsp : true;
        if (b) {
          if (CardGridChangeEvent.insert == event) add(row);
          if (CardGridChangeEvent.delete == event) remove(row);
          if (CardGridChangeEvent.update == event) {
            int idx = source.indexOf(row);
            if (idx > -1) removeAt(idx);
          }
        }
      });
    }
    return true;
  }

  begin([value = true]) {
    _semaforo += value ? 1 : -1;
  }

  end() {
    _semaforo--;
    changed(true);
  }

  changed(bool value) {
    if (_semaforo <= 0) subscribeChanges.notify(source);
  }

  add(item) {
    source.add(item);
    changed(true);
  }

  remove(item) {
    source.remove(item);
    changed(true);
  }

  removeAt(index) {
    source.removeAt(index);
    changed(true);
  }

  update(index, item) {
    source[index] = item;
    changed(true);
  }

  indexOf(key, value) {
    for (int i = 0; i < source.length; i++) {
      if (source[i][key] == value) return i;
    }
    return -1;
  }
}

class CardGrid extends StatefulWidget {
  final List<dynamic> source;
  final Function(dynamic) builder;
  final CardGridController controller;
  final Future<dynamic> futureSource;
  final List<CardGridColumn> columns;
  final bool canInsert;
  final bool canDelete;
  final bool canUpdate;
  //final bool Function(CardGridController, dynamic, CardGridChangeEvent)    onEditItem;
  //final bool Function(CardGridController, dynamic) onNewItem;
  //final Future<dynamic> Function(CardGridController, dynamic) onDeleteItem;
  //final Function(CardGridController) onRefresh;
  //final Function(bool, CardGridController) onSelectChanged;
  final Future<dynamic> Function(
      CardGridController, dynamic, CardGridChangeEvent) onChangeEvent;

  CardGrid({
    Key key,
    this.source,
    this.builder,
    this.controller,
    this.futureSource,
    //  this.onNewItem,
    //  this.onEditItem,
    //  this.onDeleteItem,
    this.columns,
    //this.onRefresh,
    //this.onSelectChanged,
    this.onChangeEvent,
    this.canInsert = false,
    this.canDelete = false,
    this.canUpdate = false,
  }) : super(key: key);

  @override
  _CardGridState createState() => _CardGridState();
}

class _CardGridState extends State<CardGrid> {
  CardGridController controller;
  @override
  void initState() {
    controller = widget.controller ?? CardGridController();
    if (controller.columns == null) controller.columns = widget.columns ?? [];
    controller.widget = widget;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //child: child,
      body: SingleChildScrollView(
          child: FutureBuilder<dynamic>(
        initialData: widget.source,
        future: widget.futureSource,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            controller.source = snapshot.data;
            if (controller.source.length == 0)
              return Align(child: Text('Ops, não tem nada para mostrar'));
          }
          return StreamBuilder(
              stream: controller.subscribeChanges.stream,
              builder: (context, snapshot) {
                return Wrap(children: [
                  for (var item in controller.source)
                    (widget.canUpdate)
                        ? InkWell(
                            child: widget.builder(item),
                            onTap: () {
                              controller.data = item;
                              Dialogs.showPage(context,
                                  width: 400,
                                  height: 500,
                                  child: CardGridEditRow(
                                    title: 'Alteração do item',
                                    controller: controller,
                                    event: CardGridChangeEvent.update,
                                  ));
                            },
                          )
                        : widget.builder(item)
                ]);
              });
        },
      )),
      floatingActionButton:
          ((widget.onChangeEvent != null) && (widget.canInsert))
              ? FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: () {
                    Dialogs.showPage(context,
                        width: 400,
                        height: 500,
                        child: CardGridEditRow(
                          title: 'Novo item',
                          controller: controller,
                          event: CardGridChangeEvent.insert,
                        ));
                  },
                )
              : Container(),
    );
  }
}

class CardGridColumn {
  final bool readOnly;
  final String label;
  final String name;
  final bool isPrimaryKey;
  final Widget Function(CardGridController, CardGridColumn, dynamic, dynamic)
      editBuilder;
  final int maxLines;
  final int maxLength;
  final dynamic Function(dynamic) onGetValue;
  final String Function(dynamic) onValidate;
  final String editInfo;
  final bool required;
  final dynamic Function(dynamic) onSetValue;
  CardGridColumn({
    this.editBuilder,
    this.maxLines = 1,
    this.label,
    this.required = false,
    this.editInfo = '',
    this.readOnly = false,
    this.name,
    this.isPrimaryKey = false,
    this.maxLength,
    this.onGetValue,
    this.onValidate,
    this.onSetValue,
  });
}

enum CardGridChangeEvent { insert, update, delete }

class CardGridEditRow extends StatefulWidget {
  final String title;
  final CardGridController controller;
  final CardGridChangeEvent event;
  const CardGridEditRow({Key key, this.event, this.controller, this.title})
      : super(key: key);

  @override
  _CardGridEditRowState createState() => _CardGridEditRowState();
}

class _CardGridEditRowState extends State<CardGridEditRow> {
  Map<String, dynamic> p;
  CardGridChangeEvent _event;
  @override
  void initState() {
    _event = widget.event ??
        ((widget.controller.data == null)
            ? CardGridChangeEvent.insert
            : CardGridChangeEvent.update);
    p = widget.controller.data ?? {};
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  bool canEdit(CardGridColumn col) {
    if (col.readOnly) return false;
    if (col.isPrimaryKey) {
      if (_event == CardGridChangeEvent.update) return false;
    }
    return true;
  }

  bool _focused = false;
  bool canFocus(CardGridColumn col) {
    if (_focused) return false;
    if (col.readOnly) return false;
    if (widget.event == CardGridChangeEvent.update) if (col.isPrimaryKey)
      return false;
    _focused = true;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var item in widget.controller.columns)
                  if (item != null)
                    (item.editBuilder != null)
                        ? item.editBuilder(
                            widget.controller, item, p[item.name], p)
                        : TextFormField(
                            autofocus: canFocus(item),
                            maxLines: item.maxLines,
                            maxLength: item.maxLength,
                            enabled: canEdit(item),
                            initialValue: (item.onGetValue != null)
                                ? item.onGetValue(p[item.name])
                                : (p[item.name] ?? '').toString(),
                            style: TextStyle(
                                fontSize: 16, fontStyle: FontStyle.normal),
                            decoration: InputDecoration(
                              labelText: item.label ?? item.name,
                            ),
                            validator: (value) {
                              if (item.onValidate != null)
                                return item.onValidate(value);
                              if (item.required) if (value.isEmpty) {
                                return (item.editInfo.replaceAll(
                                    '{label}', item.label ?? item.name));
                              }

                              return null;
                            },
                            onSaved: (x) {
                              if (item.onSetValue != null) {
                                p[item.name] = item.onSetValue(x);
                                return;
                              }
                              if (p[item.name] is int)
                                p[item.name] = int.tryParse(x);
                              else if (p[item.name] is double)
                                p[item.name] = double.tryParse(x);
                              else if (p[item.name] is bool)
                                p[item.name] = x;
                              else
                                p[item.name] = x;
                            }),
                Divider(),
                FlatButton(
                  child: Text('Salvar'),
                  onPressed: () {
                    _save(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _save(context) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      widget.controller.changeRow(p, _event);
      Navigator.pop(context);
    }
  }
}
