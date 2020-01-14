import 'package:controls_data/odata_client.dart';

class CloudV3 {
  static final _singleton = CloudV3._create();
  final client = ODataClient();
  CloudV3._create() {
    client.baseUrl = 'https://us-central1-selfandpay.cloudfunctions.net';
    client.prefix = '/v3';
  }
  set loja(x) {
    client.prefix = '/v3/$x';
  }

  factory CloudV3() => _singleton;
}
