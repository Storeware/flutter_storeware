import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class RestClientBloC<T> {
  var _controller = StreamController<T>.broadcast();
  dispose() {
    _controller.close();
  }

  get sink => _controller.sink;
  Stream<T> get stream => _controller.stream;
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
  String tokenId;
  String _authorization;
  get authorization => _authorization;
  set authorization(x) {
    _authorization = x;
  }

  /* decode json string to object */
  dynamic decode(String texto) {
    return json.decode(texto, reviver: (k, v) {
      if (v is String) {
        /// validação do dado como DateTime
        RegExp exp =
            new RegExp("^([0-9]{4})-(1[0-2]|0[1-9])-([0-3]{1})([0-9]{1})T");
        var matches = exp.hasMatch(v);
        try {
          if (matches)

            /// É um DataTime
            return DateTime.tryParse(v);
          else
            return v;
        } catch (e) {
          return v;
        }
      }
      return v;
    });
  }

  get observable => notify.stream;
  dispose() {}
  String encode(js) {
    return json.encode(js, toEncodable: (v) {
      if (v is DateTime)
        return v.toIso8601String();
      else
        return v;
    });
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

  String encodeUrl() {
    var r = formatUrl();
    return r;
  }

  String prefix = '';
  formatUrl({path}) {
    String p = '';
    (params ?? {}).forEach((key, value) {
      p += (p == '' ? '?' : '&') + "$key=$value";
    });
    if (path != null) {
      service = path;
    }
    String url = /*(baseUrl ?? '') +*/ (prefix ?? '') +
        (service ?? '') +
        (p ?? '');
    return url;
  }

  addParameter(String key, value) {
    params[key] = value;
    return this;
  }

  setToken(value) {
    tokenId = value;
  }

  getToken() => tokenId;

  addHeader(String key, value) {
    _headers[key] = value ?? '';
    if (authorization != null) {
      _headers['authorization'] = authorization;
    }
    if (tokenId != null) _headers['token'] = tokenId;
    return this;
  }

  int statusCode = 0;
  _decodeResp(Response resp) {
    statusCode = resp.statusCode;
    if (resp.data != null) {
      jsonResponse = resp.data;
    }
  }

  _setHeader() {
    if ((contentType ?? '') != '') addHeader('content-type', contentType);
  }

  Future<String> openUrl(String url,
      {String method, Map<String, dynamic> body}) async {
    var resp = await openJson(url, method: method, body: body);
    var rsp = jsonEncode(resp);
    notify.send(rsp);
    return rsp;
  }

  int connectionTimeout = 30000;
  int receiveTimeout = 60000;
  bool followRedirects = false;

  Future<dynamic> openJson(String url,
      {String method = 'GET', Map<String, dynamic> body}) async {
    _setHeader();
    Response resp;
    //print(_headers);
    BaseOptions bo = BaseOptions(
        connectTimeout: connectionTimeout,
        followRedirects: followRedirects,
        receiveTimeout: receiveTimeout,
        baseUrl: this.baseUrl,
        headers: _headers,
        queryParameters: params,
        contentType: this.contentType);
    String uri = Uri.parse(url).toString();
    Dio dio = Dio(bo);
    //print('URL: ${this.baseUrl}$uri, $contentType ');

    try {
      if (method == 'GET') {
        resp = await dio.get(uri);
      } else if (method == 'POST') {
        resp = await dio.post(uri, data: body); //, headers: headers);
      } else if (method == 'PUT')
        resp = await dio.put(uri, data: body); //, headers: headers);
      else if (method == 'PATCH')
        resp = await dio.patch(uri, data: body); //, headers: headers);
      else if (method == 'DELETE')
        resp = await dio.delete(uri);
      else
        throw "Method inválido";
      //print('Response: $resp');
      _decodeResp(resp);

      if (statusCode == 200) {
        return resp.data;
      } else {
        return throw (resp.data);
      }
    } catch (e) {
      print('Error: $e');
      throw e.message;
    }
  }

  Stream openJsonAsync(String url,
      {String method = 'GET', Map<String, dynamic> body}) {
    _setHeader();
    //Response resp;
    //print(_headers);
    BaseOptions bo = BaseOptions(
        connectTimeout: connectionTimeout,
        followRedirects: followRedirects,
        receiveTimeout: receiveTimeout,
        baseUrl: this.baseUrl,
        headers: _headers,
        queryParameters: params,
        contentType: this.contentType);
    String uri = Uri.parse(url).toString();
    Dio dio = Dio(bo);
    //print('URL: ${this.baseUrl} $uri, $contentType ');
    Future<Response> ref;
    try {
      if (method == 'GET') {
        ref = dio.get(uri);
      } else if (method == 'POST') {
        ref = dio.post(uri, data: body); //, headers: headers);
      } else if (method == 'PUT')
        ref = dio.put(uri, data: body); //, headers: headers);
      else if (method == 'PATCH')
        ref = dio.patch(uri, data: body); //, headers: headers);
      else if (method == 'DELETE')
        ref = dio.delete(uri);
      else
        throw "Method inválido";

      ref.then((resp) {
        _decodeResp(resp);

        if (statusCode == 200) {
          return resp.data;
        } else {
          return throw (resp.data);
        }
      });
      return ref.asStream();
    } catch (e) {
      print('Error: $e');
      throw e.message;
    }
  }

  Future<String> send(String urlService, {method = 'GET', body}) async {
    this.service = urlService;
    var url = encodeUrl();
    //print(url);
    return openUrl(url, method: method, body: body);
  }

  Future<String> post(String urlService, {body}) async {
    this.service = urlService;
    var url = encodeUrl();
    //print(url);
    return openUrl(url, method: 'POST', body: body);
  }

  Future<String> put(String urlService, {body}) async {
    this.service = urlService;
    var url = encodeUrl();
    return openUrl(url, method: 'PUT', body: body);
  }

  Future<String> delete(String urlService, {body}) async {
    this.service = urlService;
    var url = encodeUrl();
    return openUrl(url, method: 'DELETE', body: body);
  }

  Future<String> patch(String urlService, {body}) async {
    this.service = urlService;
    var url = encodeUrl();
    return openUrl(url, method: 'PATCH', body: body);
  }
}
