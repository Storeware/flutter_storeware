import 'dart:convert';

import 'package:controls_data/odata_client.dart';
import 'package:controls_data/odata_firestore.dart';
import 'package:controls_data/rest_client.dart';
import 'package:controls_web/drivers/bloc_model.dart';

class LojaExistsBloc extends BlocModel<bool> {
  static final _singleton = LojaExistsBloc._create();
  LojaExistsBloc._create();
  factory LojaExistsBloc() => _singleton;
}

class CheckoutConfigBloc extends BlocModel<dynamic> {
  static final _singleton = CheckoutConfigBloc._create();
  CheckoutConfigBloc._create();
  factory CheckoutConfigBloc() => _singleton;
}

// FirebaseService de uso geral
class FirebaseService {
  set token(String? tkn) {
    CloudV3().client.client.setToken('Bearer $tkn');
  }

  String? get token => CloudV3().client.client.getToken();
  Map<String, dynamic> config = {};

  Future<bool?> lojaExists(String loja) async {
    var v3 = CloudV3();
    v3.loja = loja;
    try {
      var resp = await v3.send(ODataQuery(resource: 'config', select: '*'));
      var result = resp['result'] ??
          [
            {"inativo": true}
          ];
      addResult(result);
      return !(result[0]['inativo'] ?? true);
    } catch (e) {
      v3.client.errorNotifier.send(
          'Não estou conseguindo obter informações relevantes para continuar. Verifique a conexão e tente novamente! ');
      return null;
    }
  }

  Future<dynamic> checkoutItemDados() async {
    var v3 = CloudV3();
    try {
      var resp =
          await v3.send(ODataQuery(resource: 'checkoutConfig', select: '*'));
      var result = resp['result'] ??
          [
            {"inativo": true}
          ];
      return result[0];
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> configDados(String loja) async {
    var v3 = CloudV3();
    v3.loja = loja;
    try {
      var resp = await v3.send(ODataQuery(resource: 'config', select: '*'));

      var result = resp['result'] ?? [];
      addResult(result);
      return result[0];
    } catch (e) {
      v3.client.errorNotifier.send(
          'Não estou conseguindo obter informações relevantes para continuar. Verifique a conexão e tente novamente! ');
      return null;
    }
  }

  addResult(result) {
    result.forEach((linha) {
      linha.forEach((k, v) {
        config[k] = v;
      });
    });
  }

  auth(String user, String pass) {
    var bytes = utf8.encode('$user:$pass');
    var b64 = 'Basic ' + base64.encode(bytes);
    return b64;
  }

  login(String loja, String user, String pass) async {
    var cli = RestClient(baseUrl: CloudV3().client.baseUrl);
    cli
      ..authorization = auth(user, pass)
      ..addHeader('contaid', loja);
    try {
      var rsp =
          await cli.openJson(cli.formatUrl(path: '/v3/login'), method: 'GET');
      String tkn = rsp['token'];
      CloudV3().client.client
        ..authorization = 'Bearer ' + tkn
        ..addHeader('contaid', loja);

      return tkn;
    } catch (e) {
      // notify error;
      return null;
    }
  }
}
