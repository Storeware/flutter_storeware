import 'package:controls_web/controls/swipe_detector.dart';
import 'package:controls_web/controls/tab_choice.dart';
import 'package:flutter/material.dart';

//import 'swipe_detector.dart';

class VerticalTopTabNavigatorController {
  _VerticalTopTabNavigatorState? parent;
  animateTo(index) => parent!.animateTo(index);
  get activeIndex => parent!.activeIndex;
  showPage(Widget page) {
    if (pageView != null) pageView!.showPage(page);
  }

  _VerticalTopTabViewState? pageView;
}

class VerticalTopTabView extends StatefulWidget {
  final VerticalTopTabPosition? position;
  final double? right;
  final double? left;
  final List<Widget>? actions;
  final List<TabChoice>? choices;
  final Function(BuildContext context, TabChoice item, bool selected)? builder;
  final double? height;
  final VerticalTopTabNavigatorController? controller;
  final int? initialIndex;
  final Color? iconColor;
  final TextStyle? style;
  final Color? indicatorColor;
  final Color? selectedColor;
  final Color? tabColor;
  final Widget? leading;
  final double? spacing;
  final Color? completedColor;
  final Widget Function(TabChoice)? timelineBuild;
  final Function(int)? onSelectedItem;
  final Color? backgroundColor;
  final WrapAlignment mainAxisAlignment;
  final WrapCrossAlignment crossAxisAlignment;

  const VerticalTopTabView(
      {Key? key,
      this.position = VerticalTopTabPosition.right,
      this.mainAxisAlignment = WrapAlignment.end,
      this.crossAxisAlignment = WrapCrossAlignment.center,
      this.initialIndex = 0,
      this.builder,
      this.indicatorColor,
      this.selectedColor,
      this.spacing = 4,
      this.height = 32,
      this.backgroundColor,
      this.right,
      this.left,
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
  VerticalTopTabNavigatorController? controller;
  ValueNotifier<Widget> _child = ValueNotifier<Widget>(Container());
  int? position;
  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? VerticalTopTabNavigatorController();
    controller!.pageView = this;
    _child = ValueNotifier<Widget>(Container());
    position = widget.initialIndex;
  }

  showPage(Widget page) {
    _child.value = page;
  }

  get maxIndex => widget.choices!.length - 1;
  get minIndex => 0;
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    //DateTime ultimo = DateTime.now();
    //int newIndex = widget.initialIndex!;
    return Container(
        color: widget.backgroundColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
//        if (widget.left != null) SizedBox(width: widget.left),
            VerticalTopTabNavigator(
              backgroundColor: widget.backgroundColor,
              position: widget.position,
              builder: widget.builder,
              left: widget.left,
              right: widget.right,
              crossAxisAlignment: widget.crossAxisAlignment,
              mainAxisAlignment: widget.mainAxisAlignment,
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
                if (widget.onSelectedItem != null)
                  widget.onSelectedItem!(index);
                if (tab.onPressed != null)
                  tab.onPressed!();
                else {
                  if (tab.child == null && tab.builder != null)
                    tab.child = tab.builder!();
                  _child.value = tab.child ?? Container();
                }
              },
            ),
            Expanded(
              child: ValueListenableBuilder<Widget>(
                valueListenable: _child,
                builder: (a, wg, Widget? c) => AnimatedSwitcher(
                    duration: Duration(milliseconds: 500),
                    child: SwipeDetector(
                      child: wg,
                      onSwipeRight: () {
                        print(['right', position, maxIndex]);
                        if (position! > 0) controller!.animateTo(position! - 1);
                      },
                      onSwipeLeft: () {
                        print(['left', position]);
                        if (position! < maxIndex)
                          controller!.animateTo(position! + 1);
                      },
                    ),
                    switchInCurve: Curves.ease,
                    transitionBuilder: (widget, animation) =>
                        //genAnimation(widget, animation) ??
                        ScaleTransition(
                          scale: animation,
                          child: widget,
                        )),
              ),
            ),
            if (widget.right != null) SizedBox(width: widget.right),
          ],
        ));
  }

  genAnimation(child, animation) => SlideTransition(
        position: CurvedAnimation(
          parent: animation,
          reverseCurve: Curves.ease,
          curve: Curves.bounceOut,
        ).drive(Tween<Offset>(begin: Offset(0.0, -1.0), end: Offset.zero)),
        child: SlideTransition(
            position: Tween<Offset>(begin: Offset.zero, end: Offset(-1.0, 0.0))
                .animate(animation),
            child: child),
      );
}

