import 'dart:async';
import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:universal_io/io.dart';

class RestClientBloC<T> {
  var _controller = StreamController<T>.broadcast();
  dispose() {
    _controller.close();
  }

  get sink => _controller.sink;
  Stream<T> get stream => _controller.stream;
  void send(T reply) {
    DataProcessingNotifier.stop();
    sink.add(reply);
  }

  void notify(T reply) {
    DataProcessingNotifier.stop();
    sink.add(reply);
  }
}

class DataErrorNotifier extends RestClientBloC<String> {
  static final _singleton = DataErrorNotifier._create();
  DataErrorNotifier._create();
  factory DataErrorNotifier() => _singleton;
}

class LinearDataProgressIndicator extends StatelessWidget {
  final double height;
  const LinearDataProgressIndicator({Key? key, this.height = 3})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: this.height,
        child: StreamBuilder<bool>(
            initialData: false,
            stream: DataProcessingNotifier().stream,
            builder: (context, snapshot) {
              return (snapshot.hasData && (snapshot.data ?? false))
                  ? LinearProgressIndicator(
                      backgroundColor: Colors.transparent,
                    )
                  : Container();
            }));
  }
}

class DataProcessingNotifier {
  static final _singleton = DataProcessingNotifier._create();
  DataProcessingNotifier._create();
  factory DataProcessingNotifier() => _singleton;
  StreamController<bool> _stream = StreamController<bool>.broadcast();
  get stream => _stream.stream;
  dipose() {
    _stream.close();
  }

  static start() => _singleton._stream.sink.add(true);
  static stop() => _singleton._stream.sink.add(false);
}

class RestClientProvider<T> extends StatelessWidget {
  final RestClientBloC<T>? bloc;
  final AsyncWidgetBuilder? builder;
  final Widget? noDataChild;
  const RestClientProvider(
      {Key? key, @required this.bloc, @required this.builder, this.noDataChild})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc?.stream,
      builder: (a, b) {
        if (builder != null) return builder!(a, b);
        return noDataChild ?? Container();
      },
    );
  }
}

class RestClient {
  bool isLocalApi = false;
  RestClientBloC<String> notify = RestClientBloC<String>();
  RestClientBloC<String> notifyLog = RestClientBloC<String>();
  RestClientBloC<String> notifyError = RestClientBloC<String>();
  String service = '/';
  String accessControlAllowOrigin = '*';
  Map<String, String> _headers = {};
  Map<String, dynamic>? jsonResponse;
  RestClient({this.baseUrl = ''});
  String? tokenId;
  String? _authorization;
  String? get authorization => _authorization;
  set authorization(String? x) {
    _authorization = x!;
  }

  bool inDebug = false;
  String? _url;
  String? get url => _url;
  Dio? dio;
  /* decode json string to object */
  Map<String, dynamic> decode(String texto) {
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
    return jsonResponse?[key];
  }

  String get response => encode(jsonResponse);
  set response(String data) {
    jsonResponse = decode(data);
  }

  int rows({String? data, key = 'rows'}) {
    if (data != null) response = data;
    return fieldByName(key) ?? 0;
  }

  bool checkError({String? data, String key = 'error'}) {
    if (data != null) response = data;
    if (jsonResponse?[key] != null) {
      throw new StateError(jsonResponse?[key]);
    }
    return true;
  }

  result({String? data, key = 'result'}) {
    if (data != null) response = data;
    return fieldByName(key);
  }

  /*  RestClient Interface */
  String baseUrl = '';
  Map<String, dynamic> params = {};
  String contentType = 'application/json';
  Map<String, String> get headers => _headers;
  autenticator({String key = 'authorization', String? value}) {
    _headers[key] = value!;
    return this;
  }

  String encodeUrl() => formatUrl();

  String prefix = '';
  formatUrl({path}) {
    String p = '';
    (params).forEach((key, value) {
      p += (p == '' ? '?' : '&') + "$key=$value";
    });
    if (path != null) {
      service = path;
    }
    return (prefix) + (service) + (p);
  }

  addParameter(String key, value) {
    params[key] = value;
    return this;
  }

  setToken(value) {
    tokenId = value;
  }

  String? getToken() => tokenId;

  addHeader(String key, value) {
    _headers[key] = value ?? '';
    if (authorization != null) {
      _headers['authorization'] = authorization!;
    }
    if (tokenId != null) {
      _headers['tokenid'] = tokenId!; // nao mudar, usado no restserver
    }
    return this;
  }

