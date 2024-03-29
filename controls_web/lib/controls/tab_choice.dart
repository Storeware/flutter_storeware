import 'package:flutter/widgets.dart';

class TabChoice<T> {
  T? data;
  Widget Function()? builder;
  Function()? onPressed;
  String? label;
  Widget? title;
  bool visible;
  bool enabled;
  int? index;
  Widget? image;
  Widget? child;
  IconData? icon;
  IconData? selectedIcon;
  bool primary;
  Widget? trailing;
  int? count;
  String? tooltip;
  List<TabChoice>? items;
  Color? color;
  double? width;
  bool Function(int)? completed;
  TextStyle? style;
  String label_title = '';
  TabChoice(
      {this.builder,
      this.style,
      this.data,
      this.image,
      this.onPressed,
      this.completed,
      this.title,
      this.items,
      this.tooltip,
      this.index,
      this.width,
      this.label,
      this.child,
      this.icon,
      this.color,
      this.count,
      this.trailing,
      this.selectedIcon,
      this.primary = false,
      this.enabled = true,
      this.visible = true,
      this.label_title = ''})
      : assert(items != null ||
            (label != null) ||
            (builder != null || child != null || onPressed != null));
}

extension ColorMix on Color {
  Color mix(Color color) {
    var r = (color.red + this.red) ~/ 2;
    var g = (color.green + this.green) ~/ 2;
    var b = (color.blue + this.blue) ~/ 2;
    int a = (color.alpha + this.alpha) ~/ 2;
    return Color.fromARGB(a, r, g, b);
  }

  double get luminance =>
      (0.299 * this.red + 0.587 * this.green + 0.114 * this.blue) / 255;
  get isDark {
    // print(luminance);
    return luminance < 0.5;
  }
}
