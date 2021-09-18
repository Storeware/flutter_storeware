// @dart=2.12
import 'package:flutter/material.dart';

class ValueProvider<T> extends ChangeNotifier {
  T? value;
  ValueProvider(this.value);
  notify(T value) {
    this.value = value;
    notifyListeners();
  }
}

class MapProvider extends ChangeNotifier {
  Map? value;
  MapProvider(Map value) {
    this.value = value;
  }
  notify(Map value) {
    this.value = value;
    notifyListeners();
  }
}
