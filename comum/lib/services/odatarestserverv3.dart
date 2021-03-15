import 'package:controls_data/odata_client.dart';

class RestServerV3 {
  static final _singleton = RestServerV3._create();
  final client = ODataClient();
  RestServerV3._create() {
    if ((client.baseUrl /*?? ''*/) != '') {
      client.baseUrl = 'http://localhost:8886';
      client.prefix = '/v3/';
    }
  }
  factory RestServerV3() => _singleton;
  get baseUrl => client.baseUrl;
  set baseUrl(x) {
    client.baseUrl = x;
  }

  get prefix => client.prefix;
  set prefix(x) {
    client.prefix = x;
  }

  Future<ODataResult> send(ODataQuery query) async {
    var resp = await client.send(query);
    return ODataResult(json: resp);
  }

  post(String resource, json) async {
    return await client.post(resource, json);
  }

  delete(String resource, json) async {
    return await client.delete(resource, json);
  }

  put(String resource, json) async {
    return await client.put(resource, json);
  }
}
