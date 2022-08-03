library controls_firebase;

import 'driver/firebase_messaging.dart';

export 'firebase_config.dart';
export 'firebase_data_model.dart';
export 'firebase_driver.dart';
export 'firebase_functions.dart';
export 'firestorage_images.dart';

class FBPushNotification extends FBMessaging {
  static final _singleton = FBPushNotification._create();
  FBPushNotification._create();
  factory FBPushNotification() => _singleton;
  static get instance => _singleton;
}
