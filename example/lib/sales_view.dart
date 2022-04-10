// ignore_for_file: avoid_print

import 'package:controls_dash/controls_dash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_storeware/index.dart';

import 'dashboard_densed.dart';

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
          DashboardDensedTile(
            elevation: 10,
            title: const Text('BTC'),
            subtitle: const Text('Bitcoin'),
            value: '\$ 20.788',
            percent: '+0.25%',
            icon: const Icon(Icons.charging_station),
            child: DashLineChart(
              DashLineChart.createSerie(
                id: 'dashboard',
                data: [
                  ChartPairDouble(1, 5),
                  ChartPairDouble(2, 15),
                  ChartPairDouble(3, 8),
                  ChartPairDouble(4, 13),
                ],
              ),
              animate: false,
            ),
          ),
        ],
      ).singleChildScrollView(),
    );
  }
}
