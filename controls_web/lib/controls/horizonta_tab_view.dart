import 'package:controls_web/controls/tab_choice.dart';
import 'package:flutter/material.dart';
//import 'tab_choice.dart';

class VerticalTopTabNavigatorController {
  _VerticalTopTabNavigatorState parent;
  animateTo(index) => parent.animateTo(index);
  get activeIndex => parent.activeIndex;
  showPage(Widget page) {
    if (pageView != null) pageView.showPage(page);
  }

  _VerticalTopTabViewState pageView;
}

class VerticalTopTabView extends StatefulWidget {
  final List<Widget> actions;
  final List<TabChoice> choices;
  final VerticalTopTabNavigatorController controller;
  final int initialIndex;
  final Color iconColor;
  final TextStyle style;
  final Color indicatorColor;
  final Color selectedColor;
  final Widget leading;
  final double spacing;

  const VerticalTopTabView(
      {Key key,
      this.initialIndex = 0,
      this.indicatorColor = Colors.amber,
      this.selectedColor,
      this.actions,
      this.choices,
      this.controller,
      this.iconColor,
      this.leading,
      this.spacing,
      this.style})
      : super(key: key);

  @override
  _VerticalTopTabViewState createState() => _VerticalTopTabViewState();
}

class _VerticalTopTabViewState extends State<VerticalTopTabView> {
  VerticalTopTabNavigatorController controller;
  ValueNotifier<Widget> _child;
  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? VerticalTopTabNavigatorController();
    controller.pageView = this;
    _child = ValueNotifier<Widget>(Container());
  }

  showPage(Widget page) {
    _child.value = page;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VerticalTopTabNavigator(
          actions: widget.actions,
          choices: widget.choices,
          controller: controller,
          leading: widget.leading,
          iconColor: widget.iconColor,
          initialIndex: widget.initialIndex,
          indicatorColor: widget.indicatorColor,
          selectedColor: widget.selectedColor,
          spacing: widget.spacing,
          onSelectItem: (index, tab) {
            if (tab.child == null) tab.child = tab.builder();
            _child.value = tab.child;
          },
        ),
        Expanded(
            child: ValueListenableBuilder<Widget>(
                valueListenable: _child,
                builder: (a, widget, c) => _child.value ?? Container())),
      ],
    );
  }
}

class VerticalTopTabNavigator extends StatefulWidget {
  final List<TabChoice> choices;
  final Function(int, TabChoice) onSelectItem;
  final int initialIndex;
  final Color indicatorColor;
  final Color selectedColor;
  final List<Widget> actions;
  final Widget leading;
  final Color tabColor;
  final Color iconColor;
  final TextStyle style;
  final double spacing;
  final VerticalTopTabNavigatorController controller;
  VerticalTopTabNavigator(
      {Key key,
      @required this.choices,
      this.onSelectItem,
      this.spacing = 4,
      this.initialIndex = 0,
      this.selectedColor,
      this.leading,
      this.actions,
      this.controller,
      this.indicatorColor = Colors.amber,
      this.iconColor,
      this.style,
      this.tabColor})
      : super(key: key);

  @override
  _VerticalTopTabNavigatorState createState() =>
      _VerticalTopTabNavigatorState();
}

class _VerticalTopTabNavigatorState extends State<VerticalTopTabNavigator> {
  ValueNotifier<int> active;
  VerticalTopTabNavigatorController controller;
  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? VerticalTopTabNavigatorController();
    controller.parent = this;
  }

  animateTo(index) {
    widget.onSelectItem(index, widget.choices[index]);
    active.value = index;
  }

  get activeIndex => active.value;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color _iconColor = widget.iconColor ?? theme.primaryColor;
    Color _tabColor = widget.tabColor ?? theme.scaffoldBackgroundColor;
    Color _selectedColor =
        widget.selectedColor ?? theme.scaffoldBackgroundColor;
    if (active == null) {
      active = ValueNotifier<int>(widget.initialIndex ?? 0);
      if (active.value >= 0)
        widget.onSelectItem(active.value, widget.choices[active.value]);
    }
    return Container(
      padding: const EdgeInsets.all(3.0),
      height: 36,
      width: double.maxFinite,
      child: ValueListenableBuilder<int>(
        valueListenable: active,
        builder: (a, b, w) => Row(children: [
          Expanded(child: Container(child: widget.leading)),
          for (var index = 0; index < widget.choices.length; index++)
            Container(
              padding:
                  EdgeInsets.only(left: widget.spacing, right: widget.spacing),
              color: (active.value == index) ? _selectedColor : _tabColor,
              child: InkWell(
                child: (!widget.choices[index].visible)
                    ? Container()
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(widget.choices[index].label,
                                      style: widget.style ??
                                          TextStyle(
                                              color: _iconColor,
                                              fontSize: 14)))),
                          Container(
                              height: 2,
                              width: widget.choices[index].label.length * 8.0,
                              color: (active.value == index)
                                  ? widget.indicatorColor
                                  : null)
                        ],
                      ),
                onTap: () {
                  widget.onSelectItem(index, widget.choices[index]);
                  active.value = index;
                },
              ),
            ),
          if (widget.actions != null) ...widget.actions,
        ]),
      ),
    );
  }
}
