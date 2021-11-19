import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart' as m show Color;

enum DashSeriesType { bar, line }

/// Sample linear data type.
class ChartPair {
  dynamic? key;
  String title;
  num value;
  String? tooltip;
  charts.Color? color;
  ChartPair(this.title, this.value, {this.key, this.color, this.tooltip});
  toJson() {
    return {
      "key": key,
      "title": title,
      "value": value,
      "tooltip": tooltip,
      "color": color
    };
  }

  static charts.Color fromColor(m.Color color) =>
      charts.ColorUtil.fromDartColor(color);

  static toColor(charts.Color color) => charts.ColorUtil.toDartColor(color);
}

class ChartPairInt {
  final int title;
  final num value;
  final charts.Color? color;
  ChartPairInt(this.title, this.value, {this.color});
}

class ChartPairDouble {
  final double title;
  final num value;
  final charts.Color? color;
  ChartPairDouble(this.title, this.value, {this.color});
}
