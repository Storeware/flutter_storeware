import 'package:flutter/material.dart';

class DotnutChartTile extends StatefulWidget {
  const DotnutChartTile({
    Key? key,
    this.height = 140,
    this.width = 320,
    this.value,
    this.total,
    this.percent,
    this.title,
    this.subtitle,
    this.icon,
    this.color,
    this.onPressed,
    this.child,
    this.chart,
    this.elevation = 10,
  }) : super(key: key);
  final double? elevation;
  final double? height;
  final double? width;
  final String? value;
  final double? total;
  final double? percent;
  final Widget? title;
  final Widget? subtitle;
  final IconData? icon;
  final Color? color;
  final Function()? onPressed;
  final Widget? child;
  final Widget? chart;
  @override
  _DotnutChartTileState createState() => _DotnutChartTileState();
}

class _DotnutChartTileState extends State<DotnutChartTile> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return (widget.onPressed == null)
        ? _builder(theme)
        : InkWell(
            child: _builder(theme),
            onTap: widget.onPressed!,
          );
  }

  Card _builder(ThemeData theme) {
    return Card(
      elevation: widget.elevation,
      color: widget.color,
      child: SizedBox(
        height: widget.height,
        width: widget.width,
        child: Row(children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.icon != null)
                  CircleAvatar(
                    child: Icon(
                      widget.icon,
                    ),
                  ),
                const SizedBox(
                  height: 5,
                ),
                if (widget.title != null)
                  DefaultTextStyle(
                      style: theme.textTheme.bodyText1!.copyWith(
                        fontSize: 16,
                      ),
                      child: widget.title!),
                if (widget.child != null) widget.child!,
                const SizedBox(
                  height: 5,
                ),
                if (widget.value != null)
                  Text(
                    widget.value!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                if (widget.total != null) Text('${widget.total!}'),
                const Spacer(),
                if (widget.subtitle != null)
                  DefaultTextStyle(
                      child: widget.subtitle!,
                      style: theme.textTheme.bodyText2!.copyWith(
                        fontSize: 10,
                      )),
              ],
            ),
          )),
          widget.percent == null
              ? widget.chart == null
                  ? Container()
                  : widget.chart!
              : SizedBox(
                  height: widget.height! * 0.8,
                  width: widget.height! * 0.8,
                  child: Center(
                    child: Stack(
                      children: [
                        Center(
                          child: SizedBox(
                            height: widget.height! * fator,
                            width: widget.height! * fator,
                            child: CircularProgressIndicator(
                              semanticsValue: '${widget.value}%',
                              strokeWidth: 15,
                              value: widget.percent! / 100,
                            ),
                          ),
                        ),
                        Center(
                          child: Text('${widget.percent!.toStringAsFixed(0)}%',
                              style: const TextStyle(
                                fontSize: 9,
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
        ]),
      ),
    );
  }

  double get fator => 0.5;
}
