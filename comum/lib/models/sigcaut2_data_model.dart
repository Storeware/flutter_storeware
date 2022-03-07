// @dart=2.12
import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';
import 'package:controls_data/odata_firestore.dart';
import 'package:controls_extensions/extensions.dart' as ext;

class Sigcaut2DataItem extends DataItem {
  DateTime? data;
  String? codigo;
  int? filial;
  String? operacao;
  int? qtde;
  int? valor;
  int? descontos;
  int? acrescimos;

  Sigcaut2DataItem(
      {this.data,
      this.codigo,
      this.filial,
      this.operacao,
      this.qtde,
      this.valor,
      this.descontos,
      this.acrescimos});

  Sigcaut2DataItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }
  @override
  fromMap(Map<String, dynamic> json) {
    data = toDateTime(json['data']);
    codigo = json['codigo'];
    filial = json['filial'];
    operacao = json['operacao'];
    qtde = json['qtde'];
    valor = json['valor'];
    descontos = json['descontos'];
    acrescimos = json['acrescimos'];

    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;
    data['codigo'] = this.codigo;
    data['filial'] = this.filial;
    data['operacao'] = this.operacao;
    data['qtde'] = this.qtde;
    data['valor'] = this.valor;
    data['descontos'] = this.descontos;
    data['acrescimos'] = this.acrescimos;
    data['id'] = '$filial-$codigo-${this.data!.format('yyyyMMdd')}';
    return data;
  }
}

class Sigcaut2DataItemModel extends ODataModelClass<Sigcaut2DataItem> {
  Sigcaut2DataItemModel() {
    collectionName = 'sigcaut2_data';
    super.API = ODataInst();
    super.CC = CloudV3().client;
  }
  Sigcaut2DataItem newItem() => Sigcaut2DataItem();

  Future<List<dynamic>> vendasPeriodo(
      {double? filial, required DateTime de, required DateTime ate}) async {
    String dDe = de.toIso8601String().substring(0, 10);
    String dAte = ate.toIso8601String().substring(0, 10);
    return search(
      resource: (driver == 'mssql') ? 'sigcaut2' : collectionName,
      select:
          "filial,data,sum(valor*(case when operacao<'200' then 1 else -1 end)) valor",
      top: 100,
      filter: //((filial > 0) ? 'filial eq $filial and ' : '') +
          " data ge '$dDe' and data le '$dAte' ${(filial != null) ? 'and filial eq ' + filial.toString() : ''} ",
      orderBy: 'data,filial',
      groupBy: 'data,filial',
      cacheControl: 'no-cache',
    ).then((rsp) => rsp.asMap());
  }

  Future<List<dynamic>> vendasQtdePeriodo(
      {String? filterExt,
      String? selectExt,
      double? filial,
      required DateTime de,
      required DateTime ate}) async {
    String dDe = de.toIso8601String().substring(0, 10);
    String dAte = ate.toIso8601String().substring(0, 10);
    /* if (driver == 'mssql') {
      return search(
              resource: (driver == 'mssql') ? 'sigcaut2' : collectionName,
              select:
                  "filial,data,sum(valor*(case when operacao<'200' then 1 else -1 end)) valor,sum(qtde*(case when operacao<'200' then 1 else -1 end)) qtde",
              top: 100,
              filter: //((filial > 0) ? 'filial eq $filial and ' : '') +
                  " (data ge '$dDe' and data le '$dAte') ${(filial != null) ? 'and filial eq ' + filial.toString() : ''}  ${(filterExt != null) ? ' and ' + filterExt : ''}   ",
              orderBy: 'data,filial',
              groupBy: 'data,filial')
          .then((rsp) => rsp.asMap());
    }*/
    return search(
      resource: collectionName,
      select:
          " extract(month from data) mes,extract(year from data) ano,filial,sum(valor*(case when operacao<'200' then 1 else -1 end)) valor,sum(qtde*(case when operacao<'200' then 1 else -1 end)) qtde ${selectExt != null ? ', ' + selectExt : ''}  ",
      top: 100,
      filter: //((filial > 0) ? 'filial eq $filial and ' : '') +
          " (data ge '$dDe' and data le '$dAte') ${(filial != null) ? 'and filial eq ' + filial.toString() : ''}  ${(filterExt != null) ? ' and ' + filterExt : ''}   ",
      orderBy: '2,1,filial',
      groupBy: '2,1,filial',
      cacheControl: 'no-cache',
    ).then((rsp) => rsp.asMap());
  }

  Future<dynamic> kpiVendasPeriodo(
      {required double filial,
      required DateTime de,
      required DateTime ate}) async {
    String dDe = de.toIso8601String().substring(0, 10);
    String dAte = ate.toIso8601String().substring(0, 10);
    return search(
      resource:
          'sigcaut2 a', //'${(driver == 'mssql') ? 'sigcaut2' : collectionName}  a ',
      join: 'left join ctprod c on (a.codigo=c.codigo)',
      select: "count(*) eventos,sum(a.valor*(case when a.operacao<'200' then 1 else -1 end)) valor, " +
          "sum(case when c.inServico='S' then a.valor*(case when a.operacao<'200' then 1 else -1 end) end) as servicos," +
          "sum(case when coalesce(c.inServico,'N')<>'S' then a.valor*(case when a.operacao<'200' then 1 else -1 end) end) as produtos, " +
          "sum(case when coalesce(c.inServico,'N')<>'S' then a.qtde*a.pa*(case when a.operacao<'200' then 1 else -1 end) end) as pa",
      top: 100,
      filter: //((filial > 0) ? 'filial eq $filial and ' : '') +
          "data ge '$dDe' and data le '$dAte' ",
    ).then((rsp) {
      return rsp.docs[0].data();
    });
  }
}
