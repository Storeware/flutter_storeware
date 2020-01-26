import 'dart:async';

import 'dart:convert';

extension DataExtensionBool on bool {
  String toSN() => this ? 'S' : 'N';
  String toTF() => this ? 'T' : 'F';
}

extension DataExtensionNum on String {
  double toDouble({String def = '0'}) {
    return double.tryParse(this ?? def);
  }

  String toSN() => toBool() ? 'S' : 'N';
  int toInt({String def = '0'}) {
    var value = this ?? def;
    return int.tryParse(value);
  }

  bool toBool({String def = 'F'}) {
    var value = this ?? def;
    switch (def) {
      case 'F':
        return false;
        break;
      case 'T':
        return true;
        break;
      case 'N':
        return false;
        break;
      case 'Y':
        return true;
        break;
      case 'S':
        return true;
        break;
      default:
        return false;
    }
  }
}

class ErrorNotify {
  static final _singleton = ErrorNotify._create();
  ErrorNotify._create();
  factory ErrorNotify() => _singleton;
  StreamController<String> _stream = StreamController<String>.broadcast();
  get stream => _stream.stream;
  notify(String text) {
    _stream.sink.add(text);
    return this;
  }

  static send(text) {
    _singleton._stream.sink.add(text);
    return text;
  }
}

/// Class Changed Events
class DataNotifyChange<T> {
  final _notifier = StreamController<T>.broadcast();
  close() {
    _notifier.close();
  }

  notify(T value) {
    _notifier.sink.add(value);
  }

  get stream => _notifier.stream;
  get sink => _notifier.sink;
}

abstract class DataService {
  Future<Map<String, dynamic>> post(String service, Map<String, dynamic> data,
      {header}) async {
    return null;
  }

  Future<Map<String, dynamic>> put(String service, Map<String, dynamic> data,
      {header}) async {
    return null;
  }

  Future<Map<String, dynamic>> patch(String service, Map<String, dynamic> data,
      {header}) async {
    return null;
  }

  Future<Map<String, dynamic>> delete(String service, Map<String, dynamic> data,
      {header}) async {
    return null;
  }

  Future<Map<String, dynamic>> send(String service, {header}) {
    return null;
  }
}

abstract class DataItem {
  String id;
  fromMap(Map<String, dynamic> data);
  Map<String, dynamic> toJson();
  bool validate() {
    return true;
  }

  /// Change Events
  var _notifierItem;
  void changed() {
    if (_notifierItem != null) _notifierItem.notify(this);
  }

  Stream<DataItem> get notifier {
    if (_notifierItem == null) _notifierItem = DataNotifyChange<DataItem>();
    return _notifierItem.stream;
  }

  dispose() {
    if (_notifierItem != null) _notifierItem.close();
    _notifierItem = null;
  }

  dynamic byName(String key) {
    var r = toJson();
    return r[key];
  }
}

abstract class DataModel {
  final _changed = DataNotifyChange<dynamic>();
  get notifier => _changed.stream;
  notify(dynamic value) => notifier.sink.add(value);

  static Map<String, dynamic> encodeValues(Map<String, dynamic> values,
      {bool encodeFull = false}) {
    Map<String, dynamic> m = {};
    values.forEach((k, v) {
      //print(['data_model->encodeValues', k, v]);
      if (v is String)
        m[k] = encodeFull ? Uri.encodeFull(v) : v;
      else if (v is DateTime)
        m[k] = v.toIso8601String();
      else
        m[k] = v;
      //TODO: Lists.
    });
    return m;
  }

  static dynamic decodeValues(Map<String, dynamic> j) {
    Map<String, dynamic> rt = {};
    j.forEach((k, v) {
      rt[k] = v;
      if (v is String && v.length > 13) if (v.substring(10, 11) == 'T' &&
          v.substring(13, 14) == ':') {
        //print([k, v, v is String, v.substring(10, 11)]);
        try {
          DateTime d = DateTime.tryParse(v);
          //print(['datetime', d]);
          if (d != null) rt[k] = d;
        } catch (e) {}
        //TODO: Lists
      }
    });
    return rt;
  }
}

