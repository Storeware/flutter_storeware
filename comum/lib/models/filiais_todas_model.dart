import 'package:controls_data/data_model.dart';

class FilialTodasItem extends DataItem {
  int? codigo;
  String? nome;

  FilialTodasItem({this.codigo, this.nome});

  FilialTodasItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }
  @override
  fromMap(Map<String, dynamic> json) {
    codigo = json['codigo'];
    nome = json['nome'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['codigo'] = this.codigo;
    data['nome'] = this.nome;
    return data;
  }
}

class FilialTodasItemModel extends DataModelClass<FilialTodasItem> {
  FilialTodasItemModel() {
    collectionName = 'filial_todas';
  }
  FilialTodasItem newItem() => FilialTodasItem();

  @override
  enviar(FilialTodasItem item) {
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
