import 'package:flutter/material.dart';

class SliverContents extends StatefulWidget {
  final Widget appBar;
  final List<Widget> children;
  final List<Widget> grid;
  final List<Widget> slivers;
  final Widget body;
  final Widget bottonBar;
  final int crossAxisCount;
  final Axis scrollDirection;
  final int itemCount;
  final Function builder;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
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
      this.crossAxisSpacing = 2.0,
      this.mainAxisSpacing = 2.0,
      this.slivers,
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
          child: Column(children: [
        widget.appBar ?? Container(),
        widget.body ?? Container(),
        ...items ?? [],
        ...widget.children ?? []
      ])),
      ...(widget.slivers ?? []),
      widget.grid != null
          ? SliverGrid.count(
              crossAxisCount: widget.crossAxisCount,
              children: widget.grid,
              crossAxisSpacing: widget.crossAxisSpacing ,
              mainAxisSpacing: widget.mainAxisSpacing ,
            )
          : SliverToBoxAdapter(child: Container()),
      SliverToBoxAdapter(
        child: widget.bottonBar,
      ),
    ]);
  }
}

createBoxDecoration({radius = 10.0, color = Colors.white}) => BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF656565).withOpacity(0.15),
            blurRadius: 4.0,
            spreadRadius: 1.0,
          )
        ]);

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
  final Function onPressed;
  final padding;
  const ApplienceTile(
      {Key key,
      this.padding,
      this.color,
      this.top = 10,
      this.left = 10,
      this.title,
      this.onPressed,
      this.titleStyle,
      this.titleFontSize = 18,
      this.value,
      this.valueStyle,
      this.valueFontSize = 28,
      this.image,
      this.body,
      this.appBar,
      this.bottomBar,
      this.elevation = 0.0,
      this.height,
      this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    List<Widget> items = [];
    if (value != null)
      items.add(Text(value,
          style: valueStyle ??
              TextStyle(
                  color: theme.primaryColor,
                  fontSize: valueFontSize,
                  fontWeight: FontWeight.w200)));
    if (body != null) items.add(body);

    if (title != null)
      items.add(Text(title,
          textAlign: TextAlign.center,
          style: titleStyle ??
              TextStyle(fontFamily: 'Sans', fontSize: titleFontSize, fontWeight: FontWeight.w500)));

    return Container(
      padding: padding,
      decoration: createBoxDecoration(color:color),
      height: height,
      width: width,
      child: InkWell(
          onTap: onPressed,
          child: Container(
              //elevation: elevation,
              //color: color,
              child: Stack(children: [
                Positioned(
                  left: left,
                  top: top,
                  child: image ?? Container(),
                ),
                Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        appBar ?? Container(),
                        ...items,
                        bottomBar ?? Container()
                      ]),
                )
              ]))),
    );
  }
}
