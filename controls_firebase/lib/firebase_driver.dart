library controls_firebase;

/*
import "package:controls_firebase_platform_android/controls_firebase_platform_android.dart"
    if (dart.library.linux) "package:controls_firebase_platform_linux/controls_firebase_linux.dart"
    if (dart.library.windows) "package:controls_firebase_platform_windows/controls_firebase_windows.dart"
    if (dart.library.js) "package:controls_firebase_platform_web/controls_firebase_platform_web.dart";
*/
import 'driver/platform_impls.dart';

class FirebaseApp extends FirebaseAppDriver {
  static final FirebaseApp _singleton = FirebaseApp._create();
  int callStack = 0;
  FirebaseApp._create();
  factory FirebaseApp() {
    return _singleton;
  }
  @override
  init(options) async {
    try {
      if (callStack == 0) {
        callStack++;
        await super.init(options);
        return app;
      }
    } catch (e) {
      print(e);
    }
    return app;
  }
}
