import 'package:flutter/material.dart';

Color primaryColor = Colors.blue;

enum StrapButtonType {
  primary,
  secondary,
  success,
  danger,
  warning,
  info,
  light,
  dark,
  link
}
strapColor(StrapButtonType type) {
  return [
    primaryColor,
    Colors.grey,
    Colors.green,
    Colors.red,
    Colors.amber,
    Colors.lightBlue,
    Colors.white,
    Colors.black,
    Colors.white
  ][type.index];
}

strapFontColor(StrapButtonType type) {
  switch (type) {
    case StrapButtonType.warning:
      return Colors.black;
      break;
    case StrapButtonType.light:
      return Colors.black;
      break;
    case StrapButtonType.link:
      return Colors.blue;
      break;

    default:
      return Colors.white;
  }
}

class StrapButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final StrapButtonType type;
  final double height;
  final double width;
  final double margin;
  final double radius;
  final double borderWidth;
  const StrapButton({
    Key key,
    @required this.text,
    @required this.onPressed,
    this.margin = 1,
    this.type = StrapButtonType.primary,
    this.height = kMinInteractiveDimension,
    this.width,
    this.borderWidth = 1,
    this.radius = 5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    primaryColor = theme.primaryColor;
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border:
            Border.all(width: borderWidth, color: Colors.grey.withOpacity(0.2)),
        color:
            (type == StrapButtonType.primary) ? primaryColor : strapColor(type),
      ),
      child: FlatButton(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(text,
              style: TextStyle(
                color: strapFontColor(type),
                fontSize: 16,
              )),
        ),
        onPressed: () {
          onPressed();
        },
      ),
    );
  }
}
