import 'package:flutter/material.dart';

class GradientBox extends StatelessWidget {
  final double height;
  final List<Widget> children;
  final List<Color> colors;
  final List<double> stops;
  const GradientBox(
      {Key key,
      this.height = kToolbarHeight,
      this.children,
      this.colors,
      this.stops})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return gradiente(
      height: height,
      children: children,
    );
  }

  gradiente({double height = kToolbarHeight + 30, List<Widget> children}) {
    return Container(
        height: height,
        // alingment:Alingment.bottom,
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: stops ?? [0.1, 0.5, 0.7, 0.9],
          colors: colors ??
              [
                Color(0xffafdbdd),
                Color(0xff37bde9),
                Color(0xff37bde9),
                Color(0xff00afef),
              ],
        )),
        child: (children == null)
            ? null
            : Stack(children: [
                ...children,
              ]));
  }
}
