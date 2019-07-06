import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sliver_scaffold/sliver_scaffold.dart';

class CleanView extends StatefulWidget {
  CleanView({Key key}) : super(key: key);

  _CleanViewState createState() => _CleanViewState();
}

class _CleanViewState extends State<CleanView> {
  @override
  void initState() {
    // TODO: implement initState
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliverScaffold(
      drawer: Drawer(
        child: Text('x'),
      ),
      bodyTop: -60,
      extendedBar: ExtendedAppBar(
          height: 250,
          color: Colors.white30 ,
          //title:Center(child:Text('Title',style:TextStyle(fontSize: 24))),
          child: Image.asset(
            'assets/speed_racer.jpg',
            
            //fit: BoxFit.cover,
            //height: double.maxFinite,
          )),
      body: BoxContainer(
        topLeft: 90,
        topRight: 90,
        bottomLeft: 0,
        bottomRight: 0,
        color: Colors.yellow[100],
        child: ListView.builder(
          itemBuilder: (x, y) {
            return ListTile(
                leading: Icon(Icons.access_alarm),
                title: Text('Item: ' + y.toString()));
          },
          itemCount: 30,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (idx) {
          Navigator.of(context).pop();
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.comment), title: Text('Comments')),
          BottomNavigationBarItem(
              icon: Icon(Icons.exit_to_app), title: Text('Exit'))
        ],
      ),
    );
  }
}
