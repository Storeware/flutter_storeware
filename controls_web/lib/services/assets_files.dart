import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';


class AssetsJson {
  String filename;
  Map<String, dynamic> _dados = {};
  
  Future save(file,values) async{
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

  /// obterm o valor da chave
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

  get items => _dados;
}
