import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';
import 'package:controls_data/odata_firestore.dart';

class SigfluItem extends DataItem {
  DateTime vcto;
  DateTime emissao;
  double valor;
  String banco;
  String historico;
  String dcto;
  String codigo;
  double control;
  double ctrlId;
  double filial;
  DateTime data;
  DateTime digitacao;
  double clifor;
  //DateTime insercao;
  DateTime dtcontabil;

  /// S ou N
  String dctook;
  String prtserie;

  /// S ou N
  bool aprovado;
  //int tipoIdentPgto;
  /// 1 ou 0
  bool bdregdebito;
  //String criadorRegistro;

  SigfluItem({
    //this.hist,
    this.vcto,
    this.emissao,
    this.valor,
    this.banco,
    this.historico,
    this.dcto,
    this.codigo,
    this.control,
    this.valor,
    //this.ctrlId,
    //this.id,
    this.filial,
    this.data,
    this.digitacao,
    this.clifor,
    //this.insercao,
    this.dtcontabil,
    this.dctook,
    this.prtserie,
    this.aprovado,
    //this.tipoIdentPgto,
    this.bdregdebito,
    //this.criadorRegistro,
  });

  SigfluItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }
  @override
  fromMap(Map<String, dynamic> json) {
    //  hist = json['hist_'];
    vcto = json['vcto_'];
    emissao = json['emissao'];
    valor = json['valor'];
    banco = json['banco'];
    historico = json['historico'];
    dcto = json['dcto'];
    codigo = json['codigo'];
    control = json['control'];
    valor = json['valor_'];
    ctrlId = json['ctrl_id'];
    id = json['id'];
    filial = json['filial'];
    data = json['data'];
    digitacao = json['digitacao'];
    clifor = json['clifor'];
    // insercao = json['insercao'];
    //dtcontabil = json['dtcontabil'];
    dctook = json['dctook'];
    prtserie = json['prtserie'];
    aprovado = json['aprovado'];
    //  tipoIdentPgto = json['tipo_ident_pgto'];
    bdregdebito = json['bdregdebito'];
    //  criadorRegistro = json['criador_registro'];
    _regularizar();
    return this;
  }

  _regularizar() {
    DateTime now = DateTime.now();
    this.emissao ??= toDate(now);
    this.digitacao ??= now;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    _regularizar();
    //data['hist_'] = this.hist;
    //data['vcto_'] = this.vcto;
    data['emissao'] = toDate(this.emissao);
    data['valor'] = this.valor;
    data['banco'] = this.banco;
    data['historico'] = this.historico;
    data['dcto'] = this.dcto;
    data['codigo'] = this.codigo;
    data['control'] = this.control;
    //data['valor_'] = this.valor;
    data['ctrl_id'] = this.ctrlId;
    data['id'] = this.id;
    data['filial'] = this.filial;
    data['data'] = this.data;
    data['digitacao'] = this.digitacao;
    data['clifor'] = this.clifor;
    //data['insercao'] = this.insercao;
    data['dtcontabil'] = this.dtcontabil;
    data['dctook'] = this.dctook;
    data['prtserie'] = this.prtserie;
    data['aprovado'] = this.aprovado;
    //data['tipo_ident_pgto'] = this.tipoIdentPgto;
    data['bdregdebito'] = this.bdregdebito;
    //data['criador_registro'] = this.criadorRegistro;
    return data;
  }
}

class SigfluItemModel extends ODataModelClass<SigfluItem> {
  SigfluItemModel() {
    collectionName = 'sigflu';
    super.API = ODataInst();
    super.CC = CloudV3().client..client.silent = true;
  }
  SigfluItem newItem() => SigfluItem();
}
