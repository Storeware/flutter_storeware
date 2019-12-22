extension StringExtensions on String {
  double toDouble() => double.tryParse(this);
  DateTime toDateTime() => DateTime.tryParse(this);
  int toInt() => int.tryParse(this);
}
