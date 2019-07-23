import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

String tokenId;

class RestClientBloC<T> {
  var _controller = StreamController<T>.broadcast();
  dispose() {
    _controller.close();
  }

  get sink => _controller.sink;
  get stream => _controller.stream;
  void send(T reply) {
    sink.add(reply);
  }
}

class RestClient {
  String baseUrl;
  RestClientBloC<String> notify = RestClientBloC<String>();
  String service = '/';
  String accessControlAllowOrigin = '*';
  Map<String, String> _headers = {};
  Map<String, dynamic> jsonResponse;
  RestClient({this.baseUrl});
  /* decode json string to object */
  Map<String, dynamic> decode(String texto) {
    return json.decode(texto);
  }

  get observable => notify.stream;
  dispose() {}

  /* convert String to List<int> */
  List<int> strToList(String value) {
    return utf8.encode(value);
  }

  dynamic fieldByName(key) {
    return jsonResponse[key];
  }

  get response => encode(jsonResponse);
  set response(String data) {
    if (data != null) jsonResponse = decode(data);
  }

  int rows({String data, key = 'rows'}) {
    if (data != null) response = data;
    return fieldByName(key) ?? 0;
  }

  bool checkError({String data, String key = 'error'}) {
    response = data;
    if (jsonResponse[key] != null) {
      throw new StateError(jsonResponse[key]);
    }
    return true;
  }

  result({String data, key = 'result'}) {
    response = data;
    return fieldByName(key);
  }

  /*  RestClient Interface */
  Map<String, dynamic> params = {};
  String contentType = 'application/json';
  get headers => _headers;
  autenticator({String key = 'authorization', String value}) {
    _headers[key] = value;
    return this;
  }

  Uri encodeUrl({String service}) {
    return Uri.parse(formatUrl(service:service));
  }

  formatUrl({String service}) {
    service = service??this.service;
    String p = '';
    params.forEach((key, value) {
      p = (p == '' ? '?' : '&') + "$key=$value";
    });
    String rt = '${this.baseUrl}${service}${p}';
    return rt;
  }

  addParameter(String key, value) {
    params[key] = value;
    return this;
  }

  setToken(value) {
    tokenId = value;
  }

  addHeader(String key, value) {
    _headers[key] = value;
    if (tokenId != null && _headers['authorization'] == null)
      autenticator(value: tokenId);
    return this;
  }

  int statusCode = 0;
  _decodeResp(http.Response resp) {
    statusCode = resp.statusCode;
    if (resp.body != null) {
      //if (resp.headers.containsValue('application/json')) 
      response = resp.body;
    }
  }

  _setHeader() {
    addHeader('Content-Type', contentType);
    addHeader('Access-Control-Allow-Origin', accessControlAllowOrigin);
  }

  Future<String> openUrl(Uri url, {String method, Map<String,dynamic> body}) async {
    _setHeader();
    http.Response resp;
    if (method == 'GET') resp = await http.get(url, headers: headers);
    if (method == 'POST')
      resp = await http.post(url, body: encode(body), headers: headers);
    if (method == 'PUT')
      resp = await http.put(url, body: encode(body), headers: headers);
    if (method == 'PATCH')
      resp = await http.patch(url, body: encode(body), headers: headers);
    if (method == 'DELETE') resp = await http.delete(url, headers: headers);
    _decodeResp(resp);
    if (statusCode == 200) {
      notify.send(resp.body);
      return resp.body;
    } else {
      return throw (resp.body);
    }
  }

  Future<String> send(String urlService, {method = 'GET', Map<String,dynamic> body}) async {
    this.service = urlService;
    Uri url = encodeUrl();
    return openUrl(url, method: method, body: body);
  }

  Future<String> post(String urlService, {Map<String,dynamic> body}) async {
    Uri url = encodeUrl(service:urlService);
    return await openUrl(url, method: 'POST', body: body);
  }

  Future<String> put(String urlService, {Map<String,dynamic> body}) async {
    this.service = urlService;
    Uri url = encodeUrl();
    return openUrl(url, method: 'PUT', body: body);
  }

  Future<String> delete(String urlService, {Map<String,dynamic> body}) async {
    this.service = urlService;
    Uri url = encodeUrl();
    return openUrl(url, method: 'DELETE', body: body);
  }

  Future<String> patch(String urlService, {Map<String,dynamic> body}) async {
    this.service = urlService;
    Uri url = encodeUrl();
    return openUrl(url, method: 'PATCH', body: body);
  }

  String encode(Map<String, dynamic> js) {

    var rt = json.encode(RestClient.encodeValues(js??{}));
    return rt;
  }

  static Map<String, dynamic> encodeValues(Map<String, dynamic> values) {
    Map<String, dynamic> m = {};
    values.forEach((k, v) {
      if (v is String)
        m[k] = Uri.encodeFull(v);
      else if (v is DateTime)
        m[k] = v.toIso8601String();
      else
        m[k] = v;
    });
    return m;
  }

  static String asJson(dynamic object) {
    return json.encode(RestClient.encodeValues(object));
  }

  static dynamic decodeValues(Map<String, dynamic> j) {
    Map<String, dynamic> rt = {};
    j.forEach((k, v) {
      rt[k] = v;
      if (v is String && v.length > 13) if (v.substring(10, 10) == 'T' &&
          v.substring(13, 13) == ':') {
        DateTime d = DateTime.tryParse(v);
        if (d != null) rt[k] = d;
      }
    });
    return rt;
  }

  static dynamic fromJson(String js) {
    return decodeValues(json.decode(js));
  }

  static String uriEncode(String motivo) {
    return Uri.encodeFull(motivo);
  }

  static String uriDecode(String motivo) {
    return Uri.decodeFull(motivo);
  }

  static Map<String, dynamic> decodeString(String js) {
    return fromJson(js);
  }
}
