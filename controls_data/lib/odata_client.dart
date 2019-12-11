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

class ODataResult {
  int length = 0;
  List<dynamic> data;
  bool hasData = false;
  ODataResult({Map<String, dynamic> json}) {
    hasData = json != null;
    if (hasData) {
      length = json['rows'] ?? 0;
      data = [];
      var it = json['result'] ?? [];
      for (var item in it) {
        data.add(item);
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
      {Key key, this.client, this.initialData, this.query, this.builder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
    return odata.send(query);
  }
}

/*
class ODataClient extends ODataClientBase {
  static final _singleton = ODataClient._create();
  ODataClient._create() {
    baseUrl = 'http://localhost:8886';
    prefix = '/v3/';
  }
  factory ODataClient() => _singleton;
}
*/

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

  Future send(ODataQuery query) async {
    String r = prefix + query.resource + '?';
    if (query.select != null) r += '\$select=${query.select}&';
    if (query.filter != null) r += '\$filter=${query.filter}&';
    if (query.top != null) r += '\$top=${query.top}&';
    if (query.skip != null) r += '\$skip=${query.skip}&';
    if (query.groupby != null) r += '\$groupby=${query.groupby}&';
    if (query.orderby != null) r += '\$orderby=${query.orderby}&';
    if (query.join != null) r += '\$join=${query.join}&';
    return client.send(r).then((res) {
      return client.decode(res);
    });
  }
}
