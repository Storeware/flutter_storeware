// @dart=2.12
// @dart=2.12
import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';
import 'package:controls_data/odata_firestore.dart';

class MeiopgtoItem extends DataItem {
  int? idMeioPagto;
  String? sgMeioPagto;
  String? dsMeioPagto;
  String? idGrupoWba;
  String? inLiqDuvidosa;

  MeiopgtoItem({
    this.idMeioPagto,
    this.sgMeioPagto,
    this.dsMeioPagto,
    this.idGrupoWba,
    this.inLiqDuvidosa,
  });

  MeiopgtoItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }
  @override
  fromMap(Map<String, dynamic> json) {
    idMeioPagto = toInt(json['id_meio_pagto']);
    sgMeioPagto = json['sg_meio_pagto'];
    dsMeioPagto = json['ds_meio_pagto'];
    idGrupoWba = json['id_grupo_wba'];
    inLiqDuvidosa = json['in_liq_duvidosa'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_meio_pagto'] = this.idMeioPagto;
    data['sg_meio_pagto'] = this.sgMeioPagto;
    data['ds_meio_pagto'] = this.dsMeioPagto;
    data['id_grupo_wba'] = this.idGrupoWba;
    data['in_liq_duvidosa'] = this.inLiqDuvidosa;
    data['id'] = '$idMeioPagto';
    return data;
  }
}

class MeiopgtoItemModel extends ODataModelClass<MeiopgtoItem> {
  MeiopgtoItemModel() {
    collectionName = 'meiopgto';
    super.API = ODataInst();
    super.CC = CloudV3().client..client.silent = true;
  }
  MeiopgtoItem newItem() => MeiopgtoItem();
}
