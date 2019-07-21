import 'package:controls/controls.dart';
import 'package:flutter/material.dart';

class ScaffoldView extends StatefulWidget {
  ScaffoldView({Key key}) : super(key: key);

  _ScaffoldViewState createState() => _ScaffoldViewState();
}

class _ScaffoldViewState extends State<ScaffoldView> {
  @override
  Widget build(BuildContext context) {
    return SliverScaffold(
      //drawer: Drawer(child: Container(),),
      appBar: AppBar(elevation: 0, title: Text('scaffold')),
      topRadius: 200, // title radius
      radius: 200,
      bodyTop: 20,
      bottomRadius: 10,
      //backgroundColor: Colors.red,
      resizeToAvoidBottomPadding: true,
      extendedBar:
          ExtendedAppBar(color: Colors.amber, child: Stack(children: [
            
            Icon(Icons.access_alarm)
          ])),
      // uses WidgetList to create new list;
      //grid: WidgetList.count(context,itemCount: 10,itemBuilder: (context,i){
      //  return Text(i.toString());
      //}),
      padding:EdgeInsets.all(12),
      body: 
        Container(child: Text('SliverScaffold')),
    );
  }
}
