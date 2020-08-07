/// Horizontal bar chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'chart_pair.dart';
import 'package:flutter/material.dart';

class DashHorizontalBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool vertical;
  final bool animate;
  final bool showValues, showDomainAxis;
  final int barRadius;
  final bool showAxisLine;
  final Function(ChartPair) onSelected;

  DashHorizontalBarChart(this.seriesList,
      {this.vertical = false,
      this.showValues = true,
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
  _onSelectionChanged(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;
    if (selectedDatum.isNotEmpty) {
      var dados = selectedDatum.first.datum;
      if (onSelected != null) onSelected(dados);
    }
  }

  @override
  Widget build(BuildContext context) {
    // For horizontal bar charts, set the [vertical] flag to false.
    return new charts.BarChart(seriesList,
        animate: animate,
        vertical: vertical,
        //barRendererDecorator: ,
        selectionModels: [
          new charts.SelectionModelConfig(
            type: charts.SelectionModelType.info,
            changedListener: _onSelectionChanged,
          )
        ],
        behaviors: [
          // Add this behavior to show initial hint animation that will pan to the
          // final desired viewport.
          // The duration of the animation can be adjusted by pass in
          // [hintDuration]. By default this is 3000ms.
          new charts.InitialHintBehavior(maxHintTranslate: 4.0),
          // Optionally add a pan or pan and zoom behavior.
          // If pan/zoom is not added, the viewport specified remains the viewport
          new charts.PanAndZoomBehavior(),
        ],
        defaultRenderer: new charts.BarRendererConfig(
            // By default, bar renderer will draw rounded bars with a constant
            // radius of 100.
            // To not have any rounded corners, use [NoCornerStrategy]
            // To change the radius of the bars, use [ConstCornerStrategy]

            cornerStrategy: charts.ConstCornerStrategy(barRadius)),
        primaryMeasureAxis: (showValues)
            ? null
            : new charts.NumericAxisSpec(
                renderSpec: new charts.NoneRenderSpec()),
        domainAxis: (showDomainAxis)
            ? charts.OrdinalAxisSpec(
                showAxisLine: showAxisLine,
              )
            : charts.OrdinalAxisSpec(renderSpec: new charts.NoneRenderSpec()));
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
      charts.Series<ChartPair, String>(
        id: id,
        domainFn: (ChartPair sales, _) => sales.title,
        measureFn: (ChartPair sales, _) => sales.value,
        data: data,
      )
    ];
  }
}
