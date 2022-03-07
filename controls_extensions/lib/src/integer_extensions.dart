import 'dynamic_extensions.dart';

extension IntegerExtension on int {
  /// convert int para string padleft '0'
  toStrZero(int count) {
    return this.toString().padLeft(count, '0');
  }

  int from(value) => toInt(value);

  /// min valor
  int min(int value) {
    return (this < value) ? value : this;
  }

  /// max valor
  int max(int value) {
    return (this > value) ? value : this;
  }

  /// range -> gerar um intervalo de/ate
  Iterable<int> range(int from, int to, {int skip = 1}) sync* {
    while (from.compareTo(to) <= 0) {
      yield from;
      from += skip;
    }
  }

  Iterable<int> rangeTo(int to, {int skip = 1}) => range(this, to, skip: skip);

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
