import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ImageLinks {
  static final _singleton = ImageLinks._create();
  ImageLinks._create();
  factory ImageLinks() => _singleton;

  Map<String, String> images = {};
  Map<String, IconData> icons = {};

  register(String key, String value) {
    _singleton.images[key.toLowerCase()] = value;
    return _singleton;
  }

  registerIcon(key, IconData icon) {
    icons[key.toLowerCase()] = icon;
  }

  find(key) {
    return _singleton.images[key.toLowerCase()];
  }

  static of(key) {
    return _singleton.images[key.toLowerCase()];
  }

  static IconData icon(key) {
    IconData ic = _singleton.icons[key.toLowerCase()];
    return ic;
  }

  static Widget image(String key,
      {double width, double height, Color color, BoxFit fit}) {
    //return Container();
    // checa se é um icon
    IconData ic = _singleton.icons[key];
    if (ic != null) return Icon(ic, color: color, size: width ?? height);

    // checa se é uma image
    String src = of(key);
    if (src == null) return Container();
    if (src.startsWith('assets/'))
      return Image.asset(
        src,
        color: color, // ?? Colors.white,
        height: height,
        width: width,
        fit: fit ?? BoxFit.contain,
      );
    if (src.startsWith('http'))
      return Image.network(
        src,
        fit: fit,
        height: height,
        width: width,
        color: color,
      );

    return Container();
  }
}
