import 'package:intl/intl.dart';

/// https://api.flutter.dev/flutter/intl/NumberFormat-class.html
/// [NumberFormat]
extension DoubleExtension on double {
  String format(String mask, {String lang}) {
    final oCcy = new NumberFormat(mask, lang ?? Intl.defaultLocale);
    return oCcy.format(this);
  }
}

extension CurrencyExtension on double {
  static get currencyName => NumberFormat().currencyName;
  static get currencySymbol => NumberFormat().currencySymbol;
  String formatCurrency() => NumberFormat.simpleCurrency().format(this);
}
