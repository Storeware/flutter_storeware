import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  /// Format DateTime to custom mask
  format(String dateMask) {
    var formatter = new DateFormat(dateMask);
    return formatter.format(this);
  }
}
