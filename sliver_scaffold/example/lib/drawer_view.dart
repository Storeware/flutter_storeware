import 'package:flutter/material.dart';
import 'package:sliver_scaffold/sliver_scaffold.dart';

class DrawerView extends StatefulWidget {
  final Widget child;
  DrawerView({Key key, this.child}) : super(key: key);

  _DrawerViewState createState() => _DrawerViewState();
}

class _DrawerViewState extends State<DrawerView> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: SliverScaffold(
        sliverAppBar: SliverAppBar(
          actions: <Widget>[Icon(Icons.access_alarms)],
          floating: true,
          centerTitle: true,
          backgroundColor: Colors.orange,
          expandedHeight: 200.0,
          title: Text('SliverAppBar Title'),
          flexibleSpace: FlexibleSpaceBar(
            title: Text('Title'),
            background: Image.asset('assets/spacebar.jpg'),
          ),
        ),
        backgroundColor: Colors.blue[200],
        extendedBar: ExtendedAppBar(
            color: Colors.red,
            height: 160,
            child: Container(
              constraints: BoxConstraints(maxHeight: 50),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.person),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.settings),
                      onPressed: () {},
                    ),
                  ]),
            )),
        bodyTop: -150,
        body: BoxContainer(
            color: Colors.blue[50],
            topLeft: 200,
            topRight: 200,
            bottomLeft: 60,
            bottomRight: 60,
            child: ListView(children: _listItens())),
      ),
    );
  }

  List<Widget> _listItens() {
    List<Widget> r = [];
    r.add(Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      Container(
          width: 100.0,
          height: 100.0,
          decoration: new BoxDecoration(
              color: Colors.red.withOpacity(1),
              shape: BoxShape.circle,
              image: new DecorationImage(
                  fit: BoxFit.cover,
                  image: Image.asset(
                    'assets/garfield.jpg',
                    color: Colors.red.withOpacity(1),
                  ).image))),
    ]));

    for (var i = 0; i < 20; i++) {
      r.add(ListTile(
          leading: Icon(Icons.person_add),
          title: Text('Item ' + i.toString())));
    }
    return r;
  }
}
