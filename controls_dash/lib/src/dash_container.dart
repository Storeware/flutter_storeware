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
      this.width, //= 200,
      this.height, // = 150,
      Key key,
      this.body,
      this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      elevation: elevation,
      child: Column(
        children: [
          SizedBox(
            height: 5,
          ),
          if (title != null)
            Column(
              children: <Widget>[
                Text(title,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                if (body != null) body,
              ],
            ),
          Expanded(
              child: Container(
                  padding: EdgeInsets.all(3),
                  width: width,
                  height: height,
                  child: child)),
          if (subTitle != null)
            Text(subTitle,
                style: TextStyle(
                  fontSize: 12,
                )),
        ],
      ),
    );
  }
}
