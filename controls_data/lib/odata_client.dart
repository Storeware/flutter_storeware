import 'dart:async';
import 'dart:convert';

import 'rest_client.dart';
import 'package:flutter/material.dart';
import 'data_model.dart';

const errorConnectionMsg =
    'Não executou a solicitação, provedor indisponível %s';

bool debugOn = false;
void debug(dynamic x) {
  if (debugOn) print(x);
}

class ODataQuery {
  final String resource;
  String select;
  String filter;
  int top;
  int skip;
  String groupby;
  String orderby;
  String join;
  ODataQuery({
    @required this.resource,
    @required this.select,
    this.filter,
    this.top,
    this.skip,
    this.groupby,
    this.orderby,
    this.join,
  });
}

class ODataDocument {
  String id;
  Map<String, dynamic> doc;
  data() => doc;
  dynamic operator [](String key) => doc[key];
  bool operator ==(item) {
    return id == item.id;
  }
  //bool operator !=(item)=>this.id!=item.id;
}

class ODataDocuments {
  /// compatibilidade com firebase
  List<ODataDocument> docs;
  get length => docs.length;
  dynamic operator [](int idx) => docs[idx];
  get first => docs.first;
  get last => docs.last;
  asMap() {
    return [for (var item in docs) item.data()];
  }
}

class ODataResult {
  int rows = 0;
  Map<String, dynamic> response;
  ODataDocuments _data = ODataDocuments();
  bool hasData = false;
  toList() async {
    return _data.docs;
  }

  asMap() {
    return [for (var item in _data.docs) item.data()];
  }

  static ODataResult item({Map<String, dynamic> json}) {
    return ODataResult(json: {
      "rows": 1,
      "result": [json]
    });
  }

  static fromJson(Map<String, dynamic> json) {
    return ODataResult(json: json);
  }

/*
  T as<T extends DataItem>(int index) {
    T obj = T();
    return obj.fromMap(docs[index].data());
  }
*/
  ODataDocument get first => _data.docs.first;
  ODataDocument get last => _data.docs.last;

  ODataDocument operator [](int index) {
    return _data[index];
  }

  ODataDocuments get data => _data;
  List<ODataDocument> get docs => _data.docs;
  int get length => _data.docs.length;
  ODataResult({Map<String, dynamic> json}) {
    _encode(json);
  }
  void _encode(json) {
    response = json;
    try {
      hasData = json != null;
      debug(json);
      if (hasData) {
        rows = json['rows'] ?? 0;
        debug('rows: $rows');
        _data.docs = [];
        var it = json['result'] ?? [];
        debug(['result', it]);
        for (var item in it) {
          var doc = ODataDocument();
          doc.id = "${item['id']}";
          doc.doc = item;
          debug(item);
          _data.docs.add(doc);
        }
      }
    } catch (e) {
      print(e);
      ErrorNotify.send('Não consegui obter dados do servidor OData');
      rethrow;
    }
  }
}

class ODataBuilder extends StatelessWidget {
  final ODataQuery query;
  final ODataClient client;
  final Function(BuildContext, ODataResult) builder;
  final initialData;
  const ODataBuilder(
      {Key key,
      this.client,
      this.initialData,
      @required this.query,
      this.builder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //print('futureBuilder');
    return FutureBuilder(
      initialData: (initialData != null)
          ? {
              "rows": 1,
              "result": [initialData]
            }
          : null,
      future: execute(client, query),
      builder: (context, response) {
        if (response.hasData) {
          var rst = ODataResult(json: response.data);
          return builder(context, rst);
        } else
          return builder(context, ODataResult(json: null));
      },
    );
  }

  Future execute(ODataClient odata, query) async {
    debug(['execute', odata]);
    var odt = odata ?? ODataInst();
    return odt.send(query);
  }
}

class ODataClient {
  RestClient client = RestClient();
  String get prefix => client.prefix;
  set prefix(String p) {
    client.prefix = p;
  }

  get notifier => client.notify;
  get errorNotifier => client.notifyError;

  String get baseUrl => client.baseUrl;
  set baseUrl(x) {
    client.baseUrl = x;
  }

  ODataClient clone() {
    var o = ODataClient();
    o.baseUrl = client.baseUrl;
    o.prefix = client.prefix;
    o.client = client.authorization;
    o.client.setToken(client.tokenId);
    return o;
  }

  error(callback) {
    errorNotifier.stream.listen(callback);
    return this;
  }

  log(callback) {
    client.notifyLog.stream.listen(callback);
    return this;
  }

  data(callback) {
    client.notify.stream.listen(callback);
    return this;
  }

  Future<dynamic> send(ODataQuery query, {String cacheControl}) async {
    try {
      String r = query.resource + '?';
      if (query.select != null) r += '\$select=${query.select}&';
      if (query.filter != null) r += '\$filter=${query.filter}&';
      if (query.top != null) r += '\$top=${query.top}&';
      if (query.skip != null) r += '\$skip=${query.skip}&';
      if (query.groupby != null) r += '\$groupby=${query.groupby}&';
      if (query.orderby != null) r += '\$orderby=${query.orderby}&';
      if (query.join != null) r += '\$join=${query.join}&';
      client.service = r;
      client.notifyLog.send(r);
      return client
          .openJsonAsync(client.encodeUrl(), cacheControl: cacheControl)
          .then((res) {
        //print('response $res');
        return res;
      });
    } catch (e) {
      ErrorNotify.send('$e');
      rethrow;
    }
  }

  getOne(String resource) async {
    try {
      return client.send(resource).then((res) {
        return client.decode(res);
      });
    } catch (e) {
      ErrorNotify.send('$e');
      rethrow;
    }
  }

