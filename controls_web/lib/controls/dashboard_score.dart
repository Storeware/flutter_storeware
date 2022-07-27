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

class DashboardDensedScore extends StatelessWidget {
  const DashboardDensedScore({
    Key? key,
    this.width,
    this.score,
    this.child,
    this.title,
    this.height,
    this.label,
    this.elevation = 0,
    this.color,
    this.backgroundColor,
    this.labelColor,
    this.labelIcon,
    this.style,
  }) : super(key: key);
  final String? score;
  final Widget? child;
  final String? title;
  final double? width;
  final double? height;
  final String? label;
  final double? elevation;
  final Color? color;
  final Color? backgroundColor;
  final Color? labelColor;
  final Widget? labelIcon;
  final TextStyle? style;
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextStyle styled = style ?? theme.textTheme.headline1!;
    return Card(
        elevation: elevation,
        color: backgroundColor ?? theme.cardColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
              width: width,
              height: height,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title != null)
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(title!,
                            style: styled.copyWith(
                              color: color ??
                                  theme.primaryTextTheme.bodyText2!
                                      .backgroundColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            )),
                      ),
                    ),
                  if (score != null)
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 1),
                        child: Text(score!,
                            //textAlign: TextAlign.left,
                            style: styled.copyWith(
                              color: color ??
                                  theme.primaryTextTheme.bodyText2!
                                      .backgroundColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            )),
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    //mainAxisSize: MainAxisSize.min,
                    children: [
                      if (label != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 1),
                          child: Text(label!,
                              style: styled.copyWith(
                                color: labelColor ??
                                    theme.primaryTextTheme.bodyText2!
                                        .backgroundColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              )),
                        ),
                      // if (labelIcon != null)
                      Padding(
                          padding: const EdgeInsets.only(left: 5, top: 1),
                          child: labelIcon ??
                              Icon(
                                Icons.circle,
                                size: 10,
                                //Icons.water_outlined,
                                color: styled.color,
                              )),
                    ],
                  ),
                  if (child != null) child!,
                ],
              )),
        ));
  }
}
