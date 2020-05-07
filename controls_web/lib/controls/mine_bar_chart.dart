import 'package:flutter/material.dart';

class MiniBarChart extends StatefulWidget {
  final double width;
  final Color color;
  final Color barColor;
  final Map<String, num> data;
  final int decimais;
  final String prefix;
  final String labelPrefix;
  final double height;
  const MiniBarChart(
      {Key key,
      this.width,
      this.barColor = Colors.black,
      this.data,
      this.decimais = 0,
      this.height = 40,
      this.prefix = '',
      this.labelPrefix = '',
      this.color = Colors.lightBlue})
      : super(key: key);

  @override
  _MiniBarChartState createState() => _MiniBarChartState();
}

class _MiniBarChartState extends State<MiniBarChart> {
  num maxValue = 0;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    widget.data.keys.forEach((k) {
      var v = widget.data[k];
      if (v > maxValue) maxValue = v;
      count++;
    });

    return Container(
        alignment: Alignment.bottomCenter,
        color: widget.color,
        width: widget.width,
        height: widget.height,
        child: ListView(
          scrollDirection: Axis.horizontal,
          //mainAxisAlignment: MainAxisAlignment.start,
          children: [for (var key in widget.data.keys) createBar(key)],
        ));
  }

  createBar(key) {
    num value = widget.data[key];
    num w = (widget.width - (count * 2)) / count;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(left: 1, right: 1),
        child: Tooltip(
          message:
              '${widget.labelPrefix}$key: ${widget.prefix}${value.toStringAsFixed(widget.decimais)}',
          child: Container(
            alignment: Alignment.bottomCenter,
            color: widget.barColor,
            width: 5,
            height: (value / maxValue) * widget.height,
          ),
        ),
      ),
    );
  }
}
