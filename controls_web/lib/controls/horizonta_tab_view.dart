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
  final bool isMobile;
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
    this.isMobile = false,
    @required this.choices,
    this.initialIndex = 0,
    this.tabColor,
    this.indicatorColor,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.iconColor,
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
  Color _tabColor;
  Color _indicatorColor;
  Color _iconColor;
  @override
  void initState() {
    sidebarController = widget.sidebarController ?? SidebarController();
    sidebarController.isMobile = widget.isMobile;
    if (widget.isMobile) sidebarController.compactSize = 50;
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

  Color _sidebarColor;
  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);

    _tabColor = widget.tabColor ?? theme.buttonTheme.colorScheme.secondary;
    _indicatorColor = widget.indicatorColor ?? theme.primaryColorDark;
    _iconColor = widget.iconColor ?? theme.primaryTextTheme.bodyText1.color;
    _sidebarColor = sidebarController.color ?? theme.primaryColorLight;

    return Container(
      child: SidebarScaffold(
        controller: sidebarController,
        sidebarVisible: sidebarController.visible,
        canShowCompact: sidebarController.canShowCompact,
        sidebarPosition: SidebarPosition.left,
        appBar: widget.appBar ??
            PreferredSize(
                preferredSize: Size.fromHeight(
                    widget.isMobile ? 40 : 56), // here the desired height
                child: AppBar(
                  leading: IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      if (!sidebarController.canShowCompact) {
                        (sidebarController.visible)
                            ? sidebarController.hide()
                            : sidebarController.show();
                      } else
                        sidebarController.showCompact(
                            compact: !sidebarController.compacted);
                      tabChangeEvent.sink.add(indexSelected);
                    },
                  ),
                  title: widget.title,
                  elevation: widget.elevation,
                )),
        sidebar: StreamBuilder<Object>(
            initialData: sidebarController.visible,
            stream: sidebarController.visibleStream,
            builder: (context, snapshot) {
              return DefaultTextStyle(
                  style: theme.primaryTextTheme.bodyText1,
                  child: SidebarContainer(
                      compact: widget.compacted,
                      compactWidth: sidebarController.compactSize,
                      controller: sidebarController,
                      width: sidebarController.width,
                      child: ListView(
                        padding: widget.isMobile ? EdgeInsets.zero : null,
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
                                            ? _indicatorColor
                                            : _tabColor,
                                        child: (tab.primary ||
                                                (sidebarController.compacted &&
                                                    widget.isMobile))
                                            ? IconButton(
                                                icon: Icon(
                                                  tab.icon,
                                                  color: _iconColor,
                                                ),
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (x) =>
                                                              tab.child));
                                                  //_tabController.animateTo(i);
                                                })
                                            : ListTile(
                                                title:
                                                    sidebarController.compacted
                                                        ? null
                                                        : Text(tab.title,
                                                            style: TextStyle(
                                                              color: _iconColor,
                                                            )),
                                                leading: (tab.icon != null)
                                                    ? Icon(
                                                        tab.icon,
                                                        color: _iconColor,
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
                      )));
            }),
        sidebarColor: _sidebarColor,
        body: Padding(
          padding: widget.bodyPadding ?? EdgeInsets.all(8.0),
          child: TabBarView(
            controller: _tabController, //_pageController,
            children: _pages(),
          ),
        ),
        bottomNavigationBar: (widget.bottomNavigationBar != null)
            ? DefaultTextStyle(
                style: theme.primaryTextTheme.bodyText1,
                child: widget.bottomNavigationBar)
            : null,
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
    this.primary = false,
    this.bottomNavigationBar,
  });
  final bool primary;
  final double width;
  final String title;
  final IconData icon;
  final Widget child;
  final Widget image;
  final Color iconColor;
  final AppBar appBar;
  final Widget bottomNavigationBar;
}
