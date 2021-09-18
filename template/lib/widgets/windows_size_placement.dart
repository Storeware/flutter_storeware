// @dart=2.12
import 'package:controls_data/local_storage.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'windows_size_interfaced.dart' as cc;

class WindowsSize extends cc.WindowsSize {
  Future<Size> getSize() async {
    return DesktopWindow.getWindowSize();
  }

  setSize(Size size) {
    return DesktopWindow.setWindowSize(size);
  }

  @override
  save([Size? size]) async {
    if (size == null) {
      size = await getSize();
    }
    LocalStorage()
        .setJson('windowSize', {"width": size.width, "height": size.height});
  }

  @override
  restore() {
    var r = LocalStorage().getJson('windowSize');
    if (r != null) {
      Size size = Size(r['width'] ?? 0, r['height'] ?? 0);
      if (size.width > 0 && size.height > 0) setSize(size);
    }
  }

  @override
  instance() => this;
}
