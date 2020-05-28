library controls_firebase;

import "package:controls_firebase_platform_android/controls_firebase_platform_android.dart"
    if (dart.library.js) "package:controls_firebase_platform_web/controls_firebase_platform_web.dart";

import "package:controls_firebase_platform_android/firebase_messaging.dart" 
    if (dart.library.js) "package:controls_firebase_platform_web/firebase_messaging.dart" ;

export "firebase_messaging.dart";


class FirebaseApp extends FirebaseAppDriver {
  static final FirebaseApp _singleton = FirebaseApp._create();
  int callStack = 0;
  FirebaseApp._create();
  factory FirebaseApp() {
    return _singleton;
  }
  @override
  init(options) async {
    if (callStack == 0) {
      callStack++;
      return super.init(options);
    }
    return app;
  }
}
