import 'dart:convert';
import 'package:models/data/sql_builder.dart';
import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';
import 'package:controls_data/odata_firestore.dart';
import 'package:controls_extensions/extensions.dart' hide DynamicExtension;

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
  String conferido;

  /// S ou N
  bool aprovado;
  //int tipoIdentPgto;
  /// 1 ou 0
  bool bdregdebito;
  //String criadorRegistro;
  int baixaAutomatica;
  String baixaBanco;
  DateTime baixaDtpgto;
  double baixaValor;

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
    //this.valor,
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
    //vcto = toDate(json['vcto_']);
    emissao = toDate(json['emissao']);
    this.valor = toDouble(json['valor']);
    banco = json['banco'];
    historico = json['historico'];
    dcto = json['dcto'];
    codigo = json['codigo'];
    control = toDouble(json['control']);
    //valor = toDouble(json['valor_']);
    ctrlId = toDouble(json['ctrl_id']);
    id = toDouble(json['id']);
    filial = toDouble(json['filial']);
    data = toDate(json['data']);
    digitacao = toDate(json['digitacao']);
    clifor = toDouble(json['clifor']);
    conferido = json['conferido'];
    // insercao = json['insercao'];
    //dtcontabil = json['dtcontabil'];
    dctook = json['dctook'];
    prtserie = json['prtserie'];
    aprovado = json['aprovado'] == 'S';
    //  tipoIdentPgto = json['tipo_ident_pgto'];
    bdregdebito = (json['bdregdebito'] == '1');
    //  criadorRegistro = json['criador_registro'];

    baixaAutomatica = toInt(json['baixa_automatica']);
    baixaBanco = json['baixa_banco'];
    if (json['baixa_dtpgto'] != null)
      baixaDtpgto = toDate(json['baixa_dtpgto']);
    baixaValor = toDouble(json['baixa_valor']);

    _regularizar();
    return this;
  }

  _regularizar() {
    DateTime now = DateTime.now();
    this.emissao ??= toDate(now);
    this.digitacao ??= now;
    //this.hist_ ??= this.historico;
    //this.valor_ ??= this.valor;
    //this.tipo = this.codigo < '200' ? 'E' : 'S';
    this.banco ??= '';
    this.conferido ??= 'N';
    this.clifor ??= 0;
    this.dctook ??= 'N';
    this.bdregdebito ??= true;
    this.dtcontabil ??= this.emissao;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    _regularizar();
    //data['hist_'] = this.hist;
    //data['vcto_'] = this.vcto;
    data['emissao'] = toDate(this.emissao);
    data['valor'] = this.valor;
    data['banco'] = this.banco ?? '';
    data['historico'] = this.historico;
    data['dcto'] = this.dcto;
    data['codigo'] = this.codigo;
    data['control'] = this.control;
    data['tipo'] = (this.codigo ?? '').compareTo('200') < 0 ? 'E' : 'S';
    data['conferido'] = this.conferido;
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
    data['aprovado'] = this.aprovado ? 'S' : 'N';
    //data['tipo_ident_pgto'] = this.tipoIdentPgto;
    data['bdregdebito'] = this.bdregdebito ? '1' : '0';
    //data['criador_registro'] = this.criadorRegistro;

    if (this.baixaAutomatica != null) {
      data['baixa_automatica'] = this.baixaAutomatica;
      data['baixa_banco'] = this.baixaBanco;
      data['baixa_dtpgto'] = this.baixaDtpgto;
      data['baixa_valor'] = this.baixaValor;
    }

    validarDadosBaixa();
    return data;
  }

  validarDadosBaixa() {
    if (this.baixaAutomatica == 1 && this.baixaBanco != null) {
      this.baixaValor ??= this.valor;
      this.baixaDtpgto ??= toDate(this.data);
    }
  }

  static SigfluItem criarNovo({Map<String, dynamic> json}) {
    var r = SigfluItem.fromJson(json ?? {});
    var d = r.toDate(DateTime.now());
    r.emissao ??= d;
    r.data ??= d;
    r.dctook ??= 'S';
    r.digitacao ??= DateTime.now();

    return r;
  }
}

class SigfluItemModel extends ODataModelClass<SigfluItem> {
  SigfluItemModel() {
    collectionName = 'sigflu';
    super.API = ODataInst();
    super.CC = CloudV3().client..client.silent = true;
  }
  SigfluItem newItem() => SigfluItem();
//Future<List<Map<String, dynamic>>>
  entradaSaidasDiarias({double filial, DateTime de, DateTime ate}) async {
    final sDe = (de ?? DateTime.now()).toDateSql();
    final sAte = (ate ?? DateTime.now().endOfMonth()).toDateSql();
    var filtro = "data between '$sDe' and '$sAte' ";
    var sFilial = '';
    if (filial != null) {
      filtro += ' and filial eq $filial';
      sFilial = 'filial, ';
    }
    var qry =
        '''select $sFilial data,  sum(case when codigo < '200' then valor end) entradas, sum(case when codigo >= '200' then valor end) saidas  from sigflu
        where $filtro
        group by $sFilial data ''';
    //print(qry);
    return super
        .API
        .openJson(qry, cacheControl: 'no-cache')
        .then((rsp) => rsp['result']);
  }

