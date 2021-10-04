// @dart=2.12
import 'package:flutter/material.dart';

// Our design contains Neumorphism design and i made a extention for it
// We can apply it on any  widget

extension WidgetMorphism on Widget {
  shadow({
    double borderRadius = 10.0,
    Offset offset = const Offset(5, 5),
    double blurRadius = 10,
    Color topShadowColor = Colors.white60,
    Color bottomShadowColor = const Color(0x26234395),
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        boxShadow: [
          BoxShadow(
            offset: offset,
            blurRadius: blurRadius,
            color: bottomShadowColor,
          ),
          BoxShadow(
            offset: Offset(-offset.dx, -offset.dx),
            blurRadius: blurRadius,
            color: topShadowColor,
          ),
        ],
      ),
      child: this,
    );
  }

  paddingAll({double? all}) {
    return Padding(padding: EdgeInsets.all(all ?? 8.0), child: this);
  }

  padding({EdgeInsets? padding}) {
    return Padding(padding: padding ?? EdgeInsets.all(8.0), child: this);
  }

  card({Color? color, double elevation = 4.0}) {
    return Card(
      color: color,
      elevation: elevation,
      child: this,
    );
  }

  sizedBox({
    Color? color,
    double? height,
    double? width,
  }) {
    return SizedBox(
      height: height,
      width: width,
      child: this,
    );
  }

  rounded(
      {BoxDecoration? decoration,
      BoxBorder? border,
      double radius = 15.0,
      Color? color}) {
    return Container(
      decoration: decoration ??
          BoxDecoration(
            color: color,
            border: border,
            borderRadius: BorderRadius.circular(radius),
          ),
      child: this,
    );
  }

  box(
      {Color? color,
      double borderWidth = 2.0,
      BoxBorder? border,
      BoxDecoration? decoration,
      double? width,
      double? height,
      BorderRadiusGeometry? borderRadius,
      Color borderColor = Colors.black54}) {
    return Container(
      width: width,
      height: height,
      decoration: decoration ??
          BoxDecoration(
            color: color,
            borderRadius: borderRadius,
            border:
                border ?? Border.all(width: borderWidth, color: borderColor),
          ),
      child: this,
    );
  }
}
