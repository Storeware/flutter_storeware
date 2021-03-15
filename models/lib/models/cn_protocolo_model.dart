import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';
import 'package:controls_data/odata_firestore.dart';

class CnProtocoloItem extends DataItem {
  String? protocolo;
  String? nome;
  String? inativo;
  DateTime? data;

  CnProtocoloItem({this.protocolo, this.nome, this.inativo, this.data});

  CnProtocoloItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }
  @override
  fromMap(Map<String, dynamic> json) {
    protocolo = json['protocolo'];
    nome = json['nome'];
    inativo = json['inativo'];
    data = toDateTime(json['data']);
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['protocolo'] = this.protocolo;
    data['nome'] = this.nome;
    data['inativo'] = this.inativo ?? 'N';
    data['data'] = this.data ?? DateTime.now();
    data['id'] = this.protocolo;
    return data;
  }
}

class CnProtocoloItemModel extends ODataModelClass<CnProtocoloItem> {
  CnProtocoloItemModel() {
    collectionName = 'cn_protocolo';
    super.API = ODataInst();
    super.CC = CloudV3().client..client.silent = true;
  }
  CnProtocoloItem newItem() => CnProtocoloItem();
}