  post(String resource, json, {bool removeNulls = true}) async {
    Map<String, dynamic> data = {};
    try {
      if (removeNulls) {
        json.forEach((k, v) {
          if (v != null) data[k] = v;
        });
      } else
        data = json;

      return client.post(resource, body: data).then((resp) {
        return resp;
      });
    } catch (e) {
      ErrorNotify.send('$e');
      rethrow;
    }
  }

  put(String resource, Map<String, dynamic> json,
      {bool removeNulls = true}) async {
    /// remover os null
    Map<String, dynamic> data = {};
    try {
      if (removeNulls) {
        json.forEach((k, v) {
          if (v != null) data[k] = v;
        });
      } else
        data = json;

      return client.put(resource, body: data).then((resp) {
        return resp;
      });
    } catch (e) {
      ErrorNotify.send('$e');
      rethrow;
    }
  }

  delete(String resource, Map<String, dynamic> json) async {
    try {
      return client.delete(resource, body: json).then((resp) {
        return resp;
      });
    } catch (e) {
      ErrorNotify.send('$e');
      rethrow;
    }
  }

  Future<Object> open(String command) async {
    try {
      var url = client.formatUrl(path: 'open');
      return client
          .openJsonAsync(url, body: {"command": command}, method: 'POST')
          .then((x) => x);
    } catch (e) {
      ErrorNotify.send('$e');
      rethrow;
    }
  }

  Future<Map> openJson(String command) async {
    try {
      //    print(command);
      var url = client.formatUrl(path: 'open');
      return client
          .openJson(url + '?\$command=' + command, method: 'GET')
          .then((x) => x);
    } catch (e) {
      ErrorNotify.send('$e');
      rethrow;
    }
  }

  execute(String command) async {
    try {
      //print(command);
      return client.patch('execute?\$command=' + command).then((x) => x);
    } catch (e) {
      ErrorNotify.send('$e');
      rethrow;
    }
  }

  Future<Map> executeJson(String command) async {
    try {
      //    print(command);
      var url = client.formatUrl(path: 'execute');
      return client
          .openJson(url + '?\$command=' + command, method: 'PATCH')
          .then((x) => x);
    } catch (e) {
      ErrorNotify.send('$e');
      rethrow;
    }
  }
}

class ODataInst extends ODataClient {
  static final _singleton = ODataInst._create();
  ODataInst._create();
  factory ODataInst() => _singleton;
  DataNotifyChange loginNotifier = DataNotifyChange<Map>();
  auth(user, pass) {
    var bytes = utf8.encode('$user:$pass');
    var b64 = 'Basic ' + base64.encode(bytes);
    return b64;
  }

  login(loja, user, pass) async {
    RestClient cli = RestClient(baseUrl: baseUrl);
    cli.prefix = prefix;
    cli.authorization = auth(user, pass);
    cli.addHeader('contaid', loja);
    return cli
        .openJson(cli.formatUrl(path: 'login'), method: 'GET')
        .then((rsp) {
      var token = rsp['token'];
      client.authorization = 'Bearer $token';
      if (client.tokenId == null) client.setToken(auth(user, pass));
      client.addHeader('contaid', loja);
      loginNotifier.notify(rsp);
      return token;
    });
  }

  String formatUrl(String s) {
    return client.formatUrl(path: s);
  }
}

get ODataClientDefault => ODataInst();

abstract class ODataModelClass<T extends DataItem> {
  String collectionName;
  String columns = '*';
  ODataClient API;
  ODataModelClass({this.API});
  enviar(T item) {
    try {
      return API.post(collectionName, item.toJson()).then((x) => x);
    } catch (e) {
      ErrorNotify.send('$e');
      rethrow;
    }
  }

  post(T item) async {
    try {
      return API.post(collectionName, item.toJson()).then((x) => x);
    } catch (e) {
      ErrorNotify.send('$e');
      rethrow;
    }
  }

  put(T item) async {
    try {
      return API.put(collectionName, item.toJson()).then((x) => x);
    } catch (e) {
      ErrorNotify.send('$e');
      rethrow;
    }
  }

  delete(T item) async {
    return API
        .delete(collectionName, item.toJson())
        .then((x) => x)
        .errorCatch((err) {
      ErrorNotify.send('$err');
      throw err;
    });
  }

  Future<ODataResult> search(
      {String resource,
      String select,
      String filter,
      String orderBy,
      String groupBy,
      int top,
      int skip,
      String cacheControl}) async {
    try {
      return API
          .send(
              ODataQuery(
                  resource: resource ?? collectionName,
                  select: select ?? columns ?? '*',
                  filter: filter ?? '',
                  top: top ?? 0,
                  skip: skip ?? 0,
                  groupby: groupBy ?? '',
                  orderby: orderBy ?? ''),
              cacheControl: cacheControl)
          .then((r) {
        //print(r);
        return ODataResult(json: r);
      });
    } catch (e) {
      /// ops,  não deu certo.
      var s = '$errorConnectionMsg ${e}';
      ErrorNotify.send(s);
      rethrow;
    }
  }

  Future<ODataResult> snapshots(
      {String select,
      String filter,
      String groupBy,
      String orderBy,
      bool inativo = false,
      int top = 200,
      int skip = 0}) async {
    return API
        .send(ODataQuery(
          resource: collectionName,
          select: select ?? '*',
          filter: filter ?? "inativo eq '${inativo ? "S" : "N"}' ",
          top: top,
          skip: skip,
          groupby: groupBy,
          orderby: orderBy,
        ))
        .then((x) => x);
  }
}
