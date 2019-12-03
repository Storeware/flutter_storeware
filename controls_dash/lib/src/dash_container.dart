import 'package:flutter/material.dart';

class DashContainer extends StatelessWidget {
  final String title;
  final String subTitle;
  final Color color;
  final Widget child;
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
      this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      elevation: elevation,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (title != null)
            SizedBox(
              height: 8,
            ),
          if (title != null)
            Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          Container(width: width, height: height, child: child),
          if (subTitle != null)
            Text(subTitle,
                style: TextStyle(
                  fontSize: 12,
                )),
          if (subTitle != null)
            SizedBox(
              height: 8,
            ),
        ],
      ),
    );
  }
}
