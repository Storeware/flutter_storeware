import 'package:flutter/material.dart';

enum ResponsiveInfoScreen { mobile, tablet, desktop }

class ResponsiveInfo {
  Size _size;
  ResponsiveInfoScreen screen;
  Orientation orientation;
  get size => _size;
  set size(x) {
    _size = x;
    if (size.width > 1200)
      screen = ResponsiveInfoScreen.desktop;
    else if (size.width < 800)
      screen = ResponsiveInfoScreen.mobile;
    else
      screen = ResponsiveInfoScreen.tablet;
  }

  get isTablet => screen == ResponsiveInfoScreen.tablet;
  get isDesktop => screen == ResponsiveInfoScreen.desktop;
  get isMobile => screen == ResponsiveInfoScreen.mobile;
  ThemeData theme;
  ResponsiveInfo(BuildContext context) {
    var mq = MediaQuery.of(context);
    orientation = mq.orientation;
    size = mq.size;
    theme = Theme.of(context);
  }
}

class ResponsiveBuilder extends StatelessWidget {
  final EdgeInsets minimum;
  final bool maintainBottomViewPadding;
  final Widget Function(BuildContext, ResponsiveInfo) builder;
  const ResponsiveBuilder(
      {Key key,
      this.minimum = EdgeInsets.zero,
      this.builder,
      this.maintainBottomViewPadding = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ResponsiveInfo info = ResponsiveInfo(context);
    return SafeArea(
      minimum: minimum,
      maintainBottomViewPadding: maintainBottomViewPadding,
      child: builder(context, info),
    );
  }
}
