import 'package:charts_flutter/flutter.dart' as charts;
import 'package:controls_dash/controls_dash.dart';
import 'package:flutter/material.dart';
//import 'package:charts_common/src/common/color.dart' as gcolor;

class PointsLineChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  final List<charts.SeriesRendererConfig> customSeriesRenderers;

  PointsLineChart(
    this.seriesList, {
    this.animate,
    this.customSeriesRenderers,
  });

  /// Creates a [LineChart] with sample data and no transition.
  factory PointsLineChart.withSampleData() {
    return new PointsLineChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.LineChart(
      seriesList,
      animate: animate,
      defaultRenderer: new charts.LineRendererConfig(includePoints: true),
      customSeriesRenderers: customSeriesRenderers,
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<ChartPairDouble, double>> _createSampleData() {
    final data = [
      new ChartPairDouble(0, 5),
      new ChartPairDouble(1, 25),
      new ChartPairDouble(2, 100),
      new ChartPairDouble(3, 75),
    ];

    return [
      new charts.Series<ChartPairDouble, double>(
        id: 'Sales',
        colorFn: (ChartPairDouble sales, __) =>
            sales.color ?? charts.MaterialPalette.blue.shadeDefault,
        domainFn: (ChartPairDouble sales, _) => sales.title,
        measureFn: (ChartPairDouble sales, _) => sales.value,
        data: data,
      )
    ];
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<ChartPairDouble, double>> createSerie({
    String id,
    List<ChartPairDouble> data,
  }) {
    return [
      new charts.Series<ChartPairDouble, double>(
        id: id,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (ChartPairDouble sales, idx) => sales.title,
        measureFn: (ChartPairDouble sales, _) => sales.value,
        data: data,
      )
    ];
  }
}
