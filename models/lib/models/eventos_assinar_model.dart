// @dart=2.12
//import 'dart:convert';

import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';
//import 'package:controls_web/controls/profile_widgets.dart';
import 'package:uuid/uuid.dart';
//import 'package:controls_extensions/extensions.dart' hide DynamicExtension;

class EventosAssinarItem extends DataItem {
  DateTime? data;
  String? evNome;
  int? evGrupo;
  int? evEstado;
  String? pessoa;
  String? inativo;
  String? gid;
  String? descricao;

  EventosAssinarItem(
      {this.data,
      this.evNome,
      this.evGrupo,
      this.evEstado,
      this.pessoa,
      this.inativo,
      this.gid});

  EventosAssinarItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data ?? DateTime.now();
    data['ev_nome'] = this.evNome;
    data['ev_grupo'] = this.evGrupo;
    data['ev_estado'] = this.evEstado;
    data['pessoa'] = this.pessoa;
    data['inativo'] = this.inativo ?? 'S';
    data['gid'] = this.gid ?? Uuid().v4();
    // nao faz parte da tabela, somente de controle de memoria
    data['descricao'] = this.descricao;

    return data;
  }

  @override
  fromMap(Map<String, dynamic> json) {
    data = toDateTime(json['data']);
    evNome = json['ev_nome'];
    evGrupo = toInt(json['ev_grupo']);
    evEstado = toInt(json['ev_estado']);
    pessoa = json['pessoa'];
    inativo = json['inativo'];
    gid = json['gid'];
    descricao = json['descricao'];
  }
}

class EventosAssinarItemModel extends ODataModelClass<EventosAssinarItem> {
  EventosAssinarItemModel() {
    collectionName = 'eventos_assinar';
    super.API = ODataInst();
  }
  EventosAssinarItem newItem() => EventosAssinarItem.fromJson({});

  Future<List> eventosQueAssino({usuario = 'm5'}) {
    var qry = '''select x.*,xb.data, xb.pessoa, xb.inativo from
 (select a.nome ev_nome , a.descricao,a.ev_grupo,a.ev_estado,
      (select first 1 gid from eventos_assinar b where 
       a.nome = b.EV_NOME and b.pessoa='$usuario' ) gid
        from  eventos_auto a 
        where a.inativo='N'
  ) x
  left join eventos_assinar xb on (xb.GID = x.gid)''';
    if (driver == 'mssql') qry = qry.replaceAll('first 1', 'top 1');
    return API!.openJson(qry).then((rsp) {
      return rsp['result'];
    });
  }

  assinarOrRevogar(Map<String, dynamic> item) {
    return API!.put('eventos_assinar', item);
  }
}
