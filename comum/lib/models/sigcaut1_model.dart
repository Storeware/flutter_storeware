// @dart=2.12
import 'dart:convert';

import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';
import 'package:controls_data/odata_firestore.dart';
import 'package:controls_extensions/validadores.dart';

class Sigcaut1Item extends DataItem {
  String? codigo;
  DateTime? data;
  String? dcto;
  double? preco;
  double? filial;
  double? qtde;
  String? baixado;
  double? clifor;
  String? operacao;
  String? compl;
  String? mesa;
  double? dctoid;
  double? sigcauthlote;
  String? vendedor;
  // double empresa;
  // double formapgto;
  // String hora;
  // double icms;
  // double ipi;
  // double irf;
  // double iss;
  String? nome;
  // String operacao;
  // double percDesc;
  double precoBase = 0;
  // double precoBase;
  double? qtdebaixa;
  double? qtdeOrigi;
  String? registrado;
  double? ordem;
  String? localarmazenamento;
  // double estado;
  // double filialprod;
  double? estprod;
  // String hrestado;
  double? total;
  String? unidade;
  // String aplServico;
  // String imprimeimediato;
  // String cancelado;
  // double qtdecanc;
  DateTime? dtEntRet;
  double descmaximo =
      0; // percentual de desconto que pode ser aplicado ao produto
  double percDesconto = 0;

  double get desconto {
    try {
      if (precoBase == 0) precoBase = preco!;
      return precoBase - preco!;
    } catch (e) {
      return 0.0;
    }
  }

  double get valorBruto {
    if (precoBase == 0) precoBase = preco!;
    return roundTo(precoBase * qtde!, 2) as double;
  }

  double get valorDesconto => roundTo(desconto * qtde!, 2) as double;

  double get valorLiquido => total!;

  static test() {
    return Sigcaut1Item.fromJson({
      "codigo": "100",
      "data": "2020-03-23T03:00:00.000Z",
      "dcto": "5176",
      "id": 4,
      "preco": 1,
      "filial": 1,
      "qtde": 0,
      "baixado": "N",
      "clifor": 16001,
      "empresa": 0,
      "formapgto": 0,
      "hora": "10:30",
      "icms": 0,
      "ipi": 0,
      "irf": 0,
      "iss": 0,
      "nome": "PRODUTO DE EXEMPLO",
      "operacao": "129",
      "perc_desc": 0,
      "preco_base": 0,
      "qtdebaixa": 0,
      "qtde_origi": 0,
      "registrado": "N",
      "ordem": 1,
      "estado": 1,
      "filialprod": 1,
      "estprod": 1,
      "hrestado": "2017-11-27T12:58:28.952Z",
      "total": 10,
      "apl_servico": "N",
      "imprimeimediato": "S",
      "cancelado": "S",
      "qtdecanc": 1,
      "unidade": "KG",
      "localarmazenamento": '1',
      "dtent_ret": DateTime.now().toIso8601String(),
    });
  }

  double? get lote => sigcauthlote;
  set lote(double? x) => sigcauthlote = x;
  Sigcaut1Item({
    this.codigo,
    this.data,
    this.dcto,
    //this.id,
    this.preco,
    this.percDesconto = 0,
    this.descmaximo = 0,
    this.filial,
    this.qtde,
    this.baixado,
    this.clifor,
    this.compl,
    this.mesa,
    this.dctoid,
    this.vendedor,
    //   this.empresa,
    //   this.formapgto,
    //   this.hora,
    //   this.icms,
    //   this.ipi,
    //   this.irf,
    //  this.iss,
    this.nome,
    //  this.operacao,
    //   this.percDesc,
    this.precoBase = 0,
    //   this.precoBase,
    this.qtdebaixa,
    this.qtdeOrigi,
    this.registrado,
    this.ordem,
    //   this.estado,
    //   this.filialprod,
    this.estprod,
    //   this.hrestado,
    this.total,
    this.localarmazenamento,
    this.dtEntRet,
    this.unidade,
    //   this.aplServico,
    //   this.imprimeimediato,
    //   this.cancelado,
    //   this.qtdecanc
  });

