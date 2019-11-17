import 'package:controls_web/controls/home_elements.dart';
import 'package:flutter/material.dart';


class AppsGrid extends StatelessWidget {
  final List<Widget> children;
  const AppsGrid({Key key,this.children }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int cols = MediaQuery.of(context).size.width ~/ 150;
    if (cols<2) cols = 2;
    return SliverContents(grid: children ,crossAxisCount: cols , );
  }
}