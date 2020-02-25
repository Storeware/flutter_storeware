library control_data_platform_android;

import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:control_data_platform_interface/control_data_platform_interface.dart';

class PlatformLocalStorage extends LocalStorageInterface {
  var _prefs;
  String appFileName;
  File _file;
  init() async {
    if (Platform.isWindows) {
      _prefs = {};
      //Directory appDocDir = await getApplicationDocumentsDirectory();
      appFileName = /*appDocDir.path +*/ 'checkout.config';
      _file = File(appFileName);
      try {
        String s = _file.readAsStringSync();
        _prefs = jsonDecode(s ?? {});
      } catch (e) {
        // nao existe o arquivo;
      }
    } else
      _prefs = await SharedPreferences.getInstance();
  }

  @override
  setKey(String key, String value) {
    if (Platform.isWindows) {
      _prefs[key] = value;
      _file.writeAsString(jsonEncode(_prefs));
    } else
      _prefs.setString(key, value);
  }

  @override
  String getKey(String key) {
    if (Platform.isWindows)
      return _prefs[key];
    else
      return _prefs.getString(key);
  }

  @override
  dispose() {
    if (Platform.isWindows) {
      // fazer close do arquivo ?
    }
  }
}
