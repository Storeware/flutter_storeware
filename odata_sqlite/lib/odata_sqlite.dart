// @dart=2.12
library odata_sqlite;

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:controls_data/odata_client.dart';

class ODataSqlite extends ODataClientInterface {
  late SqfliteClient client;
  ODataSqlite({String? fileName}) {
    client = SqfliteClient(db: fileName ?? 'storeware.db');
  }
  @override
  void close() {
    client.close();
  }

  @override
  createNew() {
    return ODataSqlite();
  }

  @override
  Future<String> delete(String resource, Map<String, dynamic> json) {
    return client.delete(resource, data: json);
  }

  @override
  Future<String> execute(String command) async {
    await client._instance.execute(command);
    return 'OK';
  }

  @override
  Future getOne(String resource, {String? id}) {
    return client.open(
        collection: resource,
        top: 1,
        filter: (id == null) ? null : ' id = $id');
  }

  @override
  Future<String> post(String resource, Map<String, dynamic> json,
      {bool removeNulls = true}) {
    var j = removeNulls ? this.removeNulls(json) : json;
    return client.post(resource, data: j);
  }

  @override
  Future<String> put(String resource, Map<String, dynamic> json,
      {bool removeNulls = true}) {
    var j = removeNulls ? this.removeNulls(json) : json;
    return client.put(resource, data: j);
  }

  @override
  send(ODataQuery query, {String? cacheControl}) async {
    return client.open(
      collection: query.resource!,
      filter: query.filter,
      orderBy: query.orderby,
      select: query.select!,
      skip: query.skip,
      top: query.top,
    );
  }
}

class SqfliteClient {
  String db;
  late Database _instance;
  int version;
  FutureOr<void> Function(Database instance, int version)? onCreate;
  SqfliteClient({
    required this.db,
    this.version = 1,
    this.onCreate,
  }) {
    init();
  }
  init() async {
    _instance = await openDatabase(
      fileName,
      version: version,
      onCreate: onCreate,
    );
  }

  close() async {
    return _instance.close();
  }

  get path => getDatabasesPath();

  String get fileName => join(path, db);

  post(String collection, {required Map<String, dynamic> data}) async {
    // montar insert;
    String fields = '';
    String values = '';
    data.forEach((key, value) {
      if (fields.isNotEmpty) {
        fields += ', ';
        values += ', ';
      }
      fields += key;
      values += "$value ?? 'null' ";
    });
    return _instance
        .rawInsert('insert into $collection ($fields) values ($values)')
        .then((int x) {
      return {
        'rows': x,
        'result': [data]
      };
    });
  }

  put(String collection, {String? id, required Map<String, dynamic> data}) {
    String sets = '';
    String where = '';
    id ??= data['id'] ?? data['gid'];
    data.forEach((key, value) {
      if (sets.isNotEmpty) {
        sets += ',';
      }
      sets += "$key = '$value'";
    });
    if (id != null) where = "where id = '$id'";
    return _instance.rawUpdate('update $collection set $sets $where').then((x) {
      return {
        'rows': x,
        'result': [data]
      };
    });
  }

  delete(String collection, {String? id, required Map<String, dynamic> data}) {
    String where = '';
    id ??= data['id'] ?? data['gid'];
    if (id != null) where = "where id = '$id'";
    return _instance.delete("delete from $collection $where").then((x) {
      return {
        'rows': x,
        'result': [data]
      };
    });
  }

  open({
    required String collection,
    String select = '*',
    String? filter,
    String? orderBy,
    int? skip,
    int? top,
  }) {
    String str = '';
    if (filter != null) str += ' where $filter';
    if (orderBy != null) str += ' order by $orderBy';
    if (top != null && skip == null) str += ' LIMIT $top!';
    if (top != null && skip != null) str += ' LIMIT $top!, $skip!';

    String query = 'select $select from $collection $str';
    return _instance.rawQuery(query).then((rows) {
      return {'rows': rows.length, 'result': rows};
    });
  }
}

class SqliteInst extends ODataSqlite {
  static final _singleton = SqliteInst._create();
  SqliteInst._create();
  factory SqliteInst() => _singleton;
}
