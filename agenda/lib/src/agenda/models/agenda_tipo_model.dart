// @dart=2.12

import 'package:controls_data/cached.dart';
import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';
import 'package:controls_data/odata_firestore.dart';
import 'package:controls_web/controls/color_picker.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AgendaTipoItem extends DataItem {
  String? gid;
  String? nome;
  String? inativo;
  String? ctprodCodigo;
  String? gerarcobranca;
  String? cor;
  bool? requerContato;

  AgendaTipoItem(
      {this.gid,
      this.nome,
      this.inativo,
      this.ctprodCodigo,
      this.gerarcobranca,
      this.requerContato,
      this.cor});

  AgendaTipoItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }
  @override
  fromMap(Map<String, dynamic> json) {
    try {
      gid = json['gid'];
      nome = json['nome'];
      inativo = json['inativo'];
      ctprodCodigo = json['ctprod_codigo'];
      gerarcobranca = json['gerarcobranca'];
      cor = json['cor'];
      requerContato = (json['requercontato'] ?? 'N') == 'S';
    } catch (e) {
      print('AgendaTipo.fromMap $json $e');
    }
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gid'] = this.gid ?? Uuid().v4();
    data['nome'] = this.nome;
    data['inativo'] = this.inativo ?? 'N';
    data['ctprod_codigo'] = this.ctprodCodigo;
    data['gerarcobranca'] = this.gerarcobranca ?? 'N';
    data['cor'] = this.cor;
    data['id'] = data['gid'];
    data['requercontato'] = this.requerContato! ? 'S' : 'N';
    return data;
  }

  get color => ColorExtension.hexToARGB(this.cor ?? '', Colors.blue);
}

class AgendaTipoItemModel extends ODataModelClass<AgendaTipoItem> {
  AgendaTipoItemModel() {
    collectionName = 'agenda_tipo';
    super.API = ODataInst();
    super.CC = CloudV3().client..client.silent = true;
  }
  AgendaTipoItem newItem() => AgendaTipoItem();

  @override
  list({filter}) {
    return Cached.value<dynamic>('${collectionName}_$filter', builder: (k) {
      return super.listNoCached(filter: filter);
    });
  }

  findOne(gid) async {
    var rt;
    await list().then((rsp) {
      return rsp.forEach((it) {
        if (it['gid'] == gid) rt = it;
      });
    });
    return rt;
  }

  clearCache() {
    Cached.clearLike(collectionName);
  }
}
