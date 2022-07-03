part of data_viewer;

class DataViewerStorage<T> extends StatelessWidget {
  final List<T>? columns;
  final String? keyStorage;
  final Function()? onSaved;
  const DataViewerStorage(
      {Key? key, this.columns, this.keyStorage, this.onSaved})
      : super(key: key);

  static Widget button<T>(BuildContext context,
      {String? keyStorage,
      List<T>? columns,
      double width = 350,
      double height = 550,
      Function()? onSaved}) {
    Size size = MediaQuery.of(context).size;
    return InkButton(
      child: Icon(Icons.reorder),
      onTap: () {
        Dialogs.showPage(context,
            width: size.width < width ? size.width : width,
            height: size.height < height ? size.height : height,
            child: DataViewerStorage<T>(
              keyStorage: keyStorage,
              columns: columns!,
              onSaved: onSaved!,
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
    DataViewerStorage.save(keyStorage!, columns!);
    if (onSaved != null) onSaved!();
  }

  createItems(BuildContext context) {
    return Wrap(children: [
      for (var item in columns!) ...createItem(context, item),
    ]);
  }

  List<Widget> createItem(context, item) {
    return [
      MaskedCheckbox(
        label: item.label ?? item.name,
        value: item.visible,
        onChanged: (b) => item.visible = b,
      ),
    ];
  }

  static load(String keyStorage, List columns) {
    var j = LocalStorage().getJson(keyStorage) ?? {};
    for (var key in j.keys) {
      var p = key.split('.');
      Iterable<dynamic>? column =
          columns.where((element) => p[0] == element.name);
      //if (column != null)
      column.first.visible = j[key];
    }

    return columns;
  }

  static save(String keyStorage, List columns) {
    Map<String, dynamic> j = {};
    for (var item in columns) j['${item.name}.visible'] = item.visible;
    LocalStorage().setJson(keyStorage, j);
    return columns;
  }
}
