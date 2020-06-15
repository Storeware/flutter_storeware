library html_container;

import 'package:flutter/widgets.dart';
import "package:html_container_io/html_container_io.dart"
    if (dart.library.js) "package:html_container_web/html_container_web.dart";

class HtmlElementContainer<T> extends HtmlElementContainerImpls<T> {}

class HtmlElementContainerController<T>
    extends HtmlElementContainerControllerImpls<T> {}

class HtmlDiv extends HtmlDivImpls {
  HtmlDiv({Key key, Widget child}) : super(key: key, child: child);
}

class HtmlIFrameView extends HtmlIFrameViewImpls {
  HtmlIFrameView(
      {Key key,
      String src,
      String style,
      String width,
      String height,
      int border,
      String scrolling,
      String srcdoc,
      String allow})
      : super(
            src: src,
            srcdoc: srcdoc,
            width: width,
            scrolling: scrolling,
            style: style,
            border: border,
            height: height,
            allow: allow);
}
