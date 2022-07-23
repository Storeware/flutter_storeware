import 'package:flutter/material.dart';

enum TagPosition { none, left, top, bottom, right }

class DashboardScore extends StatefulWidget {
  const DashboardScore(
      {Key? key,
      this.score,
      this.title,
      this.icon,
      this.tagColor = Colors.amber,
      this.borderRadius = 5,
      this.tagWidth = 5,
      this.color,
      this.position = TagPosition.left,
      this.onPressed,
      this.trailing,
      this.child,
      this.topBar,
      this.leading,
      this.elevation = 5,
      this.width = 200,
      this.scoreStyle,
      this.height = 90})
      : super(key: key);
  final double borderRadius;
  final double tagWidth;
  final String? score;
  final Widget? title;
  final Widget? icon;
  final TextStyle? scoreStyle;
  final Color? tagColor;
  final Color? color;
  final double? width;
  final double? height;
  final double? elevation;
  final TagPosition position;
  final Function()? onPressed;
  final Widget? trailing;
  final Widget? leading;
  final Widget? child;
  final Widget? topBar;

  @override
  _DashboardScoreState createState() => _DashboardScoreState();
}

class _DashboardScoreState extends State<DashboardScore> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return (widget.onPressed == null)
        ? _builder(theme)
        : InkWell(
            child: _builder(theme),
            onTap: widget.onPressed,
          );
  }

  Widget _builder(ThemeData theme) {
    return Container(
        child: Card(
      color: widget.color,
      elevation: widget.elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: Column(children: [
          if (widget.topBar != null) widget.topBar!,
          Expanded(
              child: Stack(
            children: [
              Row(children: [
                if (widget.position == TagPosition.left)
                  Container(
                    width: widget.tagWidth,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: widget.tagColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(widget.borderRadius),
                        bottomLeft: Radius.circular(widget.borderRadius),
                      ),
                    ),
                  ),
                if (widget.leading != null) widget.leading!,
                if (widget.icon != null) ...[
                  Expanded(flex: 1, child: widget.icon!),
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0, bottom: 18.0),
                    child: VerticalDivider(
                      color: widget.tagColor,
                    ),
                  ),
                ],
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (widget.title != null)
                        DefaultTextStyle(
                          style: theme.textTheme.bodyText1!.copyWith(
                            fontSize:
                                theme.textTheme.bodyText1!.fontSize! * 0.9,
                          ),
                          child: widget.title!,
                        ),
                      if (widget.child != null) widget.child!,
                      if (widget.score != null)
                        Text(widget.score!,
                            style: widget.scoreStyle ??
                                TextStyle(
                                  fontSize:
                                      theme.textTheme.bodyText1!.fontSize! *
                                          1.25,
                                  fontWeight: FontWeight.bold,
                                )),
                    ],
                  ),
                ),
                if (widget.trailing != null) widget.trailing!,
                if (widget.position == TagPosition.right)
                  Container(
                    //color: widget.tagColor,
                    width: widget.tagWidth,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: widget.tagColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(widget.borderRadius),
                        bottomRight: Radius.circular(widget.borderRadius),
                      ),
                    ),
                  ),
              ]),
              if (widget.position == TagPosition.top)
                Container(
                  //color: widget.tagColor,
                  height: widget.tagWidth,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: widget.tagColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(widget.borderRadius),
                      bottomRight: Radius.circular(widget.borderRadius),
                    ),
                  ),
                ),
              if (widget.position == TagPosition.bottom)
                Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: widget.tagColor,
                      height: widget.tagWidth,
                      width: double.infinity,
                    )),
            ],
          )),
        ]),
      ),
    ));
  }
}
