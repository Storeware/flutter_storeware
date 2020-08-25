import 'package:flutter/material.dart';

extension SizeResponsive on Size {
  bool get isSmaller {
    return width < 500;
  }

  bool get isCellPhone {
    return (width >= 500) && (width < 700);
  }

  bool get isMedium {
    return (width >= 700) && (width < 1400);
  }

  bool get isLarger {
    return width >= 1400;
  }

  double boxWidth({double max = 250, double min = 200}) {
    var cols = width ~/ max;
    if (cols <= 1) return width;
    var w = (width - (cols * 5)) / cols;
    return (w >= min) ? w : min;
  }

  int cols({double max = 250, double min = 200}) {
    var cols = width ~/ max;
    if (cols <= 1) return 1;
    return cols;
  }
}
