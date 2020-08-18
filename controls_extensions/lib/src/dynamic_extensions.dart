extension DynamicExtension on dynamic {
  String toStr(value, {def = ''}) {
    return (value ?? def).toString();
  }

  int toInt(value, {def = 0}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return def;
  }

  double toDouble(value, {def = 0.0}) {
    if (value is double) return value;
    if (value is int) return value + 0.0;
    if (value is num) return value + 0.0;
    if (value is String) return double.tryParse(value);
    return def;
  }

  bool toBool(value, {def: false}) {
    if (value is bool) return value;
    if (value is num) return (value == 0) ? false : true;
    if (value is String) return (value == '1' || value == 'T');
    return def;
  }

  DateTime toDateTime(value, {DateTime def, int z = 0}) {
    if (value is String) {
      var v = DateTime.tryParse(value);
      int dif = z;
      if (v != null) {
        dif = (value.endsWith('Z'))
            ? 0
            : dif; // quando termado Z  não muda o fuso.
        return DateTime.tryParse(value)?.add(Duration(hours: dif));
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