enum VerticalTopTabPosition { none, left, right }

class VerticalTopTabNavigator extends StatefulWidget {
  final List<TabChoice>? choices;
  final Function(int, TabChoice)? onSelectItem;
  final int? initialIndex;
  final VerticalTopTabPosition? position;
  final Color? indicatorColor;
  final Color? selectedColor;
  final List<Widget>? actions;
  final Widget? leading;
  final double? left, right;
  final Color? tabColor;
  final Color? iconColor;
  final TextStyle? style;
  final double? spacing;
  final double? height;
  final Color? backgroundColor;
  final Color? completedColor;
  final Widget Function(TabChoice)? timelineBuild;
  final VerticalTopTabNavigatorController? controller;
  final WrapAlignment mainAxisAlignment;
  final WrapCrossAlignment crossAxisAlignment;
  final Function(BuildContext context, TabChoice item, bool selected)? builder;

  VerticalTopTabNavigator(
      {Key? key,
      @required this.choices,
      this.onSelectItem,
      this.initialIndex = 0,
      this.selectedColor,
      this.builder,
      this.left,
      this.right,
      this.completedColor = Colors.green,
      this.leading,
      this.height = kMinInteractiveDimension,
      this.actions,
      this.position = VerticalTopTabPosition.right,
      this.mainAxisAlignment = WrapAlignment.start,
      this.crossAxisAlignment = WrapCrossAlignment.center,
      this.spacing = 4,
      this.controller,
      this.indicatorColor,
      this.iconColor,
      this.style,
      this.backgroundColor,
      this.timelineBuild,
      this.tabColor})
      : super(key: key);

  @override
  _VerticalTopTabNavigatorState createState() =>
      _VerticalTopTabNavigatorState();
}

