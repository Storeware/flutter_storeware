import 'package:charts_flutter/flutter.dart' as charts;
import 'package:controls_dash/controls_dash.dart';
import 'package:flutter/material.dart';
//import 'package:charts_common/src/common/color.dart' as gcolor;

class DashLineChart extends StatelessWidget {
  final List<charts.Series<dynamic, num>> seriesList;
  final bool? animate;
  final List<charts.SeriesRendererConfig<num>>? customSeriesRenderers;
  final bool showAxisLine;
  final bool showValues;
  final bool includePoints;
  final bool includeArea;
  final bool stacked;
  DashLineChart(
    this.seriesList, {
    this.animate,
    this.showAxisLine = true,
    this.showValues = true,
    this.includePoints = true,
    this.includeArea = false,
    this.stacked = false,
    this.customSeriesRenderers,
  });

  /// Creates a [LineChart] with sample data and no transition.
  factory DashLineChart.withSampleData() {
    return new DashLineChart(
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
      defaultRenderer: new charts.LineRendererConfig(
        includePoints: includePoints,
        includeArea: includeArea,
        stacked: stacked,
      ),
      customSeriesRenderers: customSeriesRenderers,
      primaryMeasureAxis: (showValues)
          ? null
          : charts.NumericAxisSpec(renderSpec: charts.NoneRenderSpec()),
      domainAxis: (showAxisLine)
          ? null
          : charts.NumericAxisSpec(
              showAxisLine: showAxisLine,
              renderSpec: new charts.NoneRenderSpec()),
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
    required String id,
    required List<ChartPairDouble> data,
    Color? color = Colors.blue,
  }) {
    return [
      new charts.Series<ChartPairDouble, double>(
        id: id,
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(color!),
        domainFn: (ChartPairDouble sales, idx) => sales.title,
        measureFn: (ChartPairDouble sales, _) => sales.value,
        data: data,
      )
    ];
  }
}
