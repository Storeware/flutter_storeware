import 'package:flutter/material.dart';

/// [TabBarViewDynamic] is a dynamic TabBarView

class TabBarViewDynamic extends StatefulWidget {
  final Function(int) builder;
  final int activeIndex;
  final Function(int) onPositionChange;
  final Function(double) onScroll;
  final Function(TabController) onControllerChange;
  const TabBarViewDynamic({
    Key key,
    this.activeIndex = 0,
    this.onPositionChange,
    this.onScroll,
    this.onControllerChange,
    @required this.itemCount,
    @required this.builder,
  }) : super(key: key);
  final int itemCount;
  @override
  _TabViewBottomState createState() => _TabViewBottomState();
}

class _TabViewBottomState extends State<TabBarViewDynamic>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  Widget getChild(int idx) {
    if (mounted && (idx == _currentPosition)) {
      return widget.builder(idx);
    } else
      return Container();
  }

  TabController controller;
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _currentPosition = widget.activeIndex ?? 0;
    controller = TabController(
      length: widget.itemCount,
      vsync: this,
      initialIndex: _currentPosition,
    );
    controller.addListener(onPositionChange);
    controller.animation.addListener(onScroll);
    _currentCount = widget.itemCount;
    if (widget.onControllerChange != null)
      widget.onControllerChange(controller);
    super.initState();
  }

  @override
  void dispose() {
    controller.animation.removeListener(onScroll);
    controller.removeListener(onPositionChange);
    controller.dispose();
    super.dispose();
  }

  doChanged(int index) {
    tabView.children[index] = widget.builder(index);
  }

  int _currentCount = 0;
  int _currentPosition = 0;
  int _lastPosition = -1;

  onPositionChange() {
    if (!controller.indexIsChanging) {
      _currentPosition = controller.index;

      setState(() {
        doChanged(_currentPosition);
      });
      if (widget.onPositionChange != null) {
        widget.onPositionChange(_currentPosition);
      }
    }
  }

  onScroll() {
    if (widget.onScroll != null) {
      widget.onScroll(controller.animation.value);
    }
  }

  TabBarView tabView;
  @override
  Widget build(BuildContext context) {
    return tabView = TabBarView(
      key: UniqueKey(),
      controller: controller,
      children: [for (var i = 0; i < widget.itemCount; i++) getChild(i)],
    );
  }
}
