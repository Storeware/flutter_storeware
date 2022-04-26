// import test

import 'package:controls_data/data.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'testar_search_form_builder.dart';

//var msg;
void main() async {
  var rest = ODataInst();
  rest.baseUrl = 'https://estouentregando.com';
  rest.prefix = '/v3/';
  final dio = Dio(BaseOptions(
    baseUrl: 'https://estouentregando.com',
  ));
//  dio.interceptors.add(LoggingInterceptions());
  dio.interceptors.add(PrettyDioLogger());
  final adapter = DioAdapter(dio: dio);
  adapter.onGet('https://estouentregando.com/v3/ctprod',
      (server) => server.reply(200, {'data': 'teste'}));
  adapter.onGet('/v3/login', (server) => server.reply(200, {'token': 'teste'}));
  rest.client.dio = dio;
  await rest.login('m0', 'm0', 'm0').then((r) {
    group('search form builder: ', () {
      builderTest();
    });
  });
}
