import 'package:controls_web/controls/home_elements.dart';
import 'package:flutter/material.dart';

class DashboardTile extends StatelessWidget {
  final String value;
  final Widget body;
  final Widget image;
  final String title;
  final double width;
  final Color color;
  const DashboardTile(
      {Key key,
      this.value,
      this.body,
      this.image,
      this.title,
      this.color,
      this.width = 200})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    Color _textColor = theme.primaryTextTheme.bodyText1.color;
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: ApplienceTile(
        color: color ?? theme.appBarTheme.color,
        titleStyle: TextStyle(color: _textColor, fontSize: 18),
        valueStyle: TextStyle(color: _textColor, fontSize: 28),
        width: width,
        value: value,
        body: body,
        image: image,
        title: title,
      ),
    );
  }
}
