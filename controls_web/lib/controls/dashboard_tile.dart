import 'package:flutter/material.dart';
import 'package:controls_web/controls/responsive.dart';

class DashboardIcon extends StatelessWidget {
  final IconData? icon;
  final double? size;
  const DashboardIcon({Key? key, this.icon, this.size = 32}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: size,
      color: Theme.of(context).primaryColor.withOpacity(0.5),
    );
  }
}

class DashboardTile extends StatelessWidget {
  final String? value;
  final TextStyle? valueStyle;
  final String? title;
  final TextStyle? titleStyle;
  final double? titleHeight;
  final Color? color;
  final Widget? image;
  final Widget? icon;
  final Widget? body;
  final double? width;
  final double? height;
  final Widget? left;
  final double? borderRadius;
  final double? avatarRadius;
  final Widget? avatarChild;
  final Color? avatarColor;
  final double? avatarMargin;
  final double? elevation;
  final Function()? onPressed;
  final Color? indicatorColor;
  final double? avatarSize;
  final Widget? topBar;
  final List<Widget>? actions;
  final Widget? leading;
  final double? maxWidth;
  final double? maxHeight;
  final Widget? counter;
  const DashboardTile(
      {Key? key,
      this.value,
      this.elevation = 2,
      this.valueStyle,
      this.title,
      this.counter,
      this.titleStyle,
      this.color,
      this.actions,
      this.leading,
      this.borderRadius = 5,
      this.avatarMargin = 00,
      this.image,
      this.icon,
      this.onPressed,
      this.titleHeight = 25,
      this.avatarRadius = 60,
      this.avatarSize = 45,
      this.avatarColor,
      this.avatarChild,
      this.indicatorColor,
      this.width = 180,
      this.height = 80,
      this.maxWidth,
      this.maxHeight,
      this.left,
      this.topBar,
      this.body})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color _color = color ?? theme.primaryColor;
    ResponsiveInfo? responsive = ResponsiveInfo(context);
    Color _indicatorColor = indicatorColor ?? theme.indicatorColor;
    return Theme(
        data: theme.copyWith(primaryColor: _color),
        child: Card(
            elevation: elevation,
            shape: RoundedRectangleBorder(
              //side: BorderSide(color: Colors.white70, width: 1),
              borderRadius: BorderRadius.circular(borderRadius!),
            ),
            color: color ?? _color.withAlpha(150),
            child: LayoutBuilder(builder: (ctx, sizes) {
              Size size = MediaQuery.of(ctx).size;
              if (sizes.maxWidth < size.width)
                size = Size(sizes.maxWidth, size.height);
              double w = (responsive.isSmall
                  ? (size.width)
                  : responsive.isMobile
                      ? ((width! * 2) < size.width)
                          ? (size.width / 2) - 16
                          : width!
                      : width ?? 180.0);
              //print(w);
              return InkWell(
                  onTap: () {
                    if (onPressed != null) onPressed!();
                  },
                  child: Container(
                    width: w,
                    height: height,
                    constraints: BoxConstraints(
                        maxHeight: maxHeight ?? height!,
                        maxWidth: maxWidth ?? w),
                    child: Stack(
                      children: [
                        if (counter != null)
                          Positioned(top: -3, right: -3, child: counter!),
                        Positioned(
                          child: Column(mainAxisSize: MainAxisSize.min,
                              //crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (topBar != null) topBar!,
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (value != null)
                                        Container(
                                          alignment: Alignment.center,
                                          child: FittedBox(
                                              fit: BoxFit.contain,
                                              child: Text(
                                                value!,
                                                style: valueStyle ??
                                                    TextStyle(
                                                        fontSize: 32,
                                                        color: theme
                                                            .primaryTextTheme
                                                            .bodyText1!
                                                            .color),
                                              )),
                                        ),
                                      if (left != null)
                                        Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              left!,
                                              if (body != null)
                                                Expanded(child: body!)
                                            ]),
                                      if (left == null)
                                        if (body != null)
                                          Expanded(child: body!),
                                    ],
                                  ),
                                ),
                                if (title != null || actions != null)
                                  Container(
                                    alignment: Alignment.center,
                                    height: titleHeight,
                                    decoration: BoxDecoration(
                                      color: indicatorColor ??
                                          _indicatorColor.withAlpha(100),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft:
                                            Radius.circular(borderRadius!),
                                        bottomRight:
                                            Radius.circular(borderRadius!),
                                      ),
                                    ),
                                    child: Row(children: [
                                      if (leading != null) leading!,
                                      Expanded(
                                          child: Text(
                                        title ?? '',
                                        textAlign: TextAlign.center,
                                        style: titleStyle ??
                                            theme.primaryTextTheme.caption!
                                                .copyWith(fontSize: 18),
                                      )),
                                      if (actions != null) ...actions!,
                                    ]),
                                  ),
                              ]),
                        ),
                        if (avatarChild != null)
                          Positioned(
                            top: avatarMargin,
                            left: avatarMargin,
                            child: Container(
                              width: avatarSize,
                              height: avatarSize,
                              decoration: BoxDecoration(
                                color: avatarColor ?? _color.withOpacity(0.5),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(borderRadius!),
                                  bottomRight: Radius.circular(avatarRadius!),
                                ),
                              ),
                              child: avatarChild,
                              alignment: Alignment.center,
                            ),
                          ),
                        if (image != null)
                          Positioned(
                            bottom: this.titleHeight! / 2,
                            right: 4,
                            child: Container(
                                color: Colors.transparent, child: image),
                          ),
                        if (icon != null)
                          Positioned(
                            left: 10,
                            top: 10,
                            child: icon!,
                          ),
                      ],
                    ),
                  ));
            })));
  }
}

Color darken(Color c, [int percent = 10]) {
  assert(1 <= percent && percent <= 100);
  var f = 1 - percent / 100;
  return Color.fromARGB(c.alpha, (c.red * f).round(), (c.green * f).round(),
      (c.blue * f).round());
}

Color brighten(Color c, [int percent = 10]) {
  assert(1 <= percent && percent <= 100);
  var p = percent / 100;
  return Color.fromARGB(
      c.alpha,
      c.red + ((255 - c.red) * p).round(),
      c.green + ((255 - c.green) * p).round(),
      c.blue + ((255 - c.blue) * p).round());
}

class CounterWidget extends StatelessWidget {
  const CounterWidget(
      {Key? key,
      this.radius = 15,
      this.fontSize = 10,
      this.style,
      this.color = Colors.white,
      this.backgroundColor,
      required this.value})
      : super(key: key);
  final double radius;
  final Color? backgroundColor;
  final String value;
  final TextStyle? style;
  final double fontSize;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor,
      child: Text(
        value,
        style: style ??
            TextStyle(
              fontSize: fontSize,
              color: color,
            ),
      ),
    );
  }
}
