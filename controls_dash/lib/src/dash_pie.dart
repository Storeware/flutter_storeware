/// Simple pie chart with outside labels example.
import 'package:charts_flutter_new/flutter.dart' as charts;
import 'chart_pair.dart';
import 'package:flutter/material.dart';

class DashPieChart extends StatelessWidget {
  final List<charts.Series<dynamic, String>> seriesList;
  final bool animate;

  DashPieChart(this.seriesList, {this.animate = true});

  /// Creates a [PieChart] with sample data and no transition.
  static withSampleData() {
    return DashPieChart(
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
      {required String id, required List<ChartPair> data}) {
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
    return new charts.PieChart(
      seriesList,
//        layoutConfig: charts.LayoutConfig(
//            leftMarginSpec: charts.MarginSpec.fixedPixel(150),
//            bottomMarginSpec: charts.MarginSpec.fixedPixel(50),
//            rightMarginSpec: charts.MarginSpec.fixedPixel(150),
//            topMarginSpec: charts.MarginSpec.fixedPixel(50)),
      animate: animate,
      // Add an [ArcLabelDecorator] configured to render labels outside of the
      // arc with a leader line.
      //
      // Text style for inside / outside can be controlled independently by
      // setting [insideLabelStyleSpec] and [outsideLabelStyleSpec].
      //
      // Example configuring different styles for inside/outside:
      //       new charts.ArcLabelDecorator(
      //          insideLabelStyleSpec: new charts.TextStyleSpec(...),
      //          outsideLabelStyleSpec: new charts.TextStyleSpec(...)),

      defaultRenderer: new charts.ArcRendererConfig<Object>(
//            arcWidth: arcWidth,
//            startAngle: 4 / 5 * pi,
//            arcLength: 7 / 5 * pi,
        arcRendererDecorators: [
          new charts.ArcLabelDecorator(
              labelPosition: charts.ArcLabelPosition.auto)
        ],
      ),
    );

//        defaultRenderer: new charts.ArcRendererConfig(arcRendererDecorators: [
//          new charts.ArcLabelDecorator(
//              labelPosition: charts.ArcLabelPosition.auto)
//        ]));
  }
}
