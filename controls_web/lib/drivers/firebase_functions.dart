import 'dart:convert';
import 'firebase_config.dart';
import 'rest_client.dart';
import 'local_storage.dart';

class FireFunctionsApp extends RestClient {
  FireFunctionsApp() {
    baseUrl = FirebaseConfig.functionUrl;
    if (tokenId != null) {
      autenticator(value: tokenId);
    }
  }

  Future<String> getToken(
      {String user,
      String pass,
      String email,
      String service = '/token',
      String conta}) async {
    tokenId = '';
    var b64 = 'Basic ' + base64.encode(utf8.encode(user + ':' + pass));
    LocalStorage().setKey('usuarioBase',b64);
    autenticator(value: b64);
    addParameter('email', email);
    if (conta != null) addParameter('conta', conta);
    print('Service: $service');
    String rsp = await send(service);
    var d = decode(rsp);
    print(jsonResponse);
    tokenId = d['authorization'];
    setToken(tokenId);
    return tokenId;
  }
}
