import 'package:flutter/material.dart';

typedef Widget SeparatorBuilder();

class SeparatedRow extends StatelessWidget {
  final List<Widget> children;
  final SeparatorBuilder separatorBuilder;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final TextBaseline textBaseline;
  final TextDirection textDirection;
  final VerticalDirection verticalDirection;

  const SeparatedRow({
    Key key,
    this.children,
    this.separatorBuilder,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline,
    this.textDirection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> c = children.toList();
    for (var i = c.length; i-- > 0;) {
      if (i > 0) c.insert(i, separatorBuilder());
    }
    return Row(
      children: c,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      textBaseline: textBaseline,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
    );
  }
}

class SeparatedColumn extends StatelessWidget {
  final List<Widget> children;
  final SeparatorBuilder separatorBuilder;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final TextBaseline textBaseline;
  final TextDirection textDirection;
  final VerticalDirection verticalDirection;

  const SeparatedColumn({
    Key key,
    this.children,
    this.separatorBuilder,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline,
    this.textDirection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> c = children.toList();
    for (var i = c.length; i-- > 0;) {
      if (i > 0 && separatorBuilder != null) c.insert(i, separatorBuilder());
    }
    return Column(
      children: c,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      textBaseline: textBaseline,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
    );
  }
}
