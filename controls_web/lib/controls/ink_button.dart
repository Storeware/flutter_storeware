import 'package:flutter/material.dart';

class InkButton extends StatefulWidget {
  final Widget? child;
  final Function()? onTap;
  final String? tooltip;
  final EdgeInsets? padding;
  final double? radius;
  InkButton({
    Key? key,
    //this.shape,
    this.child,
    this.onTap,
    this.padding,
    this.tooltip,
    this.radius = 5,
    //this.side,
  }) : super(key: key);

  @override
  _InkButtonState createState() => _InkButtonState();
}

class _InkButtonState extends State<InkButton> {
  ThemeData? theme;

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return (widget.tooltip == null)
        ? createButton()
        : Tooltip(
            message: widget.tooltip!,
            child: createButton(),
          );
  }

  createButton() => InkResponse(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(widget.radius!),
      splashColor: theme!.indicatorColor,
      child: Padding(
        padding: widget.padding ?? EdgeInsets.all(4),
        child: widget.child,
      ));
}
