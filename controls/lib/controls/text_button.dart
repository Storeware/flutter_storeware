import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TextButton extends StatelessWidget {
  final String buttonName;
  final TextAlign textAlign;
  final EdgeInsetsGeometry padding;
  final VoidCallback onPressed;
  final TextStyle textStyle = const TextStyle(
      color: const Color(0XFFFFFFFF),
      fontSize: 16.0,
      fontWeight: FontWeight.bold);

  TextStyle _buttonTextStyle;

  //passing props in react style
  TextButton({
    this.buttonName,
    this.textAlign = TextAlign.center,
    this.padding = const EdgeInsets.all(4.0),
    this.onPressed,
    TextStyle buttonTextStyle,
  }){
    if (buttonTextStyle==null)
      _buttonTextStyle = new TextStyle(
          color: const Color(0XFFFFFFFF),
          fontSize: 16.0,
          fontWeight: FontWeight.bold);
      else
      _buttonTextStyle = buttonTextStyle;
  }

  @override
  Widget build(BuildContext context) {
    return (new FlatButton(
      padding: padding,
      child: new Text(buttonName,
          textAlign: textAlign, style: _buttonTextStyle),
      onPressed: onPressed,
    ));
  }
}
