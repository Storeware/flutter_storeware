import 'package:controls_web/controls/tab_choice.dart';
import 'package:flutter/material.dart';

import 'swipe_detector.dart';
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
  final Color tabColor;
  final Widget leading;
  final double spacing;

  const VerticalTopTabView(
      {Key key,
      this.initialIndex = 0,
      this.indicatorColor = Colors.amber,
      this.selectedColor,
      this.spacing = 4,
      this.actions,
      this.choices,
      this.controller,
      this.iconColor,
      this.leading,
      this.tabColor,
      this.style})
      : super(key: key);

  @override
  _VerticalTopTabViewState createState() => _VerticalTopTabViewState();
}

class _VerticalTopTabViewState extends State<VerticalTopTabView> {
  VerticalTopTabNavigatorController controller;
  ValueNotifier<Widget> _child;
  int position;
  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? VerticalTopTabNavigatorController();
    controller.pageView = this;
    _child = ValueNotifier<Widget>(Container());
    position = widget.initialIndex;
  }

  showPage(Widget page) {
    _child.value = page;
  }

  get maxIndex => widget.choices.length - 1;
  get minIndex => 0;
  @override
  Widget build(BuildContext context) {
    DateTime ultimo = DateTime.now();
    int newIndex = widget.initialIndex;
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
          tabColor: widget.tabColor,
          onSelectItem: (index, tab) {
            position = index;
            if (tab.onPressed != null)
              tab.onPressed();
            else {
              tab.child ??= tab.builder();
              _child.value = tab.child;
            }
          },
        ),
        Expanded(
          child: ValueListenableBuilder<Widget>(
            valueListenable: _child,
            builder: (a, widget, c) => AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                child: SwipeDetector(
                  child: _child.value ?? Container(),
                  onSwipeRight: () {
                    print(['right', position, maxIndex]);
                    if (position > 0) controller.animateTo(position - 1);
                  },
                  onSwipeLeft: () {
                    print(['left', position]);
                    if (position < maxIndex) controller.animateTo(position + 1);
                  },
                ),
                switchInCurve: Curves.ease,
                transitionBuilder: (widget, animation) => ScaleTransition(
                      scale: animation,
                      child: widget,
                    )),
          ),
        ),
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
      this.initialIndex = 0,
      this.selectedColor,
      this.leading,
      this.actions,
      this.spacing = 4,
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
  //ValueNotifier<bool> bShowDrownMenu;
  Color _iconColor;
  Color _tabColor;
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    _iconColor = widget.iconColor ?? theme.tabBarTheme.labelColor;
    _tabColor = widget.tabColor ?? theme.scaffoldBackgroundColor;
    Color _selectedColor =
        widget.selectedColor ?? theme.scaffoldBackgroundColor;
    //bShowDrownMenu = ValueNotifier<bool>(false);
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
                              child: (widget.choices[index].items != null)
                                  ? Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8),
                                      child: showDrownMenu(
                                          index, widget.choices[index].items),
                                    )
                                  : Align(
                                      alignment: Alignment.center,
                                      child: buildLabel(index))),
                          Container(
                              height: 2,
                              width:
                                  (widget.choices[index].label.length * 8.0) +
                                      ((widget.choices[index].items != null)
                                          ? 30
                                          : 0),
                              color: (active.value == index)
                                  ? widget.indicatorColor
                                  : null),
                        ],
                      ),
                onTap: () {
                  var choice = widget.choices[index];
                  if ((choice.items ?? []).length > 0) {
                    active.value = index;
                    //bShowDrownMenu.value = true;
                  } else {
                    widget.onSelectItem(index, widget.choices[index]);
                    active.value = index;
                  }
                },
              ),
            ),
          if (widget.actions != null) ...widget.actions,
        ]),
      ),
    );
  }

  buildLabel(index) {
    return widget.choices[index].title ??
        Text(widget.choices[index].label,
            style: widget.style ?? TextStyle(color: _iconColor, fontSize: 14));
  }

  showDrownMenu(int mainIndex, List<TabChoice> items) {
    return DropdownButtonHideUnderline(
        child: DropdownButton<int>(
      hint: buildLabel(mainIndex),
      items: [
        for (int item = 0; item < items.length; item++)
          ((items[item].label ?? '') == '-')
              ? DropdownMenuItem(
                  value: -item, child: items[item].title ?? Divider())
              : DropdownMenuItem(
                  value: item,
                  child: items[item].title ?? Text(items[item].label),
                )
      ],
      onChanged: (index) {
        active.value = mainIndex;
        if ((items[index].label ?? '') != '-')
          widget.onSelectItem(index, items[index]);
      },
    ));
  }
}
