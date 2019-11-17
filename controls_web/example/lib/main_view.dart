
import 'package:flutter/material.dart';
import 'views/drawer_view.dart';

class MainView extends StatefulWidget {
  MainView({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: DrawerView(),
      ),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
