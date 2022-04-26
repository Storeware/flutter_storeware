// import test

import 'package:controls_data/data.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'testar_search_form_builder.dart';

var msg = '';
void main() async {
  group('testar', () {
    var rest = ODataInst();
    final dio = Dio(BaseOptions(
      baseUrl: 'https://estouentregando.com',
    ));

    // inicializa
    setUpAll(() async {
      rest.baseUrl = 'https://estouentregando.com';
      rest.prefix = '/v3/';
      rest.log((s) => msg += s);
      rest.error((s) => msg += s);
      dio.interceptors.add(PrettyDioLogger());
      final adapter = DioAdapter(dio: dio);
      adapter.onGet(
          '/v3/ctprod',
          (server) => server.reply(200, {
                'rows': 1,
                'result': [
                  {'codigo': '1'}
                ]
              }));
      adapter.onGet(
          '/v3/login', (server) => server.reply(200, {'token': 'teste'}));
      adapter.onGet(
          'v3/ctprod_atalho_titulo',
          (server) => server.reply(200, {
                'rows': 1,
                'result': [
                  {'codigo': '1'}
                ]
              }));
      rest.client.dio = dio;
      await rest.login('m0', 'm0', 'm0').then((r) {});
    });

    // testes
    builderTest();

    // finaliza
    tearDownAll(() {
      dio.close();
      print(msg);
    });
  });
}
