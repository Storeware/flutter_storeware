// Copyright (c) 2018, Raouf Rahiche. All rights reserved. Use of this source code

//library badge;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

//a widget that paint a Badge with full control
// the badge can be placed inside the child widget or in the corner
// ignore: must_be_immutable
class Badge extends StatefulWidget {
  //the target widget
  Widget child;

  //the badge text
  String value;

  //the badge text style
  TextStyle textStyle = new TextStyle(color: Colors.white);

  //the badge background color
  final Color color;

  //the badge Border color
  final Color borderColor;

  //the badge border width
  final double borderSize;
  final fontSize;

  //is the badge is circle or a rectangle
  bool isRounded;

  //the badge position if it's not in the right place
  double positionTop;
  double positionRight;
  double positionLeft;
  double positionBottom;
  bool visibleIfZero;

  //if the badge is inside we have to set [_before]
  bool _inside = false;
  //if the badge is before or after the child
  bool _before;
  //we can set the space between the badge and the child
  double spacing;

  Badge({
    Key key,
    this.child,
    this.value = "0",
    this.fontSize = 10.0,
    this.color = Colors.red,
    this.isRounded = true,
    this.borderColor = Colors.white,
    this.borderSize = 0.0,
    this.textStyle = const TextStyle(color: Colors.white),
    this.positionTop = -15.0,
    this.positionRight = -10.0,
    this.positionLeft,
    this.positionBottom,
    this.visibleIfZero = false,
  }) : super(key: key);

  //create a badge in the left corner of the child in a Stack
  Badge.left({
    Key key,
    this.child,
    this.value = "0",
    this.fontSize = 10.0,
    this.color = Colors.red,
    this.isRounded = true,
    this.borderColor = Colors.white,
    this.borderSize = 1.0,
    this.textStyle = const TextStyle(color: Colors.white),
    this.positionTop = -20.0,
    this.positionRight = -10.0,
    this.positionLeft,
    this.positionBottom,
  }) : super(key: key);

  //create a badge in the right corner of the child in a Stack
  Badge.right({
    Key key,
    this.child,
    this.value = "0",
    this.fontSize = 10.0,
    this.color = Colors.red,
    this.isRounded = true,
    this.borderColor = Colors.white,
    this.borderSize = 1.0,
    this.textStyle = const TextStyle(color: Colors.white),
    this.positionTop = -20.0,
    this.positionRight,
    this.positionLeft = -10.0,
    this.positionBottom,
  }) : super(key: key);

  //create a badge after the child in a row
  Badge.after({
    Key key,
    this.child,
    this.value = "0",
    this.fontSize = 10.0,
    this.color = Colors.red,
    this.isRounded = true,
    this.borderColor = Colors.white,
    this.borderSize = 1.0,
    this.textStyle = const TextStyle(color: Colors.white),
    this.positionTop = -20.0,
    this.positionRight,
    this.positionLeft = -10.0,
    this.positionBottom,
    this.spacing = 0.0,
  }) : super(key: key) {
    this._inside = true;
    this._before = false;
  }

  //create a badge before the child in a row
  Badge.before({
    Key key,
    this.child,
    this.value = "0",
    this.fontSize = 10.0,
    this.color = Colors.red,
    this.isRounded = true,
    this.borderColor = Colors.white,
    this.borderSize = 1.0,
    this.textStyle = const TextStyle(color: Colors.white),
    this.positionTop = -20.0,
    this.positionRight,
    this.positionLeft = -10.0,
    this.positionBottom,
    this.spacing = 0.0,
  }) : super(key: key) {
    this._inside = true;
    this._before = true;
  }

  @override
  _BadgeState createState() => new _BadgeState();
}

class _BadgeState extends State<Badge> {
  @override
  Widget build(BuildContext context) {
    if (widget.visibleIfZero==null)
      widget.visibleIfZero=false;

    if (widget.child == null) widget.child = Text('');
    if (widget._inside) {
      return createBadgeInside();
    } else {
      return createBadgeCorner();
    }
  }

  //create the badge after/before the child
  Row createBadgeInside() {
    return new Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        widget._before == true ? null : widget.child,
        new Container(
          margin: widget._before == true
              ? new EdgeInsets.only(right: widget.spacing)
              : new EdgeInsets.only(left: widget.spacing),
          decoration: badgeDecoration(),
          child: valueWidget(),
        ),
        widget._before == true ? widget.child : null,
      ].where((l) => l != null).toList(),
    );
  }

  //create the badge in the right/left corner of the child
  Stack createBadgeCorner() {
    return new Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        widget.child,
        (_canShow()
            ? new Positioned(
                top: widget.positionTop,
                right: widget.positionRight,
                left: widget.positionLeft,
                bottom: widget.positionBottom,
                child: new Container(
                  decoration: badgeDecoration(),
                  child: valueWidget(),
                ))
            : Text(''))
      ],
    );
  }

  bool _canShow() {
    return widget.value != '0' ||
        !(widget.value == '0' && !widget.visibleIfZero);
  }

  _getValue() {
    int i = int.tryParse(widget.value);
    if (i!=null) {
      if (i >= 100 && i < 1000)
        return i.toStringAsFixed(0);//'+' + ((i / 100).toStringAsFixed(0)) + 'c';
      if (i >= 1000 && i < 1000000)
        return '+' + ((i / 1000).toStringAsFixed(1)) + 'k';
      if (i >= 1000000) return '+' + ((i / 1000000).toStringAsFixed(1)) + 'g';
    }
    return widget.value;
  }

  ///the text inside the Badge Widget
  Padding valueWidget() {
    return new Padding(
      padding: const EdgeInsets.all(2.5),
      child: new Text(
        _getValue(),
        style: widget.textStyle.copyWith(fontSize: widget.fontSize),
      ),
    );
  }

  //control how the badge look
  BoxDecoration badgeDecoration() {
    return new BoxDecoration(
        color: widget.color,
        border:
            new Border.all(color: widget.borderColor, width: widget.borderSize),
        borderRadius: widget.isRounded == true
            ? new BorderRadius.circular(100.0)
            : new BorderRadius.circular(0.0));
  }
}
