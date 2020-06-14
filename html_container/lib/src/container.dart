import 'package:flutter/widgets.dart';
import 'dart:ui' as ui;

class HtmlElementContainerController<T> {
  T value;
}

class HtmlElementContainer<T> extends StatelessWidget {
  final String viewType;
  final HtmlElementContainerController controller;
  final double width;
  final double height;
  final Function(T) onComplete;
  final T Function(String) builder;
  const HtmlElementContainer(
      {Key key,
      @required this.viewType,
      this.onComplete,
      this.width,
      this.height,
      @required this.builder,
      this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    T elem = builder(viewType);
    if (controller != null) controller.value = elem;
    if (onComplete != null) onComplete(elem);
    return Container(
        child: FutureBuilder(
            future: getViewType(viewType, elem),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Container();
              return HtmlElementView(
                viewType: viewType,
              );
            }));
  }

  getViewType(viewType, elem) async {
    // ignore: undefined_prefixed_name
    return ui.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
      return elem;
    });
  }
}
