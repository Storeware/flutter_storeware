import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ConfigModel {
  static final ConfigModel _singleton = ConfigModel._create();
  SharedPreferences prefs;
  ConfigModel._create(); 
  
  factory ConfigModel() {
    _singleton.init();
    return _singleton;
  }
  init() async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
    return this;
  }

  setKey(String key, String value) {
    prefs.setString(key, value);
  }

  setInt(String key, int value) {
    prefs.setInt(key, value);
  }

  setDouble(String key, double value) {
    prefs.setDouble(key, value);
  }

  setBool(String key, bool value) {
    prefs.setBool(key, value);
  }

  setJson(String key,  value) {
    print(value);
    prefs.setString(key, json.encode(value));
  }

  getKey(key) {
    return prefs.get(key);
  }

  getJson(key) {
    return json.decode(prefs.get(key) ?? '[]');
  }
}
