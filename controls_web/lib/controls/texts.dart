import 'package:flutter/material.dart';

class LabeledText extends StatelessWidget {
  final String label;
  final String text;
  final double fontSize;
  const LabeledText({this.label, this.text, this.fontSize = 12, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Text(this.label, style: TextStyle(fontSize: this.fontSize)),
          Text(this.text, style: TextStyle(fontSize: this.fontSize))
        ]),
      ),
    );
  }
}
