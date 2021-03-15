import 'package:controls_data/data_model.dart';

class IniFilesItem extends DataItem {
  int? filial;
  String? arquivo;
  String? secao;
  String? item;
  String? valor;

  IniFilesItem({this.filial, this.arquivo, this.secao, this.item, this.valor});

  IniFilesItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['filial'] = this.filial;
    data['arquivo'] = this.arquivo;
    data['secao'] = this.secao;
    data['item'] = this.item;
    data['valor'] = this.valor;
    return data;
  }

  @override
  fromMap(Map<String, dynamic> json) {
    filial = json['filial'];
    arquivo = json['arquivo'];
    secao = json['secao'];
    item = json['item'];
    valor = json['valor'];
    return this;
  }
}

class IniFilesModel extends DataRows<IniFilesItem> {
  @override
  IniFilesItem newItem() {
    return IniFilesItem();
  }
}
