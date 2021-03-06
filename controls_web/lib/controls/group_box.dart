import 'package:flutter/material.dart';

class GroupBox extends StatelessWidget {
  final Widget? title;
  final List<Widget>? children;
  final double? height, width;
  final Color? color;
  final Color? titleColor;
  final double? elevation;
  final CrossAxisAlignment? crossAxisAlignment;
  const GroupBox(
      {Key? key,
      this.title,
      this.children,
      this.height = 180,
      this.width = 300,
      this.color,
      this.titleColor,
      this.elevation,
      this.crossAxisAlignment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      width: width,
      height: height,
      child: Card(
        elevation: elevation,
        color: color,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
          children: [
            if (title != null)
              Container(
                padding: EdgeInsets.only(left: 8),
                alignment: Alignment.centerLeft,
                constraints: BoxConstraints(minHeight: 25),
                color: titleColor ?? (lighten(theme.primaryColor, 50)),
                child: title,
                width: double.maxFinite,
              ),
            Expanded(
              child: Wrap(direction: Axis.vertical, children: children!),
            ),
          ],
        ),
      ),
    );
  }

  Color lighten(Color color, [int percent = 10]) {
    Color c = color;
    assert(1 <= percent && percent <= 100);
    var p = percent / 100;
    return Color.fromARGB(
        c.alpha,
        c.red + ((255 - c.red) * p).round(),
        c.green + ((255 - c.green) * p).round(),
        c.blue + ((255 - c.blue) * p).round());
  }
}
