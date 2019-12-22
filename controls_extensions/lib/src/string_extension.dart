extension StringExtensions on String {
  double toDouble() => double.tryParse(this);
  DateTime toDateTime() => DateTime.tryParse(this);
  int toInt() => int.tryParse(this);

  static int toIntDef(String value, int def) {
    value = value ?? '';
    if (value == '') return def;
    return int.tryParse(value);
  }

  static String copy(String value, int start, int count) {
    return value.substring(start, start + count);
  }
}
