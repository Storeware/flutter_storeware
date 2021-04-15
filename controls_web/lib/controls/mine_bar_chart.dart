import 'package:flutter/material.dart';
import 'package:controls_web/controls/overlay_container.dart';

class MiniBarChart extends StatefulWidget {
  final double? width;
  final Color? color;
  final Widget? leading;
  final Color? barColor;
  final Map<String, num>? data;
  final int? decimais;
  final String? prefix;
  final String? labelPrefix;
  final double? height;
  final bool? showX;
  final double? heightX;
  final double? maxValue;
  final double? left;
  final double? right;
  final double? gap;
  final int? interval;
  final double? barWidth;
  final Function()? onPressed;
  final Function(int, String)? onBarPressed;
  final TextStyle? xStyle;
  final double Function(double)? onGetBarWidth;
  const MiniBarChart(
      {Key? key,
      this.width,
      this.leading,
      this.barColor = Colors.black,
      this.data,
      this.onPressed,
      this.left = 1.0,
      this.gap = 1.5,
      this.barWidth,
      this.right = 1.0,
      this.decimais = 0,
      this.height = 40.0,
      this.interval = 5,
      this.onBarPressed,
      this.prefix = '',
      this.labelPrefix = '',
      this.xStyle,
      this.onGetBarWidth,
      this.showX = false,
      this.heightX = 8.0,
      this.maxValue,
      this.color = Colors.lightBlue})
      : super(key: key);

  @override
  _MiniBarChartState createState() => _MiniBarChartState();
}

class _MiniBarChartState extends State<MiniBarChart> {
  double maxValue = 0.0;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.data!.keys.length == 0) return Container();
    double v = 0.0;
    widget.data!.keys.forEach((k) {
      v = widget.data![k]! + 0.0;
      if (v > maxValue) maxValue = v;
      count++;
    });
    if (maxValue <= 0) return Container();
    if (widget.maxValue != null) maxValue = widget.maxValue!;

    return InkWell(
        onTap: widget.onPressed,
        child: Container(
          padding: EdgeInsets.only(left: widget.left!, right: widget.right!),
          alignment: Alignment.bottomCenter,
          color: widget.color,
          //width: widget.width,
          //height: widget.height,
          constraints: BoxConstraints(
            maxWidth: widget.width!,
            maxHeight: widget.height!,
          ),
          child: LayoutBuilder(builder: (x, y) {
            return Stack(children: [
              if (widget.leading != null) widget.leading!,
              ListView(
                scrollDirection: Axis.horizontal,
                //mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  for (var index = 0; index < widget.data!.keys.length; index++)
                    createBar(index, y.maxWidth, widget.data!.keys.length)
                ],
              )
            ]);
          }),
        ));
  }

  createBar(int index, double width, int n) {
    //print({'index': index, "n": n, 'width': width});
    String key = widget.data!.keys.toList()[index];
    num value = widget.data![key]!;
    num w = (width -
            ((n + 2) * widget.gap!) -
            (widget.left ?? 0.0) -
            (widget.right ?? 0.0)) /
        (n + 2);
    if (w < 1) w = 1;
    if (widget.barWidth != null) w = widget.barWidth!;
    if (widget.onGetBarWidth != null) w = widget.onGetBarWidth!(w + 0.0);

    return Align(
      alignment: Alignment.bottomCenter,
      child: InkWell(
          child: Padding(
              padding: EdgeInsets.only(
                  left: widget.gap! / 2, right: widget.gap! / 2),
              child: Tooltip(
                message:
                    '${widget.labelPrefix}$key: ${widget.prefix}${value.toStringAsFixed(widget.decimais!)}',
                child: Container(
                    //height: widget.height + (widget.showX ? 15 : 0),
                    child: Column(children: [
                  Spacer(),
                  Container(
                    alignment: Alignment.bottomCenter,
                    color: widget.barColor,
                    width: w + 0.0,
                    height: validaHeight(
                        ((maxValue > 0) ? (value / maxValue) : 0) *
                            (widget.height! -
                                (widget.showX! ? widget.heightX! - 2 : 0))),
                  ),
                  if (widget.showX!)
                    Container(
                        height: validaHeight(widget.heightX!) + 2,
                        //    show: true,
                        //    position: OverlayContainerPosition(0, 0),
                        child: (((index % widget.interval!) != 0) &&
                                (index != (n - 1)))
                            ? null
                            : Text(key,
                                style: widget.xStyle ??
                                    TextStyle(
                                      fontSize: widget.heightX,
                                      fontWeight: FontWeight.bold,
                                      backgroundColor: Colors.transparent,
                                    ))),
                ])),
              )),
          onTap: () {
            if (widget.onBarPressed != null) widget.onBarPressed!(index, key);
          }),
    );
  }

  validaHeight(double v) {
    if (v < 0) return 0;
    return v;
  }
}
