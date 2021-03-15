import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';
import 'package:controls_data/odata_firestore.dart';

class FpMeioItem extends DataItem {
  int? idCond;
  String? sgCond;
  String? dsCond;
  int? idMeioPagto;
  String? sgMeioPagto;
  String? dsMeioPagto;
  String? checkdata;
  int? qtdeParc;
  String? inAplicSinal;
  String? inAplicParc;

  FpMeioItem(
      {this.idCond,
      this.sgCond,
      this.dsCond,
      this.idMeioPagto,
      this.sgMeioPagto,
      this.dsMeioPagto,
      this.checkdata,
      this.qtdeParc,
      this.inAplicSinal,
      this.inAplicParc});

  FpMeioItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }
  @override
  fromMap(Map<String, dynamic> json) {
    idCond = json['id_cond'];
    sgCond = json['sg_cond'];
    dsCond = json['ds_cond'];
    idMeioPagto = json['id_meio_pagto'];
    sgMeioPagto = json['sg_meio_pagto'];
    dsMeioPagto = json['ds_meio_pagto'];
    checkdata = json['checkdata'];
    qtdeParc = json['qtde_parc'];
    inAplicSinal = json['in_aplic_sinal'];
    inAplicParc = json['in_aplic_parc'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_cond'] = this.idCond;
    data['sg_cond'] = this.sgCond;
    data['ds_cond'] = this.dsCond;
    data['id_meio_pagto'] = this.idMeioPagto;
    data['sg_meio_pagto'] = this.sgMeioPagto;
    data['ds_meio_pagto'] = this.dsMeioPagto;
    data['checkdata'] = this.checkdata;
    data['qtde_parc'] = this.qtdeParc;
    data['in_aplic_sinal'] = this.inAplicSinal;
    data['in_aplic_parc'] = this.inAplicParc;
    data['id'] = '$idCond';
    return data;
  }
}

class FpMeioItemModel extends ODataModelClass<FpMeioItem> {
  FpMeioItemModel() {
    collectionName = 'fp_meio';
    super.API = ODataInst();
    super.CC = CloudV3().client..client.silent = true;
  }
  FpMeioItem newItem() => FpMeioItem();

  listGrid({filter, top = 20, skip = 0, orderBy, cacheControl}) {
    return search(
      resource: collectionName,
      select: 'id_cond,id_meio_pagto',
      filter: filter,
      top: top,
      skip: skip,
      orderBy: orderBy,
      cacheControl: cacheControl ?? 'no-cache',
    ).then((rsp) => rsp.asMap());
  }
}
