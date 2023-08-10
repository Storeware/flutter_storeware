import 'dash_danut.dart';
import 'dash_pie.dart';

/// Gauge chart example, where the data does not cover a full revolution in the
/// chart.
import 'package:charts_flutter_new/flutter.dart' as charts;
import 'package:flutter/material.dart';

import 'chart_pair.dart';

class DashGaugeChart extends StatelessWidget {
  final pi = 3.1415926535;
  final List<charts.Series<dynamic, String>> seriesList;
  final bool? animate;
  final int arcWidth;
  final double arcLenght;
  final double startAngle;
  final String? label;
  final bool enableLabel;
  final Widget? bottom;
  DashGaugeChart(this.seriesList,
      {this.label,
      this.enableLabel = true,
      this.bottom,
      this.startAngle = 4 / 5 * 3.14,
      this.arcWidth = 40,
      this.arcLenght = 7 / 5 * 3.14,
      this.animate}) {}

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

  static odometro(
      {String? title, String? label, required double percent, Widget? bottom}) {
    return DashGaugeChart(
      createSerie(id: title ?? '', data: [
        ChartPair(label ?? '', percent),
        ChartPair(
          '',
          (100 - percent),
          //  color: charts.Color.fromHex(code: '#757575'),
        ),
        // ChartPair('', 50),
      ]),
      label: '$percent%',
      arcWidth: 35,
      //arcLenght: 3.14,
      //startAngle: 3.14,
      enableLabel: false,
      bottom: bottom,
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
        //colorFn: (ChartPair sales, _) => sales.color,
        data: data,
        // Set a label accessor to control the text of the arc label.
        labelAccessorFn: (ChartPair row, _) => '${row.title}',
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var b = size.height / 2;

    return Stack(children: [
      charts.PieChart(
        seriesList,
        animate: animate,
        // Configure the width of the pie slices to 30px. The remaining space in
        // the chart will be left as a hole in the center. Adjust the start
        // angle and the arc length of the pie so it resembles a gauge.
        defaultRenderer: new charts.ArcRendererConfig<Object>(
            arcWidth: arcWidth,
            startAngle: startAngle,
            arcLength: arcLenght,
            arcRendererDecorators: [
              if (enableLabel)
                charts.ArcLabelDecorator(
                    labelPosition: charts.ArcLabelPosition.auto)
            ]),
      ),
      Positioned(
          left: 20,
          right: 20,
          top: 20,
          bottom: 20,
          child: Center(
            child: Text(
              label ?? '',
            ),
          )),
      Positioned(
        child: bottom ?? Container(),
        bottom: 5,
        left: 5,
        right: 5,
      )
    ]);
  }
}
