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
