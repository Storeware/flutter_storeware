import 'package:flutter/material.dart';

class Button extends StatefulWidget {
  final Widget child;
  final String text;
  final Function onPressed;
  Button({Key key, this.text, this.child, this.onPressed}) : super(key: key);

  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: widget.child ?? Text(widget.text),
      onPressed: widget.onPressed,
    );
  }
}

class LinkButton extends StatelessWidget {
  final Widget image;
  final String text;
  final Function onPressed;
  final Color color;
  const LinkButton(
      {Key key,
      this.text,
      this.image,
      this.color = Colors.blue,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Row(
        children: <Widget>[
          Text(
            text,
            style: TextStyle(
              color: color,
              decoration: TextDecoration.underline,
            ),
          ),
          image != null
              ? CircleAvatar(
                  child: image,
                )
              : Container(),
        ],
      ),
      onTap: onPressed,
    );
  }
}
