import 'package:controls_web/controls/home_elements.dart';
import 'package:flutter/material.dart';

class DashboardTile extends StatelessWidget {
  final String value;
  final Widget body;
  final Widget image;
  final String title;
  final double width;
  const DashboardTile(
      {Key key,
      this.value,
      this.body,
      this.image,
      this.title,
      this.width = 200})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: ApplienceTile(
        color: Colors.blue,
        titleStyle: TextStyle(color: Colors.white, fontSize: 22),
        valueStyle: TextStyle(color: Colors.white, fontSize: 32),
        width: width,
        value: value,
        body: body,
        image: image,
        title: title,
      ),
    );
  }
}
