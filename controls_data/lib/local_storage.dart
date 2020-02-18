import 'dart:convert';
import "native_local_storage.dart"
    if (dart.library.html) "html_local_storage.dart"
    if (dart.library.windows) "widows_local_storage.dart";

class LocalStorage extends PlataformLocalStorage {
  static final _singleton = LocalStorage._create();
  LocalStorage._create();
  factory LocalStorage() => _singleton;
}
