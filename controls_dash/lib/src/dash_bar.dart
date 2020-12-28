/// Bar chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'chart_pair.dart';
import 'package:flutter/material.dart';

class DashBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  final bool vertical;
  final bool showSeriesNames;
  final DashSeriesType rendererType;

  final List<charts.SeriesRendererConfig<String>> customSeriesRenderers = [];
  DashBarChart(
    this.seriesList, {
    this.showSeriesNames = false,
    this.vertical = true,
    this.animate,
    this.rendererType = DashSeriesType.bar,
    List<charts.SeriesRendererConfig<String>> customSeriesRenderers,
  }) {
    if (customSeriesRenderers != null)
      this.customSeriesRenderers.addAll(customSeriesRenderers);
  }

  /// Creates a [BarChart] with sample data and no transition.
  factory DashBarChart.withSampleData() {
    return new DashBarChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  addSerie({
    String id,
    List<ChartPair> data,
    String rendererId,
    int strokeWidth = 1,
    DashSeriesType rendererType,
    bool includeArea = false,
  }) {
    final s = createSerie(
      id: id,
      data: data,
      strokeWidth: strokeWidth,
    )[0];
    s.setAttribute(charts.rendererIdKey, rendererId ?? id);
    seriesList.add(s);
    if (rendererType != null) {
      addSerieRenderer(createRenderer(rendererType,
          rendererId: rendererId, includeArea: includeArea));
    }
    return s;
  }

  addSerieRenderer(charts.SeriesRendererConfig<String> renderer) =>
      customSeriesRenderers.add(renderer);

  createRenderer(type, {String rendererId, bool includeArea = false}) {
    var r;
    switch (type) {
      case DashSeriesType.bar:
        r = charts.BarRendererConfig<String>(
          customRendererId: rendererId,
        );
        break;
      default:
        r = charts.LineRendererConfig<String>(
          customRendererId: rendererId,
          includeArea: includeArea,
        );
    }
    ;

    return r;
  }

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      defaultRenderer: createRenderer(rendererType),
      animate: animate,
      vertical: vertical,
      behaviors: [
        new charts.SelectNearest(),
        new charts.DomainHighlighter(),
        if (showSeriesNames)
          charts.SeriesLegend(
            position: charts.BehaviorPosition.bottom,
          ),
      ],
      customSeriesRenderers: customSeriesRenderers,
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<ChartPair, String>> _createSampleData() {
    return createSerie(id: 'vendas', data: [
      new ChartPair('2014', 5),
      new ChartPair('2015', 25),
      new ChartPair('2016', 100),
      new ChartPair('2017', 75),
    ]);
  }

  static List<charts.Series<ChartPair, String>> createSerie({
    String id,
    List<ChartPair> data,
    int strokeWidth = 1,
  }) {
    return [
      new charts.Series<ChartPair, String>(
        id: id,
        colorFn: (ChartPair sales, __) =>
            sales.color ?? charts.MaterialPalette.blue.shadeDefault,
        domainFn: (ChartPair sales, _) => sales.title,
        measureFn: (ChartPair sales, _) => sales.value,
        data: data,
        strokeWidthPxFn: (sales, idx) => strokeWidth,
      )
    ];
  }
}
