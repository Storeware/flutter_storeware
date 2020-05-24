import 'package:flutter/material.dart';

double defaultFontSize = 15;

textNormal(texto, {double size, Color color, TextStyle style}) {
  return Text(texto,
      style:
          style ?? TextStyle(fontSize: size ?? defaultFontSize, color: color));
}

textBold(texto, {double size, Color color, TextStyle style}) {
  return Text(texto,
      style: style ??
          TextStyle(
              fontSize: size ?? defaultFontSize,
              color: color,
              fontWeight: FontWeight.bold));
}

textLight(texto, {double size, Color color, TextStyle style}) {
  return Text(texto,
      style: style ??
          TextStyle(
              fontSize: size ?? defaultFontSize,
              color: color,
              fontWeight: FontWeight.w300));
}
