import 'package:flutter/material.dart';
//import './badge.dart';
//import '../day_theme.dart';

enum RoundedButtonIconPosition { left, right }
enum RoundedButtonType { rounded, vertical, horizontal, raised }

Color defaultButtonColor = Colors.red;
Color defaultTextButtonColor = Colors.white;
TextStyle defaultTextStyleButton;
RoundedButtonType defaultButtonType = RoundedButtonType.rounded;

enum BadgePosition { topCenter, left, right, center }

class BadgeButton extends StatelessWidget {
  final int value;
  final Color color;
  BadgeButton({Key key, this.value, this.color = Colors.red}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      value.toString(),
      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color),
    );
  }
}

class RoundedButton extends StatelessWidget {
  final String buttonName;
  final String assertImagePath;
  final VoidCallback onTap;
  final double height;
  final IconData icon;
  final double width;
  final double bottomMargin;
  final double borderWidth;
  Color textColor;
  Color color;
  final Color barColor;
  final double barWidth;
  final Widget child;
  RoundedButtonType buttonType;
  final RoundedButtonIconPosition iconPosition;
  final double roundLeft;
  final double roundRight;
  final int badgeValue;
  final bool showBadge;
  final BadgePosition badgePosition;
  TextStyle textStyle;
  RoundedButton(
      {this.child,
      this.buttonName = '',
      this.showBadge = false,
      this.onTap,
      this.roundLeft = 15,
      this.roundRight = 15,
      this.badgeValue = 0,
      this.badgePosition = BadgePosition.right,
      this.height = 35,
      this.bottomMargin = 0.0,
      this.borderWidth = 0.0,
      this.buttonType,
      this.width = 90.0,
      this.color,
      this.textColor,
      this.barColor,
      this.barWidth = 3,
      this.icon,
      this.assertImagePath,
      this.textStyle,
      this.iconPosition = RoundedButtonIconPosition.left}) {
    if (buttonType == null) buttonType = defaultButtonType;
    if (color == null) color = defaultButtonColor;
    if (textColor == null) textColor = defaultTextButtonColor;
    if (textStyle == null) {
      textStyle = defaultTextStyleButton ??
          TextStyle(
              color: textColor, fontSize: 16.0, fontWeight: FontWeight.bold);
    }
  }

  static rounded(
      {Widget child,
      double width,
      double heigth,
      badgeValue,
      BadgePosition badgePosition,
      Function onPressed}) {
    return RoundedButton(
      buttonType: RoundedButtonType.rounded,
      child: child,
      width: width,
      badgeValue: badgeValue,
      showBadge: (badgeValue ?? 0) > 0,
      badgePosition: badgePosition ?? BadgePosition.right,
      onTap: onPressed,
      height: heigth,
    );
  }

  static roundedLeft(
      {Widget child, double width, double heigth, Function onPressed}) {
    return RoundedButton(
      buttonType: RoundedButtonType.rounded,
      child: child,
      roundRight: 0,
      width: width,
      onTap: onPressed,
      height: heigth,
    );
  }

  static roundedRight(
      {Widget child, double width, double heigth, Function onPressed}) {
    return RoundedButton(
      buttonType: RoundedButtonType.rounded,
      child: child,
      width: width,
      roundLeft: 0,
      onTap: onPressed,
      height: heigth,
    );
  }

  static raised(
      {Widget child, double width, double heigth, Function onPressed}) {
    return RoundedButton(
      buttonType: RoundedButtonType.raised,
      child: child,
      width: width,
      onTap: onPressed,
      height: heigth,
    );
  }

  static vertical(
      {Widget child, double width, double heigth, Function onPressed}) {
    return RoundedButton(
      buttonType: RoundedButtonType.vertical,
      child: child,
      width: width,
      onTap: onPressed,
      height: heigth,
    );
  }

  static horizontal(
      {Widget child, double width, double heigth, Function onPressed}) {
    return RoundedButton(
      buttonType: RoundedButtonType.horizontal,
      child: child,
      width: width,
      onTap: onPressed,
      height: heigth,
    );
  }

