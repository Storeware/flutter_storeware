import 'dart:async';

import 'package:flutter/material.dart';

class PageTabViewController {
  TabController tabController;

  animateTo(index) {
    tabController.animateTo(index);
  }

  next() {
    tabController.animateTo(tabController.index + 1);
  }

  previus() {
    tabController.animateTo(tabController.previousIndex);
  }
}

class PageTabView extends StatefulWidget {
  final List<TabChoice> choices;
  final PageTabViewController controller;
  final int initialIndex;
  final Widget title;
  final List<Widget> actions;
  final double elevation;
  final Color tabColor;
  final Widget tabTitle;
  final List<Widget> tabActions;
  final double tabHeight;
  final Widget tabLeading;
  final Widget Function(TabController, TabChoice, int) tabBuilder;
  final Color iconColor;
  final Color indicatorColor;
  final Widget bottomNavigationBar;
  final Widget floatingActionButton;
  final Widget leading;
  final Widget topBar;
  final Size preferredSize;
  final bool automaticallyImplyLeading;
  PageTabView({
    this.title,
    this.topBar,
    this.tabBuilder,
    this.elevation = 1.0,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.actions,
    @required this.choices,
    this.initialIndex = 0,
    this.tabColor = Colors.white,
    this.indicatorColor = Colors.blue,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.iconColor,
    this.tabHeight = 42,
    this.tabActions,
    this.tabTitle,
    this.preferredSize,
    this.tabLeading,
    this.controller,
  });
  _TabBarViewState createState() => _TabBarViewState();
}

class _TabBarViewState extends State<PageTabView>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  //PageController _pageController = PageController();
  ThemeData theme;
  @override
  void initState() {
    super.initState();
    indexSelected = widget.initialIndex;
    _tabController = TabController(vsync: this, length: widget.choices.length);
    _tabController.addListener(_nextPage);
    if (widget.controller != null) {
      widget.controller.tabController = _tabController;
    }
  }

  var tabChangeEvent = StreamController<int>.broadcast();
  @override
  void dispose() {
    _tabController.removeListener(_nextPage);
    _tabController.dispose();
    tabChangeEvent.close();
    super.dispose();
  }

  int indexSelected;
  void _nextPage() {
    var delta = 0;
    final int newIndex = _tabController.index + delta;
    if (newIndex < 0 || newIndex >= _tabController.length) return;
    _tabController.animateTo(newIndex);
    indexSelected = newIndex;
    tabChangeEvent.sink.add(newIndex);
  }

  List<Widget> _pages() {
    List<Widget> rt = [];
    if (widget.choices != null)
      widget.choices.forEach((c) {
        rt.add(c.child);
      });
    return rt;
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return Container(
      child: Scaffold(
        appBar: AppBar(
            title: widget.title,
            elevation: widget.elevation,
            leading: widget.leading,
            automaticallyImplyLeading: widget.automaticallyImplyLeading,
            actions: widget.actions,
            bottom: PreferredSize(
              child: Column(children: [
                if (widget.topBar != null) widget.topBar,
                (widget.tabBuilder != null)
                    ? Row(
                        children: <Widget>[
                          if (widget.tabLeading != null) widget.tabLeading,
                          Expanded(
                            child: Container(
                                height: widget.tabHeight,
                                constraints: BoxConstraints(maxWidth: 2000),
                                child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      for (int i = 0;
                                          i < widget.choices.length;
                                          i++)
                                        Container(
                                            width:
                                                widget.choices[i].width ?? 42,
                                            child: Column(
                                              children: <Widget>[
                                                Expanded(
                                                  child: widget.tabBuilder(
                                                      _tabController,
                                                      widget.choices[i],
                                                      i),
                                                ),
                                                StreamBuilder<int>(
                                                    stream:
                                                        tabChangeEvent.stream,
                                                    initialData: indexSelected,
                                                    builder:
                                                        (context, snapshot) {
                                                      //print(snapshot.data);
                                                      return Container(
                                                        height: 2,
                                                        constraints:
                                                            BoxConstraints(
                                                                maxWidth: 2000),
                                                        color: (snapshot.data ==
                                                                i)
                                                            ? widget.tabColor
                                                            : widget
                                                                .indicatorColor,
                                                        //child:
                                                      );
                                                    })
                                              ],
                                            )),
                                      if (widget.tabTitle != null)
                                        widget.tabTitle,
                                    ])),
                          ),
                          for (var item in widget.tabActions ?? []) item
                        ],
                      )
                    : DefaultTabController(
                        length: widget.choices.length,
                        initialIndex: widget.initialIndex,
                        child: TabBar(
                            indicator: BoxDecoration(color: widget.tabColor),
                            indicatorColor: widget.indicatorColor,
                            controller: _tabController,
                            tabs: widget.choices.map((choice) {
                              return Tab(
                                iconMargin: EdgeInsets.only(bottom: 5),
                                child: Text(choice.title ?? '',
                                    style: TextStyle(
                                        color: choice.iconColor ??
                                            widget.iconColor)),
                                icon: choice.image ??
                                    Icon(choice.icon ?? Icons.more_vert,
                                        color: choice.iconColor ??
                                            widget.iconColor),
                              );
                            }).toList())),
              ]),
              preferredSize:
                  widget.preferredSize ?? Size.fromHeight(widget.tabHeight),
            )),
        body: TabBarView(
          controller: _tabController, //_pageController,
          children: _pages(),
        ),
        bottomNavigationBar: widget.bottomNavigationBar,
        floatingActionButton: widget.floatingActionButton,
      ),
    );
  }
}

/*
 --------------------------------------------------------------------------
 */
class TabChoice {
  final int index;
  const TabChoice(
      {this.iconColor,
      this.index,
      this.title,
      this.icon,
      this.image,
      this.width,
      this.child});
  final double width;
  final String title;
  final IconData icon;
  final Widget child;
  final Widget image;
  final Color iconColor;
}
