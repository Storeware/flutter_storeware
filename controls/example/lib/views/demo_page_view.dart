import 'package:controls/controls.dart';
import 'package:flutter/material.dart';

class DemoPageView extends StatefulWidget {
  DemoPageView({Key key}) : super(key: key);

  _DemoPageViewState createState() => _DemoPageViewState();
}

class _DemoPageViewState extends State<DemoPageView> {
  @override
  Widget build(BuildContext context) {
    return PageTabView(
      choices: [
        TabChoice(
            child: Scaffold(body: Text('p1')),
            title: 'p1',
            icon: Icons.access_alarm),
        TabChoice(
            child: Scaffold(body: Text('p2')),
            title: 'p2',
            icon: Icons.accessibility)
      ],
    );
  }
}
