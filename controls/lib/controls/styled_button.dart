import 'package:flutter/material.dart';

class StyledButton extends StatelessWidget {
  final Widget child;
  final double radius;
  final onPressed;
  final double padding;
  final Icon icon;
  final double width;
  final String text;
  const StyledButton(
      {Key key,
      this.child,
      this.text,
      this.icon,
      this.width,
      this.padding = 2.0,
      this.onPressed,
      //this.color,
      this.radius = 10.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color color = /*widget.color ??*/ Theme.of(context).buttonColor;
    Widget bt = text != null
        ? Text(text, style: theme.textTheme.button)
        : child;
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Container(
        height: 45,
        width: width,
        margin: EdgeInsets.all(padding),
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(radius)),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          icon != null
              ? IconButton(
                  icon: icon,
                  onPressed: () {
                    onPressed();
                  },
                )
              : Container(),
          Container(child: bt),
        ]),
      ),
    );
  }
}