  contasAPagar({
    double filial,
    DateTime de,
    DateTime ate,
    String filtro,
    String select,
    String orderBy,
  }) {
    final sDe = toDateSql(de ?? (DateTime.now().addMonths(-2)).startOfDay());
    final sAte = toDateSql(ate ?? (DateTime.now()).endOfDay());
    final _order = (orderBy != null) ? ' order by $orderBy' : '';

    String f = filtro ?? '';
    if (filial != null) f += (f != '') ? ' and ' : ' ' + ' a.filial = $filial ';

    if (f != '') f += ' and ';

    final qry = '''
select ${select ?? '*'} from sigflu a
where $f  (a.codigo ge '200' and a.data between '$sDe'  and '$sAte') $_order
''';
    print(qry);
    return API.openJson(qry, cacheControl: 'no-cache').then((rsp) {
      // print(rsp);
      return rsp['result'];
    });
  }

  contasAReceber({
    double filial,
    DateTime de,
    DateTime ate,
    String filtro,
    String select,
    String orderBy,
  }) {
    final sDe = toDateSql(de ?? (DateTime.now().addMonths(-2)).startOfDay());
    final sAte = toDateSql(ate ?? (DateTime.now()).endOfDay());
    final _order = (orderBy != null) ? ' order by $orderBy' : '';
    String f = filtro ?? '';
    if (filial != null) f += (f != '') ? ' and ' : ' ' + ' a.filial = $filial ';
    if (f != '') f += ' and ';

    final qry = '''
select ${select ?? '*'} from sigflu a
where $f  (a.codigo lt '200'  and coalesce(banco,'')='' and a.data between '$sDe'  and '$sAte') $_order
''';
    // print(qry);
    return API.openJson(qry).then((rsp) => rsp['result']);
  }

  @override
  validate(value) {
    var item = SigfluItem.fromJson(value);
    var erro = '';
    if (item.codigo == null) erro += 'Código de operação é obrigatório\n';
    if (item.emissao == null)
      erro += 'Não informou a data de emissão do documento\n';
    if (item.data == null)
      erro += 'Não informou a data de vencimento do documento\n';
    //if (item.emissao > DateTime.now()) throw 'A data de emissão é inválida';
    if (item.valor == null) erro += 'Falta informar o valor do documento\n';
    if (item.filial == null) erro += 'Falta indicar a filial do documento\n';
    if (erro != '') throw erro;
    return true;
  }

  @override
  put(value) {
    if (validate(value)) {
      var sql = SqlBuilder.createSqlUpdate('sigflu', 'id', value);
      return this.API.execute(sql).then((rsp) => json.decode(rsp));
    }
  }

  liquidarPagamento(PagamentoContasItem dadosPgto) async {
    String qry = '''select * from PROC_PAGAMENTO_CONTA (
    ${dadosPgto.filial},'${dadosPgto.data}',${dadosPgto.ctrlId},${dadosPgto.clifor},
    '${dadosPgto.banco}',${dadosPgto.valor},'${toDate(DateTime.now())}','${dadosPgto.dcto}',
    '${dadosPgto.historico}','${dadosPgto.dctook}',
    ${dadosPgto.valorPago},
    ${dadosPgto.valorJuros},${dadosPgto.valorDesp},${dadosPgto.valorDesc},${dadosPgto.valorOutros},'${dadosPgto.usuario}' )''';
    print(qry);
    return API.execute(qry).then((r) {
      print(r);
      return json.decode(r);
    });
  }

  liquidarRecebimento(PagamentoContasItem dadosPgto) async {
    String qry = '''select * from PROC_RECEBIMENTO_CONTA (
    ${dadosPgto.filial},'${dadosPgto.data}',${dadosPgto.ctrlId},${dadosPgto.clifor},
    '${dadosPgto.banco}',${dadosPgto.valor},'${toDate(DateTime.now())}','${dadosPgto.dcto}',
    '${dadosPgto.historico}','${dadosPgto.dctook}',
    ${dadosPgto.valorPago},
    ${dadosPgto.valorJuros},${dadosPgto.valorDesp},${dadosPgto.valorDesc},${dadosPgto.valorOutros},'${dadosPgto.usuario}' )''';
    print(qry);
    return API.execute(qry).then((r) {
      print(r);
      return json.decode(r);
    });
  }
}

class PagamentoContasItem extends SigfluItem {
  //String banco;
  double valorPago;
  double valorJuros;
  double valorDesp;
  double valorDesc;
  double valorOutros;
  String usuario;
  PagamentoContasItem.fromJson(json) {
    fromMap(json);
    valorPago = toDouble(json['valorPago']);
    valorJuros = toDouble(json['valorJuros']);
    valorDesp = toDouble(json['valorDesp']);
    valorDesc = toDouble(json['valorDesc']);
    valorOutros = toDouble(json['valorOutros']);
    usuario = json['usuario'];
  }
}
