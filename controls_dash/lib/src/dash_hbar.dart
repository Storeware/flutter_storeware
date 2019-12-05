/// Horizontal bar chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'chart_pair.dart';
import 'package:flutter/material.dart';

class DashHorizontalBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool vertical;
  final bool animate;

  DashHorizontalBarChart(this.seriesList,
      {this.vertical = false, this.animate});

  /// Creates a [BarChart] with sample data and no transition.
  factory DashHorizontalBarChart.withSampleData() {
    return new DashHorizontalBarChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    // For horizontal bar charts, set the [vertical] flag to false.
    return new charts.BarChart(
      seriesList,
      animate: animate,
      vertical: vertical,
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<ChartPair, String>> _createSampleData() {
    return createSerie(id: 'Vendas', data: [
      new ChartPair('2014', 5),
      new ChartPair('2015', 25),
      new ChartPair('2016', 100),
      new ChartPair('2017', 75),
    ]);
  }

  static List<charts.Series<ChartPair, String>> createSerie(
      {String id, List<ChartPair> data}) {
    return [
      new charts.Series<ChartPair, String>(
        id: id,
        domainFn: (ChartPair sales, _) => sales.title,
        measureFn: (ChartPair sales, _) => sales.value,
        data: data,
      )
    ];
  }
}
