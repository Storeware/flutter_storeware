import 'dart:math';

/// Horizontal bar chart example
import 'package:charts_flutter/src/text_element.dart' as ChartText;
import 'package:charts_flutter/src/text_style.dart' as ChartStyle;
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/flutter.dart';
import 'package:controls_dash/controls_dash.dart';
//import 'chart_pair.dart';
import 'package:flutter/material.dart';
//import 'package:charts_flutter/src/text_style.dart' as style;
//import 'package:charts_flutter/src/text_element.dart' as te;

class DashHorizontalBarChart extends StatefulWidget {
  final List<charts.Series> seriesList;
  final bool vertical;
  final bool animate;
  final bool showValues, showDomainAxis;
  final int barRadius;
  final bool showAxisLine;
  final bool showSeriesNames;
  final List<charts.SeriesRendererConfig<String>> customSeriesRenderers;
  final Function(ChartPair) onSelected;

  DashHorizontalBarChart(this.seriesList,
      {this.vertical = false,
      this.showValues = true,
      this.showSeriesNames = false,
      this.customSeriesRenderers,
      this.animate,
      this.barRadius = 15,
      this.onSelected,
      this.showAxisLine = true,
      this.showDomainAxis = true});

  /// Creates a [BarChart] with sample data and no transition.
  factory DashHorizontalBarChart.withSampleData() {
    return new DashHorizontalBarChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }
  @override
  _DashHorizontalBarChartState createState() => _DashHorizontalBarChartState();

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
      charts.Series<ChartPair, String>(
        id: id,
        domainFn: (ChartPair sales, _) => sales.title,
        measureFn: (ChartPair sales, _) => sales.value,
        data: data,
      )
    ];
  }
}

class _DashHorizontalBarChartState extends State<DashHorizontalBarChart> {
  String textSelected;

  _onSelectionChanged(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;
    if (selectedDatum.isNotEmpty) {
      ChartPair dados = selectedDatum.first.datum;
      textSelected = '${dados.value.toInt()}';
      if (widget.onSelected != null)
        widget.onSelected(dados);
      else
        setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // For horizontal bar charts, set the [vertical] flag to false.
    Size size = MediaQuery.of(context).size;
    final ch = charts.BarChart(widget.seriesList,
        animate: widget.animate,
        vertical: widget.vertical,

        //barRendererDecorator: ,
        selectionModels: [
          new charts.SelectionModelConfig(
            type: charts.SelectionModelType.info,
            changedListener: _onSelectionChanged,
          )
        ],
        customSeriesRenderers: widget.customSeriesRenderers,
        behaviors: (!widget.vertical)
            ? null
            : [
                new charts.LinePointHighlighter(
                    symbolRenderer: CustomCircleSymbolRenderer(
                        size: size, onGetValue: () => textSelected ?? '?')),
                new charts.SelectNearest(
                    eventTrigger: charts.SelectionTrigger.tapAndDrag),
                if (widget.showSeriesNames)
                  new charts.SeriesLegend(
                    // Positions for "start" and "end" will be left and right respectively
                    // for widgets with a build context that has directionality ltr.
                    // For rtl, "start" and "end" will be right and left respectively.
                    // Since this example has directionality of ltr, the legend is
                    // positioned on the right side of the chart.
                    position: charts.BehaviorPosition.bottom,
                    // By default, if the position of the chart is on the left or right of
                    // the chart, [horizontalFirst] is set to false. This means that the
                    // legend entries will grow as new rows first instead of a new column.
                    horizontalFirst: true,
                    // This defines the padding around each legend entry.
                    cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
                    // Set show measures to true to display measures in series legend,
                    // when the datum is selected.
                    showMeasures: true,
                    // Optionally provide a measure formatter to format the measure value.
                    // If none is specified the value is formatted as a decimal.
                    measureFormatter: (num value) {
                      return value == null ? '-' : '${value}';
                    },
                  ),
              ],
        defaultRenderer: new charts.BarRendererConfig(
            // By default, bar renderer will draw rounded bars with a constant
            // radius of 100.
            // To not have any rounded corners, use [NoCornerStrategy]
            // To change the radius of the bars, use [ConstCornerStrategy]

            cornerStrategy: charts.ConstCornerStrategy(widget.barRadius)),
        primaryMeasureAxis: (widget.showValues)
            ? null
            : new charts.NumericAxisSpec(
                renderSpec: new charts.NoneRenderSpec()),
        domainAxis: (widget.showDomainAxis)
            ? charts.OrdinalAxisSpec(
                showAxisLine: widget.showAxisLine,
              )
            : charts.OrdinalAxisSpec(renderSpec: new charts.NoneRenderSpec()));

    return ch;
  }
}

//---
class CustomCircleSymbolRenderer extends charts.CircleSymbolRenderer {
  final Size size;
  final String Function() onGetValue;

  CustomCircleSymbolRenderer({@required this.onGetValue, this.size});

  @override
  void paint(charts.ChartCanvas canvas, Rectangle bounds,
      {List dashPattern,
      charts.Color fillColor,
      charts.FillPatternType fillPattern,
      charts.Color strokeColor,
      double strokeWidthPx}) {
    super.paint(canvas, bounds,
        dashPattern: dashPattern,
        fillColor: fillColor,
        strokeColor: strokeColor,
        strokeWidthPx: strokeWidthPx);

    String text = onGetValue();

    ChartStyle.TextStyle textStyle = ChartStyle.TextStyle();

    textStyle.color = Color.black;
    textStyle.fontSize = 15;
    canvas.drawText(ChartText.TextElement(text, style: textStyle),
        (bounds.left).round() - 20, (bounds.top - 20).round());
  }
}
