import 'package:intl/date_symbol_data_local.dart';
import "package:intl/intl.dart";

/// chamada global para desativar em produção
debug(texto) {
  print(texto);
}

error(texto) {
  print(texto);
}

/// usar para informações (não debug)
info(texto) {
  print(texto);
}

firebase_loading() {
  initializeDateFormatting("pt_BR", null);
}

var defaultLang = 'pt_BR';

class DataFields {
  Map<String, dynamic> data = {};
  int get length => data.length;
  dynamic value(key) => data[key];
  List<String> keys() {
    return data.keys.toList();
  }

  List<dynamic> values() {
    return data.values.toList();
  }
}

DateTime? toDate(d) {
  if (d is DateTime) {
    return dateTimeCombine(d, '00:00');
  }
  var s = d.toString();
  if (s.contains('/')) {
    var v =
        s.substring(6, 4) + '-' + s.substring(3, 2) + '-' + s.substring(0, 1);
    return DateTime.tryParse(v);
  }
  var dt = DateTime.tryParse((d ?? DateTime.now()).toString());
  return dateTimeCombine(dt, '00:00');
}

DateTime dateTimeCombine(DateTime? date, String? time) {
  var dt = date ?? DateTime.now();
  var t = DateTime.tryParse('0000-00-00 ' + (time ?? '00:00'));
  return DateTime(dt.year, dt.month, dt.day, t?.hour ?? 0, t?.minute ?? 0);
}

bool checaAgendaAlerta(DateTime d, {int minutos = 15}) {
  return d
          .difference(DateTime.now().subtract(Duration(minutes: minutos)))
          .inMinutes <
      0;
}

String getDataExtensoAmigavel(DateTime data) {
  String r = '';
  if (toDate(data) == toDate(DateTime.now())) {
    r += 'Hoje as ';
    r += '${formatTime(data)}';
  } else {
    var dif = data.difference(DateTime.now());
    var d = dif.inHours;
    if (d < 24) {
      r = ' em $d horas';
    } else {
      var dias = dif.inDays;
      r = ' em $dias dias';
    }
  }
  return r;
}

String? formatTime(d) {
  var s = d.toString();
  var t = DateTime.tryParse(s);
  if (t == null) return null;
  //return TimeOfDay.fromDateTime(t).toString();
  return "${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}";
}

DateTime? stringToDateTime(String d) {
  return DateTime.tryParse(d);
}

String formatDateTime(String mask, DateTime d) {
  return DateFormat(mask, defaultLang).format(d);
}

DateTime today() {
  DateTime now = new DateTime.now();
  DateTime date = new DateTime(now.year, now.month, now.day);
  return date;
}

double? toDouble(v, {int? dec}) {
  if (v == null) return 0;
  String? d = v.toString();
  double r = double.tryParse((d).replaceAll(',', '.'))!;
  if (dec != null) return double.parse(r.toStringAsFixed(dec));
  return r;
}

String formatDouble(double v, dec) {
  return v.toStringAsFixed(dec);
}

String formatMoeda(double v, dec, {simbol = '\$'}) {
  return simbol + ' ' + formatDouble(v, dec).replaceAll('.', ',');
}

String? formatDate(DateTime? d) {
  debug('data_model.formatDate-> $d');
  if (d == null) return null;
  return "${d.day.toString().padLeft(2, '0')}-${d.month.toString().padLeft(2, '0')}-${d.year.toString()} ";
}
