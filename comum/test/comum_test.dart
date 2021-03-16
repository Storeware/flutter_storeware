import 'package:comum/models/pedido_model.dart';
import 'package:comum/models/produto_grupo_item.dart';
import 'package:comum/models/produto_model.dart';
import 'package:comum/models/produto_precos_model.dart';
import 'package:controls_data/odata_client.dart';
//import 'package:controls_firebase/odata_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:controls_extensions/extensions.dart';

//import 'package:comum/comum.dart';
import 'package:controls_data/data.dart';

void main() {
  var errorListen = ErrorNotify().stream.listen((x) {
    // print(x);
  });
  ODataInst().baseUrl = 'http://localhost:8886';
  ODataInst().prefix = '/V3/';

  test('Models tests', () {
    expect(ProdutoItem.fromJson({"nome": "nome"}).nome, 'nome');
    expect(ProdutoPrecosItem.fromJson({"nome": "nome"}).nome, 'nome');
    expect(ProdutoGrupoItem.fromJson({"nome": "nome"}).nome, 'nome');
  });
  test('Test Login base', () async {
    await ODataInst().login('m5', 'checkout', 'm5').then((x) {
      expect((x ?? '').isNotEmpty, true);
    });
  });

  test("testa Pedido", () async {
    PedidoModel pedido = PedidoModel.fromJson({});
    expect(pedido.items.count, 0);
    pedido.items.addJson({"codigo": '1', "qtde": 1, "preco": 10});
    expect(pedido.items.count, 1);
    expect(pedido.total, 10);
    expect(pedido.itemCount, 1);
    await pedido.prepare();
    expect(pedido.numero != '', true);
    expect(pedido.numero != null, true, reason: 'Pedido numero retornou null');

    expect(pedido.dadosVenda.data, DateTime.now().toDate());
    var p = pedido.toJson();
    var s = pedido.toString();
    pedido.fromMap(p);
    expect(pedido.total, 10);
    expect(s, pedido.toString());
    pedido.pagamento.addJson({"operacao": "111", "valor": pedido.total});
    pedido.prepare();
    expect(pedido.pagamento.total, 10);
    //print(pedido.toJson());
    print(await pedido.send());
    pedido.clear();
    expect(pedido.itemCount, 0);
  });
}
