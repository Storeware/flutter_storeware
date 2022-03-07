// @dart=2.12
import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';
import 'package:controls_data/odata_firestore.dart';

class WbaSigcaut1armItem extends DataItem {
//  int id;
  int? de;
  int? ate;
  double? filial;
  int? estado;
  String? bloqrepet;

  WbaSigcaut1armItem(
      {this.de, this.ate, this.filial, this.estado, this.bloqrepet});

  WbaSigcaut1armItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }
  @override
  fromMap(Map<String, dynamic> json) {
    id = (json['id'] ?? '0').toString();
    de = toInt(json['de'] ?? 0);
    ate = toInt(json['ate'] ?? 0);
    filial = toDouble(json['filial'] ?? 0);
    estado = toInt(json['estado'] ?? 0);
    bloqrepet = (json['bloqrepet'] ?? 'N').toString().replaceAll('null', 'N');
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id ?? '0';
    data['de'] = this.de;
    data['ate'] = this.ate;
    data['filial'] = this.filial;
    data['estado'] = this.estado;
    data['bloqrepet'] = this.bloqrepet ?? 'N';
    return data;
  }
}

class WbaSigcaut1armItemModel extends ODataModelClass<WbaSigcaut1armItem> {
  WbaSigcaut1armItemModel() {
    collectionName = 'sigcaut1armaz';
    super.API = ODataInst();
    super.CC = CloudV3().client..client.silent = true;
  }
  WbaSigcaut1armItem newItem() => WbaSigcaut1armItem();
}
