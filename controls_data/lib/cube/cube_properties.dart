import 'package:flutter/material.dart';

import 'cube_controller.dart';
import 'cube_dimensions.dart';

class CubePropertiesPage extends StatelessWidget {
  final Widget title;
  const CubePropertiesPage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DefaultCube cube = DefaultCube.of(context);
    List<CubeDimension> items = cube?.controller?.dimensions;
    if (cube == null) return Container();
    return Scaffold(
        appBar: AppBar(title: title),
        //child: child,
        body: Row(children: [
          SizedBox(
              width: 160,
              child: Container(
                  color: Colors.amber,
                  child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, i) {
                        CubeDimension item = items[i];
                        return ListTile(title: Text(item.label ?? item.name));
                      })))
        ]));
  }
}
