// @dart=2.12

import 'package:flutter/material.dart';

ValueNotifier<String?> pushMessageId = ValueNotifier<String?>(null);

fbSignInWithGoogle() {}

fbPushNotification(usuario, conta, userUid) {}

class FirebaseApp {}

class Firebase {
  static get app {
    print('dymmy_platform, não tem suporte a firebase');
    return null;
  }

  static get isFirebase => false;
}

class FirebaseAppDriver {
//  auth() async {
//    print('dymmy_platform, não tem suporte a auth');
//  }
}

class FBPushNotification {
  init(p) async {}
  getToken() async {}
  get stream => null;
  notification(title, body) {}
}
