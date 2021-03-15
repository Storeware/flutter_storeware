import 'package:controls_dash/controls_dash.dart';
import 'package:flutter/material.dart';

class MainView extends StatefulWidget {
  MainView({Key? key}) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('teste')),
      body: Wrap(
        children: [
          Text('teste'),
          Container(
            width: 200,
            height: 200,
            child: DashBarChart.withSampleData(),
          ),
          Container(
            width: 200,
            height: 200,
            child: DashPieChart.withSampleData(),
          ),
          Container(
            width: 200,
            height: 200,
            child: DashDanutChart.withSampleData(),
          ),
          Container(
            width: 200,
            height: 200,
            child: DashHorizontalBarChart.withSampleData(),
          ),
          Container(
            width: 200,
            height: 200,
            child: DashGaugeChart.withSampleData(),
          ),
        ],
        //crossAxisCount: 3,
      ),
      //body: Container(),
    );
  }
}
