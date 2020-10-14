library local_storage;

import "package:control_data_platform_android/control_data_platform_android.dart"
    if (dart.library.js) "package:control_data_platform_web/control_data_platform_web.dart"
    if (dart.library.io) "package:control_data_platform_android/control_data_platform_android.dart"
    if (dart.library.windows) "package:control_data_platform_windows/control_data_platform_windows.dart";

class LocalStorage extends PlatformLocalStorage {
  static final _singleton = LocalStorage._create();
  LocalStorage._create();
  factory LocalStorage() => _singleton;
}
