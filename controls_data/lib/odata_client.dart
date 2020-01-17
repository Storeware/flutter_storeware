import 'rest_client.dart';
import 'package:flutter/material.dart';
import 'data_model.dart';

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
}

class ODataDocuments {
  /// compatibilidade com firebase
  List<ODataDocument> docs;
  get length => docs.length;
  dynamic operator [](int idx) => docs[idx];
}

class ODataResult {
  int rows = 0;
  Map<String, dynamic> response;
  ODataDocuments _data = ODataDocuments();
  bool hasData = false;
  toList() async {
    return _data.docs;
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
        //print(['responsed....', response.hasData]);
        if (response.hasData) {
          //print(['Response:', response.data]);
          var rst = ODataResult(json: response.data);
          //print(rst.data.docs.toString());
          return builder(context, rst);
        } else
          return builder(context, ODataResult(json: null));
      },
    );
  }

  Future execute(ODataClient odata, query) async {
    //print(['execute', odata]);
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

  String get baseUrl => client.baseUrl;
  set baseUrl(x) {
    //print('url: $x');
    client.baseUrl = x;
  }

  send(ODataQuery query) async {
    String r = query.resource + '?';
    //print(['send:', r]);
    if (query.select != null) r += '\$select=${query.select}&';
    if (query.filter != null) r += '\$filter=${query.filter}&';
    if (query.top != null) r += '\$top=${query.top}&';
    if (query.skip != null) r += '\$skip=${query.skip}&';
    if (query.groupby != null) r += '\$groupby=${query.groupby}&';
    if (query.orderby != null) r += '\$orderby=${query.orderby}&';
    if (query.join != null) r += '\$join=${query.join}&';
    print('endpoint: $r');
    return client.send(r).then((res) {
      return client.decode(res);
    });
  }

  getOne(String resource) async {
    return client.send(resource).then((res) {
      return client.decode(res);
    });
  }

  post(String resource, json, {bool removeNulls = true}) async {
    Map<String, dynamic> data = {};
    if (removeNulls) {
      json.forEach((k, v) {
        if (v != null) data[k] = v;
      });
    } else
      data = json;

    return await client.post(resource, body: data).then((resp) {
      return resp;
    });
  }

  put(String resource, Map<String, dynamic> json,
      {bool removeNulls = true}) async {
    /// remover os null
    Map<String, dynamic> data = {};
    if (removeNulls) {
      json.forEach((k, v) {
        if (v != null) data[k] = v;
      });
    } else
      data = json;

    return await client.put(resource, body: data).then((resp) {
      return resp;
    });
  }

  delete(String resource, Map<String, dynamic> json) async {
    return await client.delete(resource, body: json).then((resp) {
      return resp;
    });
  }
}

class ODataInst extends ODataClient {
  static final _singleton = ODataInst._create();
  ODataInst._create();
  factory ODataInst() => _singleton;
}

abstract class ODataModelClass<T extends DataItem> {
  String collectionName;
  String columns = '*';
  ODataClient API;
  ODataModelClass({this.API});
  enviar(T item) {
    return API.post(collectionName, item.toJson());
  }

  post(T item) async {
    return await API.post(collectionName, item.toJson());
  }

  put(T item) async {
    return await API.put(collectionName, item.toJson());
  }

  delete(T item) async {
    return await API.delete(collectionName, item.toJson());
  }

  Future<ODataResult> search(
      {String filter, String orderBy, int top, int skip}) async {
    return await API
        .send(ODataQuery(
            resource: collectionName,
            select: columns,
            filter: filter,
            top: top ?? 0,
            skip: skip ?? 0,
            orderby: orderBy))
        .then((r) {
      return ODataResult(json: r);
    });
  }

  Future<ODataResult> snapshots(
      {String select,
      String filter,
      String groupBy,
      String orderBy,
      bool inativo = false,
      int top = 200,
      int skip = 0}) async {
    return await API.send(ODataQuery(
      resource: collectionName,
      select: select ?? '*',
      filter: filter ?? "inativo eq '${inativo ? "S" : "N"}' ",
      top: top,
      skip: skip,
      groupby: groupBy,
      orderby: orderBy,
    ));
  }
}
