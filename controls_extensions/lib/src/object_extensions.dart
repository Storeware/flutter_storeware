import 'datetime_extensions.dart';
import 'string_extensions.dart';

extension ObjectExtension on Object {
  /// dates
  dateTimeToString(String mask, DateTime value) => value.format(mask);

  /// doubles
  floatToStr(double value) => value.toString();
  truncFloat(double value) => value.truncate();
  roundFloat(double value, int decs) => value.toStringAsFixed(2).toDouble();
  strToFloat(String value) => value.toDouble();

  /// integers
  strToInt(String value) => value.toInt();
  intToStr(int value) => value.toString();
}
