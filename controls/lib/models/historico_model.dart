import 'package:flutter/widgets.dart';
import 'package:models/data.dart';
import 'config_client.dart';

final List<Color> colors = [
  Color(0xFFFFEE58),
  Color(0xFFEF5350),
  Color(0xFFFFFFFF),
];

class HistoricoItem extends DataItem {
  int rowid;
  String codigo;
  String title;
  String description;
  DateTime data;
  int tipo;
  int color;
  static create(title, description) {
    HistoricoItem r = HistoricoItem();
    r.title = title;
    r.description = description;
    r.data = DateTime.now();
    return r;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "rowid": rowid,
      "tipo": tipo,
      "codigo": codigo,
      "title": title,
      "description": description,
      "data": data,
      "color": color
    };
  }

  @override
  fromJson(Map<String, dynamic> dados) {
    rowid = dados['rowid'] ?? 0;
    tipo = dados['tipo'] ?? -1;
    title = dados['title'];
    codigo = dados['codigo'];
    description = dados['description'];
    try{
    data = dados['data'] ?? DateTime.now();
    } catch(e){}
    color = dados['color'] ?? 0;
    return this;
  }
}

class HistoricoLocal extends DataRows<HistoricoItem> {
  static final _instance = HistoricoLocal._create();
  HistoricoLocal._create();
  factory HistoricoLocal() => _instance;
  clear() {
    super.items.clear();
    save();
  }

  add(String codigo, String title, String descript,
      {int tipo = -1, bool exclusive = true, int colorIdx = 0}) {
    if (exclusive) {
      var it = last();
      if (it != null && it.codigo == codigo) {
        it.title = title;
        it.codigo = codigo;
        it.description = descript;
        it.codigo = codigo;
        it.color = colorIdx;
        super.setItem(it);
        return it;
      }
    }
    var r = HistoricoItem();
    r.title = title;
    r.description = descript;
    r.codigo = codigo;
    r.rowid = nextId();
    r.tipo = tipo;
    r.color = colorIdx;
    r.data = DateTime.now();
    super.addItem(r);
    save();
    return r;
  }

  nextId() {
    var n = 0;
    items.forEach((f) {
      if (f.rowid != null && f.rowid > n) n = f.rowid;
    });
    n++;
    return n;
  }

  @override
  HistoricoItem newItem() {
    return HistoricoItem();
  }

  final keyName = 'historico';
  restore() {
    fromJson(ConfigModel().getJson(keyName));
    return this;
  }

  save() {
    ConfigModel().setJson(keyName, this.toJson());
  }

  List<dynamic> toJson() {
    List<dynamic> l = [];
    items.forEach((f) {
      l.add(DataModel.encodeValues(f.toJson()));
    });
    return l;
  }

  fromJson(List<dynamic> js) {
    items.clear();
    js.forEach((f) {
      print([f]);
      print(DataModel.decodeValues(f));
      items.add(HistoricoItem().fromJson(DataModel.decodeValues(f)));
    });
    return this;
  }

  delete(int rowid) {
    for (var i = 0; i < items.length; i++) {
      if (items[i].rowid == rowid) {
        print([rowid, i]);
        return removeAt(i);
      }
    }
  }
}
