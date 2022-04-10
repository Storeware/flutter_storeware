// ignore_for_file: avoid_print

import 'package:controls_dash/controls_dash.dart';
import 'package:exemple/dashboard_barchart_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_storeware/index.dart';

import 'dashboard_filter.dart';

class SalesView extends StatelessWidget {
  const SalesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          DashboardFilter(
            width: 310,
            height: 150,
            elevation: 10,
            //color: Colors.amber,
            title: const Text('DashboardFilter Overview'),
            filter: const ['Mensal', 'Anual', 'Diário', 'Semanal'],
            filterIndex: 1,
            onFilterChanged: (index) {
              print('onFilterChanged: $index');
            },
            child: DashHorizontalBarChart(
              DashHorizontalBarChart.createSerie(
                id: 'dashboard',
                data: [
                  ChartPair('Seg', 5),
                  ChartPair('Ter', 15),
                  ChartPair('Qua', 8),
                  ChartPair('Qui', 13),
                  ChartPair('Sex', 9),
                  ChartPair('Sab', 20),
                  ChartPair('Dom', 5),
                ],
              ),
              showSeriesNames: false,
              vertical: true,
              showAxisLine: false,
              showValues: true,
              showDomainAxis: true,
              animate: false,
              onSelected: (p) {
                return p.value;
              },
              barRadius: 10,
            ),
          ),
          DashboardFilter(
              width: 310,
              elevation: 10,
              title: const Text('DashboardFilter Overview'),
              filter: const ['seg', 'ter', 'qua', 'qui', 'sex'],
              child: DashLineChart.withSampleData()),
        ],
      ).singleChildScrollView(),
    );
  }
}
