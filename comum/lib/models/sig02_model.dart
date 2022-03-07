// @dart=2.12
import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';
//import 'package:controls_extensions/extensions.dart';

class Sig02Item extends DataItem {
  String? banco;
  double? clifor;
  String? codigo;
  double? control;
  double? ctrlReg;
  String? cupomhr;
  DateTime? data;
  DateTime? dataX;
  String? dcto;
  double? desctotal;
  int? diasbloq;
  double? filial;
  String? historico;
  //double id;
  double? idrefer;
  String? olddcto;
  double? oldfilial;
  String? operador;
  double? operadora;
  String? prtserie;
  String? registrado;
  double? valor;
  double? valorX;
  String? vendedor;
  DateTime? dtcontabil;
  double? ordem;
  DateTime? datamvto;
  double? sigcauthlote;
  DateTime? datadctovenda;
  String? indcancelamento;
  String? regpafalterado;
  String? regpafccfalterado;

  Sig02Item(
      {this.banco,
      this.clifor,
      this.codigo,
      this.control,
      this.ctrlReg,
      this.cupomhr,
      this.data,
      this.dcto,
      this.desctotal,
      this.diasbloq,
      this.filial,
      this.historico,
      // this.id,
      this.idrefer,
      this.olddcto,
      this.oldfilial,
      this.operador,
      this.operadora,
      this.prtserie,
      this.registrado,
      this.valor,
      this.vendedor,
      this.dtcontabil,
      this.ordem,
      this.datamvto,
      this.sigcauthlote,
      this.datadctovenda,
      this.indcancelamento,
      this.regpafalterado,
      this.regpafccfalterado});

  Sig02Item.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }

  @override
  fromMap(Map<String, dynamic> json) {
    if (json['banco'] != null) banco = json['banco'];
    if (json['clifor'] != null) clifor = toDouble(json['clifor']);
    if (json['codigo'] != null) codigo = json['codigo'];
    if (json['control'] != null) control = toDouble(json['control']);
    ctrlReg = toDouble(json['ctrl_reg']);
    cupomhr = json['cupomhr'];
    if (json['data'] != null) data = toDateTime(json['data']);
    if (json['data_'] != null) dataX = toDateTime(json['data_']);
    if (json['dcto'] != null) dcto = json['dcto'];
    if (json['desctotal'] != null) desctotal = toDouble(json['desctotal']);
    diasbloq = toInt(json['diasbloq']);
    filial = toDouble(json['filial']);
    historico = json['historico'];
    if (json['id'] != null) id = '${json['id']}';
    idrefer = toDouble(json['idrefer']);
    olddcto = json['olddcto'];
    oldfilial = toDouble(json['oldfilial']);
    operador = json['operador'];
    operadora = toDouble(json['operadora']);
    prtserie = json['prtserie'];
    registrado = json['registrado'];
    valor = toDouble(json['valor']);
    valorX = toDouble(json['valor_']);
    vendedor = json['vendedor'];
    dtcontabil = toDateTime(json['dtcontabil']);
    ordem = toDouble(json['ordem']);
    datamvto = toDateTime(json['datamvto']);
    sigcauthlote = toDouble(json['sigcauthlote']);
    datadctovenda = toDateTime(json['datadctovenda']);
    indcancelamento = json['indcancelamento'];
    regpafalterado = json['regpafalterado'];
    regpafccfalterado = json['regpafccfalterado'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['banco'] = this.banco;
    data['clifor'] = this.clifor;
    data['codigo'] = this.codigo;
    data['control'] = this.control;
    data['ctrl_reg'] = this.ctrlReg;
    data['cupomhr'] = this.cupomhr;
    data['data'] = this.data;
    if (dataX == null) data['data_'] = this.data;
    data['dcto'] = this.dcto;
    data['desctotal'] = this.desctotal;
    data['diasbloq'] = this.diasbloq;
    data['filial'] = this.filial;
    data['historico'] = this.historico;
    data['id'] = this.id;
    data['idrefer'] = this.idrefer;
    data['olddcto'] = this.olddcto;
    data['oldfilial'] = this.oldfilial;
    data['operador'] = this.operador;
    data['operadora'] = this.operadora;
    data['prtserie'] = this.prtserie;
    data['registrado'] = this.registrado ?? 'N';
    data['valor'] = this.valor;
    if (valorX == null) data['valor_'] = this.valor;
    data['vendedor'] = this.vendedor;
    data['dtcontabil'] = this.dtcontabil;
    data['ordem'] = this.ordem ?? 1;
    data['datamvto'] = this.datamvto;
    data['sigcauthlote'] = this.sigcauthlote;
    data['datadctovenda'] = this.datadctovenda;
    data['indcancelamento'] = this.indcancelamento;
    data['regpafalterado'] = this.regpafalterado;
    data['regpafccfalterado'] = this.regpafccfalterado;
    return data;
  }
}

class Sig02ItemModel extends ODataModelClass<Sig02Item> {
  Sig02ItemModel() {
    collectionName = 'sig02';
    super.API = ODataInst();
  }
  Sig02Item newItem() => Sig02Item();

  Future<List> rankCliente({int filial = 0, int rows = 20}) {
    var ate = toDateSql(DateTime.now());
    var de = toDateSql(DateTime.now().add(Duration(days: -30)));
    return listCached(
        select: 'b.nome, a.valor, a.rank_valor, a.sigcad_codigo',
        resource:
            "md_sig02_rank_cliente($filial,'$de' ,'$ate',$rows) a left join sigcad b on (a.sigcad_codigo = b.codigo) ");
  }

  Future<List> rankProdutos({int filial = 0, int rows = 20}) {
    // TODO: mudar para a sigcaut2
    var ate = toDateSql(DateTime.now());
    var de = toDateSql(DateTime.now().add(Duration(days: -30)));
    return listCached(
      select: 'b.nome, a.valor,a.qtde, a.rank_valor, a.ctprod_codigo',
      resource:
          "md_sigcaut2_data_rank_valor($filial,'$de','$ate',$rows) a left join ctprod b on (a.ctprod_codigo = b.codigo)",
    );
  }

  Future<List> ticketMedio({int dias = 1}) {
    return listCached(
        select: '*',
        resource: 'md_ticket_medio_venda(0,null,null, ${dias - 1})');
  }

  static filterVendas({String alias = 'a'}) =>
      'exists (select 1 from estoper x where x.somavendas=1 and $alias.codigo=x.codigo)';
}
