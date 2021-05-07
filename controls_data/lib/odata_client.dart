import 'dart:async';
import 'dart:convert';

import 'rest_client.dart';
import 'package:flutter/material.dart';
import 'data_model.dart';
import 'cached.dart';

const errorConnectionMsg =
    'Não executou a solicitação, provedor indisponível %s';

bool debugOn = false;
void debug(dynamic x) {
  if (debugOn) debugPrint(x);
}

enum ODataEventState { insert, update, delete }

class BlocModelX<T> {
  var _stream = StreamController<T>.broadcast();
  dispose() {
    _stream.close();
  }

  notify(T value) => _stream.sink.add(value);
  get stream => _stream.stream;
  get sink => _stream.sink;
}

extension MapExtension on Map {
  /// [fromMap] Update values from data
  fromMap(Map<String, dynamic> data) {
    data.keys.forEach((k) {
      this[k] = data[k];
    });
    return this;
  }

  /// [copyWith] create new Map values with NO REFERENCE values
  copyWith(Map<String, dynamic> data) {
    var m = {}; // clone - NO Reference
    this.keys.forEach((k) => m[k] = this[k]);
    data.keys.forEach((k) => m[k] = data[k]);
    return m;
  }

  valuesJoin({String separator = ','}) => this.values.join(separator);
  keysJoin({String separator = ','}) => this.keys.join(separator);
}

//extension DynamicExtension on dynamic {
int toInt(value, {def = 0}) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? def;
  return def;
}

double toDouble(value, {def = 0.0}) {
  if (value is double) return value;
  if (value is int) return value + 0.0;
  if (value is num) return value + 0.0;
  if (value is String)
    return double.tryParse(value.replaceAll(',', '.')) ?? def;
  return def;
}

bool toBool(value, {def: false}) {
  if (value is bool) return value;
  if (value is num) return (value == 0) ? false : true;
  if (value is String) return (value == '1' || value == 'T');
  return def;
}

DateTime? toDateTime(value, {DateTime? def, zone = 0}) {
  if (value is String) {
    int dif = (value.endsWith('Z') ? zone : 0);
    return DateTime.tryParse(value)?.add(Duration(hours: dif)) ?? def;
  }
  if (value is DateTime) return value;
  return def ?? DateTime.now();
}

DateTime? toDate(value, {DateTime? def}) {
  if (value is String) {
    def = DateTime.tryParse(value.substring(0, 10)) ?? DateTime.now();
  }
  if (value is DateTime) def = value;
  def ??= DateTime.now();
  return DateTime(def.year, def.month, def.day);
}

String toTimeSql(DateTime value) {
  return value.toIso8601String().substring(11, 19);
}

String toDateTimeSql(DateTime value) {
  return value.toIso8601String().substring(0, 19).replaceAll('T', ' ');
}

String toDateSql(DateTime value) {
  return value.toIso8601String().substring(0, 10);
}
//}

class LoginTokenChanged extends BlocModelX<bool> {
  static final _singleton = LoginTokenChanged._create();
  LoginTokenChanged._create();
  factory LoginTokenChanged() => _singleton;
}

class ODataQuery {
  final String? resource;
  String? select;
  dynamic? filter;
  int? top;
  int? skip;
  String? groupby;
  String? orderby;
  String? join;
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
  String? id;
  Map<String, dynamic>? doc;
  data() => doc;
  dynamic operator [](String key) => doc![key];
  bool operator ==(item) {
    return (id ?? '_') == ((item as ODataDocument).id ?? '');
  }

  ODataDocument({this.doc});
}

class ODataDocuments {
  /// compatibilidade com firebase
  List<ODataDocument> docs = [];
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
  Map<String, dynamic>? response;
  ODataDocuments _data = ODataDocuments();
  bool hasData = false;
  toList() async {
    return _data.docs;
  }

  List<dynamic> asMap() {
    return [for (var item in _data.docs) item.data()];
  }

