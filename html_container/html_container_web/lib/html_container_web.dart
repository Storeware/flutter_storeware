library html_container_web;

import 'package:flutter/widgets.dart';
import 'dart:ui' as ui;
import 'dart:html';

import 'package:html_container_interface/html_container_interface.dart';

class HtmlElementContainerControllerImpls<T>
    extends HtmlElementContainerControllerInterfaced<T> {}

class HtmlIFrameViewImpls extends StatefulWidget {
  final String? width;
  final String? height;
  final String? src;
  final String? allow;
  final String? scrolling;
  final String? style;
  final int? border;
  final String? srcdoc;
  HtmlIFrameViewImpls({
    this.src,
    this.width,
    this.height,
    this.allow,
    this.scrolling,
    this.style,
    this.border = 0,
    this.srcdoc,
  });

  @override
  _HtmlIFrameViewImplsState createState() => _HtmlIFrameViewImplsState();
}

class _HtmlIFrameViewImplsState extends State<HtmlIFrameViewImpls> {
  IFrameElement? _iframeElement;

  DivElement? div;

  @override
  void initState() {
    super.initState();
    _iframeElement = IFrameElement();
    div = DivElement()
      ..contentEditable = 'true'
      ..style.width = '100%'
      ..style.height = '100%';
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementContainerImpls<DivElement>(
        viewType: 'iframeElement',
        builder: (typ) {
          if (widget.src != null) _iframeElement!.src = widget.src;
          _iframeElement!.width = widget.width ?? '100%';
          _iframeElement!.height = widget.height ?? '100%';
          _iframeElement!.setAttribute('border', "${widget.border ?? 0}");
          _iframeElement!.setAttribute('frameBorder', "${widget.border ?? 0}");
          if (widget.scrolling != null)
            _iframeElement!.setAttribute('scrolling', widget.scrolling!);
          if (widget.style != null)
            _iframeElement!.setAttribute('style', widget.style!);
          if (widget.allow != null)
            _iframeElement!.setAttribute(
                'allow',
                widget.allow ??
                    "accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture");
          if (widget.srcdoc != null) _iframeElement!.srcdoc = widget.srcdoc;
          div!.children.add(_iframeElement!);
          return div!;
        });
  }
}

class HtmlElementContainerImpls<T> extends StatelessWidget {
  final String? viewType;
  final HtmlElementContainerControllerImpls? controller;
  final double? width;
  final double? height;
  final Function(T)? onComplete;
  final T Function(String)? builder;
  const HtmlElementContainerImpls(
      {Key? key,
      @required this.viewType,
      this.onComplete,
      this.width,
      this.height,
      @required this.builder,
      this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    T elem = builder!(viewType!);
    if (controller != null) controller!.value = elem;
    if (onComplete != null) onComplete!(elem);
    return Directionality(
        textDirection: TextDirection.ltr,
        child: Container(
            width: width,
            height: height,
            child: FutureBuilder(
                future: getViewType(viewType, elem),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container();
                  return HtmlElementView(
                    viewType: viewType!,
                  );
                })));
  }

  getViewType(viewType, elem) async {
    // ignore: undefined_prefixed_name
    return ui.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
      return elem;
    });
  }
}
