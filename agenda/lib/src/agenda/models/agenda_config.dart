// @dart=2.12

import 'package:controls_data/odata_client.dart';

class AgendaConfig {
  static final _singleton = AgendaConfig._create();
  AgendaConfig._create();
  factory AgendaConfig() => _singleton;

  String? agendaHoraInicio = '06:00';
  String? agendaHoraFim = '20:00';
  int agendaIntervalo = 30;

  toJson() {
    return {
      "agenda_horainicio": agendaHoraInicio,
      "agenda_horafim": agendaHoraFim,
      "agenda_intervalo": agendaIntervalo
    };
  }

  fromMap(Map<String, dynamic> json) {
    agendaHoraInicio = json['agenda_horainicio'];
    agendaHoraFim = json['agenda_horafim'];
    agendaIntervalo = toInt(json['agenda_intervalo']);
  }

  double get nHoraInicio {
    return double.tryParse((agendaHoraInicio ?? '07:00').split(':')[0]) ?? 6.0;
  }

  double get nHoraFim {
    return double.tryParse((agendaHoraFim ?? '20:00').split(':')[0]) ?? 20.0;
  }
}
