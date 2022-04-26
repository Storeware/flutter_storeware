// @dart=2.12
import 'dart:convert';

import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';
//import 'package:controls_data/odata_firestore.dart';
//import 'package:controls_data/rest_client.dart';
//import '../widgets/firebird_extensions.dart';
import 'package:controls_extensions/extensions.dart' as ext;
import 'sql_builder.dart';
import 'ctrl_id_model.dart';

/*toDouble(dynamic value) {
  if (value is double) return value;
  if (value is int) return value + 0.0;
  return double.tryParse(value ?? '0') ?? 0;
}

toDateTime(value) {
  return DateTime.tryParse(value ?? DateTime.now().toIso8601String()) ??
      DateTime.now();
}
*/

class SigcauthItem extends DataItem {
  //int id;
  String? dcto;
  double? filial;
  double? cliente;
  double? tabela;
  String? vendedor;
  double? total;
  String? obs;
  String? entrega;
  double? filialretira;
  String? hora;
  double? valortroco;
  int? qtdepessoa;
  String? operador;
  double? lote;
  String? cobrataxa;
  String? contatravada;
  String? operacao;
  DateTime? data;
  String? dav;
  String? registrado;
  String? prevenda;
  double? baseicmssubst;
  double? icmssubst;
  String? mesa;
  DateTime? dtEntRet;
  String? nome;

  String? endentr;
  String? bairroentr;
  String? cidadeentr;
  String? estadoentr;
  String? cnpjentr;

  double? estprod;
  String? impresso = 'N';

  static get test => {
        "id": 66883,
        "dcto": "433",
        "filial": 1,
        "cliente": 80001,
        "vendedor": "001",
        "total": 117.59,
        "obs": "um observacao para o pedido",
        "dtent_ret": "2020-04-24T20:13:03.480",
        "entrega": null,
        "filialretira": null,
        "hora": null,
        "valortroco": null,
        "qtdepessoa": null,
        "operador": null,
        "lote": null,
        "cobrataxa": null,
        "contatravada": null,
        "operacao": null,
        "data": "2020-04-24T03:00:00.000Z",
        "dav": null,
        "registrado": null,
        "prevenda": null,
        "baseicmssubst": null,
        "icmssubst": null,
        "mesa": null,
        "nome": "Amarildo lacerda"
      };

  SigcauthItem(
      { //this.id,
      this.dcto,
      this.filial,
      this.cliente,
      this.vendedor,
      this.total,
      this.obs,
      this.entrega,
      this.filialretira,
      this.hora,
      this.valortroco,
      this.qtdepessoa,
      this.operador,
      this.lote,
      this.cobrataxa,
      this.contatravada,
      this.operacao,
      this.data,
      this.dav,
      this.registrado,
      this.prevenda,
      this.baseicmssubst,
      this.mesa,
      this.icmssubst,
      this.tabela});

  SigcauthItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }
  @override
  fromMap(Map<String, dynamic> json) {
    try {
      id = json['id'];
      dcto = json['dcto'];
      filial = toDouble(json['filial']);
      cliente = toDouble(json['cliente']);
      vendedor = json['vendedor'];
      total = toDouble(json['total']);
      obs = json['obs'];
      entrega = json['entrega'];
      filialretira = toDouble(json['filialretira']);
      hora = json['hora'];
      qtdepessoa = toDouble(json['qtdepessoa']).toInt();
      operador = json['operador'];
      lote = toDouble(json['lote']);
      cobrataxa = json['cobrataxa'];
      contatravada = json['contatravada'];
      operacao = json['operacao'];
      data = toDate(json['data']);
      dav = json['dav'];
      registrado = json['registrado'];
      prevenda = json['prevenda'];
      baseicmssubst = toDouble(json['baseicmssubst']);
      icmssubst = toDouble(json['icmssubst']);
      mesa = json['mesa'];
      nome = json['nome'];
      dtEntRet = toDateTime(json['dtent_ret']);
      endentr = json['endentr'];
      bairroentr = json['bairroentr'];
      cidadeentr = json['cidadeentr'];
      estadoentr = json['estadoentr'];
      cnpjentr = json['cnpjentr'];
      estprod = toDouble(json['estprod']);
      valortroco = toDouble(json['valortroco']);
      impresso = json['impresso'] ?? 'N';
      tabela = json['tabela']; // se for null, nao usa tabela de preco
    } catch (e) {
      //
    }
    return this;
  }

  get usaTabelaPreco => tabela != null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id.toString();
    data['dcto'] = strLen(this.dcto, 10);
    data['filial'] = this.filial;
    data['cliente'] = this.cliente;
    data['vendedor'] = this.vendedor;
    data['total'] = this.total;
    data['obs'] = strLen(this.obs, 255);
    data['entrega'] = strLen(this.entrega, 1);
    data['filialretira'] = this.filialretira;
    data['hora'] = this.hora;
    data['valortroco'] = this.valortroco;
    data['qtdepessoa'] = this.qtdepessoa;
    data['operador'] = this.operador;
    data['lote'] = this.lote;
    data['cobrataxa'] = this.cobrataxa;
    data['contatravada'] = this.contatravada;
    data['operacao'] = strLen(this.operacao, 10);
    data['data'] = this.data;
    data['dav'] = this.dav;
    data['registrado'] = strLen(this.registrado, 1);
    data['prevenda'] = this.prevenda;
    data['baseicmssubst'] = this.baseicmssubst;
    data['icmssubst'] = this.icmssubst;
    data['mesa'] = this.mesa;
    data['nome'] = strLen(this.nome, 50);
    data['dtent_ret'] = toDateTimeSql(this.dtEntRet ?? DateTime.now());
    data['endentr'] = strLen(endentr, 50);
    data['bairroentr'] = strLen(bairroentr, 20);
    data['cidadeentr'] = strLen(cidadeentr, 50);
    data['estadoentr'] = strLen(estadoentr, 2);
    data['cnpjentr'] = cnpjentr;
    data['estprod'] = estprod;
    data['impresso'] = impresso ?? 'N';
    data['tabela'] = tabela; // se for null, nao usa tabela

    return data;
  }

  String? strLen(String? texto, int len) {
    if (texto == null) return null;
    if (texto.length > len) return texto.padRight(len);
    return texto;
  }
}

