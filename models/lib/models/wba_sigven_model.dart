import 'package:controls_data/data_model.dart';

class WbaSigvenItem extends DataItem {
  String? codigo;
  int? comissao;
  String? nome;
  String? usuario;
  int? tpModlancto;
  int? tpDatarefer;
  int? tpBasecalc;
  String? operacao;
  String? checkdata;
  int? tipodecomissao;

  WbaSigvenItem(
      {this.codigo,
      this.comissao,
      this.nome,
      this.usuario,
      this.tpModlancto,
      this.tpDatarefer,
      this.tpBasecalc,
      this.operacao,
      this.checkdata,
      this.tipodecomissao});

  WbaSigvenItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }
  @override
  fromMap(Map<String, dynamic> json) {
    codigo = json['codigo'];
    comissao = json['comissao'];
    nome = json['nome'];
    usuario = json['usuario'];
    tpModlancto = json['tp_modlancto'];
    tpDatarefer = json['tp_datarefer'];
    tpBasecalc = json['tp_basecalc'];
    operacao = json['operacao'];
    checkdata = json['checkdata'];
    tipodecomissao = json['tipodecomissao'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['codigo'] = this.codigo;
    data['comissao'] = this.comissao;
    data['nome'] = this.nome;
    data['usuario'] = this.usuario;
    data['tp_modlancto'] = this.tpModlancto;
    data['tp_datarefer'] = this.tpDatarefer;
    data['tp_basecalc'] = this.tpBasecalc;
    data['operacao'] = this.operacao;
    data['checkdata'] = this.checkdata;
    data['tipodecomissao'] = this.tipodecomissao;
    return data;
  }
}

class WbaSigvenItemModel extends DataModelClass<WbaSigvenItem> {
  WbaSigvenItemModel() {
    collectionName = 'wba_sigven';
  }
  WbaSigvenItem newItem() => WbaSigvenItem();

  @override
  enviar(WbaSigvenItem item) {
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
