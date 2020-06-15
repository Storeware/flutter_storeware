import 'package:charts_flutter/flutter.dart' as charts;

/// Sample linear data type.
class ChartPair {
  final String title;
  final double value;
  final charts.Color color;
  ChartPair(this.title, this.value, {this.color});
}

class ChartPairInt {
  final int title;
  final double value;
  final charts.Color color;
  ChartPairInt(this.title, this.value, {this.color});
}

class ChartPairDouble {
  final double title;
  final double value;
  final charts.Color color;
  ChartPairDouble(this.title, this.value, {this.color});
}
