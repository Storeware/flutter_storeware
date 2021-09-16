// @dart=2.12
import 'package:flutter/material.dart';
import 'package:controls_web/controls.dart';

class DataViewerCardsResize extends StatelessWidget {
  final Widget Function(BuildContext context, double width) builder;
  final double width;
  final double gap;
  const DataViewerCardsResize(
      {Key? key, required this.builder, this.width = 350, this.gap = 8})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ResponsiveInfo responsive = ResponsiveInfo(context);
    //var height = responsive.size.height;
    //final theme = responsive.theme;
    //double dw = (responsive.size.width / 2) - 20;
    double cols = (responsive.size.width ~/ this.width) + 0.0;
    double wcols = (responsive.size.width / cols) - ((cols + 1) * this.gap);
    if (cols <= 1) {
      cols = 1;
      wcols = responsive.size.width;
    }

    return builder(context, wcols);
  }
}
