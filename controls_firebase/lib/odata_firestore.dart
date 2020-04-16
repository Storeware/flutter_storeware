import 'package:controls_data/odata_client.dart';

class CloudV3 {
  static final _singleton = CloudV3._create();
  final client = ODataClient();
  CloudV3._create() {
    client.baseUrl = 'https://us-central1-selfandpay.cloudfunctions.net';
    client.prefix = '/v3';
  }
  set loja(x) {
    client.client.addHeader('contaid', x);
    client.prefix = '/v3/';
  }

  factory CloudV3() => _singleton;
  send(ODataQuery query) {
    return client.send(query);
  }
}

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
  set token(String tkn) {
    CloudV3().client.client.setToken('Bearer $tkn');
  }

  get token => CloudV3().client.client.getToken();
  Map<String, dynamic> config = {};

  Future<bool> lojaExists(String loja) async {
    var v3 = CloudV3();
    v3.loja = loja;
    var resp = await v3.send(ODataQuery(resource: 'config', select: '*'));
    var result = resp['result'] ??
        [
          {"inativo": true}
        ];
    addResult(result);
    return !(result[0]['inativo'] ?? true);
  }

  Future<dynamic> configDados(String loja) async {
    var v3 = CloudV3();
    v3.loja = loja;
    var resp = await v3.send(ODataQuery(resource: 'config', select: '*'));
    var result = resp['result'] ?? [];
    addResult(result);
    return result[0];
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
    cli.authorization = auth(user, pass);
    cli.addHeader('contaid', loja);
    var rsp =
        await cli.openJson(cli.formatUrl(path: '/v3/login'), method: 'GET');
    token = rsp['token'];
    CloudV3().client.client.authorization = 'Bearer ' + token;

    return token;
  }
}
