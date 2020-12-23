import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';
import 'package:controls_data/odata_firestore.dart';
import 'package:controls_extensions/extensions.dart' hide DynamicExtension;

class SigcxItem extends DataItem {
  String agencia;
  String banco;
  String cartao;
  String cheque;
  double clifor;
  String codigo;
  String conta;
  double control;
  String cpf;
  String cupomhr;
  DateTime data;
  //String data;
  String dcto;
  double desctotal;
  int diasbloq;
  String emitente;
  double filial;
  String historico;
  //String hist;
  //int id;
  String nrbanco;
  String olddcto;
  int operadora;
  String prtserie;
  //int sacado;
  double valor;
  //int valor;
  DateTime vcto;
  String vendedor;
  DateTime dtcontabil;
  DateTime insercao;
  String dctook;
  String compensado;
  double controlExt;
  double celulaControl;
  int ordem;
  String criadorRegistro;
  DateTime dataCompensado;
  String moedaEx;
  DateTime valorEx;
  DateTime cotacaoEx;

  SigcxItem(
      {this.agencia,
      this.banco,
      this.cartao,
      this.cheque,
      this.clifor,
      this.codigo,
      this.conta,
      this.control,
      this.cpf,
      this.cupomhr,
      this.data,
      //this.data,
      this.dcto,
      this.desctotal,
      this.diasbloq,
      this.emitente,
      this.filial,
      this.historico,
      //this.hist,
      //this.id,
      this.nrbanco,
      this.olddcto,
      this.operadora,
      this.prtserie,
      //this.sacado,
      this.valor,
      //this.valor,
      this.vcto,
      this.vendedor,
      this.dtcontabil,
      this.insercao,
      this.dctook,
      this.compensado,
      this.controlExt,
      this.celulaControl,
      this.ordem,
      this.criadorRegistro,
      this.dataCompensado,
      this.moedaEx,
      this.valorEx,
      this.cotacaoEx});

  SigcxItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }
  @override
  fromMap(Map<String, dynamic> json) {
    agencia = json['agencia'];
    banco = json['banco'];
    cartao = json['cartao'];
    cheque = json['cheque'];
    clifor = toDouble(json['clifor']);
    codigo = json['codigo'];
    conta = json['conta'];
    control = toDouble(json['control']);
    cpf = json['cpf'];
    cupomhr = json['cupomhr'];
    data = toDate(json['data']);
    //data = json['data_'];
    dcto = json['dcto'];
    desctotal = toDouble(json['desctotal']);
    diasbloq = toInt(json['diasbloq']);
    emitente = json['emitente'];
    filial = toDouble(json['filial']);
    historico = json['historico'];
    id ??= (json['id'] != null) ? json['id'].toString() : null;
    nrbanco = json['nrbanco'];
    olddcto = json['olddcto'];
    operadora = json['operadora'];
    prtserie = json['prtserie'];
    //sacado = json['sacado'];
    valor = toDouble(json['valor']);
    //valor = json['valor_'];
    vcto = toDate(json['vcto']);
    vendedor = json['vendedor'];
    dtcontabil = toDate(json['dtcontabil']);
    insercao = toDateTime(json['insercao']);
    dctook = json['dctook'];
    compensado = json['compensado'];
    controlExt = json['control_ext'];
    celulaControl = json['celula_control'];
    ordem = toInt(json['ordem']);
    criadorRegistro = json['criador_registro'];
    dataCompensado = json['data_compensado'];
    moedaEx = json['moeda_ex'];
    valorEx = json['valor_ex'];
    cotacaoEx = json['cotacao_ex'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.id != null) data['id'] = this.id;
    data['agencia'] = this.agencia;
    data['banco'] = this.banco;
    data['cartao'] = this.cartao;
    data['cheque'] = this.cheque;
    data['clifor'] = this.clifor;
    data['codigo'] = this.codigo;
    data['conta'] = this.conta;
    data['control'] = this.control;
    data['cpf'] = this.cpf;
    data['cupomhr'] = this.cupomhr;
    data['data'] = this.data;
    //data['data_'] = this.data;
    data['dcto'] = this.dcto;
    data['desctotal'] = this.desctotal;
    data['diasbloq'] = this.diasbloq;
    data['emitente'] = this.emitente;
    data['filial'] = this.filial;
    data['historico'] = this.historico;
    //data['hist_'] = this.hist;
    data['id'] = this.id;
    data['nrbanco'] = this.nrbanco;
    data['olddcto'] = this.olddcto;
    data['operadora'] = this.operadora;
    data['prtserie'] = this.prtserie;
    //data['sacado'] = this.sacado;
    data['valor'] = this.valor;
    //data['valor_'] = this.valor;
    data['vcto'] = this.vcto;
    data['vendedor'] = this.vendedor;
    data['dtcontabil'] = this.dtcontabil;
    //data['insercao'] = this.insercao;
    //data['dctook'] = this.dctook;
    //data['compensado'] = this.compensado;
    data['control_ext'] = this.controlExt;
    data['celula_control'] = this.celulaControl;
    data['ordem'] = this.ordem;
    data['criador_registro'] = this.criadorRegistro;
    //data['data_compensado'] = this.dataCompensado;
    data['moeda_ex'] = this.moedaEx;
    data['valor_ex'] = this.valorEx;
    data['cotacao_ex'] = this.cotacaoEx;
    return data;
  }
}

