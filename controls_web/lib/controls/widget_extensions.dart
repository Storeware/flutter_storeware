// @dart=2.12
import 'package:flutter/material.dart';

import 'strap_widgets.dart';

// Our design contains Neumorphism design and i made a extention for it
// We can apply it on any  widget

extension WidgetMorphism on Widget {
  Widget shadow({
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

  Widget paddingAll({double? all}) {
    return Padding(padding: EdgeInsets.all(all ?? 8.0), child: this);
  }

  Widget padding({EdgeInsets? padding}) {
    return Padding(padding: padding ?? EdgeInsets.all(8.0), child: this);
  }

  Widget card({Color? color, double elevation = 4.0}) {
    return Card(
      color: color,
      elevation: elevation,
      child: this,
    );
  }

  Widget sizedBox({
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

  Widget rounded(
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

  Widget box(
      {Color? color,
      double borderWidth = 1.0,
      BoxBorder? border,
      BoxDecoration? decoration,
      double? width,
      double? height,
      BorderRadiusGeometry? borderRadius,
      Color borderColor = Colors.black26}) {
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

  Widget inkWell({required Function() onPressed}) {
    return InkWell(
      child: this,
      onTap: () => onPressed(),
    );
  }

  Widget row(
      {CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
      MainAxisAlignment mainAxisAlignment = MainAxisAlignment.spaceBetween,
      List<Widget>? ledding,
      List<Widget>? actions}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      children: [
        if (ledding != null) ...ledding,
        this,
        if (actions != null) ...actions,
      ],
    );
  }

  Widget column(
      {CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
      MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
      List<Widget>? ledding,
      List<Widget>? actions}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      children: [
        if (ledding != null) ...ledding,
        this,
        if (actions != null) ...actions,
      ],
    );
  }

  Widget fittedBox({
    BoxFit fit = BoxFit.scaleDown,
    Alignment alignment = Alignment.center,
  }) {
    return FittedBox(alignment: alignment, fit: fit, child: this);
  }

  Widget materialButton({
    double? elevation,
    required Function() onPressed,
    Color? color,
  }) {
    return MaterialButton(
      onPressed: onPressed,
      child: this,
      color: color,
      elevation: elevation,
    );
  }

  Widget textButton({
    required onPressed,
    bool autofocus = false,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      child: this,
      autofocus: autofocus,
    );
  }

  Widget strapButton({
    required onPressed,
    StrapButtonType? type,
  }) {
    return StrapButton(
      image: this,
      onPressed: onPressed,
      type: type,
    );
  }

  Widget button(
      {required onPressed, bool autofocus = false, ButtonStyle? style}) {
    return ElevatedButton(
      onPressed: onPressed,
      child: this,
      style: style,
      autofocus: autofocus,
    );
  }
}