  Sigcaut1Item.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }
  @override
  fromMap(Map<String, dynamic> json) {
    codigo = json['codigo'];
    data = toDate(json['data']);
    dcto = json['dcto'];
    id = json['id'].toString();
    preco = toDouble(json['preco']);
    filial = toDouble(json['filial']);
    qtde = toDouble(json['qtde']);
    baixado = json['baixado'];
    clifor = toDouble(json['clifor']);
    // empresa = json['empresa'];
    // formapgto = json['formapgto'];
    // hora = json['hora'];
    // icms = json['icms'];
    // ipi = json['ipi'];
    // irf = json['irf'];
    // iss = json['iss'];
    nome = json['nome'];
    compl = json['compl'] ?? '';
    mesa = json['mesa'];
    dctoid = toDouble(json['dctoid']);
    // operacao = json['operacao'];
    percDesconto = toDouble(json['perc_desc']);
    precoBase = toDouble(json['preco_base']);
    // precoBase = json['preco_base'];
    qtdebaixa = toDouble(json['qtdebaixa']);
    qtdeOrigi = toDouble(json['qtde_origi']);
    registrado = json['registrado'];
    ordem = toDouble(json['ordem']);
    // estado = json['estado'];
    // filialprod = json['filialprod'];
    estprod = toDouble(json['estprod']);
    localarmazenamento = json['localarmazenamento'] ?? '';
    // hrestado = json['hrestado'];
    total = toDouble(json['total']);
    dtEntRet = toDateTime(json['dtent_ret']);
    unidade = json['unidade'];

    /// referencia cruzada sigcauth.lote  e sigcaut1.sigcauthlote
    sigcauthlote = toDouble(json['sigcauthlote'] ?? json['lote']);
    vendedor = json['vendedor'];
    operacao = json['operacao'];
    // aplServico = json['apl_servico'];
    // imprimeimediato = json['imprimeimediato'];
    // cancelado = json['cancelado'];
    //qtdecanc = json['qtdecanc'];
    return this;
  }

  aplicarDescontoPercentual(
      {required double bruto, required double percDesc, double liquido = 0}) {
    this.precoBase = bruto;
    this.percDesconto = percDesc;
    if (liquido > 0) {
      this.preco = liquido;
      this.percDesconto = (bruto - liquido) / bruto * 100;
    } else
      this.preco = roundTo(bruto * (1 - percDesc / 100), 2) as double;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (precoBase == 0) {
      if (percDesconto > 0)
        precoBase = preco! / (1 - percDesconto / 100);
      else
        precoBase = preco ?? 0;
    }

    data['codigo'] = this.codigo;
    data['data'] = toDateSql(toDate(this.data)!);
    data['dcto'] = this.dcto;
    data['id'] = this.id.toString();
    data['preco'] = this.preco;
    data['filial'] = this.filial;
    data['qtde'] = this.qtde;
    data['baixado'] = this.baixado;
    data['clifor'] = this.clifor;
    //data['empresa'] = this.empresa;
    //data['formapgto'] = this.formapgto;
    //data['hora'] = this.hora;
    //data['icms'] = this.icms;
    //data['ipi'] = this.ipi;
    //data['irf'] = this.irf;
    //data['iss'] = this.iss;
    data['nome'] = this.nome;
    //data['operacao'] = this.operacao;
    data['perc_desc'] = this.percDesconto;
    data['preco_base'] = this.precoBase;
    //data['preco_base'] = this.precoBase;
    data['qtdebaixa'] = this.qtdebaixa;
    data['qtde_origi'] = this.qtdeOrigi;
    data['registrado'] = this.registrado;
    data['ordem'] = this.ordem;
    data['compl'] = this.compl;
    data['mesa'] = this.mesa;
    data['dctoid'] = this.dctoid;
    // data['estado'] = this.estado;
    // data['filialprod'] = this.filialprod;
    data['estprod'] = this.estprod;
    data['localarmazenamento'] = this.localarmazenamento;
    // data['hrestado'] = this.hrestado;
    data['total'] = this.total;
    data['dtent_ret'] = this.dtEntRet?.toIso8601String();
    data['unidade'] = this.unidade;
    data['sigcauthlote'] = this.sigcauthlote;
    data['vendedor'] = this.vendedor;
    data['operacao'] = this.operacao;
    // data['apl_servico'] = this.aplServico;
    // data['imprimeimediato'] = this.imprimeimediato;
    // data['cancelado'] = this.cancelado;
    // data['qtdecanc'] = this.qtdecanc;
    return data;
  }

  List<String> get keys => toJson().keys.toList();
}

class Sigcaut1ItemModel extends ODataModelClass<Sigcaut1Item> {
  Sigcaut1ItemModel() {
    collectionName = 'sigcaut1';
    super.API = ODataInst();
    super.CC = CloudV3().client..client.silent = true;

    List<String> keys = Sigcaut1Item().keys;
    // exclui colunas externas
    keys.remove('unidade');
    keys.remove('dtent_ret');
    String charSet = 'character set WIN1252';
    if (driver == 'mssql') charSet = '';
    columns = 'a.' +
        keys.join(', a.').replaceAll(
            'a.nome,', 'CAST(a.nome AS varchar(50) $charSet) nome,');
  }
  Sigcaut1Item newItem() => Sigcaut1Item();