class SigcauthItemModel extends ODataModelClass<SigcauthItem> {
  SigcauthItemModel() {
    collectionName = 'sigcauth';
    super.API = ODataInst();
    //super.CC = CloudV3().client..client.silent = true;
  }
  SigcauthItem newItem() => SigcauthItem();

  moveEstadoPara({
    required Map<String, dynamic> item,
    required double para,
    List<double>? ids,
    bool podeRebaixar = false,
  }) {
    //assert(para != null);
    String? dcto = item['dcto'];
    String data = item['data'].toString().substring(0, 10);
    double filial = toDouble(item['filial']);
    String filtro = (((ids != null)
            ? 'id in [${ids.join(',')}]'
            : "dcto='$dcto' and data='$data' and filial=$filial")) +
        (podeRebaixar ? '' : ' and (estprod < $para or estprod is null) ');
    return API!.execute("update sigcaut1 set estprod = $para where  $filtro ");
  }

  Future<ODataResult> pedidosList(
      {int top = 20,
      int skip = 0,
      bool? encerrados,
      String operacaoDe = '128',
      String operacaoAte = '199',
      int dias = 90,
      DateTime? data,
      List<String>? estados,
      String? vendedor,
      bool extended = false,
      num? filial}) async {
    var filtro = '';
    if (estados != null) {
      var s = estados.join(',');
      filtro +=
          ' and (exists (select 1 from sigcaut1 k where k.dcto=a.dcto and k.data=a.data and estprod in [$s])) ';
    }

    String d = (data ?? (DateTime.now().addDays(-dias))).toDateTimeSql();
    String filtroItens = (data != null) ? " x.data eq '$d'" : " x.data ge '$d'";

    if (encerrados != null) {
      if (encerrados) {
        filtroItens += ' and (x.qtdebaixa>=x.qtde)';
      } else {
        filtroItens += ' and (x.qtdebaixa<x.qtde)';
      }
    }
    filtroItens += " and x.operacao between '$operacaoDe' and '$operacaoAte' ";

    if (vendedor != null) filtroItens += " and x.vendedor = '$vendedor' ";

    var fldExtends = (extended)
        ? ', a.obs,a.endentr,a.bairroentr,a.cidadeentr,a.cnpjentr '
        : '';

    String qry =
        "select p.*, a.id, a.dtent_ret, a.cliente,a.total, c.nome $fldExtends from " +
            "sigcauth a, " +
            "(select dcto,filial,data,max(mesa) mesa ,count(*) itens, sum(case when qtdebaixa<qtde then 1 else 0 end) em_processo, min(estprod) estprod   " +
            "from sigcaut1 x  " +
            "where  $filtroItens " +
            "group by dcto,filial,data " +
            ") p, " +
            "web_clientes c " +
            "where (a.cliente gt 0) and (p.dcto=a.dcto and p.data=a.data and p.filial=a.filial) and (a.cliente=c.codigo) $filtro";

    if (driver == 'mssql') {
      // TODO: implementar para MSSQL
    } else
      qry += " rows ${skip + 1} to ${skip + top} ";

    return API!.openJson(qry).then((rsp) {
      return ODataResult(json: rsp);
    });
  }