class SigcxItemModel extends ODataModelClass<SigcxItem> {
  SigcxItemModel() {
    collectionName = 'sigcx';
    super.API = ODataInst();
    super.CC = CloudV3().client..client.silent = true;
  }
  SigcxItem newItem() => SigcxItem();
  dctoOk(id, bool ok) async {
    if (id != null) {
      String v = (ok) ? 'S' : 'N';
      return API
          .execute("update sigcx set dctook = '$v' where id = $id ")
          .then((rsp) => true);
    }
    return false;
  }

  compensado(id, bool ok) async {
    if (id != null) {
      String v = (ok) ? 'S' : 'N';
      return API
          .execute("update sigcx set compensado = '$v' where id = $id ")
          .then((rsp) => true);
    }
    return false;
  }

  despesas({double filial, DateTime de, DateTime ate}) {
    de ??= DateTime.now().startOfMonth();
    ate ??= de.endOfMonth();
    String d1, d2;
    d1 = (de).toDateSql();
    d2 = (ate).toDateSql();
    return API
        .send(
          ODataQuery(
              resource: 'sigcx a',
              select:
                  "a.filial,a.codigo,b.nome,a.data,sum(case when a.codigo lt '200' then -a.valor else a.valor end) valor",
              join: 'left join sig01 b on (a.codigo=b.codigo)',
              filter:
                  "a.codigo ge '200' and b.isresultado eq 1 and data between '$d1' and '$d2' ",
              groupby: 'a.filial,a.codigo,a.data,b.nome'),
        )
        .then((rsp) => rsp['result']);
  }

  despesasMensal({double filial, DateTime de, DateTime ate}) {
    final sDe = toDateSql((de ?? DateTime.now().addMonths(-6)).startOfMonth());
    final sAte = toDateSql((ate ?? DateTime.now()).endOfMonth());
    var filtro = '';
    if (filial != null) filtro = 'a.filial eq $filial  and ';
    final qry =
        '''select extract(year from r.data) ano, extract(month from r.data) mes,  sum(r.valor) valor from 
(select a.data, 
 sum(case when a.codigo>='200' then a.valor else -a.valor end ) valor 
 from sigcx a, sig01 b
where $filtro a.codigo=b.codigo and a.codigo>='200' and b.ISRESULTADO=1 and data between '$sDe'  and '$sAte'
group by 1) as r
group by 1,2''';

    return API.openJson(qry).then((rsp) => rsp['result']);
  }

  entradasMensal({double filial, DateTime de, DateTime ate}) {
    final sDe = toDateSql((de ?? DateTime.now().addMonths(-6)).startOfMonth());
    final sAte = toDateSql((ate ?? DateTime.now()).endOfMonth());
    var filtro = '';
    if (filial != null) filtro = 'a.filial eq $filial  and ';
    final qry =
        '''select extract(year from r.data) ano, extract(month from r.data) mes,  sum(r.valor) valor from 
(select a.data, 
 sum(case when a.codigo<'200' then a.valor else -a.valor end ) valor 
 from sigcx a, sig01 b
where $filtro a.codigo=b.codigo and a.codigo<'200' and (b.ISRESULTADO=1 or b.contasreceber=1)  and data between '$sDe'  and '$sAte'
group by 1) as r
group by 1,2''';

    return API.openJson(qry).then((rsp) => rsp['result']);
  }

  realizadoMensal({double filial, DateTime de, DateTime ate}) {
    final sDe = toDateSql((de ?? DateTime.now().addMonths(-6)).startOfMonth());
    final sAte = toDateSql((ate ?? DateTime.now()).endOfMonth());
    var filtro = '';
    if (filial != null) filtro = 'a.filial = $filial  and ';
    final qry =
        '''select extract(year from r.data) ano, extract(month from r.data) mes,  sum(r.entradas) entradas, sum(r.saidas) saidas 
        from 
(select a.data, 
 sum(case when a.codigo<'200' then a.valor else 0 end ) entradas, 
 sum(case when a.codigo>='200' then a.valor else 0 end ) saidas 
  from sigcx a, sig01 b
where $filtro a.codigo=b.codigo  and (b.ISRESULTADO=1 or b.contasreceber=1)  and data between '$sDe'  and '$sAte'
group by 1) as r
group by 1,2''';
    print(qry);
    return API.openJson(qry).then((rsp) => rsp['result']);
  }

}
