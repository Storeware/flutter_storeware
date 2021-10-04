import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';

enum ResponsiveInfoScreen { mobile, tablet, desktop }

extension BuildContextExtension on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  ResponsiveInfo get responsive => ResponsiveInfo(this);
  bool get isLandscape => mediaQuery.orientation == Orientation.landscape;

  Size get size => mediaQuery.size;

  double get pixelsPerInch =>
      UniversalPlatform.isAndroid || UniversalPlatform.isIOS ? 150 : 96;
}

class ResponsiveInfo {
  Size? _size;
  ResponsiveInfoScreen? screen;
  Orientation? orientation;
  Size get size => _size!;
  set size(Size x) {
    _size = x;

    if (size.width >= 1100)
      screen = ResponsiveInfoScreen.desktop;
    else if (size.width <= 650)
      screen = ResponsiveInfoScreen.mobile;
    else
      screen = ResponsiveInfoScreen.tablet;
  }

  get isTablet => screen == ResponsiveInfoScreen.tablet;
  get isDesktop => screen == ResponsiveInfoScreen.desktop;
  get isMobile => (screen == ResponsiveInfoScreen.mobile);

  get isSmall => size.width < 450;
  get isMedium => (isMobile && (!isSmall));
  get isLargest => size.width > 1800;
  get isSmalest => size.width < 350;
  ThemeData? theme;
  ResponsiveInfo(BuildContext context) {
    var mq = MediaQuery.of(context);
    orientation = mq.orientation;
    size = mq.size;
    theme = Theme.of(context);
  }
}

class ResponsiveBuilder extends StatelessWidget {
  final EdgeInsets? minimum;
  final bool? maintainBottomViewPadding;
  final Widget Function(BuildContext, ResponsiveInfo)? builder;
  const ResponsiveBuilder(
      {Key? key,
      this.minimum = EdgeInsets.zero,
      this.builder,
      this.maintainBottomViewPadding = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ResponsiveInfo info = ResponsiveInfo(context);
    return SafeArea(
      minimum: minimum!,
      maintainBottomViewPadding: maintainBottomViewPadding!,
      child: builder!(context, info),
    );
  }
}

class Responsive extends StatelessWidget {
  final Widget Function(BuildContext context, BoxConstraints constraints)
      mobile;
  final Widget Function(BuildContext context, BoxConstraints constraints)?
      tablet;
  final Widget Function(BuildContext context, BoxConstraints constraints)?
      desktop;

  const Responsive({
    Key? key,
    required this.mobile,
    this.tablet,
    this.desktop,
  }) : super(key: key);

// This size work fine on my design, maybe you need some customization depends on your design

  // This isMobile, isTablet, isDesktop helep us later
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 650;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < 1100 &&
      MediaQuery.of(context).size.width >= 650;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      // If our width is more than 1100 then we consider it a desktop
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1100) {
          return (desktop != null)
              ? desktop!(context, constraints)
              : (tablet != null)
                  ? tablet!(context, constraints)
                  : mobile(context, constraints);
        }
        // If width it less then 1100 and more then 650 we consider it as tablet
        else if (constraints.maxWidth >= 650) {
          return (tablet != null)
              ? tablet!(context, constraints)
              : mobile(context, constraints);
        }
        // Or less then that we called it mobile
        else {
          return mobile(context, constraints);
        }
      },
    );
  }
}
