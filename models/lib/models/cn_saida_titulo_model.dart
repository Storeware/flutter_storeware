import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';
import 'package:controls_data/odata_firestore.dart';
import 'package:uuid/uuid.dart';

class CnSaidaTituloItem extends DataItem {
  String titulo;
  DateTime data;
  String gidMensagem;
  String gidServidor;
  String de;
  String para;
  String cc;
  String gidEstado;
  String usuario;
  String registrado;

  CnSaidaTituloItem(
      {this.data,
      this.gidMensagem,
      this.gidServidor,
      this.de,
      this.para,
      this.cc,
      this.titulo,
      this.gidEstado,
      this.usuario,
      this.registrado});

  CnSaidaTituloItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }
  @override
  fromMap(Map<String, dynamic> json) {
    data = toDateTime(json['data']);
    gidMensagem = json['gid_mensagem'];
    gidServidor = json['gid_servidor'];
    de = json['de'];
    para = json['para'];
    cc = json['cc'];
    titulo = json['titulo'];
    gidEstado = json['gid_estado'];
    usuario = json['usuario'];
    registrado = json['registrado'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data ?? DateTime.now();
    data['gid_mensagem'] = this.gidMensagem ?? Uuid().v4();
    data['gid_servidor'] = this.gidServidor;
    data['de'] = this.de;
    data['para'] = this.para;
    data['cc'] = this.cc;
    data['titulo'] = this.titulo;
    data['gid_estado'] = this.gidEstado;
    data['usuario'] = this.usuario;
    data['registrado'] = this.registrado ?? 'N';
    data['id'] = this.gidMensagem;
    return data;
  }

  String erro;
  bool validar() {
    bool rt = true;
    erro = '';
    if (gidEstado.isEmpty) {
      rt = false;
      erro += 'Não identificou o estado\n';
    }
    if (gidServidor.isEmpty) {
      rt = false;
      erro += 'Não indicou o provedor da mensagem\n';
    }
    return rt;
  }
}

class CnSaidaTituloItemModel extends ODataModelClass<CnSaidaTituloItem> {
  CnSaidaTituloItemModel() {
    collectionName = 'cn_saida_titulo';
    super.API = ODataInst();
    super.CC = CloudV3().client..client.silent = true;
  }
  CnSaidaTituloItem newItem() => CnSaidaTituloItem();
}
