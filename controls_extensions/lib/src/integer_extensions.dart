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
}
