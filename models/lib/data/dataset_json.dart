import 'dart:convert';
import 'dart:io';

class JsonArray {
  List<JsonObject> _list = [];
  JsonArray add(JsonObject object) {
    _list.add(object);
    return this;
  }

  String toJson() {
    String rt = '';
    _list.forEach((JsonObject j) {
      rt += (rt != '' ? ', ' : '') + j.toJson();
    });
    return '[' + rt + ']';
  }

  static JsonArray fromList(List<dynamic> json) {
    JsonArray arr = JsonArray();
    json.forEach((f) {
      arr.add(JsonObject.fromMap(f));
    });
    return arr;
  }
}

class JsonObject {
  Map<String, dynamic> _json = {};

  String _jsonKey(String key, dynamic value, [bool encode = false]) {
    if (value is String) {
      String r = (encode ? Uri.encodeFull(value) : value);
      return '"$key": "$r"';
    }
    if (value is double || value is int) return '"$key": $value';
    if (value is DateTime)
      return '"$key": "' +
          DateTime.parse(value.toString()).toIso8601String() +
          '"';
    if (value is JsonArray) return '"$key": ' + value.toJson();
    if (value is List) {
      JsonArray arr = JsonArray.fromList(value);
      return '"$key": ' + arr.toJson();
    }

    if (value is JsonObject) return '"$key": ' + value.toJson();

    return '"$key": $value';
  }

  get asMap {
    return _json;
  }

  add(String field, dynamic value, [bool encode = false]) {
    if (value is String) {
      _json[field] = (encode ? Uri.encodeFull(value) : value);
    } else
      _json[field] = value;
    return this;
  }

  bool contains(String key) {
    return _json.containsKey(key);
  }

  bool saveToFile(String? pathFileName) {
    if (pathFileName != null) {
      File? fs = File(pathFileName);
      try {
        String s = toJson(false);
        fs.writeAsStringSync(s);
        fs = null;
        return true;
      } catch (e) {
        return false;
      }
    }
    return false;
  }

  bool loadFromFile(String? pathFileName) {
    if (pathFileName != null) {
      File? fs = File(pathFileName);
      try {
        String json = fs.readAsStringSync();
        fs = null;
        fromJson(json);
      } catch (e) {
        fromJson('{}');
      }
      return true;
    }
    return false;
  }

  int get lenght {
    return _json.length;
  }

  get values {
    return _json.values;
  }

  get keys {
    return _json.keys;
  }

  dynamic value(String key) {
    return _json[key];
  }

  JsonObject setValue(String key, dynamic value, [bool encode = false]) {
    if (value is String) {
      _json[key] = (encode ? Uri.decodeFull(value) : value);
    } else
      _json[key] = value;
    return this;
  }

  String toJson([bool encode = false]) {
    String rt = '';
    _json.forEach((key, value) {
      if (key != null && value != null) {
        rt += (rt != '' ? ',' : '') + _jsonKey(key, value, encode);
      }
    });
    return '{' + rt + '}';
  }

  static JsonObject parse(String text) {
    JsonObject r = new JsonObject();
    r.fromJson(text);
    return r;
  }

  JsonObject fromJson(String text) {
    try {
      Map<String, dynamic> lst = (jsonDecode(text) as Map<String, dynamic>);
      lst.forEach((key, value) {
        setValue(key, value);
      });
    } catch (e) {}
    return this;
  }

  static JsonObject fromMap(Map<String, dynamic> values) {
    JsonObject rt = JsonObject();
    values.forEach((key, value) {
      rt.add(key, value);
    });
    return rt;
  }
}
