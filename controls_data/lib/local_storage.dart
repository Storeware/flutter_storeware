library local_storage;

import "package:control_data_platform_android/control_data_platform_android.dart"
    if (dart.library.js) "package:control_data_platform_web/control_data_platform_web.dart";
import "package:control_data_platform_windows/control_data_platform_windows.dart"
    as win;
import 'package:control_data_platform_interface/control_data_platform_interface.dart';
import 'package:universal_io/io.dart';

class LocalStorage extends LocalStorageInterface {
  static final _singleton = LocalStorage._create();
  LocalStorage._create() {
    if (Platform.isWindows)
      pref = win.PlatformLocalStorage();
    else
      pref = PlatformLocalStorage();
  }
  factory LocalStorage() => _singleton;
  LocalStorageInterface? pref;
  @override
  String? getKey(String key) {
    return pref!.getKey(key);
  }

  @override
  init() async {
    return await pref!.init();
  }

  @override
  setKey(String key, String value) {
    return pref!.setKey(key, value);
  }
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
