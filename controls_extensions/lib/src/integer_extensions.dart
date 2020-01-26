extension IntegerExtension on int {
  toStrZero(int count) {
    return this.toString().padLeft(count, '0');
  }
  
  int min(int value) {
    return (this < value) ? value : this;
  }

  int max(int value) {
    return (this > value) ? value : this;
  }

}
