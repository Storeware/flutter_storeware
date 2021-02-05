import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';

class Sig01Item extends DataItem {
  String codigo;
  String contabil;
  String hiscontabil;
  int iscompet;
  String nome;
  String ofic;
  double previsto;
  double realizado;
  String rotina;
  double valor;
  String ccusto;
  String relctaspgr;
  String somadesc;
  String somaprinc;
  int stsRelLiq;
  String usacelula;
  String inativo;
  String sintetico;
  int grau;
  String codsint;
  int isresultado;
  int contaspagar;
  int contasreceber;
  int acessoCp;
  int acessoCr;
  String dispPdv;
  String dispIwba;
  String obs;
  int tipoPgto;
  String reqAprovacao;

  Sig01Item(
      {this.codigo,
      this.contabil,
      this.hiscontabil,
      this.iscompet,
      this.nome,
      this.ofic,
      this.previsto,
      this.realizado,
      this.rotina,
      this.valor,
      this.ccusto,
      this.relctaspgr,
      this.somadesc,
      this.somaprinc,
      this.stsRelLiq,
      this.usacelula,
      this.inativo,
      this.sintetico,
      this.grau,
      this.codsint,
      this.isresultado,
      this.contaspagar,
      this.contasreceber,
      this.acessoCp,
      this.acessoCr,
      this.dispPdv,
      this.dispIwba,
      this.obs,
      this.tipoPgto,
      this.reqAprovacao});

  Sig01Item.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }
  @override
  fromMap(Map<String, dynamic> json) {
    codigo = json['codigo'];
    contabil = json['contabil'];
    hiscontabil = json['hiscontabil'];
    iscompet = json['iscompet'];
    nome = json['nome'];
    ofic = json['ofic'];
    previsto = toDouble(json['previsto']);
    realizado = toDouble(json['realizado']);
    rotina = json['rotina'];
    valor = toDouble(json['valor']);
    ccusto = json['ccusto'];
    relctaspgr = json['relctaspgr'];
    somadesc = json['somadesc'];
    somaprinc = json['somaprinc'];
    stsRelLiq = json['sts_rel_liq'];
    usacelula = json['usacelula'];
    inativo = json['inativo'];
    sintetico = json['sintetico'];
    grau = json['grau'];
    codsint = json['codsint'];
    isresultado = json['isresultado'];
    contaspagar = json['contaspagar'];
    contasreceber = json['contasreceber'];
    acessoCp = json['acesso_cp'];
    acessoCr = json['acesso_cr'];
    dispPdv = json['disp_pdv'];
    dispIwba = json['disp_iwba'];
    obs = json['obs'];
    tipoPgto = json['tipo_pgto'];
    reqAprovacao = json['req_aprovacao'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['codigo'] = this.codigo;
    data['contabil'] = this.contabil;
    data['hiscontabil'] = this.hiscontabil;
    data['iscompet'] = this.iscompet;
    data['nome'] = this.nome;
    data['ofic'] = this.ofic;
    data['previsto'] = this.previsto;
    data['realizado'] = this.realizado;
    data['rotina'] = this.rotina;
    data['valor'] = this.valor;
    data['ccusto'] = this.ccusto;
    data['relctaspgr'] = this.relctaspgr;
    data['somadesc'] = this.somadesc;
    data['somaprinc'] = this.somaprinc;
    data['sts_rel_liq'] = this.stsRelLiq;
    data['usacelula'] = this.usacelula;
    data['inativo'] = this.inativo;
    data['sintetico'] = this.sintetico;
    data['grau'] = this.grau;
    data['codsint'] = this.codsint;
    data['isresultado'] = this.isresultado;
    data['contaspagar'] = this.contaspagar;
    data['contasreceber'] = this.contasreceber;
    data['acesso_cp'] = this.acessoCp;
    data['acesso_cr'] = this.acessoCr;
    data['disp_pdv'] = this.dispPdv;
    data['disp_iwba'] = this.dispIwba;
    data['obs'] = this.obs;
    data['tipo_pgto'] = this.tipoPgto;
    data['req_aprovacao'] = this.reqAprovacao;
    return data;
  }
}

class Sig01ItemModel extends ODataModelClass<Sig01Item> {
  Sig01ItemModel() {
    collectionName = 'sig01';
    super.API = ODataInst();
  }
  Sig01Item newItem() => Sig01Item();

  Future<Map<String, dynamic>> buscarByCodigo(codigo) async {
    return listCached(filter: "codigo eq '$codigo'", select: 'codigo, nome')
        .then((rsp) => (rsp.length == 0) ? {} : rsp[0]);
  }
}