  static ODataResult item({Map<String, dynamic>? json}) {
    return ODataResult(json: {
      "rows": 1,
      "result": (json == null) ? [] : [json]
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
  ODataResult({Map<String, dynamic>? json}) {
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
        var it = json['result'] ?? json['value'] ?? [];
        debug(['result', it]);
        for (var item in it) {
          var doc = ODataDocument();
          doc.id = "${item['id']}";
          doc.doc = {};
          item.forEach((k, v) {
            doc.doc![k] = v;
          });
          // print(item);
          _data.docs.add(doc);
        }
        if (rows == 0)
          rows =
              _data.docs.length; // workaroud para resposta que não vem o rows.
      }
    } catch (e) {
      print(e);
      ErrorNotify.send('Não consegui obter dados do servidor OData');
      rethrow;
    }
  }
}

class ODataBuilder extends StatelessWidget {
  final ODataQuery? query;
  final ODataClient? client;
  final String? cacheControl;
  final Function(BuildContext, ODataResult)? builder;
  final dynamic? initialData;
  const ODataBuilder(
      {Key? key,
      this.client,
      this.initialData,
      this.cacheControl,
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
              "result": (initialData == null) ? [] : [initialData]
            }
          : null,
      future: execute(client, query!),
      builder: (context, response) {
        if (response.hasData) {
          var rst = ODataResult(json: response.data as Map<String, dynamic>);
          return builder!(context, rst);
        } else
          return builder!(context, ODataResult(json: null));
      },
    );
  }

  Future execute(ODataClient? odata, ODataQuery query) async {
    debug(['execute', odata]);
    var odt = odata ?? ODataInst();
    return odt.send(query, cacheControl: cacheControl!);
  }
}

class ODataClient {
  late RestClient client = RestClient();
  String get prefix => client.prefix;
  set prefix(String p) {
    if (client != null) client.prefix = p;
  }

  get notifier => client.notify;
  get errorNotifier => client.notifyError;
  get processing => DataProcessingNotifier();
  get driver => client.headers['db-driver'] ?? 'fb';

  String get baseUrl => client.baseUrl;
  set baseUrl(x) {
    client.baseUrl = x;
  }

