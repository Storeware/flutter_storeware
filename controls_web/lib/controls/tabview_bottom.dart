//import 'tab_choice.dart';
//import 'tabview_widget.dart';
import 'dart:async';
import 'package:controls_web/controls/tab_choice.dart';
//import 'package:controls_web/controls/tabview_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class TabViewBottom extends StatefulWidget {
  final List<TabChoice>? choices;
  final int? activeIndex;
  final Color? tabColor;
  final Color? iconColor;
  final Color? tagColor;
  final Color? color;
  final Color? indicatorColor;
  final double? tabHeight;
  final TextStyle? style;
  final Widget? leading;
  final List<Widget>? actions;
  final Widget? bottomNavigationBar;
  final Widget? appBar;
  final EdgeInsets? padding;
  final Function(int)? onChanged;
  final bool? keepPage;
  const TabViewBottom({
    Key? key,
    @required this.choices,
    this.style,
    this.activeIndex = 0,
    this.tabColor = Colors.transparent,
    this.color,
    this.keepPage = true,
    this.iconColor,
    this.padding,
    this.tagColor,
    this.indicatorColor,
    this.tabHeight = kToolbarHeight,
    this.actions,
    this.bottomNavigationBar,
    this.appBar,
    this.onChanged,
    this.leading,
  })  : assert(choices != null, 'missing choices'),
        super(key: key);

  @override
  _TabViewBottomState createState() => _TabViewBottomState();
}

class _TabViewBottomState extends State<TabViewBottom> {
  Widget getChild(int idx) {
    return widget.choices![idx].child ??= Container(
        key: ValueKey(widget.choices![idx].label ?? '$idx'),
        child: (widget.choices![idx].builder != null)
            ? widget.choices![idx].builder!()
            : Container());
  }

  //TabController tabController;
  ValueNotifier<int>? index;
  ValueNotifier<bool>? _isVisible;
  PageController? _pageController;
  ScrollController? scrollController;
  @override
  void initState() {
    super.initState();
    _isVisible = ValueNotifier<bool>(true);
    scrollController = ScrollController();
    scrollController!.addListener(_scrollListener);
    index = ValueNotifier<int>(widget.activeIndex ?? 0);
    _pageController = PageController(
      initialPage: index!.value,
      keepPage: widget.keepPage!,
    );
    Timer.run(() {
      hitTop = (bw * (length - index!.value + 1)) > size.width;
      pageTo(index!.value);
    });
  }

  get length => widget.choices!.length;
  animateTo(int idx) {
    scrollController!.animateTo(idx * bw,
        duration: Duration(milliseconds: 500), curve: Curves.linear);
  }

  pageTo(int idx) {
    if (idx < 0) idx = 0;
    if (idx >= widget.choices!.length) idx = widget.choices!.length - 1;
    if (index!.value != idx) index!.value = idx;
    animateTo(idx);
  }

  bool hitBottom = false;
  bool hitTop = false;
  Size size = Size(800, 450);
  _scrollListener() {
    if (scrollController!.offset >=
            scrollController!.position.maxScrollExtent &&
        !scrollController!.position.outOfRange) {
      setState(() {
        hitBottom = true;
        hitTop = false;
      });
      return;
    }
    if (scrollController!.offset <=
            scrollController!.position.minScrollExtent &&
        !scrollController!.position.outOfRange) {
      setState(() {
        hitBottom = false;
        hitTop = true;
      });
      return;
    }
    if (hitBottom || hitTop)
      setState(() {
        hitBottom = false;
        hitTop = false;
      });
  }

  int get activeIndex => index?.value ?? widget.activeIndex ?? 0;
  int _oldIndex = -1;
  set activeIndex(int v) {
    if (v != _oldIndex) {
      _oldIndex = v;
      if (widget.onChanged != null) widget.onChanged!(v);
    }
  }

  double bw = 60;
  //Color? _iconColor;
  ThemeData? theme;
  Color? _tagColor;
  Color? _tabColor;
  Color? _color;
  Color? _indicatorColor;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    theme = Theme.of(context);
    _color = widget.color ?? theme!.bottomAppBarColor;
    _tabColor = widget.tabColor ?? theme!.appBarTheme.color ?? Colors.amber;
    // _iconColor = theme!.tabBarTheme.labelColor ?? theme!.buttonColor;

    _indicatorColor = widget.indicatorColor ?? Colors.grey.withAlpha(20);
    _tagColor = widget.tagColor ?? theme!.indicatorColor;

