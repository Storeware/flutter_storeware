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

  String build() {
    String r = resource + '?';
    if (select != null) r += '\$select=${select}&';
    if (filter != null) r += '\$filter=${filter}&';
    if (top != null) r += '\$top=${top}&';
    if (skip != null) r += '\$skip=${skip}&';
    if (groupby != null) r += '\$groupby=${groupby}&';
    if (orderby != null) r += '\$orderby=${orderby}&';
    if (join != null) r += '\$join=${join}&';
    return r;
  }
}

class ODataDocument {
  String id;
  Map<String, dynamic> doc;
  Map<String, dynamic> data() => doc;
  dynamic operator [](String key) => doc[key];
}

class ODataDocuments {
  /// compatibilidade com firebase
  List<ODataDocument> docs;
  int get length => docs.length;
  Map<String, dynamic> operator [](int idx) => docs[idx].data();
}

class ODataResult {
  int length = 0;
  ODataDocuments _data = ODataDocuments();
  bool hasData = false;
  toList() async {
    return _data.docs.toList();
  }

  ODataDocument operator [](int index) {
    return docs[index];
  }

  ODataDocuments get data => _data;
  List<ODataDocument> get docs => _data.docs;
  ODataResult({Map<String, dynamic> json}) {
    hasData = json != null;
    length = 0;
    if (hasData) {
      length = json['rows'] ?? 0;
      _data.docs = [];
      var it = json['result'] ?? [];
      for (var item in it) {
        var doc = ODataDocument();
        doc.id = item['id'];
        doc.doc = item;
        _data.docs.add(doc);
      }
      length = _data.docs.length;
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
    client.baseUrl = x;
  }

  send(ODataQuery query) async {
    String r = query.build();
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
