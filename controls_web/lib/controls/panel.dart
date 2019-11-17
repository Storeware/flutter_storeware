import 'package:flutter/material.dart';

class Panel extends StatelessWidget {
  final Widget child;
  final Color color;
  final Widget title;
  final Widget appBar;
  final List<Widget> actions;
  final double elevation;
  final EdgeInsets margin;
  final Clip clipBehavior;
  final ShapeBorder shape;
  final Widget leading;
  const Panel(
      {Key key,
      this.appBar,
      this.margin,
      this.color,
      this.elevation,
      this.child,
      this.title,
      this.leading,
      this.actions,
      this.shape,
      this.clipBehavior})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool bappBar = (title != null);
    return Card(
      elevation: elevation,
      margin: margin,
      color: color,
      clipBehavior: clipBehavior,
      shape: shape,
      child: Column(
        children: <Widget>[
          appBar ?? bappBar
              ? AppBar(
                  title: title,
                  automaticallyImplyLeading: false,
                  elevation: 0.0,
                  actions: actions,
                  leading: leading,
                )
              : Container(),
          Expanded(
            child: child,
          )
        ],
      ),
    );
  }
}

class PanelUserTile extends StatefulWidget {
  final String title;
  final int alpha;
  final List<Widget> actions;
  final double heigth;
  final Widget user;
  final Widget image;
  PanelUserTile(
      {this.user,
      this.title,
      this.image,
      this.actions,
      this.heigth,
      this.alpha = 150,
      key})
      : super(key: key);

  _PanelUserTileState createState() => _PanelUserTileState();
}

class _PanelUserTileState extends State<PanelUserTile> {
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryColor;
    final double _h = 50;
    return Container(
        child: Container(
      height: widget.heigth,
      color: Colors.transparent,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          height: 10,
        ),
        Center(
          child: Container(
              color : Colors.transparent,
              alignment: Alignment.center,
              height: _h,
              width: _h,
              child: CircleAvatar(child: widget.image ?? Icon(Icons.person))),
        ),
        widget.user ?? Container() ,
      ]),
    ));
  }
}

class ListTileMenuItem extends StatelessWidget {
  final Widget title;
  final Function onTap;
  const ListTileMenuItem({Key key, this.title, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: title,
      onTap: onTap,
      trailing: Icon(Icons.keyboard_arrow_right),
    );
  }
}
