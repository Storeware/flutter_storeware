library control_data_platform_android;

//import 'dart:convert';
//import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:control_data_platform_interface/control_data_platform_interface.dart';

class PlatformLocalStorage extends LocalStorageInterface {
  SharedPreferences _prefs;
  init() async {
    print('storage.init()');
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();
  }

  @override
  setKey(String key, String value) {
    init();
    _prefs.setString(key, value);
  }

  @override
  String getKey(String key) {
    init();
    return _prefs.getString(key);
  }

  @override
  bool getBool(key) {
    init();
    return _prefs.getBool(key);
  }

  @override
  setBool(key, value) {
    init();
    return _prefs.setBool(key, value);
  }

  @override
  dispose() {}
}
