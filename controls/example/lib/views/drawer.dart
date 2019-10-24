import 'package:controls/services.dart';
import 'package:flutter/material.dart';


class DrawerView extends StatefulWidget {
  DrawerView({Key key}) : super(key: key);

  _DrawerViewState createState() => _DrawerViewState();
}

class _DrawerViewState extends State<DrawerView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: MainMenu(items: [],),
    );
  }
}