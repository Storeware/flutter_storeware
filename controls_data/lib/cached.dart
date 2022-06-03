import 'package:flutter/material.dart';

class Cached {
  static final _singleton = Cached._create();
  factory Cached() => _singleton;
  Cached._create();
  static final Map<String, Image> _imageCached = {};
  static final Map<String, dynamic> _cached = {};

  static Map<String, dynamic> get cached => _cached;

  remove(key) {
    _cached.remove(key);
    _imageCached.remove(key);
    return this;
  }

  imageClear(key) {
    _imageCached.remove(key);
  }

  static Image image(BuildContext context, String url,
      {Image Function(String)? builder}) {
    Image? item = _imageCached[url];
    //print(['Cache image:', url, (item != null)]);
    if (item != null) return item;
    if (builder != null) item = builder(url);
    if (item != null) _imageCached[url] = item;
    return item!;
  }

  static add(key, value) {
    _cached[key] = value;
    return value;
  }

  Map<String, DateTime> _lastAge = {};
  static value<T>(String key, {int maxage = 0, T Function(String)? builder}) {
    if (maxage > 0) {
      DateTime? last = _singleton._lastAge[key];
      if ((last != null) &&
          (DateTime.now().difference(last).inMilliseconds > maxage)) {
        _cached.remove(key);
      }
    }

    var item = _cached[key];
    if (item != null) return item;
    if (builder != null) item = builder(key);
    if (item != null) {
      _cached[key] = item;
      _singleton._lastAge[key] = DateTime.now();
    }
    return item;
  }

  clear() {
    _imageCached.clear();
    _cached.clear();
    return this;
  }

  static clearLike(keyLike) {
    for (int i = cached.keys.length - 1; i >= 0; i--) {
      var key = cached.keys.elementAt(i);
      if (key.indexOf(keyLike) >= 0) {
        // print(keyLike);
        cached.remove(cached[key]);
      }
    }
    return _singleton;
  }
}
