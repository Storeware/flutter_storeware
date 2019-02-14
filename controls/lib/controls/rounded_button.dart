import 'package:flutter/material.dart';

import './badge.dart';
//import '../day_theme.dart';

enum RoundedButtonIconPosition { left, right }
enum RoundedButtonType { rounded, vertical, horizontal, raised }

// ignore: must_be_immutable
class RoundedButton extends StatelessWidget {
  // ignore: must_be_immutable
  // ignore: must_be_immutable
  final String buttonName;
  final String assertImagePath;
  final VoidCallback onTap;

  final double height;
  final IconData icon;
  final double width;
  final double bottomMargin;
  final double borderWidth;
  Color buttonColor;
  final Widget child;
  final RoundedButtonType buttonType;
  final RoundedButtonIconPosition iconPosition;
  final int badgeValue;
  final bool showBadge;
  TextStyle textStyle = const TextStyle(
      color: const Color(0XFFFFFFFF),
      fontSize: 16.0,
      fontWeight: FontWeight.bold);

  //passing props in react style
  RoundedButton(
      {this.child,
      this.buttonName = '',
      this.showBadge = false,
      this.onTap,
      this.badgeValue = 0,
      this.height = 45.0,
      this.bottomMargin = 0.0,
      this.borderWidth = 1.0,
      this.buttonType = RoundedButtonType.vertical,
      this.width = 90.0,
      this.buttonColor,
      this.icon,
      this.assertImagePath,
      this.textStyle,
      this.iconPosition = RoundedButtonIconPosition.left});

  Widget _drawRounded() {
    if (borderWidth != 0.0)
      return (new InkWell(
        onTap: onTap,
        child: new Container(
          padding: EdgeInsets.all(5.0),
          width: width,
          height: height,
          margin: new EdgeInsets.only(bottom: bottomMargin),
          alignment: FractionalOffset.center,
          decoration: new BoxDecoration(
              color: buttonColor,
              borderRadius: new BorderRadius.all(const Radius.circular(30.0)),
              border: new Border.all(
                  color: const Color.fromRGBO(221, 221, 221, 1.0),
                  width: borderWidth)),
          child: GestureDetector(
            child: (this.child != null
                ? this.child
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      (icon != null
                          ? (iconPosition == RoundedButtonIconPosition.left
                              ? Icon(icon)
                              : Text(''))
                          : Text('')),
                      Expanded(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                            new Text(buttonName, style: textStyle)
                          ])),
                      (icon != null
                          ? (iconPosition == RoundedButtonIconPosition.right
                              ? Icon(icon)
                              : Text(''))
                          : Text('')),
                    ],
                  )),
          ),
        ),
      ));
    else
      return (new InkWell(
        onTap: onTap,
        child: new Container(
          width: width,
          height: height,
          margin: new EdgeInsets.only(bottom: bottomMargin),
          alignment: FractionalOffset.center,
          decoration: new BoxDecoration(
            color: buttonColor,
            borderRadius: new BorderRadius.all(const Radius.circular(30.0)),
          ),
          child: GestureDetector(
            child: (this.child != null
                ? this.child
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      (icon != null ? Icon(icon) : Text('')),
                      new Text(buttonName, style: textStyle),
                    ],
                  )),
          ),
        ),
      ));
  }

  Widget _drawVertical() {
    TextStyle ts = new TextStyle(color: this.buttonColor);
    return FlatButton(
      child: Column(children: [
        Badge(
            child: (this.assertImagePath != null
                ? Image.asset(
                    this.assertImagePath,
                    color: this.buttonColor,
                  )
                : IconButton(
                    icon: Icon(icon),
                    color: this.buttonColor,
                    onPressed: onTap,
                  )),
            value: badgeValue.toString(),
            positionTop: 5.0,
            visibleIfZero: showBadge),
        Text(
          buttonName.toUpperCase(),
          textAlign: TextAlign.center,
          style: ts,
        ),
      ]),
      onPressed: onTap,
    );
  }

  Widget _drawHorizontal() {
    TextStyle ts = new TextStyle(color: this.buttonColor);
    return FlatButton.icon(
      icon: Icon(icon),
      color: this.buttonColor,
      label: Text(
        buttonName.toUpperCase(),
        style: ts,
      ),
      onPressed: onTap,
    );
  }

  Widget _drawRaised() {
    return RaisedButton(
      onPressed: onTap,
      textColor: (textStyle != null ? textStyle.color : Colors.black),
      color: buttonColor,
      child: Row(children: [
        Text(
          buttonName,
          style: textStyle,
        ),
        Icon(icon),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (this.buttonColor == null)
      this.buttonColor = Theme.of(context).accentColor;
    switch (buttonType) {
      case RoundedButtonType.vertical:
        return _drawVertical();
        break;
      case RoundedButtonType.horizontal:
        return _drawHorizontal();
        break;
      case RoundedButtonType.raised:
        return _drawRaised();
        break;
      default:
        return _drawRounded();
        break;
    }
  }
}
