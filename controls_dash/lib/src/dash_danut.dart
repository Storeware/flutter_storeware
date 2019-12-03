import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'chart_pair.dart';

class DashDanutChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  DashDanutChart(this.seriesList, {this.animate});

  /// Creates a [PieChart] with sample data and no transition.
  static withSampleData() {
    return DashDanutChart(
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
      {String id, List<ChartPair> data, bool showValues = false}) {
    return [
      new charts.Series<ChartPair, String>(
        id: id,
        domainFn: (ChartPair sales, _) => sales.title,
        measureFn: (ChartPair sales, _) => sales.value,
        data: data,
        // Set a label accessor to control the text of the arc label.
        labelAccessorFn: (ChartPair row, _) =>
            (showValues ? '${row.title}:${row.value}' : '${row.title}'),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(seriesList,
        animate: animate,
        // Configure the width of the pie slices to 60px. The remaining space in
        // the chart will be left as a hole in the center.
        //
        // [ArcLabelDecorator] will automatically position the label inside the
        // arc if the label will fit. If the label will not fit, it will draw
        // outside of the arc with a leader line. Labels can always display
        // inside or outside using [LabelPosition].
        //
        // Text style for inside / outside can be controlled independently by
        // setting [insideLabelStyleSpec] and [outsideLabelStyleSpec].
        //
        // Example configuring different styles for inside/outside:
        //       new charts.ArcLabelDecorator(
        //          insideLabelStyleSpec: new charts.TextStyleSpec(...),
        //          outsideLabelStyleSpec: new charts.TextStyleSpec(...)),
        defaultRenderer: new charts.ArcRendererConfig(
            arcWidth: 60,
            arcRendererDecorators: [new charts.ArcLabelDecorator()]));
  }
}
