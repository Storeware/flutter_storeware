import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';
import 'package:controls_data/odata_firestore.dart';

class TemplatesItem extends DataItem {
  String nome;
  String texto;

  TemplatesItem({this.nome, this.texto});

  TemplatesItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }
  @override
  fromMap(Map<String, dynamic> json) {
    nome = json['nome'];
    texto = json['texto'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nome'] = this.nome;
    data['texto'] = this.texto;
    data['id'] = this.nome;
    return data;
  }
}

class TemplatesItemModel extends ODataModelClass<TemplatesItem> {
  TemplatesItemModel() {
    collectionName = 'templates';
    super.API = ODataInst();
    super.CC = CloudV3().client..client.silent = true;
  }
  TemplatesItem newItem() => TemplatesItem();
}