  int statusCode = 0;
  _decodeResp(Response resp) {
    statusCode = resp.statusCode!;
    if (resp.headers['content-type']
        .toString()
        .contains('json')) if (resp.data != null) {
      jsonResponse = resp.data;
    }
  }

  String? cacheControl;
  _setHeader() {
    //if ((contentType) != '') addHeader('content-type', contentType);
    if (cacheControl != null) addHeader('Cache-Control', cacheControl);
  }

  Future<String> openUrl(String url,
      {String? method, body, String? contentType, String? cacheControl}) async {
    var resp = await openJson(url,
        method: method,
        body: body,
        contentType: contentType,
        cacheControl: cacheControl);
    var rsp = jsonEncode(resp);
    notify.send(rsp);
    return rsp;
  }

  int connectionTimeout = 10000;
  int receiveTimeout = 60000;
  bool followRedirects = true;

  String? getContentType([String contentType = 'application/json']) {
    //if (contentType.contains('text')) return ContentType.text;
    //if (contentType.contains('json')) return ContentType.json;
    //return ContentType.binary;
    return contentType;
  }

  Future<dynamic> openJson(String url,
      {String? method = 'GET',
      body,
      String? contentType,
      String? cacheControl}) async {
    _setHeader();
    final _h = _headers;
    if (cacheControl != null) _h['Cache-Control'] = cacheControl;
    Response? resp;
    BaseOptions bo = BaseOptions(
        connectTimeout: connectionTimeout,
        followRedirects: followRedirects,
        receiveTimeout: receiveTimeout,
        baseUrl: this.baseUrl,
        headers: _h,
        queryParameters: params,
        contentType: getContentType(
            contentType ?? this.contentType) // [e automatic no DIO??]
        );

    this._url = this.baseUrl + url;
    notifyLog.send('$method: ${this.baseUrl}$url - $body');

    String uri = Uri.parse(url).toString();
    Dio dio = this.dio ?? Dio(bo);
    //dio.transformer = ClientTransformer();
    DataProcessingNotifier.start();
    try {
      if (method == 'GET') {
        /* dio.interceptors.add(
          RetryOnConnectionChangeInterceptor(
            requestRetrier: DioConnectivityRequestRetrier(
              dio: dio,
              connectivity: Connectivity(),
            ),
          ),
        );*/
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
      notifyLog.notify('statusCode: $statusCode - $resp');
      _decodeResp(resp);
      if (inDebug) {
        resp.data['url'] = url;
        resp.data['method'] = method;
        resp.data['body'] = body;
      }
      if (statusCode == 200) {
        error = 'OK';
        return resp.data;
      } else {
        return throw (resp.data);
      }
      //} on TypeErrorImpl catch (e) {
      //  return throw '$e';
    } catch (e) {
      try {
        error = formataMensagemErro('$method:$url', e);
        if (!silent)
          sendError('$error [$resp]');
        else
          print([error, uri, body]);
        return throw error;
      } catch (err) {
        return throw '$e';
      }
    } finally {
      DataProcessingNotifier.stop();
    }
  }

  var error;
  sendError(texto) {
    notifyError.send(texto);
    DataErrorNotifier().notify(texto);
  }

  bool silent = false;

  formataMensagemErro(path, e) {
    var msg = '${e?.message}';
    if (inDebug) msg += '$path |';
    if ((e?.response?.statusCode ?? 0) == 403)
      return 'A solicitação foi recusada pelo servidor - checar permissões de acesso (403) ($msg)';
    if ((e?.response?.statusCode ?? 0) == 404)
      return 'A solicitação não foi encontrada - checar se é um objeto válido (404) ($msg)';

    String title = '${e?.message}';
    if (e?.response?.statusCode == 409) {
      title =
          'Servidor não processou a requisição (${e?.response?.statusCode})';
    }

    //print(e?.response?.data);
    String es = '';
    if (e?.response?.data is String) {
      es = '${e?.response?.data}';
    } else {
      es = (e?.response?.data != null) ? e?.response?.data['error'] ?? '' : '';
    }
    String erro = (title.isNotEmpty ? '${title}|' : '') + es;

    if (erro.isEmpty) erro += '${e?.message}';
    try {
      try {
        erro += e?.error?.osError?.message ?? '';
      } catch (e) {
        /// nada a fazer;
      }
      if (erro.isEmpty) erro += '${e?.response?.statusCode ?? ''}';
      if (erro.isEmpty) erro += '${e?.response?.statusMessage ?? ''}';
      if (erro.isEmpty) erro += '${e?.message ?? ''}';
      if (erro.isEmpty) erro += '${e?.toString()}';
      if (erro.isEmpty) erro += '${e?.response?.data ?? ''}';

      if (erro.contains('PRIMARY KEY'))
        erro = 'Operação bloqueada pela chave de identificação|$erro';
      if (erro.contains('FOREIGN KEY'))
        erro = 'Uma chave externa bloqueou a operação |$erro';
    } catch (e) {
      //
    }
    return erro;
  }

  Future<Map<String, dynamic>> openJsonAsync(String url,
      {String method = 'GET', Map<String, dynamic>? body, cacheControl}) async {
    _setHeader();
    final _h = _headers;
    //if (cacheControl != null) _h['Cache-Control'] = cacheControl;
    BaseOptions bo = BaseOptions(
      connectTimeout: connectionTimeout,
      followRedirects: followRedirects,
      receiveTimeout: receiveTimeout,
      baseUrl: this.baseUrl,
      headers: _h,

      /// The request Content-Type. The default value is "application/json; charset=utf-8".
      //encoding: Encoding.getByName('utf-8'),
      queryParameters: params,
      contentType: getContentType(contentType), //formUrlEncodedContentType,
      //contentType: this.contentType
    );
    this._url = this.baseUrl + url;
    notifyLog.send('$method: ${this.baseUrl}$url - $contentType');

    String uri = Uri.parse(url).toString();
    Dio dio = this.dio ?? Dio(bo);
    //dio.transformer = ClientTransformer();
    DataProcessingNotifier.start();
    Future<Response> ref;
    try {
      if (method == 'GET') {
        /*dio.interceptors.add(
          RetryOnConnectionChangeInterceptor(
            requestRetrier: DioConnectivityRequestRetrier(
              dio: dio,
              connectivity: Connectivity(),
            ),
          ),
        );*/
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

      return ref.then((resp) {
        _decodeResp(resp);
        if (inDebug) {
          resp.data['url'] = url;
          resp.data['method'] = method;
          resp.data['body'] = body;
        }

        if (statusCode == 200) {
          error = 'OK';
          notifyLog.notify(resp.data.toString());
          return resp.data;
        } else {
          return throw (resp.data);
        }
      }, onError: (e) {
        DataProcessingNotifier.stop();
        error = formataMensagemErro(url, e);
        if (!silent) sendError(error);
        return throw error;
      });
    } catch (e) {
      var error = formataMensagemErro(url, e);
      if (!silent) sendError(error);
      throw error;
    } finally {
      DataProcessingNotifier.stop();
    }
  }

  Future<String> send(String urlService,
      {method = 'GET', body, String? cacheControl}) async {
    this.service = urlService;
    var url = encodeUrl();
    if (inDebug) print(['SEND', url]);
    return openUrl(url, method: method, body: body, cacheControl: cacheControl)
        .then((x) => x);
  }

  Future<String> post(String urlService, {body}) async {
    this.service = urlService;
    var url = encodeUrl();
    if (inDebug) print(['POST', url, body]);
    return openUrl(url, method: 'POST', body: body).then((x) => x);
  }

  Future<String> put(String urlService, {body}) async {
    this.service = urlService;
    var url = encodeUrl();
    if (inDebug) print(['PUT', url, body]);
    return openUrl(url, method: 'PUT', body: body).then((x) => x);
  }

  Future<String> delete(String urlService, {body}) async {
    this.service = urlService;
    var url = encodeUrl();
    if (inDebug) print(['DELETE', url, body]);
    return openUrl(url, method: 'DELETE', body: body).then((x) => x);
  }

  Future<String> patch(String urlService, {body, String? contentType}) async {
    this.service = urlService;
    var url = encodeUrl();
    contentType ??= this.contentType;

    if ((body != null) && (body is String)) {
      contentType = 'text/plain';
    }
    if (inDebug) print(['PATCH', url, body]);
    return openUrl(url, method: 'PATCH', body: body, contentType: contentType)
        .then((x) => x);
  }

  Future<dynamic> rawData(String url,
      {method = 'GET', body, String? contentType, String? cacheControl}) async {
    _setHeader();
    final _h = _headers;
    if (cacheControl != null) _h['Cache-Control'] = cacheControl;
    dynamic ref;
    BaseOptions bo = BaseOptions(
        connectTimeout: connectionTimeout,
        followRedirects: followRedirects,
        receiveTimeout: receiveTimeout,
        baseUrl: this.baseUrl,
        headers: _h,
        queryParameters: params,
        contentType: getContentType(
            contentType ?? this.contentType) // [e automatic no DIO??]
        );
    var rt = getContentType(contentType ?? this.contentType)!;
    if (rt.contains('text/plain')) {
      bo.responseType = ResponseType.plain;
    }
    this._url = this.baseUrl + url;

    notifyLog.send('$method: ${this.baseUrl}$url - $body');

    String uri = Uri.parse(url).toString();
    Dio dio = this.dio ?? Dio(bo);

    DataProcessingNotifier.start();

    try {
      if (method == 'GET') {
        ref = dio.get(uri).onError((error, stackTrace) => throw error!);
      } else if (method == 'POST') {
        ref = dio.post(uri, data: body).onError(
            (error, stackTrace) => throw error!); //, headers: headers);
      } else if (method == 'PUT')
        ref = dio.put(uri, data: body); //, headers: headers);
      else if (method == 'PATCH')
        ref = dio.patch(uri, data: body); //, headers: headers);
      else if (method == 'DELETE')
        ref = dio.delete(uri);
      else
        throw "Method inválido";

      return ref.then((resp) {
        //return resp;
        _decodeResp(resp);
        notifyLog.notify(resp.data.toString());
        if (statusCode == 200) {
          error = 'OK';
          return resp;
        } else {
          return throw (resp);
        }
      });
    } catch (e) {
      error = formataMensagemErro(url, e);
      if (!silent) sendError(error);
      throw error;
    } finally {
      DataProcessingNotifier.stop();
    }
  }
}


/*
  TODO: revisar
class DioConnectivityRequestRetrier {
  final Dio? dio;
  final Connectivity? connectivity;

  DioConnectivityRequestRetrier({
    @required this.dio,
    @required this.connectivity,
  });

  Future<Response> scheduleRequestRetry(RequestOptions requestOptions) async {
    StreamSubscription? streamSubscription;
    final responseCompleter = Completer<Response>();

    streamSubscription = connectivity?.onConnectivityChanged.listen(
      (connectivityResult) async {
        RestConnectionChanged()
            .notify(connectivityResult != ConnectivityResult.none);
        if (connectivityResult != ConnectivityResult.none) {
          streamSubscription?.cancel();
          // Complete the completer instead of returning
          responseCompleter.complete(
            dio?.request(
              requestOptions.path,
              cancelToken: requestOptions.cancelToken,
              data: requestOptions.data,
              onReceiveProgress: requestOptions.onReceiveProgress,
              onSendProgress: requestOptions.onSendProgress,
              queryParameters: requestOptions.queryParameters,
              //options: requestOptions,
            ),
          );
        }
      },
    );

    return responseCompleter.future;
  }
}

class RetryOnConnectionChangeInterceptor extends Interceptor {
  final DioConnectivityRequestRetrier? requestRetrier;

  RetryOnConnectionChangeInterceptor({
    @required this.requestRetrier,
  });

  @override
  Future onError(
    DioError err,
    ErrorInterceptorHandler handler,
  ) async {
    if (_shouldRetry(err)) {
      try {
        return requestRetrier?.scheduleRequestRetry(err.request!);
      } catch (e) {
        // Let any new error from the retrier pass through
        return e;
      }
    }
    DataProcessingNotifier.stop();

    //    var error = formataMensagemErro(url, e);
    //    if (!silent) notifyError.send(error);
    //    return e;

    // Let the error pass through if it's not the error we're looking for
    return err;
  }

  bool _shouldRetry(DioError err) {
    return err.type == //DioErrorType.DEFAULT &&
        //err.error != null &&
        err.error is SocketException;
  }
}

class RestConnectionChanged {
  static final _singleton = RestConnectionChanged._create();
  RestConnectionChanged._create();
  factory RestConnectionChanged() => _singleton;

  final _stream = StreamController<bool>.broadcast();
  get stream => _stream.stream;
  get sink => _stream.sink;
  var subscription =
      Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
    _singleton.notify(result != ConnectivityResult.none);
  });
  notify(bool value) {
    sink.add(value);
  }

  close() {
    subscription.cancel();
    _stream.close();
  }

  void dispose() {
    close();
  }
}
*/