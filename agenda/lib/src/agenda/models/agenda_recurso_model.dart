// @dart=2.12

import 'dart:async';

import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';
import 'package:controls_data/odata_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:controls_web/controls/color_picker.dart';

class AgendaResourceNotifyChanged {
  static final _singleton = AgendaResourceNotifyChanged._create();
  AgendaResourceNotifyChanged._create();
  factory AgendaResourceNotifyChanged() => _singleton;
  var _stream = StreamController<dynamic>.broadcast();

  dispose() {
    _stream.close();
  }

  get stream => _stream.stream;
  notify(item) {
    _stream.sink.add(item);
  }
}

class AgendaRecursoItem extends DataItem {
  String? gid;
  String? nome;
  double? cor;
  double? ordem;
  String? inativo;
  double? intervalo;

  AgendaRecursoItem(
      {this.gid,
      this.nome,
      this.cor,
      this.intervalo,
      this.ordem,
      this.inativo});

  AgendaRecursoItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }
  @override
  fromMap(Map<String, dynamic> json) {
    gid = json['gid'];
    nome = json['nome'];
    cor = toDouble(json['cor']);
    ordem = toDouble(json['ordem']);
    inativo = json['inativo'];
    intervalo = toDouble(json['intervalo']);
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    this.gid ??= Uuid().v4();
    data['gid'] = this.gid;
    data['nome'] = this.nome;
    data['cor'] = this.cor ?? Colors.blue.toRGBInt();
    data['ordem'] = this.ordem ?? 0.0;
    data['inativo'] = this.inativo ?? 'N';
    data['id'] = data['gid'];
    data['intervalo'] = this.intervalo;
    return data;
  }
}

class AgendaRecursoItemModel extends ODataModelClass<AgendaRecursoItem> {
  AgendaRecursoItemModel() {
    collectionName = 'agenda_recurso';
    super.API = ODataInst();
    super.CC = CloudV3().client..client.silent = true;
  }
  AgendaRecursoItem newItem() => AgendaRecursoItem();
  @override
  post(item) {
    return super.post(item).then((it) {
      AgendaResourceNotifyChanged().notify(it);
      return it!;
    });
  }

  put(item) {
    return super.put(item).then((it) {
      AgendaResourceNotifyChanged().notify(it);
      return it!;
    });
  }

  delete(item) {
    return super.delete(item).then((it) {
      AgendaResourceNotifyChanged().notify(it);
      return it;
    });
  }
}
