extension DynamicExtension on dynamic {
  String toStr(value, {def = ''}) {
    return (value ?? def).toString();
  }

  int toInt(value, {def = 0}) {
    return toDouble(value, def: def).toInt();
  }

  double toDouble(value, {def = 0.0}) {
    if (value is double) return value;
    if (value is int) return value + 0.0;
    if (value is num) return value + 0.0;
    if (value is String) return double.tryParse(value) ?? 0.0;
    return def;
  }

  DateTime toTime(DateTime value) {
    return DateTime(0, 0, 0, value.hour, value.minute, value.second);
  }

  bool toBool(value, {def: false}) {
    if (value is bool) return value;
    if (value is num) return (value == 0) ? false : true;
    if (value is String) return (value == '1' || value == 'T');
    return def;
  }

  int strTimeToMinutes(String time) {
    try {
      var sp = time.split(':');
      int h = 0, m = 0;
      h = int.tryParse(sp[0]) ?? 0;
      if (sp.length > 1) m = int.tryParse(sp[1]) ?? 0;
      if (h < 0) h = h * -1;
      num f = (time.startsWith('-')) ? -1 : 1;
      return ((f * (h * 60) + m) ~/ 1);
    } catch (e) {
      return 0;
    }
  }

  DateTime toDateTime(value, {DateTime? def, num zone = -3}) {
    if (value is String) {
      DateTime? v = DateTime.tryParse(value);
      num dif = zone * 60;
      if (v != null) {
        dif = (value.endsWith('Z')) ? dif : 0;
        if ('$value'.length > 20)
          dif = strTimeToMinutes('$value'.substring(19));
        // quando termado Z  formatar fuso horario.
        return v.add(Duration(minutes: ((dif)) ~/ 1));
      }
    }
    if (value is DateTime) return value;
    return def ?? DateTime.now();
  }

  get isNull => this == null;
  get isNotNull => this != null;
  iff(bool b, t, f) {
    if (b)
      return t;
    else
      return f;
  }
}
