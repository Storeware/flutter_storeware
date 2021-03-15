import 'package:controls_data/data_model.dart';

class WbaTipocontItem extends DataItem {
  String? nome;
  String? cadastrabco;
  String? dadosentrega;
  String? dadoscobranca;
  String? complemento;
  String? contato;

  WbaTipocontItem(
      {this.nome,
      this.cadastrabco,
      this.dadosentrega,
      this.dadoscobranca,
      this.complemento,
      this.contato});

  WbaTipocontItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }
  @override
  fromMap(Map<String, dynamic> json) {
    nome = json['nome'];
    cadastrabco = json['cadastrabco'];
    dadosentrega = json['dadosentrega'];
    dadoscobranca = json['dadoscobranca'];
    complemento = json['complemento'];
    contato = json['contato'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nome'] = this.nome;
    data['cadastrabco'] = this.cadastrabco;
    data['dadosentrega'] = this.dadosentrega;
    data['dadoscobranca'] = this.dadoscobranca;
    data['complemento'] = this.complemento;
    data['contato'] = this.contato;
    return data;
  }
}

class WbaTipocontItemModel extends DataModelClass<WbaTipocontItem> {
  WbaTipocontItemModel() {
    collectionName = 'wba_tipocont';
  }
  WbaTipocontItem newItem() => WbaTipocontItem();

  @override
  enviar(WbaTipocontItem item) {
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
