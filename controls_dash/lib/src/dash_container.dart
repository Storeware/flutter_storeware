import 'package:flutter/material.dart';

class DashContainer extends StatelessWidget {
  final String title;
  final String subTitle;
  final Color color;
  final Widget child;
  final Widget body;
  final double width;
  final double height;
  final double elevation;
  const DashContainer(
      {this.title,
      this.color,
      this.elevation = 1,
      this.subTitle,
      this.width = 200,
      this.height = 150,
      Key key,
      this.body,
      this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      elevation: elevation,
      child: Stack(
        children: [
          if (title != null)
            Positioned(
              left: 5,
              right: 5,
              top: 5,
              child: Column(
                children: <Widget>[
                  Text(title,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  if (body != null) body,
                ],
              ),
            ),
          Container(
              padding: EdgeInsets.all(3),
              width: width,
              height: height,
              child: child),
          if (subTitle != null)
            Positioned(
                top: 40,
                left: 5,
                right: 5,
                child: Text(subTitle,
                    style: TextStyle(
                      fontSize: 12,
                    ))),
        ],
      ),
    );
  }
}
