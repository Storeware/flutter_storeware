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
  final double height;
  final VerticalTopTabNavigatorController controller;
  final int initialIndex;
  final Color iconColor;
  final TextStyle style;
  final Color indicatorColor;
  final Color selectedColor;
  final Color tabColor;
  final Widget leading;
  final double spacing;
  final Color completedColor;
  final Widget Function(TabChoice) timelineBuild;
  final Function(int) onSelectedItem;

  const VerticalTopTabView(
      {Key key,
      this.initialIndex = 0,
      this.indicatorColor,
      this.selectedColor,
      this.spacing = 4,
      this.height = 32,
      this.actions,
      this.choices,
      this.controller,
      this.iconColor,
      this.leading,
      this.tabColor,
      this.completedColor = Colors.green,
      this.timelineBuild,
      this.onSelectedItem,
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
    ThemeData theme = Theme.of(context);
    DateTime ultimo = DateTime.now();
    int newIndex = widget.initialIndex;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VerticalTopTabNavigator(
          height: widget.height,
          actions: widget.actions,
          choices: widget.choices,
          controller: controller,
          leading: widget.leading,
          iconColor: widget.iconColor,
          initialIndex: widget.initialIndex,
          indicatorColor: widget.indicatorColor ?? theme.indicatorColor,
          selectedColor: widget.selectedColor,
          spacing: widget.spacing,
          tabColor: widget.tabColor,
          completedColor: widget.completedColor,
          timelineBuild: widget.timelineBuild,
          onSelectItem: (index, tab) {
            position = index;
            if (widget.onSelectedItem != null) widget.onSelectedItem(index);
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
  final double height;
  final Color completedColor;
  final Widget Function(TabChoice) timelineBuild;
  final VerticalTopTabNavigatorController controller;
  VerticalTopTabNavigator(
      {Key key,
      @required this.choices,
      this.onSelectItem,
      this.initialIndex = 0,
      this.selectedColor,
      this.completedColor = Colors.green,
      this.leading,
      this.height = kMinInteractiveDimension,
      this.actions,
      this.spacing = 4,
      this.controller,
      this.indicatorColor,
      this.iconColor,
      this.style,
      this.timelineBuild,
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
  ThemeData theme;
  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    _iconColor = widget.iconColor ??
        theme.tabBarTheme?.labelColor ??
        theme.textTheme.bodyText1.color.withAlpha(100);
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
      height: widget.height,
      width: double.maxFinite,
      child: ValueListenableBuilder<int>(
        valueListenable: active,
        builder: (a, b, w) => Row(children: [
          /// objetos a esquerda
          if (widget.leading != null) widget.leading,

          /// space em branco a esquerda do menu
          Spacer(),

          /// lista itens do menu
          for (var index = 0; index < widget.choices.length; index++)
            Builder(builder: (x) {
              bool completed = (widget.choices[index].completed != null)
                  ? widget.choices[index].completed(activeIndex) ?? false
                  : false;

              return Container(
                width: widget.choices[index].width,
                //padding: EdgeInsets.only(
                //    left: existIndicator(index) ? 0 : widget.spacing,
                //    right: existIndicator(index) ? 0 : widget.spacing),
                color: (active.value == index) ? _selectedColor : _tabColor,
                child: InkWell(
                  child: (!widget.choices[index].visible)
                      ? Container()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                      //width: widget.choices[index].width,
                                      child: (widget.choices[index].items !=
                                              null)
                                          ? Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8),
                                              child: showDrownMenu(index,
                                                  widget.choices[index].items),
                                            )
                                          : Align(
                                              alignment: Alignment.center,
                                              child: buildLabel(index))),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Container(
                                    height: 2,
                                    width: widget.choices[index].width ??
                                        (widget.choices[index].label.length *
                                                8.0) +
                                            ((widget.choices[index].items !=
                                                    null)
                                                ? 30
                                                : 0),
                                    color: (active.value == index)
                                        ? widget.indicatorColor ??
                                            theme.indicatorColor
                                        : (completed)
                                            ? widget.completedColor
                                            : null,
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: widget.spacing,
                              ),
                              if (existIndicator(index) &&
                                  active.value != index)
                                (widget.timelineBuild != null)
                                    ? widget
                                        .timelineBuild(widget.choices[index])
                                    : Container(
                                        width: widget.spacing,
                                        height: widget.spacing,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            //border: Border.all(
                                            //    width: 1, color: Colors.black),
                                            color: completed
                                                ? widget.completedColor
                                                : Colors.transparent)),
                              SizedBox(
                                width: widget.spacing,
                              ),
                            ]),
                  onTap: (!widget.choices[index].enabled)
                      ? null
                      : () {
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
              );
            }),
          if (widget.actions != null) ...widget.actions,
        ]),
      ),
    );
  }

  existIndicator(index) => widget.choices[index].completed != null;

  buildLabel(index) {
    return widget.choices[index].title ??
        Text(
          widget.choices[index].label,
          overflow: TextOverflow.ellipsis,
          style: (!widget.choices[index].enabled)
              ? TextStyle(color: theme.dividerColor)
              : widget.style ??
                  (theme.tabBarTheme?.labelStyle ??
                          theme.textTheme.button
                              .copyWith(color: theme.buttonColor))
                      .copyWith(color: _iconColor),
        );
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
        if ((items[index].enabled)) if ((items[index].label ?? '') != '-')
          widget.onSelectItem(index, items[index]);
      },
    ));
  }
}
