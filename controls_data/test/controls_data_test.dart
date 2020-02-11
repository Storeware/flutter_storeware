import 'package:flutter_test/flutter_test.dart';

import 'package:controls_data/data.dart';

void main() async {
  await LocalStorage().init();

  final o = ODataInst();
  o.baseUrl = 'http://localhost:8886';
  o.prefix = '/v3/';

  test('test ODataInst', () async {
    var tkn = await o.login('m5', 'checkout', 'm5');
    //print(tkn);
    expect(tkn != null, true);
    expect(o.prefix, '/v3/');

    print(await o.open("select * from sp_enviar_gostei('1',0,1 ) "));
    print(await o.execute("select * from sp_enviar_gostei('1',0,1 ) "));

    print('execute - finished');
    var rsp = await o.send(ODataQuery(
      resource: 'ctprod_favoritos',
      select: '*',
      filter: "codigo eq '1' and filial eq 0",
      top: 1,
    ));
    //print(rsp);
    expect(rsp['rows'] >= 0, true);

    print(rsp);
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
