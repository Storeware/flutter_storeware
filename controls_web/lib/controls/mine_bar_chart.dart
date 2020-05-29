import 'package:flutter/material.dart';
import 'pacakge:controls_web/controls/overlay_container.dart';

class MiniBarChart extends StatefulWidget {
  final double width;
  final Color color;
  final Color barColor;
  final Map<String, num> data;
  final int decimais;
  final String prefix;
  final String labelPrefix;
  final double height;
  final bool showX;
  final double maxValue;
  const MiniBarChart(
      {Key key,
      this.width,
      this.barColor = Colors.black,
      this.data,
      this.decimais = 0,
      this.height = 40,
      this.prefix = '',
      this.labelPrefix = '',
      this.showX = false,
      this.maxValue,
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
    if (widget.maxValue != null) maxValue = widget.maxValue;

    return Container(
        alignment: Alignment.bottomCenter,
        color: widget.color,
        //width: widget.width,
        //height: widget.height,
        constraints: BoxConstraints(
          maxWidth: widget.width,
          maxHeight: widget.height,
        ),
        child: ListView(
          scrollDirection: Axis.horizontal,
          //mainAxisAlignment: MainAxisAlignment.start,
          children: [
            for (var index = 0; index < widget.data.keys.length; index++)
              createBar(index)
          ],
        ));
  }

  createBar(int index) {
    String key = widget.data.keys.toList()[index];
    num value = widget.data[key];
    num w = (widget.width - (count * 2)) / count;
    if (w > 8) w = 8;
    if (w < 2) w = 2;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
          padding: const EdgeInsets.only(left: 1, right: 1),
          child: Tooltip(
            message:
                '${widget.labelPrefix}$key: ${widget.prefix}${value.toStringAsFixed(widget.decimais)}',
            child: Container(
                height: widget.height + (widget.showX ? 15 : 0),
                child: Column(children: [
                  Spacer(),
                  Container(
                    alignment: Alignment.bottom,
                    color: widget.barColor,
                    width: w,
                    height: ((maxValue > 0) ? (value / maxValue) : 0) *
                        widget.height,
                  ),
                  if ((widget.showX) && ((index % 5) == 0))
                    OverlayContainer(
                        show: true,
                        position: OverlayContainerPosition.bottom,
                        child: Text(key, style: TextStyle(fontSize: 8))),
                ])),
          )),
    );
  }
}
