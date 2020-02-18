import 'package:flutter_test/flutter_test.dart';

//import 'package:controls_firebase/firebase.dart';

import 'package:controls_firebase/android_firebase_driver.dart';

void main() {
  test('testar data movel', () {
    var storage = FirebaseStorageDriver();
    storage.init();
  });
}
