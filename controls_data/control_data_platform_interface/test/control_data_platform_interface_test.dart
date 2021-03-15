import 'package:flutter_test/flutter_test.dart';

import 'package:control_data_platform_interface/control_data_platform_interface.dart';

class Testar extends LocalStorageInterface {
  String? chave;
  dynamic valor;
  @override
  String getKey(String key) {
    // TODO: implement getKey
    return valor;
    throw UnimplementedError();
  }

  @override
  init() {
    chave = 'x';
    valor = 'v';
    // TODO: implement init
    throw UnimplementedError();
  }

  @override
  setKey(String key, String value) {
    this.chave = key;
    this.valor = value;
  }
}

void main() {
  test('Testar LocalStorageInterface', () {
    var t = Testar();
    t.setJson('x', {"chave": 1});
    expect(t.getJson('x'), {"chave": 1});
  });
}
