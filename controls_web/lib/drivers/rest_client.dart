
//import 'dart:io';

//import "package:universal_html/html.dart" as http;
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';

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

class RestClientProvider<T> extends StatelessWidget {
  final RestClientBloC<T> bloc;
  final AsyncWidgetBuilder builder;
  final Widget noDataChild;
  const RestClientProvider({Key key, this.bloc, this.builder, this.noDataChild})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.stream,
      builder: (a, b) {
        return (b.hasData ? builder(a, b) : noDataChild ?? Container());
      },
    );
  }
}

class RestClient {
  RestClientBloC<String> notify = RestClientBloC<String>();
  String service = '/';
  String accessControlAllowOrigin = '*';
  Map<String, String> _headers = {};
  Map<String, dynamic> jsonResponse;
  RestClient({this.baseUrl}) {}
  /* decode json string to object */
  decode(String texto) {
    return json.decode(texto);
  }

  get observable => notify.stream;
  dispose() {}
  String encode(js) {
    return json.encode(js);
  }

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
  String baseUrl;
  Map<String, dynamic> params = {};
  String contentType = 'application/json';
  get headers => _headers;
  autenticator({String key = 'authorization', String value}) {
    _headers[key] = value;
    return this;
  }

  Uri encodeUrl() {
    return Uri.parse(formatUrl());
  }

  formatUrl() {
    String p = '';
    params.forEach((key, value) {
      p += (p == '' ? '?' : '&') + "$key=$value";
    });
    return baseUrl + service + p;
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
      if (resp.headers.containsValue('application/json')) response = resp.body;
    }
  }

  _setHeader() {
    addHeader('Content-Type', contentType);
    //addHeader('Access-Control-Allow-Origin', accessControlAllowOrigin); // controle é no servidor
    //print(headers);
  }

  Future<String> openUrl(Uri url, {String method, body}) async {
    _setHeader();
    http.Response resp;
    print('OpenUrl $method:$url');
    if (method == 'GET') resp = await http.get(url, headers: headers);
    if (method == 'POST')
      resp = await http.post(url, body: body, headers: headers);
    if (method == 'PUT')
      resp = await http.put(url, body: body, headers: headers);
    if (method == 'PATCH')
      resp = await http.patch(url, body: body, headers: headers);
    if (method == 'DELETE') resp = await http.delete(url, headers: headers);
    _decodeResp(resp);
    if (statusCode == 200) {
      notify.send(resp.body);
      return resp.body;
    } else {
      return throw (resp.body);
    }
  }

  Future<String> send(String urlService, {method = 'GET', body}) async {
    this.service = urlService;
    Uri url = encodeUrl();
    return openUrl(url, method: method, body: body);
  }

  Future<String> post(String urlService, {body}) async {
    this.service = urlService;
    Uri url = encodeUrl();
    return openUrl(url, method: 'POST', body: body);
  }

  Future<String> put(String urlService, {body}) async {
    this.service = urlService;
    Uri url = encodeUrl();
    return openUrl(url, method: 'PUT', body: body);
  }

  Future<String> delete(String urlService, {body}) async {
    this.service = urlService;
    Uri url = encodeUrl();
    return openUrl(url, method: 'DELETE', body: body);
  }

  Future<String> patch(String urlService, {body}) async {
    this.service = urlService;
    Uri url = encodeUrl();
    return openUrl(url, method: 'PATCH', body: body);
  }
}
