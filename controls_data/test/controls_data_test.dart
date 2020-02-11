import 'package:flutter_test/flutter_test.dart';

import 'package:controls_data/data.dart';

void main() async {
  await LocalStorage().init();
  test('tetar ODataClient', () {
    final o = ODataClient();
    o.prefix = '/v3/';
    expect(o.prefix, '/v3/');
  });
  test('testar LocalStorage', () {
    final f = LocalStorage();
    f.setKey('teste', 'ok');
    expect(f.getKey('teste'), 'ok');
  });
  test('testar DataItem', () {
    var o = TesteItem();
    o.codigo = '1';
    expect(o.codigo, '1');
  });
  test('testar Model', () {
    var o = TesteModel().newItem();
    o.codigo = '1';
    expect(o.codigo, '1');
  });
}

class TesteItem extends DataItem {
  String codigo;
  TesteItem();
  TesteItem.fromJson(json) {
    fromMap(json);
  }

  @override
  fromMap(Map<String, dynamic> json) {
    codigo = json['codigo'];
    return this;
  }

  @override
  toJson() {
    Map<String, dynamic> data = {"codigo": codigo};
    return data; // itens
  }
}

class TesteModel extends DataRows<TesteItem> {
  @override
  TesteItem newItem() {
    return TesteItem();
  }
}
