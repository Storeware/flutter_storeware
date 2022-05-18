// @dart=2.12
import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';
import 'package:controls_data/odata_firestore.dart';
import 'package:uuid/uuid.dart';

class CnSaidaServidorItem extends DataItem {
  String? gidServidor;
  String? protocolo;
  String? nome;
  String? conta;
  String? senha;
  String? contaMestre;
  String? inativo;
  DateTime? data;
  DateTime? dtatualiz;
  String? servidor;
  int? porta;
  String? autenticar;

  CnSaidaServidorItem(
      {this.gidServidor,
      this.protocolo,
      this.nome,
      this.conta,
      this.senha,
      this.contaMestre,
      this.inativo,
      this.data,
      this.dtatualiz,
      this.servidor,
      this.porta,
      this.autenticar});

  CnSaidaServidorItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }
  @override
  fromMap(Map<String, dynamic> json) {
    gidServidor = json['gid_servidor'];
    protocolo = json['protocolo'];
    nome = json['nome'];
    conta = json['conta'];
    senha = json['senha'];
    contaMestre = json['conta_mestre'];
    inativo = json['inativo'];
    data = toDateTime(json['data']);
    dtatualiz = toDateTime(json['dtatualiz']);
    servidor = json['servidor'];
    porta = toInt(json['porta']);
    autenticar = json['autenticar'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gid_servidor'] = this.gidServidor ?? Uuid().v4();
    data['protocolo'] = this.protocolo;
    data['nome'] = this.nome;
    data['conta'] = this.conta;
    data['senha'] = this.senha;
    data['conta_mestre'] = this.contaMestre ?? 'N';
    data['inativo'] = this.inativo ?? 'N';
    data['data'] = this.data ?? DateTime.now();
    data['dtatualiz'] = DateTime.now();
    data['servidor'] = this.servidor;
    if (porta != null) data['porta'] = this.porta;
    data['autenticar'] = this.autenticar ?? 'N';
    data['id'] = this.gidServidor;
    return data;
  }
}

class CnSaidaServidorItemModel extends ODataModelClass<CnSaidaServidorItem> {
  CnSaidaServidorItemModel() {
    collectionName = 'cn_saida_servidor';
    super.API = ODataInst();
    super.CC = CloudV3().client..client.silent = true;
  }
  CnSaidaServidorItem newItem() => CnSaidaServidorItem();
}
