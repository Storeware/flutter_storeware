import 'package:flutter/widgets.dart';

InjectBuilder? _injects;

class InjectItem<T> {
  final String? name;
  final Widget Function(BuildContext, dynamic)? builder;
  final Future<T> Function(BuildContext, dynamic)? builderAsync;
  InjectItem({this.name, this.builder, this.builderAsync});
}

class InjectBuilder extends InheritedWidget {
  final List<InjectItem> injects = [];
  InjectBuilder({Key? key, Widget? child, List<InjectItem>? items})
      : super(key: key, child: child!) {
    _injects ??= this;
    if (items != null) items.forEach((item) => injects.add(item));
  }

  static InjectBuilder? get instance => _injects;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }

  static InjectBuilder? of(BuildContext context) =>
      context.findAncestorWidgetOfExactType<InjectBuilder>();
  InjectItem? operator [](String name) {
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
    delete(item.name!);
    injects.add(item);
    return item;
  }

  delete(String name) {
    var idx = indexOf(name);
    if (idx >= 0) injects.removeAt(idx);
  }

  static builderAsync(BuildContext context, nome, dados) async {
    InjectBuilder? alvo = InjectBuilder.of(context);
    if (alvo != null) {
      var idx = alvo.indexOf(nome);
      if (idx >= 0) {
        var inj = alvo.injects[idx];
        return inj.builderAsync!(context, dados);
      }
    }
    return null;
  }

  static Widget builder(BuildContext context, nome, dados) {
    InjectBuilder? alvo = InjectBuilder.of(context);
    if (alvo != null) {
      var idx = alvo.indexOf(nome);
      if (idx >= 0) {
        var inj = alvo.injects[idx];
        return inj.builder!(context, dados);
      }
    }
    return Container();
  }
}

class InjectConsumer<T> extends StatelessWidget {
  final Widget Function(BuildContext, InjectItem<T>?) builder;
  final String name;
  const InjectConsumer({Key? key, required this.builder, required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var injects = InjectBuilder.instance;
    if (injects == null) return Container();
    var inject = injects[name];
    return builder(context, inject as InjectItem<T>);
  }
}
