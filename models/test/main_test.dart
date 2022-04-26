// import test
import 'package:controls_data/data.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'testar_search_form_builder.dart';

void main() async {
  var rest = ODataInst();
  print(rest.baseUrl);
  final dio = Dio();
  final adapter = DioAdapter(dio: dio);
  adapter.onGet('https://estouentregando.com',
      (server) => server.reply(200, {'data': 'teste'}));
  rest.client.dio = dio;
  await rest.login('m0', 'm0', 'm0').then((r) {
    group('search form builder: ', () {
      builderTest();
    });
  });
}
