// ignore_for_file: avoid_print

import 'package:controls_dash/controls_dash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_storeware/index.dart';

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DashboardDensedTile(
                elevation: 10,
                title: const Text('BTC'),
                subtitle: const Text('Bitcoin'),
                value: const Text('\$ 20.788'),
                percent: const Text('+0.25%',
                    style: TextStyle(
                      color: Colors.green,
                    )),
                icon: const CircleAvatar(child: Icon(Icons.charging_station)),
                child: DashLineChart(
                  DashLineChart.createSerie(
                    id: 'dashboard',
                    color: Colors.indigo,
                    data: [
                      ChartPairDouble(1, 5),
                      ChartPairDouble(2, 15),
                      ChartPairDouble(3, 8),
                      ChartPairDouble(4, 13),
                      ChartPairDouble(5, 13),
                      ChartPairDouble(6, 11),
                    ],
                  ),
                  animate: true,
                  showAxisLine: false,
                  showValues: false,
                  includePoints: false,
                  includeArea: true,
                  stacked: true,
                ),
                onPressed: () {
                  Dialogs.info(context, text: 'DashboardDensedTile.onPressed');
                },
              ),
              DashboardDensedTile(
                icon: const CircleAvatar(
                    child: Text('USD'), backgroundColor: Colors.green),
                title: const Text('Dolar'),
                subtitle: const Text('BRL / USD'),
                value: const Text('\$ 4,65'),
                percent: const Text('-0.25%',
                    style: TextStyle(
                      color: Colors.red,
                    )),
                child: DashDanutChart(
                  DashDanutChart.createSerie(
                    id: 'id',
                    data: [
                      ChartPair('Seg', 5),
                      ChartPair('Ter', 15),
                      ChartPair('Qua', 8),
                      ChartPair('Qui', 13),
                    ],
                  ),
                  showMeasures: true,
                ),
              ),
            ],
          ),
        ],
      ).singleChildScrollView(),
    );
  }
}
