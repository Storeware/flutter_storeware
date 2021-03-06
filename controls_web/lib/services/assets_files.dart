import 'dart:convert';
//import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';

/// Carrega um arquivo JSON do disco assets
/// get.items -> contem os dados default com as atualizações do disco

class AssetsJson {
  String? filename;
  Map<String, dynamic> _dados = {};

  Future save(file, values) async {
    /// TODO:
    return this;
  }

  /// file load
  Future load(arquivo) async {
    this.filename = arquivo;
    await rootBundle.loadString(arquivo).then((f) {
      Map<String, dynamic> r = jsonDecode(f);

      /// troca o dados adicionais carregados
      /// ou cria nova chave se não existir
      /// mantendo os nativos carregados no inicio
      r.forEach((k, v) {
        _dados[k] = v;
      });
      return _dados;
    });
  }

  /// obtem o valor da chave
  dynamic value(key) {
    return _dados[key];
  }

  /// checa se existe a chave
  bool containsKey(key) {
    return _dados.containsKey(key);
  }

  int get length => _dados.length;
  clear() {
    _dados.clear;
  }

  /// acesso aos dados carregados do JSON
  /// pode-se utilizar para carregar valores default antes de chamar
  /// a leitura do arquivo, Os dados default serão carregados na memoria
  /// e se existirem no JSON do disco serão sobrepostos com os valores
  /// existentes no JSON
  get items => _dados;
}
