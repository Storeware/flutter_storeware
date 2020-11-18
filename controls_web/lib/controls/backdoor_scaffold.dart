import 'package:flutter/material.dart';

class BackdoorScaffold extends StatelessWidget {
  final Widget body;
  final Size preferredSize;
  final List<Widget> appBarChildren;
  final List<Widget> children;
  final Drawer drawer;
  final Widget bottomNavigationBar;
  final Widget title;
  final double expandedHeight;
  final List<Widget> slivers;
  final bool extendBody;
  final AppBar appBar;
  final Widget bottomSheet;
  BackdoorScaffold(
      {Key key,
      this.body,
      this.drawer,
      this.bottomNavigationBar,
      this.children,
      this.appBarChildren,
      this.title,
      this.expandedHeight,
      this.slivers,
      this.extendBody = false,
      this.appBar,
      this.bottomSheet,
      this.preferredSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      extendBody: extendBody,
      body: CustomScrollView(
        slivers: [
          if (appBarChildren != null)
            SliverAppBar(
                floating: true,
                pinned: false,
                expandedHeight:
                    (appBar == null) ? 0 : expandedHeight ?? kToolbarHeight,
                bottom: PreferredSize(
                  preferredSize: preferredSize ?? Size.fromHeight(125),
                  child: Stack(children: [
                    ...appBarChildren,
                  ]),
                )),
          if (children != null)
            SliverToBoxAdapter(
                child: Stack(
              children: [if (body != null) body, ...children],
            )),
          if (slivers != null) ...slivers,
        ],
      ),
      drawer: drawer,
      bottomNavigationBar: bottomNavigationBar,
      bottomSheet: bottomSheet,
      //bottom : bottom,
    );
  }
}
