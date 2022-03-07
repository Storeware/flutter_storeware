// @dart=2.12
import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';
import 'package:controls_data/odata_firestore.dart';

class SigvenItem extends DataItem {
  String? codigo;
  num? comissao;
  String? nome;
  String? usuario;
  //int tpModlancto;
  //int tpDatarefer;
  //int tpBasecalc;
  //String operacao;
  //String checkdata;
  //int tipodecomissao;
  //String gid;

  SigvenItem({
    this.codigo,
    this.comissao,
    this.nome,
    this.usuario,
    //  this.tpModlancto,
    //  this.tpDatarefer,
    //  this.tpBasecalc,
    //  this.operacao,
    //  this.checkdata,
    //  this.tipodecomissao,
    //  this.gid
  });

  SigvenItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }
  @override
  fromMap(Map<String, dynamic> json) {
    codigo = json['codigo'];
    comissao = toDouble(json['comissao']);
    nome = json['nome'];
    usuario = json['usuario'];
    // tpModlancto = json['tp_modlancto'];
    // tpDatarefer = json['tp_datarefer'];
    // tpBasecalc = json['tp_basecalc'];
    // operacao = json['operacao'];
    // checkdata = json['checkdata'];
    // tipodecomissao = json['tipodecomissao'];
    // gid = json['gid'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['codigo'] = this.codigo;
    data['comissao'] = this.comissao;
    data['nome'] = this.nome;
    data['usuario'] = this.usuario;
    //data['tp_modlancto'] = this.tpModlancto;
    //data['tp_datarefer'] = this.tpDatarefer;
    //data['tp_basecalc'] = this.tpBasecalc;
    //data['operacao'] = this.operacao;
    //data['checkdata'] = this.checkdata;
    //data['tipodecomissao'] = this.tipodecomissao;
    data['id'] = this.codigo;
    return data;
  }
}

class SigvenItemModel extends ODataModelClass<SigvenItem> {
  SigvenItemModel() {
    collectionName = 'sigven';
    super.API = ODataInst();
    super.CC = CloudV3().client..client.silent = true;
  }
  SigvenItem newItem() => SigvenItem();
  Future<Map<String, dynamic>> buscarByCodigo(String codigo) =>
      listCached(filter: "codigo eq '$codigo'").then((rsp) => rsp.asMap()[0]);
}
