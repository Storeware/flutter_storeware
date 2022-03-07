// @dart=2.12
import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';
import 'package:controls_data/odata_firestore.dart';
//import 'package:controls_extensions/extensions.dart' hide DynamicExtension;

class CtprodFilialItem extends DataItem {
  String? codigo;
  double? filial;
  //double qtdegond;
  double? precovenda;
  double? precovda2;
  double? precovda3;
  double? precoweb;
  //double margemfixa;
  //double margxata;
  //double margfxrev;
  //double margweb;
  //String nfCodicms;
  //String nfCodicms2;
  //String dataBase;
  //int precoAq;
  //String dtatualiz;
  //int demanda;
  //int qestmax;
  //int qestmin;
  //int ppedido;
  //int lote;
  //int tentrega;
  //int testmaximo;
  //int tatraso;
  //String distribuicao;
  //int frete;
  //int fornecAq;
  //int qtdeembal;
  //int markup;
  //String nfCodpiscofins2;
  //String nfCodpiscofins;
  //double custtransf;
  //double precovendaEx;

  CtprodFilialItem({
    this.codigo,
    this.filial,
    //this.qtdegond,
    this.precovenda,
    this.precovda2,
    this.precovda3,
    this.precoweb,
    // this.margemfixa,
    // this.margxata,
    // this.margfxrev,
    // this.margweb,
    // this.nfCodicms,
    // this.nfCodicms2,
    // this.dataBase,
    //  this.precoAq,
    //  this.dtatualiz,
    //this.demanda,
    // this.qestmax,
    // this.qestmin,
    // this.ppedido,
    // this.lote,
    // this.tentrega,
    // this.testmaximo,
    // this.tatraso,
    //  this.distribuicao,
    //  this.frete,
    //  this.fornecAq,
    //  this.qtdeembal,
    //  this.markup,
    //  this.nfCodpiscofins2,
    //  this.nfCodpiscofins,
    //this.custtransf,
    // this.precovendaEx
  });

  CtprodFilialItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }
  @override
  fromMap(Map<String, dynamic> json) {
    codigo = json['codigo'];
    filial = toDouble(json['filial']);
    //qtdegond.from(json['qtdegond']);
    precovenda = toDouble(json['precovenda']);
    precovda2 = toDouble(json['precovda2']);
    precovda3 = toDouble(json['precovda3']);
    precoweb = toDouble(json['precoweb']);
    //margemfixa.from(json['margemfixa']);
    //margxata.from(json['margxata']);
    //margfxrev.from(json['margfxrev']);
    //margweb.from(json['margweb']);
    //nfCodicms.from(json['nf_codicms']);
    //nfCodicms2.from(json['nf_codicms2']);
    //dataBase.from(json['data_base']);
    //precoAq.from(json['preco_aq']);
    //dtatualiz.from(json['dtatualiz']);
    //demanda.from(json['demanda']);
    //qestmax.from(json['qestmax']);
    //qestmin.from(json['qestmin']);
    //ppedido.from(json['ppedido']);
    //lote.from(json['lote']);
    //tentrega.from(json['tentrega']);
    //testmaximo.from(json['testmaximo']);
    //tatraso.from(json['tatraso']);
    //distribuicao.from(json['distribuicao']);
    //frete.from(json['frete']);
    //fornecAq.from(json['fornec_aq']);
    //qtdeembal.from(json['qtdeembal']);
    //markup.from(json['markup']);
    //nfCodpiscofins2.from(json['nf_codpiscofins2']);
    //nfCodpiscofins.from(json['nf_codpiscofins']);
    //custtransf.from(json['custtransf']);
    //precovendaEx.from(json['precovenda_ex']);
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['codigo'] = this.codigo;
    data['filial'] = this.filial;
    //data['qtdegond'] = this.qtdegond;
    data['precovenda'] = this.precovenda;
    data['precovda2'] = this.precovda2;
    data['precovda3'] = this.precovda3;
    data['precoweb'] = this.precoweb;
    //data['margemfixa'] = this.margemfixa;
    //data['margxata'] = this.margxata;
    //data['margfxrev'] = this.margfxrev;
    //data['margweb'] = this.margweb;
    //data['nf_codicms'] = this.nfCodicms;
    //data['nf_codicms2'] = this.nfCodicms2;
    // data['data_base'] = this.dataBase;
    // data['preco_aq'] = this.precoAq;
    //data['dtatualiz'] = this.dtatualiz;
    //data['demanda'] = this.demanda;
    //data['qestmax'] = this.qestmax;
    //data['qestmin'] = this.qestmin;
    //data['ppedido'] = this.ppedido;
    //data['lote'] = this.lote;
    //data['tentrega'] = this.tentrega;
    //data['testmaximo'] = this.testmaximo;
    //data['tatraso'] = this.tatraso;
    //data['distribuicao'] = this.distribuicao;
    //data['frete'] = this.frete;
    //data['fornec_aq'] = this.fornecAq;
    //data['qtdeembal'] = this.qtdeembal;
    //data['markup'] = this.markup;
    //data['nf_codpiscofins2'] = this.nfCodpiscofins2;
    //data['nf_codpiscofins'] = this.nfCodpiscofins;
    //data['custtransf'] = this.custtransf;
    //data['precovenda_ex'] = this.precovendaEx;
    data['id'] = '${filial! ~/ 1}-$codigo';
    return data;
  }
}

class CtprodFilialItemModel extends ODataModelClass<CtprodFilialItem> {
  CtprodFilialItemModel() {
    collectionName = 'ctprod_filial';
    super.API = ODataInst();
    super.CC = CloudV3().client;
  }
  CtprodFilialItem newItem() => CtprodFilialItem();
}
