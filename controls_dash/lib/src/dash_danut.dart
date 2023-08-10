// ignore_for_file: must_be_immutable

import 'package:charts_flutter_new/flutter.dart' as charts;
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
  final TextStyle? entryTextStyle;
  final charts.ArcRendererConfig<Object>? defaultRenderer;
  final Widget? body;

  DashDanutChart(
    this.seriesList, {
    this.arcWidth = 60,
    this.animate,
    this.showLabels = false,
    this.showMeasures = false,
    this.onPressed,
    this.body,
    this.entryTextStyle,
    this.defaultRenderer,
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
  static List<charts.Series<ChartPair, String>> createSerie({
    required String id,
    required List<ChartPair> data,
    Color color = Colors.blue,
    bool showLabel = true,
    bool showMeasure = false,
    TextStyle? style,
    bool overlaySeries = false,
  }) {
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
        labelAccessorFn: (ChartPair row, _) {
          if (showLabel && showMeasure) return '${row.title}\n${row.value}';
          if (showLabel && !showMeasure) return '${row.title}';
          if (showMeasure) return '${row.value}';
          return '';
        },
        overlaySeries: overlaySeries,
        insideLabelStyleAccessorFn:
            (style == null) ? null : (a, b) => getStyle(style),
      )
    ];
  }

  addSerie(serie) => seriesList.add(serie);

  _onSelectionChanged(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;
    if (selectedDatum.isEmpty) return;
    if (onPressed != null)
      onPressed!(selectedDatum.first.index!, selectedDatum.first.datum);
  }

  late TextStyle ts;
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    ts = entryTextStyle ?? theme.textTheme.bodyText2!.copyWith(fontSize: 11);
    //TextStyle(fontFamily: 'Giorgia', fontSize: 11, color: Colors.black87);
    return Stack(children: [
      charts.PieChart<Object>(
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
            charts.DatumLegend(
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

              desiredMaxRows: 2,
              // Configure the measure value to be shown by default in the legend.
              legendDefaultMeasure: charts.LegendDefaultMeasure.firstValue,
              // Optionally provide a measure formatter to format the measure value.
              // If none is specified the value is formatted as a decimal.
              measureFormatter: (num? value) {
                return value == null ? '-' : '$value';
              },

              //entryTextStyle: getStyle(),
            )
        ],
        defaultRenderer: defaultRenderer ??
            charts.ArcRendererConfig<Object>(
              arcWidth: arcWidth,
              arcRendererDecorators: [
                if (showMeasures || showLabels)
                  charts.ArcLabelDecorator(
                      insideLabelStyleSpec: getStyle(ts),
                      labelPosition: charts.ArcLabelPosition.inside),
              ],
            ),
      ),
      if (body != null) Center(child: body!)
    ]);
  }

  static getStyle(ts) => charts.TextStyleSpec(
        color: ChartPair.fromColor(ts.color ?? Colors.black54),
        fontFamily: ts.fontFamily ?? 'Giorgia',
        fontSize: (ts.fontSize ?? 11) ~/ 1,
        // fontWeight: '${(ts.fontWeight ?? 400)}',
      );
}