  @override
  list({filter, cacheControl}) async {
    String where = (filter != null) ? ' and ($filter)' : '';
    return search(
      select: 'distinct $columns' + ', b.dtent_ret, p.unidade',
      resource: 'sigcauth b,  ctprod p,  sigcaut1 a ',
      filter:
          "(b.dcto  = a.dcto and b.data = a.data) and a.codigo=p.codigo $where ",
    ).then((ODataResult r) {
      return r.asMap();
    });
  }

  listPedidosTabPreco(
      {filter,
      orderBy,
      top,
      skip,
      select,
      cacheControl,
      tabelaPreco,
      required double filial}) async {
    String where = (filter != null) ? ' and ($filter)' : '';

    String subQueryPreco =
        ",(select precoweb from ctprod_filial pf where a.codigo=p.codigo and pf.filial = $filial) as pv";
    if (tabelaPreco != null)
      subQueryPreco =
          ",(select precovenda from web_ctprod_tabpreco t where t.codigo=p.codigo and t.filial=$filial and t.tabela=$tabelaPreco) as pv ";

    return search(
      select: select ??
          'distinct $columns' + ', b.dtent_ret, p.unidade $subQueryPreco',
      resource: 'sigcauth b,  ctprod p,  sigcaut1 a ',
      filter:
          "(b.dcto  = a.dcto and b.data = a.data) and a.codigo=p.codigo $where ",
      orderBy: orderBy,
      top: top,
      skip: skip,
    ).then((ODataResult r) {
      List<dynamic> rsp = r.asMap();
      rsp.forEach((it) {
        if (it['pv'] != null) {
          it['precovenda'] = it['pv'];
        }
        if (toDouble(it['precoweb']) == 0 && it['precovenda'] != null) {
          it['precoweb'] = it['precovenda'];
        }
      });
      return rsp;
    });
  }

  mudarEstadoPara(id, estado) {
    String qry = "update sigcaut1 set estprod = $estado where id = $id ";
    if (driver == 'mssql')
      qry = '''
         begin
           $qry;
           select @@rowcount as __rows;
         end''';
    return API!.execute(qry);
  }

  mudarQtdePara(id, double? qtde, localArmazenamento) {
    String qry =
        "update sigcaut1 set qtde=$qtde, localarmazenamento = '$localArmazenamento' where id = $id ";
    if (driver == 'mssql')
      qry = '''begin
       $qry;
       select @@rowcount as __rows;
    end
    ''';
    return API!.execute(qry);
  }

  addItem(Sigcaut1Item item) {
    var vend = (item.vendedor != null) ? "'${item.vendedor}'" : 'null';
    String? qry;
    if (driver == 'mssql') {
      qry = """
      begin
       declare @id Double precision;
       exec @id = 
         WEB_REG_OS_ITEM 0, ${item.filial}, 
        '${toDateSql(item.data!)}', 
        '${item.dcto}', ${item.clifor}, '${item.codigo}', 
        '${item.compl ?? ''}', 
        ${item.qtde}, 
        ${item.preco}, 
        ${item.ordem}, $vend, 
        ${item.lote}, null, null, 1,'N','${item.operacao}', @id;
        select (case when codigo is not null  then 'OK' else 'Erro no servidor não informado' end) as tx_msg, sigcauthlote as nr_lote, 1 as nr_linhas_afetadas, dcto as nr_pedido from sigcaut1 where dcto='${item.dcto}' and clifor=${item.clifor} and sigcauthlote=${item.lote};
      end
      """;
      return API!.execute(qry).then((rsp) {
        return jsonDecode(rsp);
      });
    } else
      qry = """SELECT p.TX_MSG, p.NR_PEDIDO, p.NR_LOTE, p.NR_LINHAS_AFETADAS 
            FROM WEB_REG_OS_ITEM_EX(0, ${item.filial}, 
        '${toDateSql(item.data!)}', 
        '${item.dcto}', ${item.clifor}, '${item.codigo}', 
        '${item.compl ?? ''}', 
        ${item.qtde}, 
        ${item.precoBase},
        ${item.preco}, 
        ${item.ordem}, $vend, 
        ${item.lote}, null, null, 1,'N','${item.operacao}') p """;
    return API!.openJson(qry);
  }
}
