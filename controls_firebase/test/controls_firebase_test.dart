import 'package:flutter_test/flutter_test.dart';

//import 'package:controls_firebase/firebase.dart';

import 'package:controls_firebase/android_firebase_driver.dart';
import 'package:controls_firebase/firebase_driver.dart' as fd;

void main() {
  test('testar data movel', () {
    var storage = FirebaseStorageDriver();
    storage.init();
  });
  test('teatar driver', () {
    var drv = fd.FirebaseStorage();
    drv.init();
  });
}