  ODataClient clone() {
    var o = ODataClient();
    o.client.inDebug = client.inDebug;
    o.baseUrl = client.baseUrl;
    o.prefix = client.prefix;
    client.headers.forEach((k, v) {
      o.client.addHeader(k, v);
    });
    if (client.tokenId != null) o.client.setToken(client.tokenId);
    if (client.authorization != null)
      o.client.authorization = client.authorization;
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

  Future<dynamic> send(ODataQuery query, {String? cacheControl}) async {
    try {
      String r = (query.resource ?? '') + '?';
      if (query.select != null) r += '\$select=${query.select}&';
      if (query.filter != null) r += '\$filter=${query.filter}&';
      if (query.top != null) r += '\$top=${query.top}&';
      if (query.skip != null) r += '\$skip=${query.skip}&';
      if (query.groupby != null) r += '\$groupby=${query.groupby}&';
      if (query.orderby != null) r += '\$orderby=${query.orderby}&';
      if (query.join != null) r += '\$join=${query.join}&';
      client.service = r;
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

  Future<dynamic> getOne(String resource, {String? id}) async {
    try {
      return client.send(resource).then((res) {
        return client.decode(res);
      });
    } catch (e) {
      ErrorNotify.send('$e');
      rethrow;
    }
  }

  reviverTo(v) {
    if (v is DateTime) return toDateTimeSql(v);
    return v;
  }

  Future<String> post(String resource, Map<String, dynamic> json,
      {bool removeNulls = true}) async {
    Map<String, dynamic> data = {};
    try {
      if (removeNulls) {
        json.forEach((k, v) {
          if (v != null) data[k] = reviverTo(v);
        });
      } else
        json.forEach((k, v) {
          data[k] = reviverTo(v);
        });

      return client.post(resource, body: data);
    } catch (e) {
      ErrorNotify.send('$e');
      rethrow;
    }
  }

  Map<String, dynamic> removeNulls(json) {
    Map<String, dynamic> data = json;
    json.forEach((k, v) {
      v ??= json[k]; // workaroud para versão 2.12 que não estava carregando
      try {
        if (v != null) data[k] = reviverTo(v);
      } catch (e) {
        print('$e');
      }
    });
    return data;
  }

  Future<String> put(String resource, Map<String, dynamic> json,
      {bool removeNulls = true}) async {
    /// remover os null
    Map<String, dynamic> data = {};
    try {
      if (removeNulls) {
        json.forEach((k, v) {
          if (v != null) data[k] = reviverTo(v);
        });
      } else
        json.forEach((k, v) {
          data[k] = reviverTo(v);
        });

      return client.put(resource, body: data).then((resp) {
        return resp;
      });
    } catch (e) {
      ErrorNotify.send('$e');
      rethrow;
    }
  }

  Future<String> delete(String resource, Map<String, dynamic> json) async {
    try {
      return client.delete(resource, body: removeNulls(json)).then((resp) {
        return resp;
      });
    } catch (e) {
      ErrorNotify.send('$e');
      rethrow;
    }
  }

  Future<Object> open(String command) async {
    try {
      //    print(command);
      var url = client.formatUrl(path: 'open');
      return client
          .openUrl(url + '?\$command=' + command, method: 'GET')
          .then((x) => x);
    } catch (e) {
      ErrorNotify.send('$e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> openJson(String command,
      {String? cacheControl}) async {
    try {
      //    print(command);
      var url = client.formatUrl(path: 'open');
      return client
          .openJson(
            url + '?\$command=' + command,
            method: 'GET',
            cacheControl: cacheControl,
          )
          .then((x) => x);
    } catch (e) {
      ErrorNotify.send('$e');
      rethrow;
    }
  }

  Future<String> execute(String command) async {
    try {
      return client.post('command', body: {"command": command}).then((x) => x);
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
  String? token;
  auth(user, pass) {
    var bytes = utf8.encode('$user:$pass');
    var b64 = 'Basic ' + base64.encode(bytes);
    return b64;
  }

  login(loja, user, pass) async {
    RestClient cli = RestClient(baseUrl: baseUrl);
    cli.prefix = prefix;
    cli.authorization = auth(user, pass);
    cli.headers.addAll(client.headers);
    cli.addHeader('contaid', loja);
    return cli
        .openJson(cli.formatUrl(path: 'login'), method: 'GET')
        .then((rsp) {
      token = rsp['token'];
      client.authorization = 'Bearer $token';
      if (client.tokenId == null) client.setToken(auth(user, pass));
      client.addHeader('contaid', loja);
      loginNotifier.notify(rsp);
      LoginTokenChanged().notify(true);
      return token;
    });
  }

  String formatUrl(String s) {
    return client.formatUrl(path: s);
  }
}

get ODataClientDefault => ODataInst();

abstract class ODataModelClass<T extends DataItem> {
  ODataClient? CC;
  String? collectionName;
  String columns = '*';
  String externalKeys = '';
  ODataClient? API;
  ODataModelClass({this.API});
  String get driver => API!.client.headers['db-driver'] ?? 'fb';
  makeCollection(Map<String, dynamic>? item) {
    return collectionName;
  }

  @deprecated //"sera desabilitado no em julho2021 - substituir por listNoChaced(..)"
  list({filter}) => listCached(filter: filter);

  bool validate(Map<String, dynamic> value) {
    return true;
  }

  Future<List<dynamic>> query(
      {filter,
      String? select,
      int? top,
      int? skip,
      orderBy,
      cacheControl}) async {
    return search(
            resource: makeCollection(null),
            select: select ?? columns,
            filter: filter,
            top: top!,
            skip: skip!,
            orderBy: orderBy,
            cacheControl: cacheControl)
        .then((ODataResult r) {
      return r.asMap();
    });
  }

  Future<List<dynamic>> listCached(
      {filter,
      cacheControl,
      resource,
      join,
      top,
      skip,
      orderBy,
      select}) async {
    String cached = (cacheControl ?? 'max-age=60');
    String tempo = '1';
    String res = resource ?? makeCollection(null);
    if (cached.contains('=')) tempo = cached.split('=')[1];
    String key = '${API!.client.headers['contaid']}$res $filter $select';
    return Cached.value(key, maxage: int.tryParse(tempo) ?? 60, builder: (k) {
      return search(
              resource: res,
              select: select ?? columns,
              filter: filter,
              top: top,
              skip: skip,
              orderBy: orderBy,
              cacheControl: cached)
          .then((ODataResult r) {
        return r.asMap();
      });
    });
  }

  Future<List<dynamic>> listNoCached(
      {filter,
      resource,
      join,
      top,
      skip,
      orderBy,
      select,
      cacheControl}) async {
    return search(
            resource: resource ?? makeCollection(null),
            select: select ?? columns,
            filter: filter,
            top: top,
            join: join,
            skip: skip,
            orderBy: orderBy,
            cacheControl: cacheControl ?? 'no-cache')
        .then((ODataResult r) {
      return (r.docs.length == 0) ? [] : r.asMap();
    });
  }

  Future<Map<String, dynamic>?> getOne({filter}) async {
    return search(
            resource: makeCollection(null),
            select: columns,
            filter: filter,
            top: 1)
        .then((ODataResult r) {
      return (r.docs.length > 0) ? r.first.doc : null;
    });
  }

  Future<Map<String, dynamic>> enviar(T item) {
    var d = item.toJson();
    try {
      return API!.post(makeCollection(d), d).then((x) => jsonDecode(x));
    } catch (e) {
      ErrorNotify.send('$e');
      rethrow;
    }
  }

  removeExternalKeys(Map<String, dynamic> dados) {
    externalKeys.split(',').forEach((key) {
      if (key != 'id') dados.remove(key);
    });
    return dados;
  }

  afterChangeEvent(item) {}

  Future<Map<String, dynamic>?> post(item) async {
    var d;
    if (item is T)
      d = item.toJson();
    else
      d = item;
    if (validate(d)) {
      try {
        d = removeExternalKeys(d);
        return API!.post(makeCollection(d), d).then((x) {
          if (CC != null) CC?.post(collectionName!, d);
          afterChangeEvent(d);
          return jsonDecode(x);
        });
      } catch (e) {
        print('$e');
        ErrorNotify.send('$e');
        rethrow;
      }
    }
  }

  Future<Map<String, dynamic>?> put(item) async {
    var d;
    if (item is T)
      d = item.toJson();
    else
      d = item;
    if (validate(d)) {
      try {
        d = removeExternalKeys(d);
        if (API!.client.isLocalApi)
          return API!.put(collectionName!, d).then((x) => jsonDecode(x));
        return API!.client
            .openJsonAsync(API!.client.formatUrl(path: collectionName),
                method: "PUT", body: API!.removeNulls(d))
            .then((x) {
          //API!.client.notifyLog.notify(x.toString());
          if (CC != null) CC!.put(makeCollection(d), d);
          afterChangeEvent(d);
          return x;
        });
      } catch (e) {
        ErrorNotify.send('$e');
        return null;
      }
    }
  }

  Future<Map<String, dynamic>?> send(ODataEventState event, T item) async {
    switch (event) {
      case ODataEventState.insert:
        return post(item);
      case ODataEventState.update:
        return put(item);

      case ODataEventState.delete:
        return delete(item);
      default:
        return null;
    }
  }

  Future<Map<String, dynamic>> delete(item) async {
    Map<String, dynamic> d;
    if (item is T)
      d = API!.removeNulls(item.toJson());
    else
      d = API!.removeNulls(item);
    try {
      if (API!.client.isLocalApi)
        return API!.delete(collectionName!, d).then((x) => jsonDecode(x));
      return API!.client
          .openJsonAsync(
              API!.client.formatUrl(path: 'delete/${makeCollection(d)}'),
              method: 'POST',
              body: d)
          .then((x) {
        if (CC != null) CC!.post('delete/${makeCollection(d)}', d);

        return x;
      });
    } catch (err) {
      ErrorNotify.send('$err');
      throw err;
    }
  }

  Future<ODataResult> search(
      {String? resource,
      String? select,
      dynamic? filter,
      String? orderBy,
      String? groupBy,
      int? top,
      int? skip,
      String? join,
      String? cacheControl}) async {
    try {
      return API!
          .send(
              ODataQuery(
                  resource: resource ?? makeCollection(null),
                  select: (select ?? columns),
                  filter: filter,
                  top: top,
                  skip: skip,
                  join: join,
                  groupby: groupBy,
                  orderby: orderBy),
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

  Future<ODataResult> snapshots({
    String? select,
    String? filter,
    String? groupBy,
    String? orderBy,
    bool inativo = false,
    int top = 200,
    int skip = 0,
    String? cacheControl,
  }) async {
    return API!
        .send(
            ODataQuery(
              resource: makeCollection(null),
              select: select ?? '*',
              filter: filter,
              top: top,
              skip: skip,
              groupby: groupBy,
              orderby: orderBy,
            ),
            cacheControl: cacheControl)
        .then((x) => x);
  }
}