  createBadge() {
    if (showBadge && badgePosition == BadgePosition.right)
      return Positioned(
          top: 0, right: 0, child: BadgeButton(value: badgeValue));
    if (showBadge && badgePosition == BadgePosition.center)
      return Positioned(
          top: 0,
          left: 0,
          bottom: 0,
          right: 0,
          child: Center(child: BadgeButton(value: badgeValue)));
    if (showBadge && badgePosition == BadgePosition.topCenter)
      return Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Center(child: BadgeButton(value: badgeValue)));
    if (showBadge && badgePosition == BadgePosition.left)
      return Positioned(top: 0, left: 0, child: BadgeButton(value: badgeValue));
    if (badgeValue == 0) return Container();
    return Positioned(
        left: 0,
        top: 5,
        right: 0,
        child: Center(child: BadgeButton(value: badgeValue)));
  }

  Widget _drawRounded() {
    if (borderWidth != 0.0)
      return (new InkWell(
        onTap: onTap,
        child: new Container(
          padding:
              EdgeInsets.all((roundLeft > 0 && roundRight > 0) ? 5.0 : 0.0),
          width: width,
          height: height,
          margin: new EdgeInsets.only(bottom: bottomMargin),
          alignment: FractionalOffset.center,
          decoration: new BoxDecoration(
              color: color,
              borderRadius: new BorderRadius.only(
                  topLeft: Radius.circular(roundLeft),
                  bottomLeft: Radius.circular(roundLeft),
                  topRight: Radius.circular(roundRight),
                  bottomRight: Radius.circular(roundRight)),
              border: new Border.all(
                  color: const Color.fromRGBO(221, 221, 221, 1.0),
                  width: borderWidth)),
          child: Container(
            child: (this.child != null
                ? Center(
                    child: Stack(
                        children: [this.child, if (showBadge) createBadge()]))
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      (icon != null
                          ? (iconPosition == RoundedButtonIconPosition.left
                              ? Icon(icon)
                              : Container())
                          : Container()),
                      Expanded(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                            if (barColor != null)
                              Container(width: barWidth, color: barColor),
                            Text(buttonName,
                                style: textStyle, textAlign: TextAlign.center)
                          ])),
                      (icon != null
                          ? (iconPosition == RoundedButtonIconPosition.right
                              ? Icon(icon)
                              : Container())
                          : Container()),
                    ],
                  )),
          ),
        ),
      ));
    else
      return (GestureDetector(
        onTap: onTap,
        child: new Container(
          width: width,
          height: height,
          margin: new EdgeInsets.only(bottom: bottomMargin),
          alignment: FractionalOffset.center,
          decoration: new BoxDecoration(
            color: color,
            borderRadius: new BorderRadius.all(const Radius.circular(30.0)),
          ),
          child: Container(
            child: (this.child != null)
                ? this.child
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      (icon != null ? Icon(icon) : Text('')),
                      new Text(buttonName, style: textStyle),
                    ],
                  ),
          ),
        ),
      ));
  }

  Widget _drawVertical() {
    return FlatButton(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(
          buttonName.toUpperCase(),
          textAlign: TextAlign.center,
          style: textStyle,
        ),
      ]),
      onPressed: onTap,
    );
  }

  Widget _drawHorizontal() {
    return InkWell(
      child: Container(
        height: height,
        width: width,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            (icon != null) ? Icon(icon) : Container(),
            (icon != null) ? Container(width: 5) : Container(),
            (child != null) ? Center(child: child) : Container(),
            Text(
              buttonName.toUpperCase(),
              style: textStyle,
              textAlign: TextAlign.center,
            )
          ],
        ),
        color: this.color,
      ),
      onTap: onTap,
    );
  }

  Widget _drawRaised() {
    return RaisedButton(
      onPressed: onTap,
      textColor: textColor,
      color: color,
      child: Row(mainAxisSize: MainAxisSize.min, children: [
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
