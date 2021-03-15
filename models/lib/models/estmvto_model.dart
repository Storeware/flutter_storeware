import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';

class EstmvtoItem extends DataItem {
  String? numserie;
  String? setor;
  String? vendedor;
  double? frete;
  String? olddcto;
  int? frag;
  double? ipi;
  double? icms;
  double? precobase;
  int? numlote;
  double? precoAq;
  double? bruto;
  double? iss;
  String? compl;
  String? prtserie;
  String? dcto;
  double? clifor;
  double? filial;
  double? percDesc;
  double? qtde;
  double? valor;
  double? pmedio;
  double? control;
  DateTime? emissao;
  DateTime? data;
  double? precoliq = 0;
  String? nome;
  //int id;
  String? operacao;
  String? codigo;
  double? icmssubst;
  String? bdregestoque;
  double? ordem;

  double? qestant;

  EstmvtoItem(
      {this.numserie,
      this.setor,
      this.vendedor,
      this.frete,
      this.olddcto,
      this.frag,
      this.ipi,
      this.icms,
      this.precobase,
      this.numlote,
      this.precoAq,
      this.bruto,
      this.iss,
      this.compl,
      this.prtserie,
      this.dcto,
      this.clifor,
      this.filial,
      this.percDesc,
      this.qtde,
      this.valor,
      this.pmedio,
      this.control,
      this.emissao,
      this.data,
      this.precoliq,
      this.nome,
      //this.id,
      this.operacao,
      this.codigo,
      this.icmssubst,
      this.bdregestoque,
      this.ordem});

  EstmvtoItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }

  validar() {
    this.precoliq ??= 0;
    this.qtde ??= 0;
    this.precobase ??= this.precoliq;
    this.bruto ??= this.precoliq;
    this.valor = (this.precoliq! * this.qtde!);
  }

  @override
  fromMap(Map<String, dynamic> json) {
    numserie = json['numserie'];
    setor = json['setor'];
    vendedor = json['vendedor'];
    frete = json['frete'];
    olddcto = json['olddcto'];
    frag = json['frag'];
    ipi = toDouble(json['ipi']);
    icms = toDouble(json['icms']);
    precobase = toDouble(json['precobase']);
    numlote = toInt(json['numlote']);
    precoAq = toDouble(json['preco_aq']);
    bruto = toDouble(json['bruto']);
    iss = toDouble(json['iss']);
    compl = json['compl'];
    prtserie = json['prtserie'];
    dcto = json['dcto'];
    clifor = toDouble(json['clifor']);
    filial = toDouble(json['filial']);
    percDesc = toDouble(json['perc_desc']);
    qtde = toDouble(json['qtde']);
    valor = toDouble(json['valor']);
    pmedio = toDouble(json['pmedio']);
    control = toDouble(json['control']);
    emissao = toDate(json['emissao']);
    data = toDate(json['data']);
    precoliq = toDouble(json['precoliq']);
    nome = json['nome'];
    id = json['id'];
    operacao = json['operacao'];
    codigo = json['codigo'];
    icmssubst = toDouble(json['icmssubst']);
    bdregestoque = json['bdregestoque'] ?? '1';
    ordem = toDouble(json['ordem']);
    qestant = toDouble(json['qestant']);
    validar();
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    validar();
    data['numserie'] = this.numserie;
    data['setor'] = this.setor;
    data['vendedor'] = this.vendedor;
    data['frete'] = this.frete;
    data['olddcto'] = this.olddcto;
    data['frag'] = this.frag;
    data['ipi'] = this.ipi;
    data['icms'] = this.icms;
    data['precobase'] = this.precobase;
    data['numlote'] = this.numlote;
    data['preco_aq'] = this.precoAq;
    data['bruto'] = this.bruto;
    data['iss'] = this.iss;
    data['compl'] = this.compl;
    data['prtserie'] = this.prtserie;
    data['dcto'] = this.dcto;
    data['clifor'] = this.clifor;
    data['filial'] = this.filial;
    data['perc_desc'] = this.percDesc;
    data['qtde'] = this.qtde ?? 0.0;
    data['precoliq'] = this.precoliq ?? 0.0;

    data['valor'] = this.valor;

    data['pmedio'] = this.pmedio;
    data['control'] = this.control;
    data['emissao'] = this.emissao;
    data['data'] = this.data;
    data['nome'] = this.nome;
    data['id'] = this.id;
    data['operacao'] = this.operacao;
    data['codigo'] = this.codigo;
    data['icmssubst'] = this.icmssubst;
    data['bdregestoque'] = this.bdregestoque;
    data['ordem'] = this.ordem;
    data['qestant'] = this.qestant;
    return data;
  }
}

class EstmvtoItemModel extends ODataModelClass<EstmvtoItem> {
  EstmvtoItemModel() {
    collectionName = 'estmvto';
    super.API = ODataInst();
  }
  EstmvtoItem newItem() => EstmvtoItem();
  listMvtoEstoque({filter, top, skip, orderBy}) async {
    var c = 'a.' + EstmvtoItem().toJson().keysJoin(separator: ', a.');
    print(c);
    return listNoCached(
        resource: 'estmvto a, ctprodsd b',
        select: '$c, b.qestfin',
        filter: 'a.codigo=b.codigo and a.filial=b.filial and $filter',
        top: top,
        skip: skip,
        orderBy: orderBy);
  }
}
