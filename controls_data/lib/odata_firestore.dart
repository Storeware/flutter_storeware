import 'package:controls_data/odata_client.dart';
import 'package:uuid/uuid.dart';

class CloudV3Client extends ODataClient {
  @override
  Future<String> put(String resource, Map<String, dynamic> json,
      {bool removeNulls = true}) async {
    if (json['id'] == null) json['id'] = json['gid'] ?? Uuid().v4();
    return super.put(resource, json, removeNulls: removeNulls);
  }

  @override
  Future<String> post(String resource, Map<String, dynamic> json,
      {bool removeNulls = true}) async {
    if (json['id'] == null) json['id'] = json['gid'] ?? Uuid().v4();
    return super.post(resource, json, removeNulls: removeNulls);
  }
}

class CloudV3 {
  static final _singleton = CloudV3._create();
  final client = CloudV3Client();
  var contaid;
  CloudV3._create() {
    client.client.connectionTimeout = 15000;
    client.baseUrl = 'https://us-central1-selfandpay.cloudfunctions.net';
    client.prefix = '/v3/';
  }
  set loja(x) {
    contaid = x;
    client.client.addHeader('contaid', x);
    client.prefix = '/v3/';
  }

  factory CloudV3() => _singleton;
  send(ODataQuery query) {
    return client.send(query);
  }

  storageUrl({String fileName, String fullPath, String part = 'p'}) {
    var p = fullPath ?? '$contaid/$part/$fileName';
    return '${client.baseUrl}/storage?path=$p';
  }
}
