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
              crossAxisSpacing: widget.crossAxisSpacing,
              mainAxisSpacing: widget.mainAxisSpacing,
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
  final Widget topBar;
  final double dividerHeight;
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
      this.titleFontSize = 16,
      this.value,
      this.valueStyle,
      this.valueFontSize = 54,
      this.image,
      this.body,
      this.appBar,
      this.topBar,
      this.bottomBar,
      this.elevation = 0.0,
      this.height,
      this.dividerHeight = 0,
      this.width})
      : super(key: key);

  static status(
      {Widget image, String value, String title, Color color, double width}) {
    return ApplienceTile(
      value: value,
      title: title,
      color: color,
      image: image,
      valueStyle: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold),
      titleStyle: TextStyle(color: Colors.white, fontSize:18),
      width: width,
    );
  }

  static panel(
      {Widget image, String value, String title, Color color, double width}) {
    return ApplienceTile(
      value: value,
      title: title,
      color: color,
      image: image,
      valueStyle: TextStyle(color:Colors.white,fontSize: 54,fontFamily: 'Raleway', fontWeight: FontWeight.bold),
      titleStyle: TextStyle(color:Colors.white,fontSize:18),
      width: width,
    );
  }


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
              TextStyle(
                  fontFamily: 'Sans',
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.w500)));

    return Container(
      padding: padding,
      decoration: createBoxDecoration(color: color),
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
                    if (topBar != null) topBar,
                    if (dividerHeight > 0)
                      Container(
                        height: dividerHeight,
                        color: Colors.black54,
                        width: double.infinity,
                      ),
                    ...items,
                    bottomBar ?? Container()
                  ]),
            )
          ]))),
    );
  }
}


class ApplienceTicket extends StatelessWidget {
  final String title;
  final Color color;
  final Color fontColor;
  final IconData icon;
  final Widget image;
  final String value;
  final String subTitle;
  final double width;
  final double height;
  final double elevation;
  final Function onPressed;
  const ApplienceTicket(
      {Key key,
      @required this.title,
      this.color,
      this.fontColor = Colors.white,
      this.onPressed,
      this.image,
      this.icon,
      this.value,
      this.width,
      this.height,
      this.elevation = 2,
      this.subTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _tickets();
  }

  Widget _tickets() {
    return Card(
      elevation: elevation,
      child: Container(
        padding: EdgeInsets.all(22),
        color: color,
        width: width,
        height: height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                if (image != null) image,
                if (icon != null)
                  Icon(
                    icon,
                    size: 36,
                    color: fontColor,
                  ),
                if (title != null)
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      color: fontColor,
                      fontFamily: 'Quicksand',
                    ),
                  )
              ],
            ),
            SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  value??'',
                  style: TextStyle(
                    fontSize: 34,
                    color: fontColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Raleway',
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                InkWell(
                    onTap: onPressed,
                    child: Text(
                      subTitle??'',
                      style: TextStyle(
                        fontSize: 14,
                        color: fontColor,
                        // fontWeight: FontWeight.bold,
                        fontFamily: 'Quicksand',
                      ),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
