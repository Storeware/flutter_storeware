extension StringExtensions on String {
  double toDouble() => double.tryParse(this) ?? 0.0;
  DateTime? toDateTime() => DateTime.tryParse(this);
  int toInt() => int.tryParse(this) ?? 0;

  int toIntDef(int def) {
    if (this == '') return def;
    return int.tryParse(this) ?? def;
  }

  String truncate(int value) {
    if (this.length > value)
      return this.padRight(value);
    else
      return this;
  }

  String from(value) => '$value';

  bool charIsNum(c) {
    return '0,1,2,3,4,5,6,7,8,9'.contains(c);
  }

  bool strIsNumber() {
    int A, lenStr;
    bool result = false;
    lenStr = this.length;
    result = (lenStr > 0);
    A = 0;
    while (result && (A < lenStr)) {
      result = charIsNum(this[A]);
      A++;
    }
    return result;
  }

  String cleanString([String charsValid = '1234567890']) {
    int A, lenStr;
    String result = '';
    lenStr = this.length;

    A = 0;
    while (A < lenStr) {
      if (charsValid.contains(this[A])) result += this[A];
      A++;
    }
    return result;
  }

  String copy(int start, int count) {
    return this.substring(start, start + count);
  }

  toUpperCapital({except}) {
    var lista = this.split(' ');
    var excluir = except ?? ',de,ate,para,';
    var r = '';
    lista.forEach((f) {
      // chce se é palavra que nao converte
      if ((f.length == 1) || (excluir.contains(f.toLowerCase())))
        r += r != '' ? ' ' : '';
      else
        r += ((r != '') ? ' ' : '') +
            f.substring(0, 1).toUpperCase() +
            f.substring(1).toLowerCase();
    });
    return r;
  }

  operator <=(value) => ((this.compareTo(value) <= 0));
  operator >=(value) => ((this.compareTo(value) >= 0));
  firstName({String separator = ' '}) {
    if (isEmpty) return '';
    return this.split(separator).first;
  }

  lastName({String separator = ' '}) {
    if (isEmpty) return '';
    return this.split(separator).last;
  }

  get shortAvatar {
    if (isEmpty) return '';
    var rsp = split(' ');

    var rt = this[0];
    if (rsp.length > 1) rt += rsp[1][0];
    return rt;
  }
}
