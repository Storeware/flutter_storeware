import 'package:flutter/material.dart';

class PageTabView extends StatefulWidget {
  final List<TabChoice> choices;
  final int initialIndex;
  final Widget title;
  final List<Widget> actions;
  final double elevation;
  final Color tabColor;
  final Color indicatorColor;
  final Widget bottomNavigationBar;
  final Widget floatingActionButton;
  final Widget leading;
  final bool automaticallyImplyLeading;
  PageTabView({
    this.title,
    this.elevation = 8.0,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.actions,
    @required this.choices,
    this.initialIndex = 0,
    this.tabColor,
    this.indicatorColor,
    this.floatingActionButton,
    this.bottomNavigationBar,
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
    _tabController = TabController(vsync: this, length: widget.choices.length);
    _tabController.addListener(_nextPage);
  }

  @override
  void dispose() {
    _tabController.removeListener(_nextPage);
    _tabController.dispose();
    super.dispose();
  }

  void _nextPage() {
    var delta = 0;
    final int newIndex = _tabController.index + delta;
    if (newIndex < 0 || newIndex >= _tabController.length) return;
    _tabController.animateTo(newIndex);
    // _pageController.animateToPage(newIndex,
    //     duration: Duration(milliseconds: 300), curve: Curves.ease);
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
              child: DefaultTabController(
                  length: widget.choices.length,
                  initialIndex: widget.initialIndex,
                  child: TabBar(
                      indicator: BoxDecoration(color: widget.tabColor),
                      indicatorColor: widget.indicatorColor,
                      controller: _tabController,
                      tabs: widget.choices.map((choice) {
                        //print(choice.title);
                        return Tab(
                          //child: Container(color:Colors.yellow,child:Text(choice.title)),
                          text: choice.title,
                          icon: Icon(choice.icon),
                        );
                      }).toList())),
              preferredSize: Size.fromHeight(60.0),
            )),
        body: TabBarView(
          controller: _tabController, //_pageController,
          children: _pages(),
        ),
        bottomNavigationBar: widget.bottomNavigationBar,
        floatingActionButton:widget.floatingActionButton,
      ),
    );
  }
}

/*
 --------------------------------------------------------------------------
 */
class TabChoice {
  const TabChoice({this.title, this.icon, this.child});
  final String title;
  final IconData icon;
  final Widget child;
}
