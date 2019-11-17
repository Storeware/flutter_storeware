import 'package:app/models/menu_items.dart';
import 'package:flutter/material.dart';

class DrawerView extends StatefulWidget {
  DrawerView({Key key}) : super(key: key);

  @override
  _DrawerViewState createState() => _DrawerViewState();
}

class _DrawerViewState extends State<DrawerView> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
       appBar: AppBar(title:Text('Opções')),
       body: Column(children: <Widget>[
        Container(width: double.infinity, color:theme.primaryColor.withAlpha(120),
        child: Menu.profile(),
        ),
        Expanded(child:Menu.builder()),
        Container(height: 40,color:theme.primaryColor.withAlpha(100))
       ],),
    );
  }
}