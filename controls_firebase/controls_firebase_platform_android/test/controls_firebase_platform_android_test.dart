import 'package:controls_firebase_platform_android/controls_firebase_platform_android.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  var m = MaterialApp();
  test('adds one to input values', () {});
  test('Init Firebase Android', () {
    var app = FirebaseAppDriver().init(null);
    //var id = FirebaseFirestoreDriver().genId('produtos');
    //print(id);
    //expect(id, !null);
  });
}
