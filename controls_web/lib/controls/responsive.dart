import 'package:flutter/material.dart';

enum ResponsiveInfoScreen { mobile, tablet, desktop }

class ResponseveInfo {
  Size _size;
  ResponsiveInfoScreen screen;
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
  get isDesktop => screen = ResponsiveInfoScreen.desktop;
  get isMobile => screen == ResponsiveInfoScreen.mobile;
  ThemeData theme;
}

class ResponsiveBuilder extends StatelessWidget {
  final EdgeInsets minimum;
  final bool maintainBottomViewPadding;
  final Widget Function(BuildContext, ResponseveInfo) builder;
  const ResponsiveBuilder(
      {Key key, this.minimum, this.builder, this.maintainBottomViewPadding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ResponseveInfo info;
    info.size = MediaQuery.of(context).size;
    info.theme = Theme.of(context);
    return SafeArea(
      minimum: minimum,
      maintainBottomViewPadding: maintainBottomViewPadding,
      child: builder(context, info),
    );
  }
}
