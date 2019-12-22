import 'package:flutter_test/flutter_test.dart';

import 'package:controls_extensions/extensions.dart';

void main() {
  test('Strings', () {
    expect('1232'.toDouble(), 1232);
    expect('2019-12-22T00:00:00'.toDateTime(), DateTime(2019, 12, 22));
    /* final calculator = Calculator();
    expect(calculator.addOne(2), 3);
    expect(calculator.addOne(-7), -6);
    expect(calculator.addOne(0), 1);
    expect(() => calculator.addOne(null), throwsNoSuchMethodError);*/
  });

  test('DateTime', () {
    expect(DateTime(2019, 12, 19).format('MM-dd-yyyy'), '12-19-2019');
  });

  test('Double', () {
    expect(9.99.format('0.00', lang: 'en_US'), '9.99');
    expect(9.99.format('0.00', lang: 'pt_BR'), '9,99');
    expect(1009.99.format('#,###.00', lang: 'pt_BR'), '1.009,99');
    expect(9.99.format('R\$ 0.00', lang: 'pt_BR'), 'R\$ 9,99');
    expect(10.89.formatCurrency(), '\$10.89');
  });
}
