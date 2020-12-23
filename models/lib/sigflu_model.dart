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
    vcto = toDate(json['vcto_']);
    emissao = toDate(json['emissao']);
    this.valor = toDouble(json['valor']);
    banco = json['banco'];
    historico = json['historico'];
    dcto = json['dcto'];
    codigo = json['codigo'];
    control = toDouble(json['control']);
    valor = toDouble(json['valor_']);
    ctrlId = toDouble(json['ctrl_id']);
    id = toDouble(json['id']);
    filial = toDouble(json['filial']);
    data = toDate(json['data']);
    digitacao = toDate(json['digitacao']);
    clifor = toDouble(json['clifor']);
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
    return super.API.openJson(qry).then((rsp) => rsp['result']);
  }

  contasAPagar(
      {double filial,
      DateTime de,
      DateTime ate,
      String filtro,
      String select}) {
    final sDe = toDateSql(de ?? (DateTime.now().addMonths(-2)).startOfDay());
    final sAte = toDateSql(ate ?? (DateTime.now()).endOfDay());
    String f = filtro ?? '';
    if (filial != null)
      f += (f != '') ? ' and ' : ' ' + ' a.filial = $filial  and ';
    final qry = '''
select ${select ?? '*'} from sigflu a
where $f  a.codigo ge '200' and a.data between '$sDe'  and '$sAte'
''';
    return API.openJson(qry).then((rsp) => rsp['result']);
  }

  contasAReceber(
      {double filial,
      DateTime de,
      DateTime ate,
      String filtro,
      String select}) {
    final sDe = toDateSql(de ?? (DateTime.now().addMonths(-2)).startOfDay());
    final sAte = toDateSql(ate ?? (DateTime.now()).endOfDay());
    String f = filtro ?? '';
    if (filial != null)
      f += (f != '') ? ' and ' : ' ' + ' a.filial = $filial  and ';
    final qry = '''
select ${select ?? '*'} from sigflu a
where $f  a.codigo lt '200' and a.data between '$sDe'  and '$sAte'
''';
    print(qry);
    return API.openJson(qry).then((rsp) => rsp['result']);
  }
}