class _TypeOf<T> {
  Type get type => T;
}

abstract class DataRows<T extends DataItem> {
  final _changed = DataNotifyChange<String>();
  get notifier => _changed.stream;
  notify(String value) {
    try {
      return _changed.sink.add(value);
    } catch (e) {}
  }

  T newItem();

  final _itemChanged = DataNotifyChange<int>();
  get itemNotifier => _itemChanged.stream;
  itemChanged(dynamic value) => _itemChanged.sink.add(value);
  dispose() {
    _changed.close();
    _itemChanged.close();
  }

  int rowNum = -1;
  List<T> items = [];
  bool _eof = true;
  bool _bof = true;

  get length => items.length;

  int checkError(String response) {
    var resp = json.decode(response);
    if (resp['error'] != null) {
      throw new StateError(resp['error']);
    }
    return resp['rows'] ?? 1;
  }

  execute(Function callback, {rest}) async {
    return callback(rest).then((resp) {
      return checkError(resp);
    });
  }

  addItem(T item) {
    items.add(item);
    rowNum = items.length - 1;
    rowChanged(0);
    itemChanged(rowNum);
    _itemChanged.notify(rowNum);
  }

  toJson() {
    List<Map<String, dynamic>> l = [];
    items.forEach((f) {
      l.add(f.toJson());
    });
    return l;
  }

  toString() {
    return json.encode(toJson());
  }

  fromList(List<dynamic> list) {
    items.clear();
    list.forEach((e) {
      items.add(newItem().fromMap(e));
    });
    first();
    notify('');
    _itemChanged.notify(rowNum);
    return this;
  }

  rowChanged(skip) {
    var old = rowNum;
    rowNum += skip;
    _eof = false;
    _bof = false;
    if (rowNum >= items.length) {
      rowNum = items.length - 1;
      _eof = true;
    }
    if (items.length == 0) {
      rowNum = -1;
    }
    if (rowNum < 0) _bof = true;
    if (rowNum != old) itemChanged(rowNum);
  }

  first() {
    rowNum = 0;
    rowChanged(0);
    _itemChanged.notify(rowNum);
    return getItem();
  }

  last() {
    rowNum = items.length - 1;
    rowChanged(0);
    _itemChanged.notify(rowNum);
    return getItem();
  }

  next() {
    rowChanged(1);
    return getItem();
  }

  prior() {
    rowChanged(-1);
    return getItem();
  }

  get eof {
    return _eof;
  }

  get bof {
    return _bof;
  }

  toList() {
    return items;
  }

  T getItem() {
    rowChanged(0);
    if (!eof && !bof) {
      return items[rowNum];
    }
    return null;
  }

  setItem(T it) {
    rowChanged(0);
    if (!eof || !bof)
      addItem(it);
    else
      items[rowNum] = it;
    _itemChanged.notify(rowNum);
    return it;
  }

  deleteItem() {
    rowChanged(0);
    if (!eof && !bof) removeAt(rowNum);
  }

  removeAt(idx) {
    items.removeAt(idx);
    _itemChanged.notify(idx);
  }

  Iterator<T> iterator() => items.iterator;

  get map => items.map;
}

enum DataState { dsBrowser, dsEdit, dsInsert, dsDelete }

class DataModelItem {
  String id;
  DataState _state = DataState.dsBrowser;
  get isInserting => _state == DataState.dsInsert;
  get isDeleting => _state == DataState.dsDelete;
  get isEditing => _state == DataState.dsEdit;
  get isBrowsing => _state == DataState.dsBrowser;

  inserting() {
    _state = DataState.dsInsert;
    return this;
  }

  deleting() {
    _state = DataState.dsDelete;
    return this;
  }

  editing() {
    _state = DataState.dsEdit;
    return this;
  }

  get state => _state;
  toJson() => {};
  fromMap(Map<String, dynamic> json) {
    return this;
  }

  clear() {
    fromMap({});
    return this;
  }

  toString() {
    return json.encode(toJson());
  }
}

abstract class DataModelClass<T> {
  String collectionName;
  getById(id);
  enviar(T item);
  snapshots({bool inativo});
}
