import 'package:controls_extensions/src/ACBRExtenso.dart';
import 'package:controls_extensions/src/ACBrUtil.dart';
import 'package:controls_extensions/src/ACBrValidador.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:controls_extensions/extensions.dart';

void main() {
  DateTime t = DateTime.now().addHours(-1);
  test('Strings', () {
    expect('1232'.toDouble(), 1232);
    expect('2019-12-22T00:00:00'.toDateTime(), DateTime(2019, 12, 22));
    expect(''.from(123), '123');
    expect(0.from('123'), 123);
    expect(1.2.from('123.1'), 123.1);
    /* final calculator = Calculator();
    expect(calculator.addOne(2), 3);
    expect(calculator.addOne(-7), -6);
    expect(calculator.addOne(0), 1);
    expect(() => calculator.addOne(null), throwsNoSuchMethodError);*/
  });

  test('DateTime', () {
    DateTime data = DateTime.now();
    var dt = data.from('2019-10-06');
    expect(DateTime(2019, 10, 6), dt);
    print(dt);
    DateTime(2020).initialize();

    expect(DateTime(2019, 12, 19).format('MM-dd-yyyy'), '12-19-2019');
    expect(t.timeAgo(lang: 'pt_BR'), 'uma hora atrás');
    expect(
        t.range(DateTime(2020, 8, 1), DateTime(2020, 8, 10)).length.toString(),
        '10');
    expect(t.range(DateTime(2020, 8, 1), DateTime(2020, 8, 10)).last.day, 10);
  });

  test('Double', () {
    expect(roundABNT(4.8505, 1), 4.9);
    expect(roundABNT(4.8500, 1), 4.8);
    expect(roundABNT(10.0555, 2), 10.06);
    expect(roundABNT(4.5500, 1), 4.6);
    expect(9.99.format('0.00', lang: 'en_US'), '9.99');
    expect(9.99.format('0.00', lang: 'pt_BR'), '9,99');
    expect(1009.99.format('#,###.00', lang: 'pt_BR'), '1.009,99');
    expect(9.99.format('R\$ 0.00', lang: 'pt_BR'), 'R\$ 9,99');
    expect(10.89.formatCurrency(), '\$10.89');
    expect(ACBrExtenso().valorToTexto(1) != '', true);
    expect(ACBrExtenso().valorToTexto(1.05), 'Um Real e Cinco Centavos');
    expect(ACBrExtenso().valorToTexto(2000.0555),
        'Dois Mil Reais e Seis Centavos');
    expect(10.234.simpleRoundTo(-2), 10.23);
    expect(10.234.roundTo(2), 10.23);

    double d = 0;
    var d1 = d.from('0.1');
    print(d1);
    expect(d1, 0.1);
  });

  test('validador', () {
    expect(validarCPF('05351151805') != '', true);
    expect(validarCPF('05351151804'), '');
    expect(validarCNPJ('08754527000113'), '');
    expect(validarCNPJ('08754527000114') != '', true);
    expect(validarCEP('09910470', fsComplemento: 'SP'), '');
    expect(validarCEP('09910470', fsComplemento: 'RS') != '', true);
    expect(validarCEP('09910470', fsComplemento: 'XX') != '', true);
  });

  test('integer', () {
    int i = 0;
    expect(i.range(1, 10).last, 10);
    expect(i.range(1, 10, skip: 2).last, 9);

    var i1 = i.from('23.1');
    print(i1);
    expect(i1, 23);
  });
}
