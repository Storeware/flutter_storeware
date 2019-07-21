import 'package:flutter/material.dart';


class StyledButton extends StatefulWidget {
  final Widget child;
  final double radius;
  final onPressed;
  //Color color;
  final double padding;
  final Icon icon;
  final double width;
  final String text;
  StyledButton(
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

  _StyledButtonState createState() => _StyledButtonState();
}

class _StyledButtonState extends State<StyledButton> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color color = /*widget.color ??*/ Theme.of(context).buttonColor;
    Widget bt = widget.text != null
        ? Text(widget.text, style:theme.textTheme.button )
        : widget.child;
    return GestureDetector(
      onTap: () {
        widget.onPressed();
      },
      child: Container(
        height: 45,
        width: widget.width,
        margin: EdgeInsets.all(widget.padding),
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(widget.radius)),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          widget.icon != null
              ? IconButton(
                  icon: widget.icon,
                  onPressed: () {
                    widget.onPressed();
                  },
                )
              : Container(),
          Container(child: bt),
        ]),
      ),
    );
  }
}
