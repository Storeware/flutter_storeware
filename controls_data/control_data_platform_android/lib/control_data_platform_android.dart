library control_data_platform_android;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:control_data_platform_interface/control_data_platform_interface.dart';

class PlatformLocalStorage extends LocalStorageInterface {
  var _prefs;
  init() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
  }

  @override
  setKey(String key, String value) {
    init();
    if (_prefs != null) _prefs.setString(key, value);
  }

  @override
  String? getKey(String key) {
    init();
    return _prefs?.getString(key);
  }

  @override
  bool getBool(key) {
    init();
    return _prefs?.getBool(key) ?? false;
  }

  @override
  setBool(key, value) {
    init();
    if (_prefs != null) return _prefs.setBool(key, value);
  }

  @override
  dispose() {}
}
