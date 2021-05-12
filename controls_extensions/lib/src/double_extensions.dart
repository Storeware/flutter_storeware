import 'package:intl/intl.dart';
import 'dart:math' as math;
import 'ACBrUtil.dart' as utils;
import 'dynamic_extensions.dart';

/// https://api.flutter.dev/flutter/intl/NumberFormat-class.html
/// [NumberFormat]
/*extension NumExtension on num {
  num between(num de, num ate) {
    num valor = this;
    if (valor > ate) valor = ate;
    if (valor < de) valor = de;
    return valor;
  }
  //double get asDouble { final r= this; return (r+0.0);}

 // int get asInt { final r = this; return (r / ~1); }

}*/

extension DoubleExtension on double {
  bool get isZero {
    //final r = this;
    return this.compareTo(0.0) == 0;
  }

  bool get isNotZero => !isZero;
  bool get isNegative {
    //final r = this;
    return this.compareTo(0.0) < 0;
  }

  bool get isPositive {
    //final r = this;
    return this.compareTo(0.0) >= 0;
  }

  bool get isNotNegative => !isNegative;
  bool get isNotPositive => !isPositive;

  String format(String mask, {String? lang}) {
    final oCcy = new NumberFormat(mask, lang ?? Intl.defaultLocale);
    return oCcy.format(this);
  }

  toStringSql([frac = 2]) {
    return this.toStringAsFixed(frac).replaceAll(',', '.');
  }

  double between(double de, double ate) {
    double valor = this;
    if (valor > ate) valor = ate;
    if (valor < de) valor = de;
    return valor;
  }

  double from(value) {
    return toDouble(value);
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
    num fac = math.pow(10, decs);
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
    lfactor = math.pow(10.0, digit) + 0.0;
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

  int between(int de, int ate) {
    int valor = this;
    if (valor > ate) valor = ate;
    if (valor < de) valor = de;
    return valor;
  }

  bool get isZero {
    return this.compareTo(0) == 0;
  }

  bool get isNotZero => !isZero;
  bool get isNegative {
    return this.compareTo(0) < 0;
  }

  bool get isPositive {
    return this.compareTo(0) >= 0;
  }

  bool get isNotNegative => !isNegative;
  bool get isNotPositive => !isPositive;
}
