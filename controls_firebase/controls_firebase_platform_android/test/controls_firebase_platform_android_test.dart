import 'package:controls_firebase_platform_android/controls_firebase_platform_android.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

get firebaseOptions => {
      "apiKey": "AIzaSyAV0c4MPfug-hSJYU8bT5pADkpaUadCYGU",
      "authDomain": "selfandpay.firebaseapp.com",
      "databaseURL": "https://selfandpay.firebaseio.com",
      "projectId": "selfandpay",
      "storageBucket": "selfandpay.appspot.com",
      "messagingSenderId": "858174338114",
      "appId": "1:858174338114:web:1f7773702de59dc336e9db",
      "measurementId": "G-G1ZWS0D01G"
    };

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
//  var m = MaterialApp();
  var app = FirebaseAppDriver();
  await app.init(firebaseOptions);
  var firestore = app.firestore();
  //test('adds one to input values', () {});
  test('Init Firestore Android', () async {
    var id = await firestore
        .genId('test'); //await firestore.collection('test').get();
    print(id);
    //expect(id, !null);

    var q = await firestore.getDoc('lojas', 'm5');
    print(q);
  });
}
