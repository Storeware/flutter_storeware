import 'package:charts_flutter/flutter.dart' as charts;

/// Sample linear data type.
class ChartPair {
  final String title;
  final double value;
  final charts.Color color;
  ChartPair(this.title, this.value, {this.color});
}
