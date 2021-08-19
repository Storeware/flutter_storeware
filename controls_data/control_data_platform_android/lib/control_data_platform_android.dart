library control_data_platform_android;

//import 'package:universal_io/io.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:control_data_platform_windows/control_data_platform_windows.dart'
    as win;
import 'package:control_data_platform_interface/control_data_platform_interface.dart';
import 'package:universal_platform/universal_platform.dart';

class PlatformLocalStorage extends LocalStorageInterface {
  var _prefs;
  init() async {
    if (_prefs == null) {
      if (UniversalPlatform.isWindows) {
        _prefs = win.PlatformLocalStorage();
        _prefs.init();
      } else {
        _prefs = await SharedPreferences.getInstance();
        //}
      }
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
