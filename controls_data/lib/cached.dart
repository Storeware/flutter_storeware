import 'package:flutter/material.dart';

class Cached {
  static final Map<String, Image> _imageCached = {};
  static final Map<String, dynamic> _cached = {};

  remove(key) {
    _cached.remove(key);
    _imageCached.remove(key);
    return this;
  }

  imageClear(key) {
    _imageCached.remove(key);
  }

  static Image image(BuildContext context, String url,
      {Image Function(String) builder}) {
    var item; //= _imageCached[url];
//    if (item != null) return item;
    item = builder(url);
    if (item != null) _imageCached[url] = item;
    return item;
  }

  static value<T>(String key, {T Function(String) builder}) {
    var item = _cached[key];
    if (item != null) return item;
    item = builder(key);
    if (item != null) _cached[key] = item;
    return item;
  }

  clear() {
    _imageCached.clear();
    _cached.clear();
    return this;
  }
}