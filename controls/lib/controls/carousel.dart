import 'package:flutter/material.dart';
import 'dart:async';

class Carousel extends StatefulWidget {
  final Widget child;
  final Function(int) onPressed;
  final Function(int) onActualIndex;

  ///All the [Widget] on this Carousel.
  final List<Widget> children;

  ///Returns [children]`s [lenght].
  int get childrenCount => children.length;

  ///The transition animation timing curve. Default is [Curves.ease]
  final Curve animationCurve;

  ///The transition animation duration. Default is 250ms.
  final Duration animationDuration;

  ///The amount of time each frame is displayed. Default is 2s.
  final Duration displayDuration;

  Carousel(
      {this.children,
      this.child,
      this.onPressed,
      this.onActualIndex,
      this.animationCurve = Curves.ease,
      this.animationDuration = const Duration(milliseconds: 1250),
      this.displayDuration = const Duration(seconds: 5)})
      : assert(children != null),
        assert(children.length > 1),
        assert(animationCurve != null),
        assert(animationDuration != null),
        assert(displayDuration != null);

  @override
  State createState() => new _CarouselState();
}

class _CarouselState extends State<Carousel>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  Timer _timer;

  ///Actual index of the displaying Widget
  int get actualIndex => _controller.index;

  ///Returns the calculated value of the next index.
  int get nextIndex {
    var nextIndexValue = actualIndex;

    if (nextIndexValue < _controller.length - 1)
      nextIndexValue++;
    else
      nextIndexValue = 0;
    if (widget.onActualIndex != null) widget.onActualIndex(nextIndexValue);
    return nextIndexValue;
  }

  @override
  void initState() {
    super.initState();

    _controller = new TabController(length: widget.childrenCount, vsync: this);

    startAnimating();
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new TabBarView(
      children: widget.children
          .map((wg) => InkWell(
              onTap: () {
                if (widget.onPressed != null) {
                  widget.onPressed(actualIndex);
                }
              },
              child: Stack(
                children: <Widget>[
                  Center(
                    child: wg,
                  ),
                  Positioned(
                      right: 10, bottom: 10, child: widget.child ?? Container())
                ],
              )))
          .toList(),
      controller: this._controller,
    );
  }

  void startAnimating() {
    _timer?.cancel();

    //Every widget.displayDuration (time) the tabbar controller will animate to the next index.
    _timer = new Timer.periodic(
        widget.displayDuration,
        (_) => this._controller.animateTo(this.nextIndex,
            curve: widget.animationCurve, duration: widget.animationDuration));
  }
}
