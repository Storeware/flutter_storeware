library html_container_interface;

class HtmlElementContainerControllerInterfaced<T> {
  T value;
}

abstract class HtmlElementContainerInterfaced<T> {
  String viewType;
  HtmlElementContainerControllerInterfaced controller;
  double width;
  double height;
  Function(T) onComplete;
  T Function(String) builder;
}
