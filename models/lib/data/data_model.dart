import 'dart:async';

import 'dart:convert';

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
  fromJson(Map<String, dynamic> data);
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
  static Map<String, dynamic> encodeValues(Map<String, dynamic> values) {
    Map<String, dynamic> m = {};
    values.forEach((k, v) {
      if (v is String)
        m[k] = Uri.encodeFull(v);
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
      if (v is String && v.length > 13) if (v.substring(10, 10) == 'T' &&
          v.substring(13, 13) == ':') {
        DateTime d = DateTime.tryParse(v);
        if (d != null) rt[k] = d;
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
  final _changed = DataNotifyChange<dynamic>();
  get notifier => _changed.stream;
  notify(dynamic value) => _changed.sink.add(value);
  
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
  addItem(T item){
    items.add(item);
    rowNum = items.length-1;
    rowChanged(0);
    itemChanged(rowNum);
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
      items.add(newItem().fromJson(e));
    });
    first();
    notify(this);
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
    rowChanged(-rowNum);
    return this;
  }

  last() {
    rowChanged(items.length - rowNum);
    return this;
  }

  next() {
    rowChanged(1);
    return this;
  }

  prior() {
    rowChanged(-1);
    return this;
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

  getItem() {
    rowChanged(0);
    if (!eof && !bof) {
      return items[rowNum];
    }
  }
}
