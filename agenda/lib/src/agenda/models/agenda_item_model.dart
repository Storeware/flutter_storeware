// @dart=2.12

import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';
import 'package:uuid/uuid.dart';

class AgendaItem extends DataItem {
  String? gid;
  String? estadoGid = '1';
  String? tipoGid;
  String? titulo;
  String? objetoAgendaNome;
  String? texto;
  DateTime? datainicio;
  DateTime? datafim;
  //String horainicio;
  //String horafim;
  String? recursoGid;
  int? completada = 0;
  DateTime? datalembrete;
  String? opcoesGid;
  int? minutoslembrete;
  int? recursosindex;
  String? local;
  int? cor;
  String? grupoid;
  String? parentid;
  int? options;
  int? eventtype;
  int? statex;
  num? sigcadCodigo;
  String? nomeCliente;
  String? domicilio;
  String? caption;

  /// usado para pegar o objeto do servico ao qual a agenda esta associada; No PET é uma tabela externa
  String? objectServiceGid;
  int? difMinutes = 0;

  get resource => recursoGid;
  set resource(x) => recursoGid = x;
  DateTime? get end => datafim;
  set end(x) => datafim = x;
  DateTime? get start => datainicio;
  set start(x) => datainicio = x;
  String? get id => gid;
  set id(x) => gid = x;

  AgendaItem(
      {this.gid,
      this.estadoGid,
      this.tipoGid,
      this.titulo,
      this.texto,
      this.datainicio,
      this.datafim,
      //this.horainicio,
      // this.horafim,
      this.recursoGid,
      this.completada,
      this.datalembrete,
      this.opcoesGid,
      this.minutoslembrete,
      this.recursosindex,
      this.local,
      this.cor,
      this.grupoid,
      this.parentid,
      this.options,
      this.eventtype,
      this.statex,
      this.sigcadCodigo,
      this.domicilio,
      this.caption}) {
    gid = gid ?? Uuid().v4();
  }

/*
  @override
  bool operator ==(covariant AgendaItem item) => false;
  int __count = 0;
  @override
  get hashCode => __count;
  changed() {
    __count++;
  }
*/
  AgendaItem.fromJson(Map<String, dynamic> json, {zone = 0}) {
    fromMap(json, zone: zone);
  }
  @override
  fromMap(Map<String, dynamic> json, {zone = 0}) {
    try {
      gid = json['gid'] ?? Uuid().v4();
      estadoGid = json['estado_gid'] ?? '1';
      tipoGid = json['tipo_gid'];
      titulo = json['titulo'] ?? '';
      objetoAgendaNome = json['objetoAgendaNome'];
      texto = json['texto'] ?? '';
      datainicio = toDateTime(json['datainicio'], zone: zone);
      datafim = toDateTime(json['datafim'], zone: zone);
      if (datafim!.difference(datainicio!).isNegative)
        datafim = datainicio!.add(Duration(minutes: 15));
      difMinutes = datafim!.difference(datainicio!).inMinutes;
      //horainicio = json['horainicio'];
      // horafim = json['horafim'];
      recursoGid = json['recurso_gid'];
      completada = toInt(json['completada'] ?? '0');
      datalembrete = toDateTime(json['datalembrete'], zone: zone);
      opcoesGid = json['opcoes_gid'];
      minutoslembrete = toInt(json['minutoslembrete']);
      recursosindex = json['recursosindex'];
      local = json['local'];
      cor = json['cor'];
      grupoid = json['grupoid'];
      parentid = json['parentid'];
      options = json['options'];
      eventtype = json['eventtype'];
      statex = json['state'];
      sigcadCodigo = toDouble(json['sigcad_codigo']);
      domicilio = json['domicilio'];
      caption = json['caption'];
      objectServiceGid = json['objectServiceGid'];
      nomeCliente = json['nomecliente'];
    } catch (e) {
      print('fromMap: $e');
    }
    //  changed();
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    try {
      data['gid'] = this.gid ?? Uuid().v4();
      data['estado_gid'] = this.estadoGid ?? 1;
      data['tipo_gid'] = this.tipoGid;
      data['titulo'] = this.titulo;
      data['objetoAgendaNome'] = this.objetoAgendaNome;
      data['texto'] = this.texto;
      data['datainicio'] = this.datainicio;
      data['datafim'] = this.datafim;
      data['horainicio'] = '1899-12-30 ' + toTimeSql(this.datainicio!);
      data['horafim'] = '1899-12-30 ' + toTimeSql(this.datafim!);
      data['recurso_gid'] = this.recursoGid;
      data['completada'] = this.completada ?? 0;
      int minutos = this.minutoslembrete ?? 15;
      data['datalembrete'] = (this.datalembrete ??
          this.datainicio!.add(Duration(minutes: -minutos)));
      data['opcoes_gid'] = this.opcoesGid;
      data['minutoslembrete'] = this.minutoslembrete ?? minutos;
      data['recursosindex'] = this.recursosindex;
      data['local'] = this.local;
      data['cor'] = this.cor;
      data['grupoid'] = this.grupoid;
      data['parentid'] = this.parentid;
      data['options'] = this.options;
      data['eventtype'] = this.eventtype ?? 0;
      data['state'] = this.statex;
      data['sigcad_codigo'] = this.sigcadCodigo ?? 0;
      data['domicilio'] = this.domicilio ?? 'N';
      data['caption'] = this.caption;
      data['id'] = data['gid'];
      if (objectServiceGid != null)
        data['objectServiceGid'] = this.objectServiceGid;
      data['nomecliente'] = nomeCliente;
    } catch (e) {
      print('AgendaItem.toJson($data): $e');
    }
    return data;
  }

  AgendaItem clone() {
    return AgendaItem.fromJson(this.toJson());
  }

  AgendaItem validateValues() {
    if (datafim!.difference(datainicio!).isNegative)
      datafim = datainicio!.add(Duration(minutes: difMinutes ?? 30));
    return this;
  }
}
