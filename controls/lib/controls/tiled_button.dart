/*
Sample:

        TiledIconButton(
          //padding: EdgeInsets.fromLTRB(0.0 , 0.0, 8.0, 0.0),
          icon:Icons.menu,
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
        ),



         new TiledButton(
            minWidth: 120.0,
            text: Text('xxx'),
            onPressed: () {
              Navigator.pushNamed(context, '/');
            }),




*/

/*
autor: https://github.com/utkarshdbodake/flutter_buttons/blob/master/lib/src/k_flat_button.dart
 */
import 'package:flutter/material.dart';

class TiledIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final EdgeInsetsGeometry padding;

  TiledIconButton({this.icon, this.onPressed, this.padding = const EdgeInsets.all(8.0)});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: GestureDetector(
          child: Row(
        children: <Widget>[
          Icon(icon),
        ],
      ),
      onTap: onPressed,
      ),
    );
  }
}

class TiledButton extends StatelessWidget {
  final double minWidth;
  final double height;
  final double radius;
  // The button's fill color, while it's in default (unpressed, [enabled]) state
  final Color color;
  final String text;
  final Color textColor;
  final FontWeight textFontWeight;
  final double textFontSize;
  final VoidCallback onPressed;
  final Icon icon;
  final EdgeInsetsGeometry padding;

  TiledButton({
    this.minWidth = 50.0,
    this.height = 50.0,
    this.padding = const EdgeInsets.all(0.0),
    this.radius = 0.0,
    this.color = Colors.transparent,
    @required this.text,
    this.textColor = Colors.white,
    this.textFontWeight = FontWeight.w600,
    this.textFontSize = 20.0,
    @required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: minWidth,
      height: height,
      child: _constructFlatButton(),
    );
  }

  Widget _constructFlatButton() {
    if (icon == null) {
      return FlatButton(
        padding: padding,
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
              color: textColor,
              fontWeight: textFontWeight,
              fontSize: textFontSize),
        ),
      );
    }

    // Flat button with icon.
    return FlatButton.icon(
      color: color,
      icon: icon,
      label: (text != null
          ? Text(
              text,
              style: TextStyle(
                  color: textColor,
                  fontWeight: textFontWeight,
                  fontSize: textFontSize),
            )
          : Text('')),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      onPressed: onPressed,
    );
  }
}
