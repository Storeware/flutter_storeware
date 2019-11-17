import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartTitle {
  double x;
  String title;
  LineChartTitle({this.x, this.title});
}

class LineChartItem {
  double x;
  double y;
  LineChartItem(this.x, this.y);
}

List<Color> _colors = [Colors.red, Colors.amber, Colors.blue, Colors.cyan];

class LineChartBar {
  final List<LineChartItem> values = [];
  Color color;
  String name;
  LineChartBar(double y, {this.color, this.name}) {
    add(y);
  }
  LineChartBar add(double y) {
    values.add(LineChartItem(values.length.toDouble(), y));
    return this;
  }
}

class LineChartBars {
  List<LineChartBar> items = [];
  LineChartBars();
  LineChartBars add(LineChartBar bar, {String name}) {
    if (bar.color == null) {
      int x = items.length % _colors.length;
      bar.color = _colors[x];
    }
    if (name != null) bar.name = name;
    items.add(bar);
    return this;
  }

  double maxY() {
    double r = -9999999;
    for (var b = 0; b < items.length; b++) {
      for (var i = 0; i < items[b].values.length; i++)
        if (items[b].values[i].y > r) r = items[b].values[i].y;
    }
    return r;
  }

  double maxX() {
    double r = -9999999;
    for (var b = 0; b < items.length; b++) {
      for (var i = 0; i < items[b].values.length; i++)
        if (items[b].values[i].x > r) r = items[b].values[i].x;
    }
    return r;
  }

  double lengthMax() {
    double r = 1;
    for (var b = 0; b < items.length; b++) {
      if (items[b].values.length > r) r = items[b].values.length.toDouble();
    }
    return r;
  }
}

class LineChartView extends StatefulWidget {
  final String title;
  final Color titleColor;
  final String subTitle;
  final Color subTitleColor;
  final LineChartBars bars;
  final bool gridLine;
  final double barWidth;
  final bool fillArea;
  List<LineChartTitle> xTitles;
  List<LineChartTitle> yTitles;
  final Gradient gradient;
  final Color gradientColor1;
  final Color gradientColor2;
  final double curveSmoothness;
  final Color labelXColor;
  final Color labelYColor;
  LineChartView(
      {this.title,
      this.titleColor,
      this.subTitle,
      this.subTitleColor,
      this.xTitles,
      this.yTitles,
      this.labelXColor,
      this.labelYColor,
      @required this.bars,
      this.gradient,
      this.gradientColor1,
      this.gradientColor2,
      this.barWidth = 2,
      this.curveSmoothness = 0.35,
      this.fillArea = false,
      this.gridLine = false});
  @override
  State<StatefulWidget> createState() => LineChartViewState();
}

class LineChartViewState extends State<LineChartView> {
  StreamController<LineTouchResponse> controller;
  @override
  void initState() {
    super.initState();

    controller = StreamController();
    controller.stream.distinct().listen((LineTouchResponse response) {});
  }

  double maxX() {
    double r = 0;
    for (var x = 0; x < widget.xTitles.length; x++) {
      if (widget.xTitles[x].x != null) if (widget.xTitles[x].x > r)
        r = widget.xTitles[x].x;
    }
    return r;
  }

  double maxY() {
    double r = 0;
    for (var x = 0; x < widget.yTitles.length; x++) {
      if (widget.yTitles[x].x != null) if (widget.yTitles[x].x > r)
        r = widget.yTitles[x].x;
    }
    return r;
  }

  checkYTitle() {
    if (widget.yTitles == null) {
      widget.yTitles = [];
      double mx = widget.bars.maxY();
      int x = (mx ~/ 5);
      int k = -x;
      while (k < (mx + x)) {
        k += x;
        widget.yTitles
            .add(LineChartTitle(x: k.toDouble(), title: k.toString()));
      }
      //k += x;
      //widget.yTitles.add(LineChartTitle(x: k.toDouble(), title: k.toString()));
    }
  }

  checkXTitle() {
    if (widget.xTitles == null) {
      widget.xTitles = [];
      double mx = widget.bars.lengthMax();
      int x = (mx ~/ 5);
      int k = -x;
      while (k < (mx + x)) {
        k += x;
        widget.xTitles
            .add(LineChartTitle(x: k.toDouble(), title: k.toString()));
      }
      //k += x;
      //widget.xTitles.add(LineChartTitle(x: k.toDouble(), title: k.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    checkYTitle();
    checkXTitle();
    return AspectRatio(
      aspectRatio: 1.23,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(18)),
            gradient: widget.gradient ??
                LinearGradient(
                  colors: [
                    widget.gradientColor1 ?? Color(0xff2c274c),
                    widget.gradientColor2 ?? Color(0xff46426c),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: widget.title == null ? 0 : 8,
            ),
            Text(
              widget.title ?? '',
              style: TextStyle(
                  color: widget.titleColor ?? Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: widget.subTitle == null ? 0 : 1,
            ),
            Text(
              widget.subTitle ?? '',
              style: TextStyle(
                color: widget.subTitleColor ?? Color(0xff827daa),
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 1,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 25.0, left: 6.0),
                child: FlChart(
                  chart: LineChart(
                    LineChartData(
                      lineTouchData: LineTouchData(
                          touchResponseSink: controller.sink,
                          touchTooltipData: TouchTooltipData(
                            tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
                          )),
                      gridData: FlGridData(
                        //show: !widget.horizontalLine,
                        drawHorizontalGrid: widget.gridLine,
                      ),
                      titlesData: FlTitlesData(
                        bottomTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 22,
                          textStyle: TextStyle(
                            color:
                                widget.labelXColor ?? const Color(0xff72719b),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          margin: 10,
                          getTitles: (value) {
                            for (var x = 0; x < widget.xTitles.length; x++) {
                              if (widget.xTitles[x].x == value)
                                return widget.xTitles[x].title;
                            }
                            return '';
                          },
                        ),
                        leftTitles: SideTitles(
                          showTitles: true,
                          textStyle: TextStyle(
                            color: widget.labelYColor ?? Color(0xff75729e),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          getTitles: (value) {
                            for (var x = 0; x < widget.yTitles.length; x++) {
                              if (widget.yTitles[x].x == value)
                                return widget.yTitles[x].title;
                            }
                            return '';
                          },
                          margin: 8,
                          reservedSize: 30,
                        ),
                      ),
                      borderData: FlBorderData(
                          show: true,
                          border: Border(
                            bottom: BorderSide(
                              color: Color(0xff4e4965),
                              width: 4,
                            ),
                            left: BorderSide(
                              color: Colors.transparent,
                            ),
                            right: BorderSide(
                              color: Colors.transparent,
                            ),
                            top: BorderSide(
                              color: Colors.transparent,
                            ),
                          )),
                      minX: 0,
                      maxX: widget.bars.maxX(),
                      maxY: widget.bars.maxY(),
                      minY: 0,
                      lineBarsData: [
                        for (var bar in widget.bars.items)
                          LineChartBarData(
                            spots: [
                              for (var it in bar.values) FlSpot(it.x, it.y),
                            ],
                            isCurved: true,
                            colors: [
                              bar.color,
                            ],
                            curveSmoothness: widget.curveSmoothness,
                            preventCurveOverShooting: false,
                            barWidth: widget.barWidth,
                            isStrokeCapRound: true,
                            dotData: FlDotData(
                              show: false,
                            ),
                            belowBarData: BelowBarData(
                              show: widget.fillArea,
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.close();
  }
}
