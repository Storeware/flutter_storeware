import 'package:flutter/material.dart';
import 'package:controls_web/controls/overlay_container.dart';

class MiniBarChart extends StatefulWidget {
  final double width;
  final Color color;
  final Widget leading;
  final Color barColor;
  final Map<String, num> data;
  final int decimais;
  final String prefix;
  final String labelPrefix;
  final double height;
  final bool showX;
  final double heightX;
  final double maxValue;
  final double left;
  final double right;
  final double gap;
  const MiniBarChart(
      {Key key,
      this.width,
      this.leading,
      this.barColor = Colors.black,
      this.data,
      this.left = 1.0,
      this.gap = 1.5,
      this.right = 1.0,
      this.decimais = 0,
      this.height = 40.0,
      this.prefix = '',
      this.labelPrefix = '',
      this.showX = false,
      this.heightX = 8.0,
      this.maxValue,
      this.color = Colors.lightBlue})
      : super(key: key);

  @override
  _MiniBarChartState createState() => _MiniBarChartState();
}

class _MiniBarChartState extends State<MiniBarChart> {
  num maxValue = 0.0;
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
        padding: EdgeInsets.only(left: widget.left, right: widget.right),
        alignment: Alignment.bottomCenter,
        color: widget.color,
        //width: widget.width,
        //height: widget.height,
        constraints: BoxConstraints(
          maxWidth: widget.width,
          maxHeight: widget.height,
        ),
        child: LayoutBuilder(builder: (x, y) {
          return Stack(children: [
            if (widget.leading != null) widget.leading,
            ListView(
              scrollDirection: Axis.horizontal,
              //mainAxisAlignment: MainAxisAlignment.start,
              children: [
                for (var index = 0; index < widget.data.keys.length; index++)
                  createBar(index, y.maxWidth, widget.data.keys.length)
              ],
            )
          ]);
        }));
  }

  createBar(int index, double width, int n) {
    String key = widget.data.keys.toList()[index];
    num value = widget.data[key];
    num w = (width - (n * widget.gap) - widget.left ?? 0 - widget.right ?? 0) /
        count;
    if (w > 8) w = 8;
    if (w < 1) w = 1;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
          padding: EdgeInsets.only(left: widget.gap / 2, right: widget.gap / 2),
          child: Tooltip(
            message:
                '${widget.labelPrefix}$key: ${widget.prefix}${value.toStringAsFixed(widget.decimais)}',
            child: Container(
                //height: widget.height + (widget.showX ? 15 : 0),
                child: Column(children: [
              Spacer(),
              Container(
                alignment: Alignment.bottomCenter,
                color: widget.barColor,
                width: w,
                height: ((maxValue > 0) ? (value / maxValue) : 0) *
                    (widget.height - (widget.showX ? widget.heightX : 0)),
              ),
              if (widget.showX)
                Container(
                    height: widget.heightX,
                    //    show: true,
                    //    position: OverlayContainerPosition(0, 0),
                    child: (index % 5) != 0
                        ? null
                        : Text(key,
                            style: TextStyle(
                              fontSize: widget.heightX,
                              backgroundColor: Colors.transparent,
                            ))),
            ])),
          )),
    );
  }
}
