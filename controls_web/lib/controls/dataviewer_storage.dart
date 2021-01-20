//library data_viewer;
//import 'package:controls_data/data.dart';
//import 'package:controls_web/controls/data_viewer.dart';
//import 'package:controls_web/controls/dialogs_widgets.dart';
//import 'package:controls_web/controls/masked_field.dart';
//import 'package:flutter/material.dart';

part of data_viewer;

class DataViewerStorage extends StatelessWidget {
  final List<DataViewerColumn> columns;
  final String keyStorage;
  final Function() onSaved;
  const DataViewerStorage(
      {Key key, this.columns, this.keyStorage, this.onSaved})
      : super(key: key);

  static Widget button(BuildContext context,
      {String keyStorage,
      List<DataViewerColumn> columns,
      double width = 350,
      double height = 550,
      Function onSaved}) {
    Size size = MediaQuery.of(context).size;
    return InkButton(
      child: Icon(Icons.reorder),
      onTap: () {
        Dialogs.showPage(context,
            width: size.width < width ? size.width : width,
            height: size.height < height ? size.height : height,
            child: DataViewerStorage(
              keyStorage: keyStorage,
              columns: columns,
              onSaved: onSaved,
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Propriedades'), actions: [
        IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _save();
              Navigator.pop(context);
            })
      ]),
      body: ListView(children: [
        ListTile(
          title: Text('Colunas Visíveis'),
          subtitle: createItems(context),
        ),
      ]),
    );
  }

  _save() {
    DataViewerStorage.save(keyStorage, columns);
    if (onSaved != null) onSaved();
  }

  createItems(BuildContext context) {
    return Wrap(children: [
      for (var item in columns) ...createItem(context, item),
    ]);
  }

  List<Widget> createItem(context, DataViewerColumn item) {
    return [
      MaskedCheckbox(
        label: item.label ?? item.name,
        value: item.visible,
        onChanged: (b) => item.visible = b,
      ),
    ];
  }

  static load(String keyStorage, List<DataViewerColumn> columns) {
    var j = LocalStorage().getJson(keyStorage) ?? {};
    for (var key in j.keys) {
      var p = key.split('.');
      Iterable<DataViewerColumn> column =
          columns.where((element) => p[0] == element.name);
      if (column != null) column.first.visible = j[key];
    }

    return columns;
  }

  static save(String keyStorage, List<DataViewerColumn> columns) {
    Map<String, dynamic> j = {};
    for (var item in columns) j['${item.name}.visible'] = item.visible;
    LocalStorage().setJson(keyStorage, j);
    return columns;
  }
}