  Future<double> totalizar(
      double filial, String? dcto, num? lote, DateTime data) async {
    String d = toDateSql(data);

    if (driver == 'mssql') {
      // executa procedure no sqlserver
      return await API!.execute("""
      begin
        declare @total float;
        exec @total = WEB_REG_PEDIDO_TOTALIZA $filial,'$d','$dcto',$lote,@total;
        select @total as 'vl_total';
      end
      """).then((rsp) {
        var j = jsonDecode(rsp);
        return toDouble(j['result'][0]["vl_total"] ?? 0.0);
      });
    }

    // executa procedure no firebird
    return await API!
        .execute(
            "execute procedure WEB_REG_PEDIDO_TOTALIZA($filial,'$d','$dcto',$lote)")
        .then((rsp) {
      var j = jsonDecode(rsp);
      return toDouble(j['result'][0]["vl_total"] ?? 0.0);
    });
  }

  iniciarPedido(double? filial, DateTime data, double? cliente, String? pedido,
      double? lote, String? operacao,
      {double? tabela}) async {
    var d = toDateSql(data);
    late String qry;
    if (driver == 'mssql') {
      // executa procedure no sql server
      qry = """
       begin
          declare @id float;
          exec @id = web_reg_pedido $filial,'$d',$cliente,$pedido,$lote,'$operacao', @id;
          select @id as 'id';
       end
       """;
      return API!.execute(qry).then((rsp) {
        updateTabelaPreco(filial, pedido!, cliente!, lote!, tabela: tabela);
        return jsonDecode(rsp)['result'];
      });
    } else {
      // executa procudure no firebird
      qry =
          """SELECT p.ID FROM WEB_REG_PEDIDO($filial, '$d', $cliente, '$pedido', $lote,'$operacao') p""";
      return API!.openJson(qry).then((rsp) {
        updateTabelaPreco(filial, pedido!, cliente!, lote!, tabela: tabela);
        return rsp['result'];
      });
    }
  }

  updateTabelaPreco(filial, String pedido, double cliente, double lote,
      {double? tabela}) {
    if (tabela != null)
      API!.execute(
          "update sigcauth set tabela=$tabela where filial = $filial and dcto='$pedido' and cliente=$cliente and lote=$lote");
  }

  registraDadosEntrega(
      filial,
      cliente,
      data,
      contato,
      dcto,
      cep,
      dtEntrega,
      endereco,
      endNumero,
      endBairro,
      endCidade,
      endEstado,
      endCnpj,
      endIe,
      endObs,
      inEntrega) {
    var d = toDateSql(data);
    var dEnt = toDateTimeSql(dtEntrega);
    if (driver == 'mssql') {
      String qry = """
        begin
          declare @msg varchar(255);
          exec @msg = WEB_REG_PEDIDO_ENTREGA_DIGITAL $filial, $cliente, '$d', '$contato', '$dcto', '$cep', '$dEnt', '$endereco', '$endNumero', '$endBairro', '$endCidade', '$endEstado', '$endCnpj', '$endIe', '$endObs', '$inEntrega';
          select @msg as 'tx_msg';
        end
      """;
      return API!.execute(qry).then((rsp) {
        return jsonDecode(rsp)['result'];
      });
    }
    String qry =
        """SELECT p.NR_LINHAS_AFETADAS, p.TX_MSG FROM WEB_REG_PEDIDO_ENTREGA_DIGITAL($filial, $cliente, '$d', '$contato', '$dcto', '$cep', '$dEnt', '$endereco', '$endNumero', '$endBairro', '$endCidade', '$endEstado', '$endCnpj', '$endIe', '$endObs', '$inEntrega') p"""
            .replaceAll("'null'", "null");
    return API!.openJson(qry).then((rsp) => rsp['result']);
  }

  updateById(SigcauthItem item) async {
    //var dEnt = toDateTimeSql(item.dtEntRet!);
    Map<String, dynamic> dados = item.toJson();
    dados.remove('total');
    dados.remove('estprod');
    dados.remove('nome');
    var colunas =
        'dcto,filial,cliente,filialretira,qtdepessoa,operador,lote,data,dtent_ret,endentr,bairroentr,cidadeentr,estadoentr, tabela, obs';
    if (item.impresso != null) colunas += ',impresso';
    String qry = SqlBuilder.createSqlUpdate(
      'sigcauth',
      'dcto,data,lote,filial',
      dados,
      colunas: colunas,
      driver: driver,
    );
    return API!.execute(qry);
  }

  Future<double> proximoNumero([double filial = 0]) async {
    var str = 'PEDIDO';
    if (filial > 0) str += '${filial.toInt()}';
    return await CtrlIdItemModel.proximoNumero(str, filial);
  }
}

printLn(t) {
  print(t);
  return t;
}
