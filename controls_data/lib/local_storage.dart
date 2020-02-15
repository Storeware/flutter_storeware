import 'dart:convert';
import "dart:convert";
import "native_local_storage.dart"
    if (dart.library.html) "html_local_storage.dart"
    if (dart.library.windows) "widows_local_storage.dart";

class LocalStorage extends PlataformLocalStorage {
  static final _singleton = LocalStorage._create();
  LocalStorage._create();
  factory LocalStorage() => _singleton;

  getJson(String key) {
    String v = getKey(key) ?? '{}';
    return jsonDecode(v);
  }

  setJson(String key, Map<String, dynamic> json) {
    String v = jsonEncode(json);
    setKey(key, v);
  }
}
