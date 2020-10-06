import 'package:intl/intl.dart';
import 'dart:math' as math;
import 'ACBrUtil.dart' as utils;
import 'dynamic_extensions.dart';

/// https://api.flutter.dev/flutter/intl/NumberFormat-class.html
/// [NumberFormat]
extension NumExtension on num {
  num between(num de, num ate) {
    num valor = this;
    if (valor > ate) valor = ate;
    if (valor < de) valor = de;
    return valor;
  }
}

extension DoubleExtension on double {
  String format(String mask, {String lang}) {
    final oCcy = new NumberFormat(mask, lang ?? Intl.defaultLocale);
    return oCcy.format(this);
  }

  double from(value) {
    return ''.toDouble(value);
  }

  num min(num value) {
    return (this > value) ? value : this;
  }

  num max(num value) {
    return (this < value) ? value : this;
  }

  num roundABNT(int decs) {
    return utils.roundABNT(this, decs);
  }

  num roundTo(int decs) {
    if (decs < 0) decs = -decs;
    int fac = math.pow(10, decs);
    return (this * fac).round() / fac;
  }

  fraction() {
    return this - this.truncate();
  }

  bool odd(num value) {
    return (value % 2) == 1;
  }

  double simpleRoundTo([int digit = -2]) {
    double result;
    double lfactor;
    if (digit > 0) digit = -digit;
    lfactor = math.pow(10.0, digit);
    if (this < 0)
      result = ((this / lfactor).truncate() - 0.5) * lfactor;
    else
      result = ((this / lfactor) + 0.5).truncate() * lfactor;
    return result;
  }
}

extension CurrencyExtension on double {
  static get currencyName => NumberFormat().currencyName;
  static get currencySymbol => NumberFormat().currencySymbol;
  String formatCurrency() => NumberFormat.simpleCurrency().format(this);
}

extension IntExtensions on int {
  int min(int value) {
    return (this > value) ? value : this;
  }

  int max(int value) {
    return (this < value) ? value : this;
  }
}
