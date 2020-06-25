import 'package:flutter/widgets.dart';

class TabChoice<T> {
  T data;
  Widget Function() builder;
  String label;
  Widget title;
  bool visible;
  int index;
  Widget image;
  Widget child;
  IconData icon;
  IconData selectedIcon;
  bool primary;
  TabChoice(
      {this.builder,
      this.data,
      this.image,
      this.title,
      this.index,
      this.label,
      this.child,
      this.icon,
      this.selectedIcon,
      this.primary = false,
      this.visible = true})
      : assert(builder != null || child != null);
}
