import 'package:controls_dash/src/dash_hbar.dart';
import 'package:flutter/material.dart';

class DashboardDensedTile extends StatefulWidget {
  final double? elevation;

  final double? height;

  final double? width;

  final Color? color;

  final Widget? child;
  final Widget? title;
  final Widget? subtitle;
  final String? value;
  final String? percent;
  final Widget? icon;

  const DashboardDensedTile(
      {Key? key,
      this.elevation = 10,
      this.height = 200,
      this.width = 150,
      this.color,
      this.title,
      this.value,
      this.subtitle,
      this.percent,
      this.child,
      this.icon})
      : super(key: key);

  @override
  _DashboardDensedTileState createState() => _DashboardDensedTileState();
}

class _DashboardDensedTileState extends State<DashboardDensedTile> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Card(
      elevation: widget.elevation,
      color: widget.color,
      child: SizedBox(
        height: widget.height,
        width: widget.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(children: [
                if (widget.icon != null)
                  Container(
                    child: widget.icon!,
                    constraints: const BoxConstraints(
                        minHeight: kMinInteractiveDimension,
                        minWidth: kMinInteractiveDimension),
                  ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.title != null)
                      DefaultTextStyle(
                          style: theme.textTheme.bodyText1!.copyWith(
                            color: theme.colorScheme.onSurface,
                          ),
                          child: widget.title!),
                    if (widget.subtitle != null)
                      DefaultTextStyle(
                          style: theme.textTheme.bodySmall!,
                          child: widget.subtitle!),
                  ],
                ),
              ]),
              Expanded(child: widget.child ?? Container()),
              Row(
                children: [
                  if (widget.value != null)
                    DefaultTextStyle(
                      style: theme.textTheme.bodyText1!.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                      child: Text(widget.value!),
                    ),
                  const Spacer(),
                  if (widget.percent != null)
                    DefaultTextStyle(
                      style: theme.textTheme.bodyText1!.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                      child: Text(widget.percent!),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
