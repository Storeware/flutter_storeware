import 'dart:async';

import 'package:controls_web/controls/responsive.dart';
import 'package:flutter/material.dart';
import 'package:controls_web/controls/tab_choice.dart';

enum HorizontalTabViewSiderBarType { hide, compact, show }

class HorizontalTabViewController {
  _HorizontalTabViewState? tabControl;
  animateTo(int index) {
    if (tabControl != null) tabControl!.animateTo(index);
  }
}

class HorizontalTabView extends StatefulWidget {
  final List<TabChoice>? choices;
  final double? top, bottom, left, right;
  final HorizontalTabViewController? controller;
  final Color? tabColor;
  final Color? sidebarBackgroundColor;
  final Color? indicatorColor;
  final Color? iconColor;
  final AppBar? appBar;
  final Widget? topBar, bottomBar;
  final Widget? sidebarHeader, sidebarFooter;
  final int? mobileCrossCount;
  final Color? color;
  final double? width;
  final double? minWidth;
  final Color? backgroundColor;
  final Widget? pageBottom;
  final EdgeInsets? padding;
  final HorizontalTabViewSiderBarType? sidebarType;
  final double? elevation;
  final Widget? floatingActionButton;
  final Color? tagColor;
  final bool? isMobile;
  final double? tabHeight;
  final TextStyle? tabStyle;
  //final double tabHeightCompact;
  final AppBar? sidebarAppBar;
  final Drawer? sidebarDrawer;
  final Widget? sidebarRight;
  final Function(int)? onChanged;
  final int? activeIndex;
  HorizontalTabView({
    Key? key,
    this.choices,
    this.appBar,
    this.sidebarAppBar,
    this.sidebarDrawer,
    this.padding,
    this.width = 220,
    this.tabHeight = kToolbarHeight,
    this.tabStyle,
    this.top = 0,
    this.bottom = 0,
    this.left = 0,
    this.right = 0,
    this.topBar,
    this.bottomBar,
    //this.tabHeightCompact,
    this.sidebarBackgroundColor,
    this.sidebarType,
    this.controller,
    this.tagColor,
    this.mobileCrossCount,
    this.indicatorColor = Colors.blue,
    this.backgroundColor,
    this.iconColor, //= Colors.white,
    this.tabColor = Colors.lightBlue,
    this.pageBottom,
    this.isMobile,
    this.minWidth = 90,
    this.color, //= Colors.lightBlue,
    this.elevation = 0,
    this.sidebarHeader,
    this.sidebarFooter,
    this.floatingActionButton,
    this.sidebarRight,
    this.onChanged,
    this.activeIndex,
  }) : super(key: key);

  @override
  _HorizontalTabViewState createState() => _HorizontalTabViewState();
}

class _HorizontalTabViewState extends State<HorizontalTabView> {
  final ValueNotifier<int> _index = ValueNotifier<int>(-1);

  animateTo(int index) {
    if (index < 0) index = 0;
    if (index >= widget.choices!.length) index = widget.choices!.length - 1;
    if (mounted) _index.value = index;
    jumpTo(index);
  }

  jumpTo(index) {
    scrollController!.animateTo(
      index * widget.tabHeight,
      duration: Duration(milliseconds: 500),
      curve: Curves.linear,
    );
  }

  Color? _iconColor;
  HorizontalTabViewSiderBarType? _sidebarType;
  ThemeData? theme;
  @override
  Widget build(BuildContext context) {
    if (_index.value < 0) _index.value = widget.activeIndex ?? 0;
    var _controller = widget.controller ?? HorizontalTabViewController();
    _controller.tabControl = this;
    ResponsiveInfo responsive = ResponsiveInfo(context);

    if (widget.isMobile ?? responsive.isSmall) return mobileBuild(context);

    _sidebarType = widget.sidebarType ??
        (widget.isMobile ?? responsive.isMobile
            ? HorizontalTabViewSiderBarType.compact
            : HorizontalTabViewSiderBarType.show);
    theme = Theme.of(context);
    _iconColor =
        widget.iconColor ?? theme!.tabBarTheme.labelColor ?? theme!.buttonColor;

    return ValueListenableBuilder(
        valueListenable: _index,
        builder: (a, b, c) {
          return Theme(
              data:
                  theme!.copyWith(scaffoldBackgroundColor: Colors.transparent),
              child: Scaffold(
                backgroundColor: widget.backgroundColor,
                appBar: widget.appBar,
                bottomNavigationBar: widget.pageBottom,
                floatingActionButton: widget.floatingActionButton,
                body: Row(
                  children: [
                    if (_sidebarType != HorizontalTabViewSiderBarType.hide)
                      buildItems(),
                    Expanded(
                      child: buildPages(),
                    ),
                    if (widget.sidebarRight != null) widget.sidebarRight!,
                  ],
                ),
              ));
        });
  }

