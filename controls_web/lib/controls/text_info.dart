import 'package:flutter/material.dart';

class Noop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }
}

class NotNull extends StatelessWidget {
  final bool check;
  final Widget child;
  NotNull(this.check, this.child);
  @override
  Widget build(BuildContext context) {
    return (check != null ? child : Noop());
  }
}

dynamic nullIf(dynamic t, dynamic ret) {
  if (t != null) return t;
  return ret;
}

class Processing extends StatelessWidget {
  final bool waiting;
  final Color color;
  Processing(this.waiting, {this.color = Colors.black});
  @override
  Widget build(BuildContext context) {
    return (waiting ? TextInfo(color: color) : Noop());
  }
}

// ignore: must_be_immutable
class TextInfo extends StatelessWidget {
  final String text;
  final Color color;
  TextInfo({this.text = '', this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return Center(
      child:
//      Row(children: <Widget>[
          new CircularProgressIndicator(
        backgroundColor: color,
      ),
//        Text(this.text)
//      ],)
    );
  }
}

class Waiting extends TextInfo {}
