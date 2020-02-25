library control_data_platform_web;

import 'package:universal_html/prefer_sdk/html.dart';
import 'package:control_data_platform_interface/control_data_platform_interface.dart';

class PlatformLocalStorage extends LocalStorageInterface {
  Storage _storage = window.localStorage;
  init() async {}
  setKey(key, value) {
    _storage[key] = value;
  }

  getKey(key) {
    return _storage[key];
  }

  @override
  dispose() {}
}
