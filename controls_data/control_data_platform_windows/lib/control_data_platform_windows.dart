library control_data_platform_windows;

import 'dart:convert';
import 'dart:io';

import 'package:control_data_platform_interface/control_data_platform_interface.dart';

class PlatformLocalStorage extends LocalStorageInterface {
  Map<String, dynamic> items = {};
  String appFileName = 'config.json';
  File? _file;

  @override
  init() async {
    if (_file == null) {
      _file = File(appFileName);
      try {
        String? s = _file!.readAsStringSync();
        items = jsonDecode(s) ?? {};
        return items;
      } catch (e) {
        // nao existe o arquivo;
      }
    }
    return items;
  }

  @override
  setKey(String key, String value) {
    items[key] = value;
    return init().then((it) {
      _file!.writeAsString(jsonEncode(it));
    });
  }

  @override
  String? getKey(String key) {
    return items[key];
  }

  @override
  dispose() {}
}
