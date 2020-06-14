library html_container_web;

import 'package:flutter/widgets.dart';
import 'dart:ui' as ui;
import 'dart:html';

import 'package:html_container_interface/html_container_interface.dart';

class HtmlElementContainerControllerImpls<T>
    extends HtmlElementContainerControllerInterfaced<T> {}

class HtmlIFrameViewImpls extends StatelessWidget {
  final String width;
  final String height;
  final String src;
  final String allow;
  final String scrolling;
  HtmlIFrameViewImpls({
    this.src,
    this.width,
    this.height,
    this.allow,
    this.scrolling,
  });
  final IFrameElement _iframeElement = IFrameElement();
  @override
  Widget build(BuildContext context) {
    return HtmlElementContainerImpls<IFrameElement>(
        viewType: 'iframeElement',
        builder: (typ) {
          _iframeElement.src = src;
          if (width != null) _iframeElement.width = '$width';
          if (height != null) _iframeElement.height = '$height';
          _iframeElement.setAttribute('border', "0");
          _iframeElement.setAttribute('frameBorder', "0");
          if (scrolling != null)
            _iframeElement.setAttribute('scrolling', scrolling);
          _iframeElement.setAttribute(
              'allow',
              allow ??
                  "accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture");
          return _iframeElement;
        });
  }
}

class HtmlElementContainerImpls<T> extends StatelessWidget {
  final String viewType;
  final HtmlElementContainerControllerImpls controller;
  final double width;
  final double height;
  final Function(T) onComplete;
  final T Function(String) builder;
  const HtmlElementContainerImpls(
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
