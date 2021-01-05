import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';
//import 'package:controls_extensions/extensions.dart';

class CprnotaItem extends DataItem {
  double frete;
  int baixado;
  double icmssobreipi;
  String emissao;
  double total;
  double ipi;
  double mercadoria;
  double desconto;
  double acrescimo;
  String operacao;
  double cotacao;
  double fornecedor;
  double qtdeparc;
  String primvcto;
  String notafiscal;
  double interdiasparc;
  double filial;
  //int id;
  String nomefor;
  String moeda;
  double icms;
  String data;
  String obs;
  double control;
  double despesa;
  String numlote;
  double idnota;
  double icmssubst;
  String motivoacres;
  String motivodesc;
  double freteitem;
  double icmssubstitem;
  String obsPgto;
  String registrado;
  String usuario;
  String bdregestoque;
  double baseicmssubst;
  double outrasDespesas;
  double valordigitado;
  String cfopnf;
  double outrasDespesasTotal;
  String serie;
  String especie;
  double icmssubstinter;
  double icmssubstinteritem;
  double baseicmssubstinter;
  String chavenfe;
  double baseicms;
  double bcicmsdigitado;
  double icmsdigitado;
  double bcicmsstdigitado;
  double icmsstdigitado;
  double valoripidigitado;
  double lvCteNfIdctenotas;
  String lvDocumentosfiscaisCodigo;
  double icmssobrefrete;
  double fretedespsobreipi;
  double descontoitem;
  String tipoEdicao;
  double fornecedorNfe;
  double icmssobredespesas;

  CprnotaItem({
    this.frete,
    this.baixado,
    this.icmssobreipi,
    this.emissao,
    this.total,
    this.ipi,
    this.mercadoria,
    this.desconto,
    this.acrescimo,
    this.operacao,
    this.cotacao,
    this.fornecedor,
    this.qtdeparc,
    this.primvcto,
    this.notafiscal,
    this.interdiasparc,
    this.filial,
    // this.id,
    this.nomefor,
    this.moeda,
    this.icms,
    this.data,
    this.obs,
    this.control,
    this.despesa,
    this.numlote,
    this.idnota,
    this.icmssubst,
    this.motivoacres,
    this.motivodesc,
    this.freteitem,
    this.icmssubstitem,
    this.obsPgto,
    this.registrado,
    this.usuario,
    this.bdregestoque,
    this.baseicmssubst,
    this.outrasDespesas,
    this.valordigitado,
    this.cfopnf,
    this.outrasDespesasTotal,
    this.serie,
    this.especie,
    this.icmssubstinter,
    this.icmssubstinteritem,
    this.baseicmssubstinter,
    this.chavenfe,
    this.baseicms,
    this.bcicmsdigitado,
    this.icmsdigitado,
    this.bcicmsstdigitado,
    this.icmsstdigitado,
    this.valoripidigitado,
    this.lvCteNfIdctenotas,
    this.lvDocumentosfiscaisCodigo,
    this.icmssobrefrete,
    this.fretedespsobreipi,
    this.descontoitem,
    this.tipoEdicao,
    this.fornecedorNfe,
    this.icmssobredespesas,
    //this.mes,
    //this.ano
  });

  CprnotaItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }
  @override
  fromMap(Map<String, dynamic> json) {
    frete = toDouble(json['frete']);
    baixado = json['baixado'];
    icmssobreipi = json['icmssobreipi'];
    emissao = json['emissao'];
    total = toDouble(json['total']);
    ipi = toDouble(json['ipi']);
    mercadoria = json['mercadoria'];
    desconto = json['desconto'];
    acrescimo = json['acrescimo'];
    operacao = json['operacao'];
    cotacao = json['cotacao'];
    fornecedor = json['fornecedor'];
    qtdeparc = json['qtdeparc'];
    primvcto = json['primvcto'];
    notafiscal = json['notafiscal'];
    interdiasparc = json['interdiasparc'];
    filial = json['filial'];
    id = json['id'];
    nomefor = json['nomefor'];
    moeda = json['moeda'];
    icms = json['icms'];
    data = json['data'];
    obs = json['obs'];
    control = json['control'];
    despesa = json['despesa'];
    numlote = json['numlote'];
    idnota = json['idnota'];
    icmssubst = json['icmssubst'];
    motivoacres = json['motivoacres'];
    motivodesc = json['motivodesc'];
    freteitem = json['freteitem'];
    icmssubstitem = json['icmssubstitem'];
    obsPgto = json['obs_pgto'];
    registrado = json['registrado'];
    usuario = json['usuario'];
    bdregestoque = json['bdregestoque'];
    baseicmssubst = json['baseicmssubst'];
    outrasDespesas = json['outras_despesas'];
    valordigitado = json['valordigitado'];
    cfopnf = json['cfopnf'];
    outrasDespesasTotal = json['outras_despesas_total'];
    serie = json['serie'];
    especie = json['especie'];
    icmssubstinter = json['icmssubstinter'];
    icmssubstinteritem = json['icmssubstinteritem'];
    baseicmssubstinter = json['baseicmssubstinter'];
    chavenfe = json['chavenfe'];
    baseicms = json['baseicms'];
    bcicmsdigitado = json['bcicmsdigitado'];
    icmsdigitado = json['icmsdigitado'];
    bcicmsstdigitado = json['bcicmsstdigitado'];
    icmsstdigitado = json['icmsstdigitado'];
    valoripidigitado = json['valoripidigitado'];
    lvCteNfIdctenotas = json['lv_cte_nf_idctenotas'];
    lvDocumentosfiscaisCodigo = json['lv_documentosfiscais_codigo'];
    icmssobrefrete = json['icmssobrefrete'];
    fretedespsobreipi = json['fretedespsobreipi'];
    descontoitem = json['descontoitem'];
    tipoEdicao = json['tipo_edicao'];
    fornecedorNfe = json['fornecedor_nfe'];
    icmssobredespesas = json['icmssobredespesas'];
    //mes = json['mes'];
    //ano = json['ano'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['frete'] = this.frete;
    data['baixado'] = this.baixado;
    data['icmssobreipi'] = this.icmssobreipi;
    data['emissao'] = this.emissao;
    data['total'] = this.total;
    data['ipi'] = this.ipi;
    data['mercadoria'] = this.mercadoria;
    data['desconto'] = this.desconto;
    data['acrescimo'] = this.acrescimo;
    data['operacao'] = this.operacao;
    data['cotacao'] = this.cotacao;
    data['fornecedor'] = this.fornecedor;
    data['qtdeparc'] = this.qtdeparc;
    data['primvcto'] = this.primvcto;
    data['notafiscal'] = this.notafiscal;
    data['interdiasparc'] = this.interdiasparc;
    data['filial'] = this.filial;
    data['id'] = this.id;
    data['nomefor'] = this.nomefor;
    data['moeda'] = this.moeda;
    data['icms'] = this.icms;
    data['data'] = this.data;
    data['obs'] = this.obs;
    data['control'] = this.control;
    data['despesa'] = this.despesa;
    data['numlote'] = this.numlote;
    data['idnota'] = this.idnota;
    data['icmssubst'] = this.icmssubst;
    data['motivoacres'] = this.motivoacres;
    data['motivodesc'] = this.motivodesc;
    data['freteitem'] = this.freteitem;
    data['icmssubstitem'] = this.icmssubstitem;
    data['obs_pgto'] = this.obsPgto;
    data['registrado'] = this.registrado;
    data['usuario'] = this.usuario;
    data['bdregestoque'] = this.bdregestoque;
    data['baseicmssubst'] = this.baseicmssubst;
    data['outras_despesas'] = this.outrasDespesas;
    data['valordigitado'] = this.valordigitado;
    data['cfopnf'] = this.cfopnf;
    data['outras_despesas_total'] = this.outrasDespesasTotal;
    data['serie'] = this.serie;
    data['especie'] = this.especie;
    data['icmssubstinter'] = this.icmssubstinter;
    data['icmssubstinteritem'] = this.icmssubstinteritem;
    data['baseicmssubstinter'] = this.baseicmssubstinter;
    data['chavenfe'] = this.chavenfe;
    data['baseicms'] = this.baseicms;
    data['bcicmsdigitado'] = this.bcicmsdigitado;
    data['icmsdigitado'] = this.icmsdigitado;
    data['bcicmsstdigitado'] = this.bcicmsstdigitado;
    data['icmsstdigitado'] = this.icmsstdigitado;
    data['valoripidigitado'] = this.valoripidigitado;
    data['lv_cte_nf_idctenotas'] = this.lvCteNfIdctenotas;
    data['lv_documentosfiscais_codigo'] = this.lvDocumentosfiscaisCodigo;
    data['icmssobrefrete'] = this.icmssobrefrete;
    data['fretedespsobreipi'] = this.fretedespsobreipi;
    data['descontoitem'] = this.descontoitem;
    data['tipo_edicao'] = this.tipoEdicao;
    data['fornecedor_nfe'] = this.fornecedorNfe;
    data['icmssobredespesas'] = this.icmssobredespesas;
    //data['mes'] = this.mes;
    //data['ano'] = this.ano;
    return data;
  }
}

class CprnotaItemModel extends ODataModelClass<CprnotaItem> {
  CprnotaItemModel() {
    collectionName = 'cprnota';
    super.API = ODataInst();
  }
  CprnotaItem newItem() => CprnotaItem();

  Future<Map<int, double>> arrayComprasDiaria({int dias = 53}) async {
    int n = 53 + 7;
    var sDe = toDate(DateTime.now().add(Duration(days: -n)));
    String qry = '''select data,sum(total) valor 
from CPRNOTA a
where baixado = 1 and data>='$sDe'
group by data'''; // print(qry);
    var r = await API.openJson(qry).then((rsp) => rsp['result']);
    // print(r);
    Map<int, double> lista = {};
    for (var i = 0; i < n; i++) {
      lista[i] = 0;
    }
    final h = DateTime.now();
    for (var item in r) {
      final v = toDate(item['data']);
      final d = h.difference(v).inDays;
      lista[d] = item['valor'] + 0.0;
    }
    // print(lista);
    return lista;
  }
}
