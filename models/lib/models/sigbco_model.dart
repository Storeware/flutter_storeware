import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';
import 'package:controls_data/odata_firestore.dart';

class SigbcoItem extends DataItem {
  String? caixa;
  int? cobfloat;
  String? codigo;
  double? control;
  int? diassemjuros;
  double? filial;
  int? limiteespecial;
  String? nome;
  double? saldo;
  double? saldoant;
  double? saldoapl;
  double? saldoapl1;
  int? txextralimite;
  double? txlimite;
  int? enviaCnab;
  int? imprimeBoleto;
  String? numBancSeq;
  String? bolidentificacao1;
  String? bolidentificacao2;
  String? checkdata;
  int? geraNumeroCob;
  String? pgtoNomedll;
  String? pgtoPasta;
  String? pgtoInfo;
  String? gerarPgto;
  String? ccliquidaretorno;
  int? enviaBoletoCnab;

  SigbcoItem(
      {this.caixa,
      this.cobfloat,
      this.codigo,
      this.control,
      this.diassemjuros,
      this.filial,
      this.limiteespecial,
      this.nome,
      this.saldo,
      this.saldoant,
      this.saldoapl,
      this.saldoapl1,
      this.txextralimite,
      this.txlimite,
      this.enviaCnab,
      this.imprimeBoleto,
      this.numBancSeq,
      this.bolidentificacao1,
      this.bolidentificacao2,
      this.checkdata,
      this.geraNumeroCob,
      this.pgtoNomedll,
      this.pgtoPasta,
      this.pgtoInfo,
      this.gerarPgto,
      this.ccliquidaretorno,
      this.enviaBoletoCnab});

  SigbcoItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }
  @override
  fromMap(Map<String, dynamic> json) {
    caixa = json['caixa'];
    cobfloat = json['cobfloat'];
    codigo = json['codigo'];
    control = json['control'];
    diassemjuros = json['diassemjuros'];
    filial = toDouble(json['filial']);
    limiteespecial = json['limiteespecial'];
    nome = json['nome'];
    saldo = json['saldo'];
    saldoant = json['saldoant'];
    saldoapl = json['saldoapl'];
    saldoapl1 = json['saldoapl1'];
    txextralimite = json['txextralimite'];
    txlimite = json['txlimite'];
    enviaCnab = json['envia_cnab'];
    imprimeBoleto = json['imprime_boleto'];
    numBancSeq = json['num_banc_seq'];
    bolidentificacao1 = json['bolidentificacao1'];
    bolidentificacao2 = json['bolidentificacao2'];
    checkdata = json['checkdata'];
    geraNumeroCob = json['gera_numero_cob'];
    pgtoNomedll = json['pgto_nomedll'];
    pgtoPasta = json['pgto_pasta'];
    pgtoInfo = json['pgto_info'];
    gerarPgto = json['gerar_pgto'];
    ccliquidaretorno = json['ccliquidaretorno'];
    enviaBoletoCnab = json['envia_boleto_cnab'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['caixa'] = this.caixa;
    data['cobfloat'] = this.cobfloat;
    data['codigo'] = this.codigo;
    data['control'] = this.control;
    data['diassemjuros'] = this.diassemjuros;
    data['filial'] = this.filial;
    data['limiteespecial'] = this.limiteespecial;
    data['nome'] = this.nome;
    data['saldo'] = this.saldo;
    data['saldoant'] = this.saldoant;
    data['saldoapl'] = this.saldoapl;
    data['saldoapl1'] = this.saldoapl1;
    data['txextralimite'] = this.txextralimite;
    data['txlimite'] = this.txlimite;
    data['envia_cnab'] = this.enviaCnab;
    data['imprime_boleto'] = this.imprimeBoleto;
    data['num_banc_seq'] = this.numBancSeq;
    data['bolidentificacao1'] = this.bolidentificacao1;
    data['bolidentificacao2'] = this.bolidentificacao2;
    data['checkdata'] = this.checkdata;
    data['gera_numero_cob'] = this.geraNumeroCob;
    data['pgto_nomedll'] = this.pgtoNomedll;
    data['pgto_pasta'] = this.pgtoPasta;
    data['pgto_info'] = this.pgtoInfo;
    data['gerar_pgto'] = this.gerarPgto;
    data['ccliquidaretorno'] = this.ccliquidaretorno;
    data['envia_boleto_cnab'] = this.enviaBoletoCnab;
    return data;
  }
}

class SigbcoItemModel extends ODataModelClass<SigbcoItem> {
  SigbcoItemModel() {
    collectionName = 'sigbco';
    super.API = ODataInst();
    super.CC = CloudV3().client..client.silent = true;
  }
  SigbcoItem newItem() => SigbcoItem();
  Future<Map<String, dynamic>> buscarByCodigo(codigo) {
    return listCached(filter: "codigo eq '$codigo'", select: 'codigo, nome')
        .then((rsp) => rsp[0]);
  }
}
