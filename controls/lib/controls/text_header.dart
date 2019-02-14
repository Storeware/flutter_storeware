import 'package:flutter/material.dart';

const alphaColorBackground = 150;

class Empty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class LinhaDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Divider(
      height: 4.0,
      color: Theme.of(context).accentColor,
    );
  }
}

// ignore: must_be_immutable
class TextBold extends StatelessWidget {
  final String text;
  final double textSize;
  TextStyle style;

  TextBold(this.text, {this.textSize = 18.0, this.style}) {
    if (style == null) {
      style = TextStyle(fontSize: textSize, fontWeight: FontWeight.bold);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
    );
  }
}

// ignore: must_be_immutable
class HeaderTile extends StatelessWidget {
  final String text;
  Widget title;
  Widget subtitle;
  final textColor;
  final fontSize;
  final int alphaColor;
  Color color;
  TextStyle textStyle;
  final double height;

  HeaderTile(
      {this.text,
      this.title,
      this.subtitle,
      this.height = 30.0,
      this.textColor = Colors.white,
      this.textStyle,
      this.fontSize = 12.0,
      this.color,
      this.alphaColor = alphaColorBackground}) {
    if (this.textStyle == null)
      this.textStyle = TextStyle(
          color: (textColor ?? Colors.white),
          fontSize: fontSize,
          fontWeight: FontWeight.w600);

    title = (title ?? Text(text ?? '', style: textStyle));
  }

  List<Widget> _createRow() {
    List<Widget> r = [];
    r.add(Expanded(
        child: Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: (subtitle == null
                ? title
                : ListTile(
                    title: title,
                    subtitle: subtitle,
                  )))));
    return r;
  }

  @override
  Widget build(BuildContext context) {
    if (color == null) {
      color = Theme.of(context).accentColor.withAlpha(alphaColor);
    }
    return Container(
        height: height,
        color: color,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: _createRow()));
  }
}

// ignore: must_be_immutable
class TextHeader extends StatelessWidget {
  final String text;
  final int maxLines;
  final double height;
  final Color textColor;
  final double fontSize;
  Color color;
  TextStyle textStyle;

  TextHeader(
      {this.text,
      this.textColor,
      this.height = 30.0,
      this.fontSize = 16.0,
      this.maxLines = 1,
      this.color}) {
    // init
    this.textStyle = TextStyle(
        color: (textColor != null ? textColor : Colors.white),
        fontSize: fontSize,
        fontWeight: FontWeight.bold);
  } //this.color: Colors.white });

  @override
  Widget build(BuildContext context) {
    if (color == null) {
      color = Theme.of(context).primaryColor;
    }
    return Container(
        height: height,
        padding: EdgeInsets.all(5.0),
        color: color,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
                child: Text(this.text, maxLines: maxLines, style: textStyle))
          ],
        ));
  }
}