class _VerticalTopTabNavigatorState extends State<VerticalTopTabNavigator> {
  ValueNotifier<int>? active;
  VerticalTopTabNavigatorController? controller;
  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? VerticalTopTabNavigatorController();
    controller!.parent = this;
  }

  animateTo(index) {
    widget.onSelectItem!(index, widget.choices![index]);
    active!.value = index;
  }

  get activeIndex => active!.value;
  //ValueNotifier<bool> bShowDrownMenu;
  //Color? _iconColor;
  Color? _tabColor;
  ThemeData? theme;
  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    //_iconColor = widget.iconColor ??
    //    theme!.tabBarTheme.labelColor ??
    //    theme!.textTheme.bodyText1!.color!.withAlpha(100);
    _tabColor = widget.tabColor ?? theme!.scaffoldBackgroundColor;
    Color _selectedColor =
        widget.selectedColor ?? theme!.scaffoldBackgroundColor;
    //bShowDrownMenu = ValueNotifier<bool>(false);
    if (active == null) {
      active = ValueNotifier<int>(widget.initialIndex ?? 0);
      if (active!.value >= 0)
        widget.onSelectItem!(active!.value, widget.choices![active!.value]);
    }
    return Container(
      padding: const EdgeInsets.only(left: 3.0, right: 3.0),
      //height: widget.height,
      constraints: BoxConstraints(minHeight: widget.height ?? 40),
      width: double.maxFinite,
      child: ValueListenableBuilder<int>(
        valueListenable: active!,
        builder: (a, b, w) => Wrap(
          alignment: widget.mainAxisAlignment,
          runAlignment: widget.mainAxisAlignment,
          //mainAxisAlignment: widget.mainAxisAlignment,
          crossAxisAlignment: widget.crossAxisAlignment,
          children: [
            /// objetos a esquerda
            if (widget.left != null) SizedBox(width: widget.left),
            if (widget.leading != null) widget.leading!,

            /// space em branco a esquerda do menu
            if (widget.position == VerticalTopTabPosition.right) Spacer(),

            /// lista itens do menu
            for (var index = 0; index < widget.choices!.length; index++)
              Builder(builder: (x) {
                bool completed = (widget.choices![index].completed != null)
                    ? (widget.choices![index].completed!(activeIndex))
                    : false;

                return Container(
                  width: widget.choices![index].width,
                  color: (active!.value == index) ? _selectedColor : _tabColor,
                  child: InkWell(
                    child: (!widget.choices![index].visible)
                        ? Container()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                                (widget.builder != null)
                                    ? widget.builder!(
                                        context,
                                        widget.choices![index],
                                        active!.value == index)
                                    : Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                              decoration: new BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                width: 2.0,
                                                color: (active!.value == index)
                                                    ? widget.indicatorColor ??
                                                        theme!.indicatorColor
                                                    : (completed)
                                                        ? widget.completedColor!
                                                        : Colors.transparent,
                                              ))),
                                              //width: widget.choices[index].width,
                                              child: (widget.choices![index]
                                                          .items !=
                                                      null)
                                                  ? Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 8),
                                                      child: showDrownMenu(
                                                          context,
                                                          index,
                                                          widget.choices![index]
                                                              .items!),
                                                    )
                                                  : Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: buildLabel(
                                                        context,
                                                        index,
                                                      ))),
                                          SizedBox(
                                            height: 2,
                                          ),
                                        ],
                                      ),
                                if (existIndicator(index) &&
                                    active!.value != index)
                                  (widget.timelineBuild != null)
                                      ? widget.timelineBuild!(
                                          widget.choices![index])
                                      : Container(
                                          width: widget.spacing,
                                          height: widget.spacing,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              color: completed
                                                  ? widget.completedColor
                                                  : Colors.transparent)),
                                SizedBox(
                                  width: widget.spacing,
                                ),
                              ]),
                    onTap: (!widget.choices![index].enabled)
                        ? null
                        : () {
                            var choice = widget.choices![index];
                            if ((choice.items ?? []).length > 0) {
                              active!.value = index;
                              //bShowDrownMenu.value = true;
                            } else {
                              if (widget.onSelectItem != null)
                                widget.onSelectItem!(
                                    index, widget.choices![index]);
                              active!.value = index;
                            }
                          },
                  ),
                );
              }),
            if (widget.position == VerticalTopTabPosition.left) Spacer(),

            if (widget.actions != null) ...widget.actions!,
            if (widget.right != null) SizedBox(width: widget.right),
          ],
        ),
      ),
    );
  }

  existIndicator(index) => widget.choices![index].completed != null;

  buildLabel(context, index) {
    var theme = Theme.of(context);
    return Padding(
        padding: EdgeInsets.only(left: 3.0, right: 3.0, top: 2.0, bottom: 2.0),
        child: widget.choices![index].title ??
            Text(widget.choices![index].label!,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: (!widget.choices![index].enabled)
                    ? TextStyle(color: theme.dividerColor)
                    : widget.choices![index].style ??
                        widget.style ??
                        theme.textTheme.bodyText1!.copyWith(
                          fontSize: 12,
                          color: _getColor(theme).isDark
                              ? Colors.white70
                              : theme.appBarTheme.color,
                          fontWeight: FontWeight.w500,
                        )));
  }

  Color _getColor(ThemeData theme) {
    return ((theme.brightness == Brightness.dark)
        ? Colors.black
        : Colors.white);
  }

  showDrownMenu(context, int mainIndex, List<TabChoice> items) {
    return DropdownButtonHideUnderline(
        child: DropdownButton<int>(
      hint: buildLabel(context, mainIndex),
      items: [
        for (int item = 0; item < items.length; item++)
          ((items[item].label ?? '') == '-')
              ? DropdownMenuItem(
                  value: -item, child: items[item].title ?? Divider())
              : DropdownMenuItem(
                  value: item,
                  child: items[item].title ?? Text(items[item].label!),
                )
      ],
      onChanged: (index) {
        active!.value = mainIndex;
        if ((items[index!].enabled)) if ((items[index].label ?? '') != '-')
          widget.onSelectItem!(index, items[index]);
      },
    ));
  }
}
