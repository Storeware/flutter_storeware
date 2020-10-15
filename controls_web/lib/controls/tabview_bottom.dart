//import 'tab_choice.dart';
//import 'tabview_widget.dart';
import 'package:controls_web/controls/tab_choice.dart';
import 'package:controls_web/controls/tabview_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class TabViewBottom extends StatefulWidget {
  final List<TabChoice> choices;
  final int activeIndex;
  final Color tabColor;
  final Color iconColor;
  final Color tagColor;
  final Color color;
  final Color indicatorColor;
  final double tabHeight;
  final TextStyle style;
  final List<Widget> actions;
  final Widget bottomNavigationBar;
  final Widget appBar;
  final EdgeInsets padding;
  final Function(int) onChanged;
  final bool keepPage;
  const TabViewBottom({
    Key key,
    this.choices,
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
  }) : super(key: key);

  @override
  _TabViewBottomState createState() => _TabViewBottomState();
}

class _TabViewBottomState extends State<TabViewBottom> {
  Widget getChild(int idx) {
    return widget.choices[idx].child ??= Container(
        key: ValueKey(widget.choices[idx].label ?? '$idx'),
        child: widget.choices[idx].builder());
  }

  //TabController tabController;
  ValueNotifier<int> index;
  ValueNotifier<bool> _isVisible;
  PageController _pageController;
  ScrollController scrollController;
  @override
  void initState() {
    super.initState();
    _isVisible = ValueNotifier<bool>(true);
    scrollController = ScrollController();
    scrollController.addListener(() {
      setState(() {
        _isVisible.value = scrollController.position.userScrollDirection ==
            ScrollDirection.forward;
      });
    });
    index = ValueNotifier<int>(widget.activeIndex ?? 0);
    _pageController = PageController(
      initialPage: index.value,
      keepPage: widget.keepPage,
    );
  }

  int get activeIndex => index?.value ?? widget.activeIndex ?? 0;
  int _oldIndex = -1;
  set activeIndex(int v) {
    if (v != _oldIndex) {
      _oldIndex = v;
      if (widget.onChanged != null) widget.onChanged(v);
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color _color = widget.color ?? theme.bottomAppBarColor;
    Color _tabColor =
        widget.tabColor ?? theme.appBarTheme.color ?? Colors.amber;
    Color _iconColor = widget.iconColor ?? theme.tabBarTheme.labelColor;
    Color _indicatorColor = widget.indicatorColor ?? Colors.grey.withAlpha(20);
    Color _tagColor = widget.tagColor ?? theme.indicatorColor;
    return Column(children: [
      if (widget.appBar != null) widget.appBar,
      Expanded(
          child: PageView.builder(
        controller: _pageController,
        onPageChanged: (idx) => index.value = idx,
        itemBuilder: (ctx, idx) => getChild(idx),
        itemCount: widget.choices.length,
      )),
      ValueListenableBuilder<bool>(
        valueListenable: _isVisible,
        builder: (a, b, c) => (!b)
            ? Container()
            : Container(
                height: 60,
                child: Padding(
                  padding: widget.padding ?? EdgeInsets.all(0.0),
                  child: Column(
                    children: [
                      Container(
                          height: 1,
                          color: theme.dividerColor,
                          child: SizedBox.expand(
                              //child: Container(height: 2, color: theme.dividerColor),
                              )),
                      Container(
                          color: _color,
                          height: widget.tabHeight,
                          child: Row(children: [
                            Expanded(
                                child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: widget.choices.length,
                              itemBuilder: (ctx, i) {
                                var choice = widget.choices[i];
                                return ValueListenableBuilder<int>(
                                  valueListenable: index,
                                  builder: (BuildContext context, int idx,
                                      Widget child) {
                                    activeIndex = idx;
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          left: 0.0,
                                          right: 0,
                                          top: 2.0,
                                          bottom: 2.0),
                                      child: InkWell(
                                        onTap: () {
                                          _pageController.animateToPage(i,
                                              duration:
                                                  Duration(milliseconds: 500),
                                              curve: Curves.ease);
                                        },
                                        child: Container(
                                            padding: const EdgeInsets.only(
                                                left: 2.0,
                                                bottom: 2,
                                                right: 2.0,
                                                top: 2.0),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: (idx == i)
                                                  ? _indicatorColor
                                                  : _tabColor,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                if (choice.image != null)
                                                  Flexible(
                                                      flex: 2,
                                                      child: Center(
                                                        child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    2),
                                                            child: (choice
                                                                        .icon !=
                                                                    null)
                                                                ? Icon(
                                                                    choice.icon)
                                                                : choice.image),
                                                      )),
                                                if (choice.label != null ||
                                                    choice.title != null)
                                                  Flexible(
                                                    flex: 1,
                                                    child: Container(
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          if (choice.title !=
                                                              null)
                                                            choice.title,
                                                          if (choice.label !=
                                                              null)
                                                            Expanded(
                                                                child: Text(
                                                                    choice
                                                                        .label,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: widget
                                                                            .style ??
                                                                        theme
                                                                            ?.tabBarTheme
                                                                            ?.labelStyle
                                                                            ?.copyWith(
                                                                                color:
                                                                                    _iconColor) ??
                                                                        theme.textTheme.caption.copyWith(
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                _iconColor))),
                                                          Container(
                                                              height: 2,
                                                              width: choice
                                                                      .width ??
                                                                  60,
                                                              color: (idx == i)
                                                                  ? _tagColor
                                                                  : null)
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
                            )),
                            if (widget.actions != null) ...widget.actions
                          ])),
                      if (widget.bottomNavigationBar != null)
                        widget.bottomNavigationBar,
                    ],
                  ),
                ),
              ),
      )
    ]);
  }
}
