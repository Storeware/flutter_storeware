library local_storage;

import "package:control_data_platform_android/control_data_platform_android.dart"
    if (dart.library.js) "package:control_data_platform_web/control_data_platform_web.dart"
    if (dart.library.io) "package:control_data_platform_android/control_data_platform_android.dart"
    if (dart.library.windows) "package:control_data_platform_windows/control_data_platform_windows.dart";

class LocalStorage extends PlatformLocalStorage {
  static final _singleton = LocalStorage._create();
  LocalStorage._create();
  factory LocalStorage() => _singleton;
}

LocalStorageConfig? _localConfig;

class LocalStorageConfig {
  LocalStorageConfig({required this.key}) {
    _localConfig = this;
    _init();
  }

  static LocalStorageConfig get instance => _localConfig!;
  _init() async {
    //return LocalStorage().init().then(() {
    load();
    return true;
    //});
  }

  final String key;

  LocalStorage get storage => LocalStorage();
  final Map<String, dynamic> _values = {};
  Map<String, dynamic> get values => _values;
  load() {
    _values.clear();
    _values.addAll(storage.getJson(key) ?? {});
  }

  save() {
    storage.setJson(key, _values);
    return this;
  }
}
