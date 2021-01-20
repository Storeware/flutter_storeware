import 'package:flutter/material.dart';

class InkButton extends StatelessWidget {
  final Widget child;
  final Function() onTap;
  final String tooltip;
  final EdgeInsets padding;
  final double radius;
  InkButton({
    Key key,
    //this.shape,
    this.child,
    this.onTap,
    this.padding,
    this.tooltip,
    this.radius = 5,
    //this.side,
  }) : super(key: key);

  ThemeData theme;
  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return (tooltip == null)
        ? createButton()
        : Tooltip(
            message: tooltip,
            child: createButton(),
          );
  }

  createButton() => InkResponse(
      onTap: onTap,
      borderRadius: BorderRadius.circular(radius),
      splashColor: theme.indicatorColor,
      child: Padding(
        padding: padding ?? EdgeInsets.all(4),
        child: child,
      ));
}
