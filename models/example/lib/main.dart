// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:models/builders.dart';
import 'package:controls_data/data.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // inicializa conexao com o v3
    var rest = ODataInst();
    rest.baseUrl = 'https://estouentregando.com';
    rest.prefix = '/v3/';
    rest.log((s) => print(s));
    rest.error((s) => print(s));
    final dio = Dio(BaseOptions(
      baseUrl: 'https://estouentregando.com',
    ));

    dio.interceptors.add(PrettyDioLogger());
    rest.login('m5', 'm5', 'm5');

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const AtalhosSearchFormField(
                  // onSearch: (x) => Future.value({}),
                  ),
              CodigoProdutoFormField(
                codigo: '1',
                buscarFuture: (c) =>
                    Future.value({'codigo': c, 'nome': 'teste'}),
                onSearch: (x) {
                  return Future.value({});
                },
                onChanged: (x) => print(['selecionou: ', x]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
