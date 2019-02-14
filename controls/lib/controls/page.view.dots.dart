import 'dart:math';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PageViewDotted extends StatelessWidget {
  List<Widget> children;
  PageViewDotted({this.children,this.controller}){
    if (controller==null)
      controller = new PageController();
  }

  PageController controller;

  final _kDuration = const Duration(milliseconds: 300);
  final _kCurve = Curves.ease;
  final _kArrowColor = Colors.black.withOpacity(0.8);

  @override
  Widget build(BuildContext context) {
    return new IconTheme(
      data: new IconThemeData(color: _kArrowColor),
      child: Stack(children: <Widget>[
        new Positioned(
          bottom: 60.0,
          left: 0.0,
          right: 0.0,
          top: 0.0,
          child: PageView(
              controller: controller,
              physics: new AlwaysScrollableScrollPhysics(),
              children: children),
        ),
        Positioned(
          bottom: 0.0,
          left: 0.0,
          right: 0.0,
          child: new Container(
            color: Colors.grey[800].withOpacity(0.5),
            padding: const EdgeInsets.all(20.0),
            child: new Center(
              child: new PageViewDots(
                controller: controller,
                color: Theme.of(context).primaryColor,
                itemCount: children.length,
                onPageSelected: (int page) {
                  controller.animateToPage(
                    page,
                    duration: _kDuration,
                    curve: _kCurve,
                  );
                },
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

/// An indicator showing the currently selected page of a PageController
class PageViewDots extends AnimatedWidget {
  PageViewDots({
    this.controller,
    this.itemCount,
    this.onPageSelected,
    this.color: Colors.white,
  }) : super(listenable: controller);

  /// The PageController that this DotsIndicator is representing.
  final PageController controller;

  /// The number of items managed by the PageController
  final int itemCount;

  /// Called when a dot is tapped
  final ValueChanged<int> onPageSelected;

  /// The color of the dots.
  ///
  /// Defaults to `Colors.white`.
  final Color color;

  // The base size of the dots
  static const double _kDotSize = 8.0;

  // The increase in the size of the selected dot
  static const double _kMaxZoom = 2.0;

  // The distance between the center of each dot
  static const double _kDotSpacing = 25.0;

  Widget _buildDot(int index) {
    double selectedness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((controller.page ?? controller.initialPage) - index).abs(),
      ),
    );
    double zoom = 1.0 + (_kMaxZoom - 1.0) * selectedness;
    return new Container(
      width: _kDotSpacing,
      child: new Center(
        child: new Material(
          color: color,
          type: MaterialType.circle,
          child: new Container(
            width: _kDotSize * zoom,
            height: _kDotSize * zoom,
            child: new InkWell(
              onTap: () => onPageSelected(index),
            ),
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: new List<Widget>.generate(
          (itemCount > 10 ? 10 : itemCount), _buildDot),
    );
  }
}

// ignore: must_be_immutable
class PageViewDotsControlled extends StatelessWidget {
  List<Widget> pages = [];
  Color color;
  final int duration;
  double withOpacity;
  Duration _kDuration;
  //Color _kArrowColor;

  PageViewDotsControlled(this.pages,
      {this.color, this.duration = 300, this.withOpacity = 0.8});

  final _controller = new PageController();
  void init() {
    _kDuration = Duration(milliseconds: duration);
    //_kArrowColor = Colors.black.withOpacity(withOpacity);
  }

  final _kCurve = Curves.ease;
  _gotoPage(int index) {
    _controller.animateToPage(
      index,
      duration: _kDuration,
      curve: _kCurve,
    );
  }

  @override
  Widget build(BuildContext context) {
    init();
    return PageViewDots(
      itemCount: pages.length,
      onPageSelected: _gotoPage,
      controller: _controller,
      color: color,
    );
  }
}
