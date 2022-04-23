// @dart=2.12
//import 'dart:convert';

import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';

class CtprodsdItem extends DataItem {
  String? codigo;
  double? filial;
  double? qestfin;
  double? pmedio;

  CtprodsdItem({
    this.codigo,
    this.filial,
    this.qestfin,
    this.pmedio,
  });

  CtprodsdItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }

  validar() {}

  @override
  fromMap(Map<String, dynamic> json) {
    codigo = json['codigo'];
    filial = toDouble(json['filial']);
    qestfin = toDouble(json['qestfin']);
    pmedio = toDouble(json['pmedio']);
    validar();
    return this;
  }

  Map<String, dynamic> toJson() {
    validar();
    Map<String, dynamic> data = {
      "codigo": this.codigo,
      "filial": filial,
      "qestfin": qestfin,
      "pmedio": pmedio
    };
    return data;
  }
}

class CtprodsdItemModel extends ODataModelClass<CtprodsdItem> {
  CtprodsdItemModel() {
    collectionName = 'ctprodsd';
    super.API = ODataInst();
  }
  CtprodsdItem newItem() => CtprodsdItem();
  Future<List<dynamic>> listSaldos(
      {filter,
      top,
      skip,
      orderBy,
      required double filial,
      String? selectExt}) async {
    //var c = 'a.' + CtprodsdItem().toJson().keysJoin(separator: ', a.');
    //print(c);
    return listNoCached(
        resource:
            'ctprodsd a left join ctprod_filial c on (a.codigo=c.codigo and a.filial=c.filial),ctprod b',
        select:
            'a.codigo,b.nome,a.qestfin,a.filial,a.pmedio, b.unidade ${(selectExt != null) ? ', ' + selectExt : ''}',
        filter: 'a.codigo=b.codigo and a.filial=$filial ' +
            (((filter ?? '') != '') ? ' and $filter ' : ''),
        top: top,
        skip: skip,
        orderBy: orderBy);
  }

  listSaldosConsignado({
    filter,
    top,
    skip,
    orderBy,
  }) async {
    return listNoCached(
        resource: 'ctprodsd_consignado a, ctprod b',
        select: 'a.clifor,a.codigo,b.nome,a.qtde',
        filter: 'a.codigo=b.codigo ' + (filter != null ? ' and $filter ' : ''),
        top: top,
        skip: skip,
        orderBy: orderBy);
  }

  Future<dynamic> listConsignadosClientes({
    filter,
    top,
    skip,
    required double filial,
    orderBy,
  }) async {
    String qry = '''
    select * from 
     (select 
       a.clifor codigo,b.nome,max(a.dtatualiz) dtatualiz,sum(a.qtde) qtde, count(*) itens, sum(a.qtde * c.precovenda) valor
     from  ctprodsd_consignado a, sigcad b left join ctprod_filial c on (b.codigo=c.codigo)
     where
        a.clifor=b.codigo and  c.filial=$filial   ${(filter != null) ? ' and $filter ' : ''}
     group by a.clifor,b.nome ) k
    order by k.dtatualiz desc       
    ''';
    //print(qry);
    return API!.execute(qry).then((rsp) {
      //print(rsp);
      var j = API!.client.decode(rsp)['result'];
      return j;
    }).catchError((onError) {
      //print(onError);
      return [];
    });
  }
}
