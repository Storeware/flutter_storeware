import 'package:flutter_test/flutter_test.dart';
import 'package:controls_firebase/firebase_driver.dart' as fb;

void main() {
  test('testar data movel', () {
    var storage = fb.FirebaseStorage();
    storage.init();
  });
  test('teatar driver', () {
    var drv = fb.FirebaseStorage();
    drv.init();
  });
}
