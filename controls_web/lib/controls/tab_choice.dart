import 'package:flutter/widgets.dart';

class TabChoice {
  Widget Function() builder;
  String text;
  Widget title;
  bool visible;
  int index;
  Widget image;
  TabChoice(
      {this.builder,
      this.image,
      this.title,
      this.index,
      this.text,
      this.visible = true});
}
