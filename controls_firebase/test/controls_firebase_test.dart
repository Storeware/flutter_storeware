import 'package:controls_firebase/firebase_driver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // add group of tests here
  late FirebaseApp app;
  int passoAll = 1;
  int passo = 1;
  group('[FirebaseApp]', () {
    setUpAll(() {
      app = FirebaseApp();
      print(['all:', passoAll++]);
      app.init({
        "apiKey": "AIzaSyAV0c4MPfug-hSJYU8bT5pADkpaUadCYGU",
        "authDomain": "selfandpay.firebaseapp.com",
        "databaseURL": "https://selfandpay.firebaseio.com",
        "projectId": "selfandpay",
        "storageBucket": "selfandpay.appspot.com",
        "messagingSenderId": "858174338114",
        "appId": "1:858174338114:web:1f7773702de59dc336e9db",
        "measurementId": "G-G1ZWS0D01G"
      });
    });
    setUp(() {
      // noop for now
      print(['Up:', passo++]);
    });

    test('testar Storage', () {
      expect(app, isNotNull);
      var storage = app.storage();
      expect(storage, isNotNull);
    });
    test('testar Firestore', () {
      var store = app.firestore();
      expect(app, isNotNull);
    });
  });
}
