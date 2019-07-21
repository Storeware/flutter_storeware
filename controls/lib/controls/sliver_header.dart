import 'package:flutter/material.dart';

class SliverHeader extends StatelessWidget {
  final text;
  final Color color;
  final TextStyle style;
  final Widget child;
  final double max;
  final double min;
  const SliverHeader(this.text,
      {Key key,
      this.child,
      this.max = 60,
      this.min = 30,
      this.color,
      this.style})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: false,
      floating: true,
      delegate: Delegate(
          max: max,
          min: min,
          child: child ??
              Center(
                  child: Text(
                text,
                style: style,
              )),
          color: color),
    );
  }
}

class Delegate extends SliverPersistentHeaderDelegate {
  final Color color;
  final Widget child;
  final double max;
  final double min;
  Delegate({this.color, this.child, this.max = 60, this.min = 30});

  @override
  Widget build(
          BuildContext context, double shrinkOffset, bool overlapsContent) =>
      Container(child: child, color: color);

  @override
  double get maxExtent => max;

  @override
  double get minExtent => min;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
