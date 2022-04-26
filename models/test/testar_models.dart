import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:models/models.dart';

void modelsTest(DioAdapter adapter) {
  // testar  SigcauthItemModel
  test('SigcauthItemModel', () async {
    final model = SigcauthItemModel();
    adapter.onGet(
        "/v3/open?\$command=select%20*%20from%20obter_id('PEDIDO1')",
        ((server) => server.reply(200, {
              'rows': 1,
              'result': [
                {'numero': 1}
              ]
            })));
    adapter.onGet(
        "/v3/open?\$command=select%20*%20from%20obter_id('PEDIDO')",
        ((server) => server.reply(200, {
              'rows': 1,
              'result': [
                {'numero': 1}
              ]
            })));

    var x = await model.proximoNumero(1);

    expect(x, 1001, reason: 'não retornou o numero do pedido (com filial)');

    x = await model.proximoNumero(0);
    expect(x, 1, reason: 'não retornou o numero do pedido (sem filial)');
  });
}