/*import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';
import 'package:controls_data/odata_firestore.dart';

class Sig01Item extends DataItem {
  String codigo;
  String contabil;
  String hiscontabil;
  int iscompet;
  String nome;
  String ofic;
  int previsto;
  int realizado;
  String rotina;
  int valor;
  String ccusto;
  String relctaspgr;
  String somadesc;
  String somaprinc;
  int stsRelLiq;
  String usacelula;
  String inativo;
  String sintetico;
  int grau;
  String codsint;
  int isresultado;
  int contaspagar;
  int contasreceber;
  int acessoCp;
  int acessoCr;
  String dispPdv;
  String dispIwba;
  String obs;
  int tipoPgto;
  String reqAprovacao;

  Sig01Item(
      {this.codigo,
      this.contabil,
      this.hiscontabil,
      this.iscompet,
      this.nome,
      this.ofic,
      this.previsto,
      this.realizado,
      this.rotina,
      this.valor,
      this.ccusto,
      this.relctaspgr,
      this.somadesc,
      this.somaprinc,
      this.stsRelLiq,
      this.usacelula,
      this.inativo,
      this.sintetico,
      this.grau,
      this.codsint,
      this.isresultado,
      this.contaspagar,
      this.contasreceber,
      this.acessoCp,
      this.acessoCr,
      this.dispPdv,
      this.dispIwba,
      this.obs,
      this.tipoPgto,
      this.reqAprovacao});

  Sig01Item.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }
  @override
  fromMap(Map<String, dynamic> json) {
    codigo = json['codigo'];
    contabil = json['contabil'];
    hiscontabil = json['hiscontabil'];
    iscompet = json['iscompet'];
    nome = json['nome'];
    ofic = json['ofic'];
    previsto = json['previsto'];
    realizado = json['realizado'];
    rotina = json['rotina'];
    valor = json['valor'];
    ccusto = json['ccusto'];
    relctaspgr = json['relctaspgr'];
    somadesc = json['somadesc'];
    somaprinc = json['somaprinc'];
    stsRelLiq = json['sts_rel_liq'];
    usacelula = json['usacelula'];
    inativo = json['inativo'];
    sintetico = json['sintetico'];
    grau = json['grau'];
    codsint = json['codsint'];
    isresultado = json['isresultado'];
    contaspagar = json['contaspagar'];
    contasreceber = json['contasreceber'];
    acessoCp = json['acesso_cp'];
    acessoCr = json['acesso_cr'];
    dispPdv = json['disp_pdv'];
    dispIwba = json['disp_iwba'];
    obs = json['obs'];
    tipoPgto = json['tipo_pgto'];
    reqAprovacao = json['req_aprovacao'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['codigo'] = this.codigo;
    data['contabil'] = this.contabil;
    data['hiscontabil'] = this.hiscontabil;
    data['iscompet'] = this.iscompet;
    data['nome'] = this.nome;
    data['ofic'] = this.ofic;
    data['previsto'] = this.previsto;
    data['realizado'] = this.realizado;
    data['rotina'] = this.rotina;
    data['valor'] = this.valor;
    data['ccusto'] = this.ccusto;
    data['relctaspgr'] = this.relctaspgr;
    data['somadesc'] = this.somadesc;
    data['somaprinc'] = this.somaprinc;
    data['sts_rel_liq'] = this.stsRelLiq;
    data['usacelula'] = this.usacelula;
    data['inativo'] = this.inativo;
    data['sintetico'] = this.sintetico;
    data['grau'] = this.grau;
    data['codsint'] = this.codsint;
    data['isresultado'] = this.isresultado;
    data['contaspagar'] = this.contaspagar;
    data['contasreceber'] = this.contasreceber;
    data['acesso_cp'] = this.acessoCp;
    data['acesso_cr'] = this.acessoCr;
    data['disp_pdv'] = this.dispPdv;
    data['disp_iwba'] = this.dispIwba;
    data['obs'] = this.obs;
    data['tipo_pgto'] = this.tipoPgto;
    data['req_aprovacao'] = this.reqAprovacao;
    data['id'] = codigo;
    return data;
  }
}

class Sig01ItemModel extends ODataModelClass<Sig01Item> {
  Sig01ItemModel() {
    collectionName = 'sig01';
    super.CC = CloudV3().client..client.silent = true;
  }
  Sig01Item newItem() => Sig01Item();

  buscarByCodigo(codigo) {
    return listCached(filter: "codigo eq '$codigo'", select: 'codigo, nome');
  }
}
*/
