import 'package:flutter/material.dart';

class BackdoorScaffold extends StatelessWidget {
  final Widget body;
  final Size preferredSize;
  final Widget appBarChild;
  final List<Widget> children;
  final Drawer drawer;
  final Widget bottomNavigationBar;
  final Widget title;
  final double expandedHeight;
  final List<Widget> slivers;
  final bool extendBody;
  final AppBar appBar;
  final Widget bottomSheet;
  final Widget floatingActionButton;
  final bool pinned;
  BackdoorScaffold(
      {Key key,
      this.body,
      this.drawer,
      this.bottomNavigationBar,
      this.children,
      this.appBarChild,
      this.title,
      this.expandedHeight,
      this.slivers,
      this.extendBody = false,
      this.appBar,
      this.pinned = false,
      this.bottomSheet,
      this.floatingActionButton,
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
                pinned: pinned,
                expandedHeight:
                    (appBar == null) ? 0 : expandedHeight ?? kToolbarHeight,
                bottom: PreferredSize(
                  preferredSize: preferredSize ?? Size.fromHeight(125),
                  child: appBarChild,
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
      floatingActionButton: floatingActionButton,
      //bottom : bottom,
    );
  }
}
