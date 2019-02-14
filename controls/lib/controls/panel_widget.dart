import 'package:flutter/material.dart';

class Panel extends StatelessWidget {
  final double height;
  final double width;
  final double topLeftRadius;
  final double topRightRadius;
  final double bottomLeftRadius;
  final double bottomRightRadius;
  final Color backgroundColor;
  final Color color;
  final Widget child;
  final double border;
  final Widget title;
  final Widget subTitle;
  final List<Widget> children;
  final Function onTapTitle;
  final double padding;
  final double elevation;
  Panel(
      {this.child,
      this.height,
      this.width,
      this.title,
      this.elevation = 0.0,
      this.subTitle,
      this.onTapTitle,
      this.children,
      this.border,
      this.padding = 0.0,
      this.topRightRadius = 0.0,
      this.topLeftRadius = 0.0,
      this.bottomLeftRadius = 0.0,
      this.bottomRightRadius = 0.0,
      this.backgroundColor,
      this.color});

  Widget _padding(Widget wg) {
    return Padding(padding: EdgeInsets.all(padding), child: wg);
  }

  List<Widget> _builder() {
    List<Widget> rt = [];
    if (title != null)
      rt.add(ListTile(
        title: title,
        subtitle: subTitle,
        onTap: onTapTitle,
      ));
    if (child != null) rt.add(child);
    return rt;
  }

  _clip(context) {
    ThemeData theme = Theme.of(context);
    return ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(topLeftRadius),
          topRight: Radius.circular(topRightRadius),
          bottomLeft: Radius.circular(bottomLeftRadius),
          bottomRight: Radius.circular(bottomRightRadius),
        ),
        child: Container(
            height: height,
            width: width,
            color: color ?? theme.scaffoldBackgroundColor,
            child: (children != null && title != null
                ? Column(children: _builder())
                : _padding(child))));
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return (elevation > 0
        ? Card(
            elevation: elevation,
            color: backgroundColor ?? theme.primaryColor,
            child: _clip(context))
        : Container(
            color: backgroundColor ?? theme.primaryColor,
            padding: EdgeInsets.all(border ?? 0.0),
            child: _clip(context)));
  }
}
