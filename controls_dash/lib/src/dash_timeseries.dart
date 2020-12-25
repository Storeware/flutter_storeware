/// Example of a time series chart using a bar renderer.
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Sample time series data type.
class TimeSeriesSales {
  final DateTime time;
  final num sales;
  final charts.Color color;

  TimeSeriesSales(this.time, this.sales, {this.color});
}

enum DashTimeSeriesType { bar, line }

class DashTimeSeries extends StatelessWidget {
  final List<charts.Series<TimeSeriesSales, DateTime>> seriesList;
  final bool animate;
  final bool showSeriesNames;
  final DashTimeSeriesType rendererType;
  final List<charts.SeriesRendererConfig<DateTime>> customSeriesRenderers = [];
  final bool includeArea;
  final bool stacked;
  final String dateFormat;
  final int labelRotation;
  final bool includeLine;
  DashTimeSeries(this.seriesList,
      {this.animate,
      this.rendererType = DashTimeSeriesType.line,
      this.includeArea = false,
      this.stacked = false,
      this.dateFormat = 'dd/MMM',
      this.labelRotation = 0,
      this.includeLine = true,
      List<charts.SeriesRendererConfig<DateTime>> customSeriesRenderers,
      this.showSeriesNames = false}) {
    if (customSeriesRenderers != null)
      this.customSeriesRenderers.addAll(customSeriesRenderers);
  }

  addSerie({
    String id,
    List<TimeSeriesSales> data,
    String rendererId,
    num strokeWidth = 1,
    DashTimeSeriesType rendererType,
  }) {
    final s = createSerie(id: id, data: data, strokeWidth: strokeWidth)[0];
    s.setAttribute(charts.rendererIdKey, rendererId ?? id);
    seriesList.add(s);
    if (rendererType != null) {
      switch (rendererType) {
        case DashTimeSeriesType.bar:
          addSerieRenderer(
              charts.BarRendererConfig<DateTime>(customRendererId: rendererId));
          break;
        default:
          addSerieRenderer(charts.LineRendererConfig<DateTime>(
              customRendererId: rendererId));
      }
    }
    return s;
  }

  addSerieRenderer(charts.SeriesRendererConfig<DateTime> renderer) =>
      customSeriesRenderers.add(renderer);

  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      // Set the default renderer to a bar renderer.
      // This can also be one of the custom renderers of the time series chart.
      defaultRenderer: (rendererType == DashTimeSeriesType.line)
          ? charts.LineRendererConfig<DateTime>(
              includeArea: includeArea,
              stacked: stacked,
              includeLine: includeLine,
            )
          : charts.BarRendererConfig<DateTime>(),
      customSeriesRenderers: customSeriesRenderers,
      // It is recommended that default interactions be turned off if using bar
      // renderer, because the line point highlighter is the default for time
      // series chart.
      defaultInteractions: false,
      // If default interactions were removed, optionally add select nearest
      // and the domain highlighter that are typical for bar charts.
      behaviors: [
        new charts.SelectNearest(),
        new charts.DomainHighlighter(),
        if (showSeriesNames)
          charts.SeriesLegend(
            position: charts.BehaviorPosition.bottom,
          ),
      ],
      dateTimeFactory:
          LocalizedDateTimeFactory(Localizations.localeOf(context)),
      primaryMeasureAxis: charts.NumericAxisSpec(
          tickProviderSpec:
              charts.BasicNumericTickProviderSpec(zeroBound: false)),
      domainAxis: charts.DateTimeAxisSpec(
          renderSpec: charts.SmallTickRendererSpec(
              minimumPaddingBetweenLabelsPx: 4,
              labelAnchor: charts.TickLabelAnchor.centered,
              labelStyle: charts.TextStyleSpec(
                fontSize: 10,
                color: charts.MaterialPalette.black,
              ),
              labelRotation: labelRotation,
              // Change the line colors to match text color.
              lineStyle:
                  charts.LineStyleSpec(color: charts.MaterialPalette.white)),
          tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
              day: charts.TimeFormatterSpec(
            format: dateFormat,
            transitionFormat: dateFormat,
          ))),
    );
  }

  static List<charts.Series<TimeSeriesSales, DateTime>> createSerie(
      {String id, List<TimeSeriesSales> data, num strokeWidth = 1}) {
    return [
      new charts.Series<TimeSeriesSales, DateTime>(
        id: id,
        colorFn: (TimeSeriesSales sales, __) =>
            sales.color ?? charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        strokeWidthPxFn: (sales, idx) => strokeWidth,
        data: data,
      )
    ];
  }
}

class LocalizedDateTimeFactory extends charts.LocalDateTimeFactory {
  final Locale locale;

  @override
  DateFormat createDateFormat(String pattern) {
    return DateFormat(pattern, locale.languageCode);
  }

  LocalizedDateTimeFactory(this.locale);
}
