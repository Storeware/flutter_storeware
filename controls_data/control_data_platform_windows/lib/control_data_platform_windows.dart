library control_data_platform_windows;

import 'dart:convert';
import 'dart:io';

import 'package:control_data_platform_interface/control_data_platform_interface.dart';

class PlatformLocalStorage extends LocalStorageInterface {
  Map<String, dynamic> items = {};
  String appFileName = 'storage.config';
  File _file;

  init() async {
    _file = File(appFileName);
    try {
      String s = _file.readAsStringSync();
      items = jsonDecode(s ?? {});
    } catch (e) {
      // nao existe o arquivo;
    }
  }

  setKey(String key, String value) {
    items[key] = value;
    _file.writeAsString(jsonEncode(items));
  }

  String getKey(String key) {
    return items[key];
  }

  @override
  dispose() {}
}
