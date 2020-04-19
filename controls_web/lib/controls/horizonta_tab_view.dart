import 'dart:async';

import 'package:flutter/material.dart';
import 'sidebar.dart';

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

class HorizontalPageTabView extends StatefulWidget {
  final List<TabChoice> choices;
  final PageTabViewController controller;
  final int initialIndex;
  final Widget title;
  final List<Widget> actions;
  final double elevation;
  final SidebarController sidebarController;
  final Color tabColor;
  final Widget tabTitle;
  final List<Widget> tabActions;
  final double tabHeight;
  final Widget tabLeading;
  final bool isScrollable;
  final bool compacted;
  final Widget Function(TabController, TabChoice, int) tabBuilder;
  final Color iconColor;
  final Color indicatorColor;
  final Widget bottomNavigationBar;
  final Widget pageBottom;
  final AppBar pageAppBar;
  final Widget floatingActionButton;
  final Widget leading;
  final Widget appBar;
  final Size preferredSize;
  final bool automaticallyImplyLeading;
  final EdgeInsets bodyPadding;
  HorizontalPageTabView({
    this.title,
    this.appBar,
    this.pageAppBar,
    this.pageBottom,
    this.tabBuilder,
    this.sidebarController,
    this.elevation = 0.0,
    this.leading,
    this.compacted = false,
    this.automaticallyImplyLeading = true,
    this.actions,
    this.bodyPadding,
    this.isScrollable = false,
    @required this.choices,
    this.initialIndex = 0,
    this.tabColor = Colors.blue,
    this.indicatorColor = Colors.indigo,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.iconColor = Colors.white,
    this.tabHeight = 55,
    this.tabActions,
    this.tabTitle,
    this.preferredSize,
    this.tabLeading,
    this.controller,
  });
  _HorizontalTabBarViewState createState() => _HorizontalTabBarViewState();
}

class _HorizontalTabBarViewState extends State<HorizontalPageTabView>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  ThemeData theme;
  SidebarController sidebarController;
  @override
  void initState() {
    sidebarController = widget.sidebarController ?? SidebarController();
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

  void _nextPage({int delta = 0, int to}) {
    int newIndex = _tabController.index + delta;
    if (to != null) newIndex = to;
    if (newIndex < 0 || newIndex >= _tabController.length) return;
    _tabController.animateTo(newIndex);
    indexSelected = newIndex;
    tabChangeEvent.sink.add(newIndex);
  }

  List<Widget> _pages() {
    List<Widget> rt = [];
    if (widget.choices != null)
      widget.choices.forEach((c) {
        rt.add(Scaffold(
          appBar: c.appBar ?? widget.pageAppBar,
          body: c.child,
          bottomNavigationBar: c.bottomNavigationBar ?? widget.pageBottom,
        ));
      });
    return rt;
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return Container(
      child: SidebarScaffold(
        controller: sidebarController,
        sidebarVisible: true,
        canShowCompact: true,
        sidebarPosition: SidebarPosition.left,
        appBar: widget.appBar ??
            AppBar(
              leading: IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  sidebarController.showCompact(
                      compact: !sidebarController.compacted);
                  tabChangeEvent.sink.add(indexSelected);
                },
              ),
              title: widget.title,
              elevation: widget.elevation,
            ),
        sidebar: SidebarContainer(
            compact: widget.compacted,
            compactWidth: 60,
            controller: sidebarController,
            width: sidebarController.width,
            child: ListView(
              children: [
                for (int i = 0; i < widget.choices.length; i++)
                  Column(
                    children: <Widget>[
                      StreamBuilder<int>(
                          stream: tabChangeEvent.stream,
                          initialData: indexSelected,
                          builder: (context, snapshot) {
                            TabChoice tab = widget.choices[i];
                            return Container(
                              color: (snapshot.data == i)
                                  ? widget.indicatorColor
                                  : widget.tabColor,
                              child: ListTile(
                                title: sidebarController.compacted
                                    ? null
                                    : Text(tab.title,
                                        style: TextStyle(
                                          color: widget.iconColor,
                                        )),
                                leading: (tab.icon != null)
                                    ? Icon(
                                        tab.icon,
                                        color: widget.iconColor,
                                      )
                                    : null,
                                onTap: () {
                                  _tabController.animateTo(i);
                                },
                              ),
                            );
                          }),
                    ],
                  )
              ],
            )),
        sidebarColor: widget.tabColor,
        body: Padding(
          padding: widget.bodyPadding ?? EdgeInsets.all(8.0),
          child: TabBarView(
            controller: _tabController, //_pageController,
            children: _pages(),
          ),
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
  const TabChoice({
    this.iconColor,
    this.index,
    this.title,
    this.icon,
    this.image,
    this.width,
    this.child,
    this.appBar,
    this.bottomNavigationBar,
  });
  final double width;
  final String title;
  final IconData icon;
  final Widget child;
  final Widget image;
  final Color iconColor;
  final AppBar appBar;
  final Widget bottomNavigationBar;
}
