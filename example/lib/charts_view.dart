import 'package:flutter/material.dart';
import 'package:controls_dash/controls_dash.dart';
import 'package:flutter_storeware/index.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:charts_flutter_new/flutter.dart' as charts;

class ChartsView extends StatefulWidget {
  const ChartsView({Key? key}) : super(key: key);

  @override
  State<ChartsView> createState() => _ChartsViewState();
}

class _ChartsViewState extends State<ChartsView> {
  @override
  void initState() {
    super.initState();
    initializeDateFormatting('pt_BR');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: VerticalTopTabView(
            //mainAxisSize: MainAxisSize.min,
            choices: [
          TabChoice(
            label: 'DashTimeline',
            builder: () {
              var c = DashTimeSeries(
                DashTimeSeries.createSerie(id: 'Vendas', data: [
                  TimeSeriesSales(
                    DateTime.now().add(const Duration(days: -10)),
                    10,
                    color: const charts.Color(b: 0, g: 0, r: 255),
                  ),
                  TimeSeriesSales(
                    DateTime.now().add(const Duration(days: -9)),
                    20,
                    color: const charts.Color(b: 0, g: 255, r: 0),
                  ),
                  TimeSeriesSales(
                      DateTime.now().add(const Duration(days: -8)), 5),
                  TimeSeriesSales(
                      DateTime.now().add(const Duration(days: -7)), 12),
                  TimeSeriesSales(
                      DateTime.now().add(const Duration(days: 0)), 7),
                ]),

                // Disable animations for image tests.
                animate: false,
              );
              return c;
            },
          ),
          TabChoice(
            label: 'DashPieChart',
            child: DashPieChart.withSampleData(),
          ),
          TabChoice(
            label: 'DashBarChart',
            child: DashBarChart.withSampleData(),
          ),
          TabChoice(
            label: 'DashhBarChart',
            child: DashHorizontalBarChart.withSampleData(),
          ),
          TabChoice(
            label: 'DashDanutChart',
            child: DashDanutChart.withSampleData(),
          ),
          TabChoice(
            label: 'DashGaugeChart',
            child: DashGaugeChart.withSampleData(),
          ),
          TabChoice(
            label: 'DashLineChart',
            child: DashLineChart.withSampleData(),
          ),
        ]));
  }
}
