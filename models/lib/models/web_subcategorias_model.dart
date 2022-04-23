import 'package:controls_data/data_model.dart';

class WebSubcategoriasItem extends DataItem {
  String? subcategoria;
  String? categoria;
  String? nome;

  WebSubcategoriasItem({this.subcategoria, this.categoria, this.nome});

  WebSubcategoriasItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }
  @override
  fromMap(Map<String, dynamic> json) {
    subcategoria = json['subcategoria'];
    categoria = json['categoria'];
    nome = json['nome'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subcategoria'] = this.subcategoria;
    data['categoria'] = this.categoria;
    data['nome'] = this.nome;
    return data;
  }
}

class WebSubcategoriasItemModel extends DataModelClass<WebSubcategoriasItem> {
  WebSubcategoriasItemModel() {
    collectionName = 'web_subcategorias';
  }
  WebSubcategoriasItem newItem() => WebSubcategoriasItem();

  @override
  enviar(WebSubcategoriasItem item) {
    // TODO: implement enviar
    throw UnimplementedError();
  }

  @override
  getById(id) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  snapshots({bool? inativo}) {
    // TODO: implement snapshots
    throw UnimplementedError();
  }
}
