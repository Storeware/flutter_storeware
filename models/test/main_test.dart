// import test

import 'package:controls_data/data.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
// ignore: unused_import
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'testar_models.dart';
import 'testar_search_form_builder.dart';

var msg = '';
void main() async {
  group('testar', () {
    var rest = ODataInst();
    final dio = Dio(BaseOptions(
      baseUrl: 'https://estouentregando.com',
    ));

    DioAdapter adapter = DioAdapter(dio: dio);

    // inicializa
    setUpAll(() async {
      rest.baseUrl = 'https://estouentregando.com';
      rest.prefix = '/v3/';
      rest.log((s) => msg += '\n' '$s');
      rest.error((s) => msg += '\n' '$s');
      //dio.interceptors.add(PrettyDioLogger());

      adapter.onGet(
          '/v3/login', (server) => server.reply(200, {'token': 'teste'}));
      rest.client.dio = dio;
      await rest.login('m0', 'm0', 'm0').then((r) {});
    });

    // testes
    builderTest(adapter);
    modelsTest(adapter);

    // finaliza
    tearDownAll(() {
      dio.close();
      print(msg);
    });
  });
}
