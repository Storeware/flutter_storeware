import 'package:charts_flutter/flutter.dart' as charts;
import 'package:controls_dash/controls_dash.dart';
import 'package:flutter/material.dart';
import 'package:charts_common/src/common/color.dart' as gcolor;

class DashDanutChart extends StatelessWidget {
  final List<charts.Series<dynamic, String>> seriesList;
  final int arcWidth;
  final bool? animate;
  final bool showLabels;
  final bool showMeasures;
  final Function(int, ChartPair)? onPressed;

  DashDanutChart(
    this.seriesList, {
    this.arcWidth = 60,
    this.animate,
    this.showLabels = false,
    this.showMeasures = false,
    this.onPressed,
  });

  /// Creates a [PieChart] with sample data and no transition.
  static withSampleData() {
    return DashDanutChart(
      createSerie(id: 'Vendas', data: [
        ChartPair('jan', 10),
        ChartPair('fev', 12),
        ChartPair('mar', 80),
        ChartPair('abr', 50),
        ChartPair('mai', 40),
      ]),
      // Disable animations for image tests.
      animate: false,
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<ChartPair, String>> createSerie(
      {required String id,
      required List<ChartPair> data,
      Color color = Colors.blue,
      bool showLabel = true}) {
    var r = color.red;
    var g = color.green;
    var b = color.blue;
    var x = 255 ~/ (data.length + 1);
    return [
      new charts.Series<ChartPair, String>(
        id: id,
        domainFn: (ChartPair sales, _) => sales.title,
        measureFn: (ChartPair sales, _) => sales.value,
        data: data,
        colorFn: (p, i) {
          // debugPrint('$p $i');
          return (p.color != null)
              ? p.color!
              : gcolor.Color(r: r, g: g, b: g, a: 255 - (i! * x));
        },
        // colorFn: (p, i) => gcolor.Color(r: r, g: g, b: g, a: 255 - (i! * x)),
        labelAccessorFn: (ChartPair row, _) =>
            '${(showLabel) ? row.title : row.value}',
      )
    ];
  }

  _onSelectionChanged(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;
    if (selectedDatum.isEmpty) return;
    if (onPressed != null)
      onPressed!(selectedDatum.first.index!, selectedDatum.first.datum);
  }

  @override
  Widget build(BuildContext context) {
    return new charts.PieChart<Object>(
      seriesList,
      animate: animate,
      selectionModels: [
        new charts.SelectionModelConfig(
          type: charts.SelectionModelType.info,
          changedListener: _onSelectionChanged,
        )
      ],
      behaviors: [
        if (showLabels)
          new charts.DatumLegend(
            // Positions for "start" and "end" will be left and right respectively
            // for widgets with a build context that has directionality ltr.
            // For rtl, "start" and "end" will be right and left respectively.
            // Since this example has directionality of ltr, the legend is
            // positioned on the right side of the chart.
            position: charts.BehaviorPosition.end,
            // By default, if the position of the chart is on the left or right of
            // the chart, [horizontalFirst] is set to false. This means that the
            // legend entries will grow as new rows first instead of a new column.
            horizontalFirst: false,
            // This defines the padding around each legend entry.
            cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
            // Set [showMeasures] to true to display measures in series legend.
            showMeasures: showMeasures,
            // Configure the measure value to be shown by default in the legend.
            legendDefaultMeasure: charts.LegendDefaultMeasure.firstValue,
            // Optionally provide a measure formatter to format the measure value.
            // If none is specified the value is formatted as a decimal.
            measureFormatter: (num? value) {
              return value == null ? '-' : '$value';
            },
          ),
      ],
      defaultRenderer: new charts.ArcRendererConfig<Object>(
          arcWidth: arcWidth,
          arcRendererDecorators: [
            //if (!showMeasures)
            new charts.ArcLabelDecorator(),
            if (showMeasures)
              new charts.ArcLabelDecorator(
                  labelPosition: charts.ArcLabelPosition.inside),
          ]),
    );
  }
}
