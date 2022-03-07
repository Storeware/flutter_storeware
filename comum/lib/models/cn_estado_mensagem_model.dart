// @dart=2.12
import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';
import 'package:controls_data/odata_firestore.dart';
import 'package:uuid/uuid.dart';

class CnEstadoMensagemItem extends DataItem {
  String? gidEstado;
  String? nome;
  String? inativo;
  String? concluido;
  DateTime? data;

  CnEstadoMensagemItem(
      {this.gidEstado, this.nome, this.inativo, this.concluido, this.data});

  CnEstadoMensagemItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }
  @override
  fromMap(Map<String, dynamic> json) {
    gidEstado = json['gid_estado'];
    nome = json['nome'];
    inativo = json['inativo'];
    concluido = json['concluido'];
    data = toDateTime(json['data']);

    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gid_estado'] = this.gidEstado ?? Uuid().v4();
    data['nome'] = this.nome;
    data['inativo'] = this.inativo ?? 'N';
    data['concluido'] = this.concluido ?? 'N';
    data['data'] = this.data ?? DateTime.now();
    data['id'] = this.gidEstado;
    return data;
  }
}

class CnEstadoMensagemItemModel extends ODataModelClass<CnEstadoMensagemItem> {
  CnEstadoMensagemItemModel() {
    collectionName = 'cn_estado_mensagem';
    super.API = ODataInst();
    super.CC = CloudV3().client..client.silent = true;
  }
  CnEstadoMensagemItem newItem() => CnEstadoMensagemItem();
}
