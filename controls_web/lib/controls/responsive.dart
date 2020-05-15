import 'package:flutter/material.dart';

enum ResponsiveInfoScreen { small, mobile, tablet, desktop }

class ResponsiveInfo {
  Size _size;
  ResponsiveInfoScreen screen;
  Orientation orientation;
  get size => _size;
  set size(x) {
    _size = x;
    if (size.width < 450) screen = ResponsiveInfoScreen.small;
    if (size.width > 1200)
      screen = ResponsiveInfoScreen.desktop;
    else if (size.width < 800)
      screen = ResponsiveInfoScreen.mobile;
    else
      screen = ResponsiveInfoScreen.tablet;
  }

  get isTablet => screen == ResponsiveInfoScreen.tablet;
  get isDesktop => screen == ResponsiveInfoScreen.desktop;
  get isMobile =>
      (screen == ResponsiveInfoScreen.mobile) ||
      (screen == ResponsiveInfoScreen.small);
  get isSmall => screen == ResponsiveInfoScreen.small;
  get isMedium => (isMobile && (!isSmall));
  get isLargest => size.width > 1800;
  ThemeData theme;
  ResponsiveInfo(BuildContext context) {
    var mq = MediaQuery.of(context);
    orientation = mq.orientation;
    size = mq.size;
    theme = Theme.of(context);
  }
}

class Responsive extends InheritedWidget {
  final BuildContext context;
  Responsive({
    Key key,
    @required this.context,
    @required Widget child,
  }) : super(key: key, child: child);
  @override
  bool updateShouldNotify(Responsive old) {
    return false;
  }

  static of(BuildContext context) {
    Responsive r = context.dependOnInheritedWidgetOfExactType<Responsive>();
    r.info = ResponsiveInfo(context);
    return r;
  }

  ResponsiveInfo info;

  get isTablet => info.isTablet;
  get isDesktop => info.isDesktop;
  get isMobile => info.isMobile;
  get isSmall => info.isSmall;
  get isLargest => info.isLargest;
  get isMedium => info.isMedium;
  get theme => info.theme;
  get size => info.size;
  get orientation => info.orientation;
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
