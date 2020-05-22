import 'package:meta/meta.dart' show sealed;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

@sealed
//@immutable
class Money {
  double value;
  Money(this.value);
  toString() {
    return value.toString();
  }

  static tryParse(String value) {
    return Money(double.tryParse(value));
  }

  @override
  bool operator ==(other) =>
      (other is Money) ? this.value == other.value : false;
  compareTo(Money other) => this.value.compareTo(other.value);
  int get hashCode => this.value ~/ 1;
  Money operator -(double other) => Money(this.value - other);
  Money operator +(double other) => Money(this.value + other);
  Money operator /(double other) => Money(this.value / other);
  Money operator *(double other) => Money(this.value * other);
}

class CurrencyInputFormatter extends TextInputFormatter {
  static double toDouble(String v) {
    String value = v ?? '';
    value = value.replaceAll(RegExp(r'[\sR\$]+'), '');
    value = value.replaceAll(RegExp(r'[\.]+'), '');
    value = value.replaceAll(RegExp(r',+'), '.');
    return double.parse(value);
  }

  static String toMoney(double v) {
    if (v > 0) {
      String value = v.toString() ?? '0';
      if (value.contains('.'))
        value = value.replaceAll(RegExp(r'[\.]+'), ',');
      else
        value += ',00';
      return "R\$ $value";
    }
    return 'R\$ 0,00';
  }

  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) return newValue;

    double value = double.parse(newValue.text);

    final formatter = NumberFormat.simpleCurrency(locale: "pt_Br");

    String newText = formatter.format(value / 100);

    return newValue.copyWith(
        text: newText,
        selection: new TextSelection.collapsed(offset: newText.length));
  }
}
