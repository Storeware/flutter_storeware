import 'package:flutter/material.dart';

class WidgetItem {
  String? id;
  String? title;
  String? chartTitle;
  String? description;
  String? imageUrl;
  bool? active;
  Color? color;
  Widget Function(BuildContext)? build;
  WidgetItem(
      {this.id,
      this.color,
      this.title,
      this.chartTitle,
      this.description,
      this.imageUrl,
      this.active = true,
      this.build});
  Widget builder(context) {
    if (build != null) return build!(context);
    return Container();
  }
}

class WidgetData {
  static final _singleton = WidgetData._create();
  WidgetData._create();
  factory WidgetData() => _singleton;

  final List<WidgetItem> items = [];
  final List<WidgetItem> headers = [];
  final List<WidgetItem> footers = [];

  add(WidgetItem item) => items.add(item);
  indexOf(String id) {
    for (var i = 0; i < items.length; i++) {
      if (items[i].id == id) return i;
    }
    return -1;
  }

  isActive(String id) {
    int i = indexOf(id);
    return items[i].active;
  }
}
