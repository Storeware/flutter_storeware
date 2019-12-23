import 'rest_client.dart';
import 'package:flutter/material.dart';

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
  int length = 0;
  ODataDocuments _data = ODataDocuments();
  bool hasData = false;
  toList() async {
    return [_data.docs];
  }

  get data => _data;
  get docs => _data.docs;
  ODataResult({Map<String, dynamic> json}) {
    hasData = json != null;
    if (hasData) {
      length = json['rows'] ?? 0;
      _data.docs = [];
      var it = json['result'] ?? [];
      for (var item in it) {
        var doc = ODataDocument();
        //print(['doc', doc]);
        doc.id = item['id'];
        doc.doc = item;
        _data.docs.add(doc);
      }
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

  get baseUrl => client.baseUrl;
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
    //print('endpoint: $r');
    return client.send(r).then((res) {
      return client.decode(res);
    });
  }

  getOne(String resource) async {
    return client.send(resource).then((res) {
      return client.decode(res);
    });
  }

  post(String resource, json) async {
    return await client.post(resource, body: json).then((resp) {
      return resp;
    });
  }

  put(String resource, Map<String, dynamic> json) async {
    return await client.put(resource, body: json).then((resp) {
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
