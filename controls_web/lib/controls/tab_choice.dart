import 'package:flutter/widgets.dart';

class TabChoice {
  Widget Function() builder;
  String text;
  Widget title;
  bool visible;
  int index;
  TabChoice({this.builder, this.text, this.visible = true});
}
