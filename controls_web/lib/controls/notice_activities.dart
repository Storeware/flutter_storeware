import 'package:flutter/material.dart';

class NoticeRow extends StatefulWidget {
  final double width;
  final double height;
  final Widget bar;
  final Widget bottom;
  final double spacing;
  final List<Widget> children;
  final double radius;
  final Color color;
  final Color titleColor;
  //final double elevation;
  final Widget leading;
  final List<Widget> actions;
  final double childAspectRatio;
  NoticeRow(
      {Key key,
      this.bar,
      this.bottom,
      //  this.body,
      this.width,
      this.height,
      this.color,
      this.children,
      this.titleColor,
      //  this.elevation = 10,
      this.spacing = 0,
      this.leading,
      this.actions,
      this.radius = 5,
      this.childAspectRatio})
      : super(key: key);

  @override
  _NoticeListState createState() => _NoticeListState();
}

class _NoticeListState extends State<NoticeRow> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var cols = widget.children.length;

    return Container(
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(widget.radius),
      ),
      width: widget.width,
      height: widget.height,
      child: Column(children: [
        if (widget.bar != null)
          Container(
              constraints: BoxConstraints(minHeight: 30),
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: widget.titleColor ?? theme.primaryColor.withAlpha(150),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(widget.radius),
                  topRight: Radius.circular(widget.radius),
                ),
              ),
              child: Row(
                children: <Widget>[
                  if (widget.leading != null) widget.leading,
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: widget.bar,
                  )),
                  if (widget.actions != null) ...widget.actions,
                ],
              )),
        Expanded(
            child: GridView.extent(
          childAspectRatio: widget.childAspectRatio ?? (cols / 2),
          maxCrossAxisExtent: widget.width,
          //crossAxisCount: 1,
          mainAxisSpacing: widget.spacing,
          crossAxisSpacing: widget.spacing,
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            if (widget.children != null)
              for (var item in widget.children)
                Container(
                  //                constraints: BoxConstraints(maxWidth: max),
                  child: item,
                ),
          ],
        )),
        if (widget.bottom != null)
          Container(
            constraints: BoxConstraints(minHeight: 30),
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: widget.titleColor ?? theme.primaryColor.withAlpha(150),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(widget.radius),
                bottomRight: Radius.circular(widget.radius),
              ),
            ),
            child: Row(
              children: <Widget>[
                Center(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: widget.bottom,
                )),
              ],
            ),
          ),
      ]),
    );
  }
}

class NoticeTile extends StatelessWidget {
  final Color color;
  final Widget child;
  final double width;
  final BorderRadius borderRadius;
  const NoticeTile(
      {Key key,
      this.child,
      this.color = Colors.blueAccent,
      this.width,
      this.borderRadius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: color ?? theme.primaryColor,
        borderRadius: borderRadius ?? BorderRadius.circular(3),
      ),
      child: Center(child: child),
    );
  }
}

class NoticeValue extends StatelessWidget {
  final Color color;
  final String value;
  final double width;
  final BorderRadius borderRadius;
  final FontStyle style;
  const NoticeValue(
      {Key key,
      this.value,
      this.color,
      this.borderRadius,
      this.width,
      this.style})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NoticeTile(
      width: width,
      color: color,
      borderRadius: borderRadius,
      child: Text(value ?? '', style: style ?? TextStyle(fontSize: 32)),
    );
  }
}
