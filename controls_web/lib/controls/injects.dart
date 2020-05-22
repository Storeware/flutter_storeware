import 'package:flutter/widgets.dart';

class InjectItem {
  final String name;
  final Widget Function(BuildContext) builder;
  InjectItem({this.name, this.builder});
}

class InjectBuilder extends InheritedWidget {
  final List<InjectItem> injects = [];
  InjectBuilder({Key key, Widget child, List<InjectItem> items})
      : super(key: key, child: child) {
    if (items != null) items.forEach((item) => injects.add(item));
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }

  static InjectBuilder of(BuildContext context) =>
      context.findAncestorWidgetOfExactType<InjectBuilder>();
  InjectItem operator [](String name) {
    for (var i = 0; i < injects.length; i++)
      if (injects[i].name == name) return injects[i];
    return null;
  }

  int indexOf(String name) {
    for (var i = 0; i < injects.length; i++)
      if (injects[i].name == name) return i;
    return -1;
  }

  InjectItem register(InjectItem item) {
    delete(item.name);
    injects.add(item);
    return item;
  }

  delete(String name) {
    var idx = indexOf(name);
    if (idx >= 0) injects.removeAt(idx);
  }
}
