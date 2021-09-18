// @dart=2.12
import 'package:flutter/widgets.dart';
import 'package:universal_platform/universal_platform.dart';

class WindowsSize {
  save([Size? size]) {}
  restore() {}
  instance() => this;

  get isDesktop {
    return (UniversalPlatform.isWindows ||
        UniversalPlatform.isLinux ||
        UniversalPlatform.isMacOS);
  }
}