  ScrollController? scrollController;
  bool hitTop = false;
  bool hitBottom = false;
  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController!.addListener(_scrollListener);
    Timer.run(() {
      jumpTo(widget.activeIndex);
    });
  }

  _scrollListener() {
    if (scrollController!.offset >=
            scrollController!.position.maxScrollExtent &&
        !scrollController!.position.outOfRange) {
      setState(() {
        hitBottom = true;
        hitTop = false;
      });
    }
    if (scrollController!.offset <=
            scrollController!.position.minScrollExtent &&
        !scrollController!.position.outOfRange) {
      setState(() {
        hitBottom = false;
        hitTop = true;
      });
    }
  }

  buildItems() => Container(
      // lateral
      width: [0.0, widget.minWidth, widget.width][_sidebarType!.index],
      color:
          widget.sidebarBackgroundColor ?? widget.color ?? Colors.transparent,
      child: SizedBox.expand(
        child: Scaffold(
            appBar: widget.sidebarAppBar,
            drawer: widget.sidebarDrawer,
            body: Column(
              children: [
                if (widget.sidebarHeader != null) widget.sidebarHeader!,
                Expanded(
                    child:
                        /*SingleChildScrollView(
                      key: UniqueKey(),
                      child:*/
                        Stack(
                  children: [
                    ListView(controller: scrollController, children: [
                      for (var index = 0;
                          index < widget.choices!.length;
                          index++)
                        buildItem(index)
                    ]),
                    if (hitBottom)
                      Positioned(
                        right: 0,
                        child: InkWell(
                            child: Icon(Icons.arrow_drop_up),
                            onTap: () {
                              animateTo(0);
                            }),
                      ),
                    if (hitTop)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                            child: Icon(Icons.arrow_drop_down),
                            onTap: () {
                              animateTo(99999);
                            }),
                      ),
                  ],
                )),
                if (widget.sidebarFooter != null) widget.sidebarFooter!,
              ],
            )),
      ));

  buildPages() => (widget.choices!.length == 0)
      ? Container()
      : Scaffold(

          /// paginas
          backgroundColor: Colors.transparent,
          body: Builder(builder: (x) {
            if (widget.choices![_index.value].child ==
                null) if (widget.choices![_index.value].builder != null)
              widget.choices![_index.value].child =
                  widget.choices![_index.value].builder!();
            if (widget.onChanged != null) widget.onChanged!(_index.value);
            if (widget.choices![_index.value].child == null) return Container();
            return Stack(children: [
              if (widget.topBar != null)
                Positioned(top: 0, left: 0, right: 0, child: widget.topBar!),
              Positioned(
                  top: widget.top,
                  bottom: widget.bottom,
                  left: widget.left,
                  right: widget.right,
                  child: widget.choices![_index.value].child!),
              if (widget.bottomBar != null)
                Positioned(
                    bottom: 0, left: 0, right: 0, child: widget.bottomBar!),
            ]);
          }));

  buildItem(int index) => Container(
        key: ValueKey(widget.choices![index].label ?? '$index'),
        alignment: Alignment.centerLeft,
        color:
            (_index.value == index) ? widget.indicatorColor : widget.tabColor,
        child: (_sidebarType != HorizontalTabViewSiderBarType.show)
            ? Container(
                padding: EdgeInsets.symmetric(vertical: 4),
                /* height: (_index.value == index)
                                                ? null
                                                : tabHeightCompact ?? 40,
                                           */
                child: Row(children: [
                  if (_index.value == index)
                    Container(
                        height: widget.tabHeight ?? kMinInteractiveDimension,
                        width: 5,
                        color: (_index.value == index)
                            ? widget.tagColor ?? theme!.indicatorColor
                            : widget.tabColor),
                  Expanded(
                      child: InkWell(
                          child: Container(
                              constraints: BoxConstraints(minHeight: 35),
                              color: (_index.value == index)
                                  ? widget.indicatorColor
                                  : null,
                              padding: EdgeInsets.zero,
                              child: Column(
                                children: [
                                  if (widget.choices![index].image != null)
                                    widget.choices![index].image!,
                                  if (widget.choices![index].icon != null)
                                    Icon(widget.choices![index].icon,
                                        color: _iconColor),
                                  if (_index.value == index) ...[
                                    SizedBox(height: 2),
                                    widget.choices![index].title ??
                                        Text(widget.choices![index].label!,
                                            style: (widget.tabStyle ??
                                                TextStyle(
                                                  fontSize: 14,
                                                  color: (widget.sidebarBackgroundColor ??
                                                              theme!
                                                                  .scaffoldBackgroundColor)
                                                          .isDark
                                                      ? Colors.white70
                                                      : Colors.black87,
                                                  fontWeight: FontWeight.w500,
                                                ))),
                                  ],
                                ],
                              )),
                          onTap: () {
                            _index.value = index;
                          }))
                ]))
            : Row(children: [
                Container(
                    height: widget.tabHeight ?? kToolbarHeight,
                    width: 5,
                    color: (_index.value == index)
                        ? widget.tagColor ?? theme!.indicatorColor
                        : widget.tabColor),
                Expanded(
                    child: Container(
                        height: widget.tabHeight,
                        child: ListTile(
                          leading: (widget.choices![index].image != null)
                              ? widget.choices![index].image
                              : (widget.choices![index].icon != null)
                                  ? Icon(
                                      widget.choices![index].icon,
                                      color: _iconColor,
                                    )
                                  : null,
                          title: widget.choices![index].title ??
                              Text(widget.choices![index].label!,
                                  style: widget.tabStyle ??
                                      theme!.textTheme.bodyText1!.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: (widget.sidebarBackgroundColor ??
                                                      theme!
                                                          .scaffoldBackgroundColor)
                                                  .isDark
                                              ? Colors.white70
                                              : Colors.black87)),
                          onTap: () {
                            _index.value = index;
                          },
                        ))),
              ]),
      );

  mobileBuild(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ThemeData theme = Theme.of(context);
    int cols = widget.mobileCrossCount ?? size.width ~/ 150;
    if (size.width < (widget.mobileCrossCount ?? 2))
      cols = widget.mobileCrossCount ?? 2;

    return Scaffold(
        backgroundColor: widget.backgroundColor,
        appBar: widget.appBar,
        bottomNavigationBar: widget.pageBottom,
        floatingActionButton: widget.floatingActionButton,
        body: Stack(children: [
          Center(
            child: GridView.count(
              primary: false,
              crossAxisCount: cols,
              children: List.generate(
                widget.choices!.length,
                (index) {
                  TabChoice tab = widget.choices![index];
                  return Padding(
                      padding: widget.padding ?? EdgeInsets.all(8),
                      child: InkWell(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                tab.image ??
                                    Icon(
                                      tab.icon,
                                      size: 80,
                                      color: _iconColor ??
                                          theme.primaryTextTheme.bodyText1!
                                              .color,
                                    ),
                                tab.title ??
                                    Text(
                                      tab.label!,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: _iconColor ??
                                            theme.textTheme.button!.color,
                                      ),
                                    ),
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          if (tab.primary!)
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (x) {
                                if (tab.child == null)
                                  tab.child = tab.builder!();
                                return tab.child!;
                              }),
                            );
                          else
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (x) {
                                if (tab.child == null)
                                  tab.child = tab.builder!();
                                return Scaffold(
                                  appBar: AppBar(
                                      title: tab.title ??
                                          Text(
                                            tab.label!,
                                          )),
                                  body: tab.child,
                                );
                              }),
                            );
                        },
                      ));
                },
              ),
            ),
          ),
        ]));
  }
}
