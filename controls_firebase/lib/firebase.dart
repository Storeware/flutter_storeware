library controls_firebase;

import "package:controls_firebase_platform_android/firebase_messaging.dart"
    if (dart.library.linux) 'dummy.dart'
    if (dart.library.windows) 'dummy.dart'
    if (dart.library.js) "package:controls_firebase_platform_web/firebase_messaging.dart";

export 'firebase_config.dart';
export 'firebase_functions.dart';
export 'firestorage_images.dart';
export 'firebase_data_model.dart';
export 'firebase_driver.dart';

class FBPushNotification extends FBMessaging {
  static final _singleton = FBPushNotification._create();
  FBPushNotification._create();
  factory FBPushNotification() => _singleton;
  static get instance => _singleton;
}
