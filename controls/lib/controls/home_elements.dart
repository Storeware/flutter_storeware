import 'package:flutter/material.dart';

class SliverContents extends StatefulWidget {
  final Widget appBar;
  final List<Widget> children;
  final List<Widget> grid;
  final Widget body;
  final Widget bottonBar;
  final int crossAxisCount;
  final Axis scrollDirection;
  final int itemCount;
  final Function builder;
  SliverContents(
      {Key key,
      this.children,
      this.appBar,
      this.body,
      this.bottonBar,
      this.grid,
      this.itemCount = 0,
      this.builder,
      this.crossAxisCount = 2,
      this.scrollDirection = Axis.vertical})
      : super(key: key);

  _SliverContentsState createState() => _SliverContentsState();
}

class _SliverContentsState extends State<SliverContents> {
  @override
  Widget build(BuildContext context) {
    List<Widget> items = [];
    if (widget.builder != null)
      for (var i = 0; i < widget.itemCount; i++) {
        items.add(widget.builder(i));
      }
    return CustomScrollView(scrollDirection: widget.scrollDirection, slivers: [
      SliverToBoxAdapter(
        child: widget.appBar,
      ),
      SliverToBoxAdapter(child: widget.body),
      SliverToBoxAdapter(child: Column(children: items)),
      SliverToBoxAdapter(
        child: Column(children: widget.children ?? []),
      ),
      widget.grid != null
          ? SliverGrid.count(
              crossAxisCount: widget.crossAxisCount,
              children: widget.grid,
            )
          : SliverToBoxAdapter(child: Container()),
      SliverToBoxAdapter(
        child: widget.bottonBar,
      ),
    ]);
  }
}

class ApplienceTile extends StatelessWidget {
  final Widget image;
  final String title;
  final TextStyle titleStyle;
  final Widget body;
  final double elevation;
  final String value;
  final TextStyle valueStyle;
  final Color color;
  final double titleFontSize;
  final double valueFontSize;
  final double height;
  final double width;
  final double top;
  final double left;
  final Widget appBar;
  final Widget bottomBar;
  const ApplienceTile(
      {Key key,
      this.color,
      this.top=10,
      this.left=10,
      this.title,
      this.titleStyle,
      this.titleFontSize = 54,
      this.value,
      this.valueStyle,
      this.valueFontSize = 18,
      this.image,
      this.body,
      this.appBar,
      this.bottomBar,
      this.elevation = 0.0, this.height, this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    List<Widget> items = [];
    if (value != null)
      items.add(Text(value,
          style: valueStyle??
              TextStyle(color: theme.primaryColor, fontSize: titleFontSize, fontWeight: FontWeight.w200)));
    if (body != null) items.add(body);

    if (title != null)
      items.add(Text(title,
          style: titleStyle??
              TextStyle(fontSize: valueFontSize, fontWeight: FontWeight.w500)));

    return  Container(
      height: height,
      width: width,
      child: Card(
          elevation: elevation,
          color: color,
          child: Stack(children: [
            Positioned(
              left: left,
              top: top,
              child: image ?? Container(),
            ),
            Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [appBar??Container(),...items, bottomBar??Container() ]),
            )
          ])),
    );
  }
}
