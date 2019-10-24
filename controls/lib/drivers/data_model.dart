import "dart:convert";

enum DataState { dsBrowser, dsEdit, dsInsert, dsDelete }

class DataFields {
  Map<String, dynamic> data = {};
  int get length => data.length;
  dynamic value(key) => data[key];
  List<String> keys() {
    return data.keys.toList();
  }

  List<dynamic> values() {
    return data.values.toList();
  }
}

class DataModelItem {
  String id;
  DataState _state = DataState.dsBrowser;
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

  toString() {
    return json.encode(toJson());
  }
}

class DataModelClass<T> {}
