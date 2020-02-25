library control_data_platform_windows;

import 'package:control_data_platform_interface/control_data_platform_interface.dart';

class PlatformLocalStorage extends LocalStorageInterface {
  Map<String, dynamic> items = {};
  init() async {
//    _storage = await SharedPreferences.getInstance();
  }

  setKey(String key, String value) {
    //  _storage.setString(key, value);
    items[key] = value;
  }

  String getKey(String key) {
    return items[key];
    // return _storage.getString(key);
  }

  @override
  dispose() {}
}
