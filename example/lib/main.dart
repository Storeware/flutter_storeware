//import 'package:exemple/controls_activities_view.dart';
//import 'package:exemple/controls_clean_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_storeware/index.dart';

//import 'charts_view.dart';
//import 'controls_view.dart';
import 'home_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Controls - Exemplos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return VerticalTabView(choices: [
      TabChoice(
          label: 'Home',
          child: const HomeView(
              //child: Text('xxxxx'),
              )),
      TabChoice(
        label: 'Opções',
        child: TabViewBottom(choices: [
          TabChoice(
            image: const Icon(Icons.lock_clock),
            //icon: LinearIcons.chart_bars,
            label: 'Op1',
          ),
          TabChoice(
            image: const Icon(Icons.chat_rounded),
            label: 'Op2',
          ),
        ]),
      ),
    ]);
  }
}
