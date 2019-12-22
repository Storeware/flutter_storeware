extension IntegerExtension on int {
  toStrZero(int count) {
    return this.toString().padLeft(count, '0');
  }
}
