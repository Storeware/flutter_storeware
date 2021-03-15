import 'package:flutter/material.dart';

var _storage;
void registerStorage(storage) {
  _storage = storage;
}

abstract class WidgetBase {
  register();
  Widget demo() => Container(height: 200, width: 80, color: Colors.grey);
  Widget builder(context);
  getKey(key) {
    return _storage.getKey(key);
  }

  setKey(key, value) {
    _storage.setKey(key, value);
    return value;
  }
}
