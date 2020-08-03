import 'package:flutter/widgets.dart';

class TabChoice<T> {
  T data;
  Widget Function() builder;
  Function() onPressed;
  String label;
  Widget title;
  bool visible;
  int index;
  Widget image;
  Widget child;
  IconData icon;
  IconData selectedIcon;
  bool primary;
  Widget trailing;
  int count;
  String tooltip;
  List<TabChoice> items;
  TabChoice(
      {this.builder,
      this.data,
      this.image,
      this.onPressed,
      this.title,
      this.items,
      this.tooltip,
      this.index,
      this.label,
      this.child,
      this.icon,
      this.count,
      this.trailing,
      this.selectedIcon,
      this.primary = false,
      this.visible = true})
      : assert(builder != null || child != null);
}
