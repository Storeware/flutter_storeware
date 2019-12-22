import 'dart:math' as math;

int strToIntDef(String value, int def) {
  value = value ?? '';
  if (value == '') return def;
  return int.tryParse(value);
}

intToStrZero(int value, int decs) {
  return value.toString().padLeft(decs, '0');
}

num roundTo(double value, int decs) {
  if (decs < 0) decs = -decs;
  int fac = math.pow(10, decs);
  return (value * fac).round() / fac;
}

num round(double value) {
  var r = roundTo(value, 0);
  return r;
}

frac(value) {
  return value - value.truncate();
}

copy(String value, int start, int count) {
  return value.substring(start, start + count);
}

num intPower(num value, int exponent) {
  return math.pow(value, exponent);
}

bool odd(num value) {
  return (value % 2) == 1;
}

/*-----------------------------------------------------------------------------
 Faz o mesmo que "SimpleRoundTo", porém divide pelo Fator, ao invés de Multiplicar.
 Isso evita Erro A.V. de estouro de Inteiro.
 Nota: Funcao copiada de SimpleRoundTo do Delphi Seatle
 -----------------------------------------------------------------------------*/
double simpleRoundToEX(double avalue, [int ADigit = -2]) {
  double result;
  double lfactor;

  lfactor = intPower(10.0, ADigit);
  if (avalue < 0)
    result = ((avalue / lfactor).truncate() - 0.5) * lfactor;
  else
    result = ((avalue / lfactor) + 0.5).truncate() * lfactor;
  return result;
}

double roundABNT(double avalue, [int digits = -2, double delta = 0.00001]) {
  double pow, fracValue, powValue;
  double restPart, lastNumber = 0;
  int intCalc, fracCalc, intValue;
  bool negativo;

  double result = 0;
  negativo = (avalue < 0);

  pow = intPower(10.0, digits.abs());
  powValue = avalue / 10;
  intValue = (powValue.truncate());
  fracValue = frac(powValue);

  powValue = simpleRoundToEX(
      fracValue * 10 * pow, -9); // SimpleRoundTo elimina dizimas ;
  intCalc = powValue.truncate();
  fracCalc = (frac(powValue) * 100).truncate();

  if (fracCalc > 50)
    intCalc++;
  else if (fracCalc == 50) {
    lastNumber = round(frac(intCalc / 10) * 10);

    if (odd(lastNumber))
      intCalc++;
    else {
      restPart = frac(powValue * 10);

      if (restPart > delta) intCalc++;
    }
  }

  result = ((intValue * 10) + (intCalc / pow));
  if (negativo) result = -result;

  return result;
}
