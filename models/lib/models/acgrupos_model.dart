import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';

class AcgruposItem extends DataItem {
  // int id;
  String? nome;
  int? prioridade;

  AcgruposItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }
  @override
  fromMap(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    prioridade = json['prioridade'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['prioridade'] = this.prioridade;
    return data;
  }
}

class AcgruposItemModel extends ODataModelClass<AcgruposItem> {
  AcgruposItemModel() {
    collectionName = 'acgrupos';
    super.API = ODataInst();
  }
  AcgruposItem newItem() => AcgruposItem.fromJson({});
}
