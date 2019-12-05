import 'package:flutter/material.dart';

import 'sliver_scaffold.dart';

class DashboardView extends StatefulWidget {
  final Color backgroundColor;
  final List<Widget> cards;
  final AppBar appBar;
  final List<Widget> listView;
  //final double gridMaxCrossAxisExtend;
  final int gridCrossAxisCount;
  final double gridChildAspectRatio;
  final Color cardColor;
  final double cardElevation;
  final double cardMargin;
  final double radius;
  final double topRadius;
  final double bottomRadius;
  final WidgetListBuilderContext gridBuilder;
  final Widget floatingActionButton;
  final Widget bottomNavigationBar;
  DashboardView(
      {this.appBar,
      this.cards,
      this.backgroundColor,
      this.radius = 0.0,
      this.topRadius = 0.0,
      this.bottomRadius = 0.0,
      //this.gridMaxCrossAxisExtend = 200.0,
      this.gridCrossAxisCount = 2,
      this.gridChildAspectRatio = 1.5,
      this.cardColor,
      this.cardElevation = 1.0,
      this.cardMargin = 4.0,
      this.gridBuilder,
      this.listView,
      this.floatingActionButton,
      this.bottomNavigationBar});

  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  _gridBuilder(context, index) {
    return Card(
        margin: EdgeInsets.all(widget.cardMargin),
        elevation: widget.cardElevation,
        color: widget.cardColor,
        child: widget.cards[index]);
  }

  @override
  Widget build(BuildContext context) {
    return SliverScaffold(
        backgroundColor: widget.backgroundColor,
        appBar: widget.appBar,
        radius: widget.radius,
        topRadius: widget.topRadius,
        bottomRadius: widget.bottomRadius,
        grid: WidgetList.count(context, itemCount: widget.cards.length,
            itemBuilder: (context, index) {
          return (widget.gridBuilder != null
              ? widget.gridBuilder(context, index)
              : _gridBuilder(context, index));
        }),
        //gridMaxCrossAxisExtend: widget.gridMaxCrossAxisExtend,
        gridCrossAxisCount: widget.gridCrossAxisCount,
        gridCrossAxisSpacing: 10.0,
        gridMainAxisSpacing: 10.0,
        gridChildAspectRatio: widget.gridChildAspectRatio,
        floatingActionButton: widget.floatingActionButton,
        bottomNavigationBar: widget.bottomNavigationBar,
        body: ListView(children: widget.listView ?? []));
  }
}