    bw = size.width / ((size.width / widget.tabHeight!).floorToDouble());

    return Column(children: [
      if (widget.appBar != null) widget.appBar!,
      Expanded(
          child: PageView.builder(
        controller: _pageController,
        onPageChanged: (idx) => index!.value = idx,
        itemBuilder: (ctx, idx) => getChild(idx),
        itemCount: (widget.choices != null) ? widget.choices!.length : 0,
      )),
      ValueListenableBuilder<bool>(
        valueListenable: _isVisible!,
        builder: (a, b, c) => (!b)
            ? Container()
            : Container(
                //height: widget.tabHeight + 6,
                child: Padding(
                  padding: widget.padding ?? EdgeInsets.all(0.0),
                  child: Column(
                    children: [
                      Container(
                          height: 1,
                          color: theme!.dividerColor,
                          child: SizedBox.expand(
                              //child: Container(height: 2, color: theme.dividerColor),
                              )),
                      Container(
                          color: _color,
                          height: widget.tabHeight,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (widget.leading != null) widget.leading!,
                              Expanded(
                                child: Stack(
                                  children: [
                                    if (hitBottom)
                                      Positioned(
                                        left: -7,
                                        top: -7,
                                        child: Icon(Icons.arrow_left),
                                      ),
                                    if (hitTop)
                                      Positioned(
                                        right: -7,
                                        top: -7,
                                        child: Icon(Icons.arrow_right),
                                      ),
                                    buildItems(),
                                  ],
                                ),
                              ),
                              if (widget.actions != null) ...widget.actions!
                            ],
                          )),
                      if (widget.bottomNavigationBar != null)
                        widget.bottomNavigationBar!,
                    ],
                  ),
                ),
              ),
      )
    ]);
  }

  buildItems() =>
      /*LayoutBuilder(builder: (_, constraints) {
        bw = constraints.maxWidth /
            ((constraints.maxWidth / constraints.maxHeight).floorToDouble());

        return */
      ListView.builder(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: widget.choices!.length,
        itemBuilder: (ctx, i) {
          var choice = widget.choices![i];
          return ValueListenableBuilder<int>(
            valueListenable: index!,
            builder: (BuildContext context, int idx, Widget? child) {
              activeIndex = idx;
              return Padding(
                padding: const EdgeInsets.only(
                    left: 0.0, right: 0, top: 2.0, bottom: 2.0),
                child: InkWell(
                  onTap: () {
                    _pageController!.animateToPage(i,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.ease);
                  },
                  child: Container(
                      //width: bw+8,
                      padding: const EdgeInsets.only(
                          left: 2.0, bottom: 1, right: 2.0, top: 2.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: (idx == i) ? _indicatorColor : _tabColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (choice.image != null)
                            Flexible(
                                flex: 2,
                                child: (idx == i)
                                    ? SelectedItemAvatar(
                                        child: (choice.icon != null)
                                            ? Icon(choice.icon)
                                            : choice.image,
                                      )
                                    : Center(
                                        child: Padding(
                                            padding: EdgeInsets.all(2),
                                            child: (choice.icon != null)
                                                ? Icon(choice.icon)
                                                : choice.image),
                                      )),
                          if (choice.label != null || choice.title != null)
                            Flexible(
                              flex: 1,
                              child: Container(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (choice.title != null) choice.title!,
                                    if (choice.label != null)
                                      Expanded(
                                          child: Text(choice.label!,
                                              overflow: TextOverflow.ellipsis,
                                              style: widget.style ??
                                                  TextStyle(
                                                    fontSize:
                                                        (idx == i) ? 12 : 11,
                                                    color:
                                                        (theme!.scaffoldBackgroundColor)
                                                                .isDark
                                                            ? Colors.white70
                                                            : Colors.black87,
                                                    fontWeight: FontWeight.w500,
                                                  ))),
                                    SizedBox(
                                      height: 1,
                                    ),
                                    Container(
                                        height: 2,
                                        width: choice.width ?? bw,
                                        color: (idx == i) ? _tagColor : null)
                                  ],
                                ),
                              ),
                            ),
                        ],
                      )),
                ),
              );
            },
          );
        },
      );
  //    });

}

class SelectedItemAvatar extends StatelessWidget {
  final Widget? child;
  const SelectedItemAvatar({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      child: child,
    );
  }
}
