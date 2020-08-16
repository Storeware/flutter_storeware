import 'package:charts_flutter/flutter.dart' as charts;

/// Sample linear data type.
class ChartPair {
  final String title;
  final num value;
  final String tooltip;
  final charts.Color color;
  ChartPair(this.title, this.value, {this.color, this.tooltip});
}

class ChartPairInt {
  final int title;
  final num value;
  final charts.Color color;
  ChartPairInt(this.title, this.value, {this.color});
}

class ChartPairDouble {
  final double title;
  final num value;
  final charts.Color color;
  ChartPairDouble(this.title, this.value, {this.color});
}
