import 'dart:convert';

import 'package:models/data.dart';

class AcessoItem extends DataItem {
  int idgrupo;
  int idacesso;
  int tipo;
  static create(grupo, acesso, tipo) {
    var r = AcessoItem();
    r.idgrupo = grupo;
    r.idacesso = acesso;
    r.tipo = tipo;
    return r;
  }

  @override
  fromJson(Map<String, dynamic> js) {
    idgrupo = js['idgrupo'];
    idacesso = js['idacesso'];
    tipo = js['tipo'];
    return this;
  }

  @override
  toJson() {
    return {"idacesso": idacesso, "idgrupo": idgrupo, "tipo": tipo};
  }
}

class AcessosModel extends DataRows<AcessoItem> {
  static final _instance = AcessosModel._create();
  AcessosModel._create();
  factory AcessosModel() {
    return _instance;
  }
  static get instance=>_instance;

  List<AcessoItem> items = [];
  
  add(grupo, acesso, tipo) {
    var it = AcessoItem.create(grupo, acesso, tipo);
    items.add(it);
    return it;
  }

  clear() {
    items.clear();
    return this;
  }

  fromJson( lst) {
    var j = json.encode(lst);
    items = json.decode(j);
    return this;
  }

  toJson() {
    return json.encode(items);
  }

  bool acessoHabilitado(int acesso) {
    for (var item in items) {
      if (item.idacesso == acesso) return item.tipo == 0;
    }
    return false;
  }

  @override
  AcessoItem newItem() {
    return AcessoItem();
  }
}
