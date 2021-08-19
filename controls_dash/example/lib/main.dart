import 'package:flutter/material.dart';
import 'package:controls_dash/controls_dash.dart';
import 'package:intl/intl.dart';

import 'package:localization/localization.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  // Intl('pt_BR');
  // Intl.defaultLocale = 'pt_BR';
  initializeDateFormatting('pt_BR');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: LocalizationWidget(
        child: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Title ${widget.title}'),
      ),
      body: GridView.count(crossAxisCount: 4, children: [
        Text('DashPieChart'),
        Container(
          width: 200,
          height: 100,
          child: DashPieChart.withSampleData(),
        ),
        Text('DashBarChart'),
        Container(
          //   width: 200,
          height: 100,
          child: DashBarChart.withSampleData(),
        ),
        Text('DashhBarChart'),
        Container(
          //   width: 200,
          height: 100,
          child: DashHorizontalBarChart.withSampleData(),
        ),
        Text('DashDanutChart'),
        Container(
          //width: 150,
          //height: 150,
          child: DashDanutChart.withSampleData(),
        ),
        Text('DashGaugeChart'),
        Container(
          height: 100,
          child: DashGaugeChart.withSampleData(),
        ),
        Text('DashTimeline'),
        DashTimeSeries.withSampleData(),
        Text('DashLineChart'),
        DashLineChart.withSampleData(),
      ]),
    ); // This trailing comma makes auto-formatting nicer for build methods.
    //);
  }
}
