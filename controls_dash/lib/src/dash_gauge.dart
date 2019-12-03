/// Gauge chart example, where the data does not cover a full revolution in the
/// chart.
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

import 'chart_pair.dart';

class DashGaugeChart extends StatelessWidget {
  final pi = 3.1415926535;
  final List<charts.Series> seriesList;
  final bool animate;
  final int arcWidth;
  final double arcLenght;
  DashGaugeChart(this.seriesList,
      {this.arcWidth = 40, this.arcLenght = 7 / 5 * 3.14, this.animate}) {}

  /// Creates a [PieChart] with sample data and no transition.
  static withSampleData() {
    return DashGaugeChart(
      createSerie(id: 'Vendas', data: [
        ChartPair('jan', 10),
        ChartPair('fev', 12),
        ChartPair('mar', 100),
        ChartPair('abr', 50),
        ChartPair('mai', 40),
      ]),

      // Disable animations for image tests.
      animate: false,
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<ChartPair, String>> createSerie(
      {String id, List<ChartPair> data}) {
    return [
      new charts.Series<ChartPair, String>(
        id: id,
        domainFn: (ChartPair sales, _) => sales.title,
        measureFn: (ChartPair sales, _) => sales.value,
        data: data,
        // Set a label accessor to control the text of the arc label.
        labelAccessorFn: (ChartPair row, _) => '${row.title}',
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(seriesList,
        animate: animate,
        // Configure the width of the pie slices to 30px. The remaining space in
        // the chart will be left as a hole in the center. Adjust the start
        // angle and the arc length of the pie so it resembles a gauge.
        //defaultRenderer: new charts.ArcRendererConfig(
        //    arcWidth: 30, startAngle: 4 / 5 * pi, arcLength: 7 / 5 * pi));

        defaultRenderer: new charts.ArcRendererConfig(
            arcWidth: arcWidth,
            startAngle: 4 / 5 * pi,
            arcLength: arcLenght,
            arcRendererDecorators: [
              new charts.ArcLabelDecorator(
                  labelPosition: charts.ArcLabelPosition.auto)
            ]));
  }
}
