import 'package:controls_data/odata_client.dart';

class CloudV3 {
  static final _singleton = CloudV3._create();
  final client = ODataClient();
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

  storageUrl({String fileName, String fullPath}) {
    var p = fullPath ?? '$contaid/p/$fileName';
    return '${client.baseUrl}/storage?path=$p';
  }
}
