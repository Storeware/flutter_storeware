import 'odata_client.dart';

class MockODataClientApi extends ODataClient {
  final List<dynamic> Function(ODataQuery query)? onGet;
  final String Function(Map value)? onPost;
  final String Function(Map value)? onPut;
  final String Function(Map value)? onDelete;
  MockODataClientApi({
    this.onGet,
    this.onPost,
    this.onPut,
    this.onDelete,
  });
  @override
  Future<dynamic> send(ODataQuery query, {String? cacheControl}) async {
    if (onGet != null) {
      var rst = onGet!(query);
      return {"rows": rst.length, "result": rst};
    }
    return {"rows": 0, "result": []};
  }

  @override
  post(String resource, Map<String, dynamic> json,
      {bool removeNulls = true}) async {
    if (onPost != null) {
      return onPost!(json);
    }
    return '{"rows": 1, "result": []}';
  }

  @override
  put(String resource, Map<String, dynamic> json,
      {bool removeNulls = true}) async {
    if (onPut != null) {
      return onPut!(json);
    }
    return '{"rows": 1, "result": []}';
  }

  @override
  delete(String resource, Map<String, dynamic> json,
      {bool removeNulls = true}) async {
    if (onDelete != null) {
      return onDelete!(json);
    }
    return '{"rows": 1, "result": []}';
  }

  @override
  loginBasic(String conta, String usuario, String senha) async {
    return 'fakeToken';
  }

  login(String contaid, String usuario, String senha) async {
    return 'fakeToken';
  }
}
