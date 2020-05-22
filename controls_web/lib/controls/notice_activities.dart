import 'package:flutter/material.dart';

class NoticeTitle extends StatelessWidget {
  final String title;
  final TextStyle style;
  const NoticeTitle({Key key, this.title, this.style}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Text(
        title,
        style: style ?? TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
      ),
    );
  }
}

class NoticeTag extends StatelessWidget {
  final Widget icon;
  final String text;
  final Color tagColor;
  final double border;
  final double tagWidth;
  final Function onPressed;
  final double width;
  final double height;
  final double radius;
  final TextStyle style;
  final Widget content;
  const NoticeTag({
    Key key,
    this.icon,
    this.text,
    this.content,
    this.tagColor,
    this.onPressed,
    this.width,
    this.height = 60,
    this.tagWidth = 6,
    this.radius = 5,
    this.style,
    this.border = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(radius),
          bottomRight: Radius.circular(radius),
        ),
        border: (border > 0)
            ? Border.all(width: border, color: theme.dividerColor)
            : Border.symmetric(),
      ),
      child: Row(
        children: <Widget>[
          Container(
              width: tagWidth,
              height: height,
              color: tagColor ?? theme.primaryColor),
          if (text != null)
            Expanded(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                onTap: onPressed,
                leading: icon ?? Icon(Icons.info, size: 42),
                title: Center(
                    child: Text(text,
                        style: style ??
                            TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500))),
              ),
            ),
          if (content != null) content,
        ],
      ),
    );
  }
}

class NoticeText extends StatelessWidget {
  final String text;
  final TextStyle style;
  const NoticeText(this.text, {Key key, this.style}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style ?? TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
    );
  }
}

class NoticeHeader extends StatelessWidget {
  final Color color;
  final String title;
  final double fontSize;
  final String subtitle;
  final Color fontColor;
  const NoticeHeader(
      {Key key,
      this.title,
      this.color,
      this.fontSize = 24,
      this.subtitle,
      this.fontColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NoticeTile(
      title: title,
      color: color,
      //fontSize: fontSize,
      //subtitle: subtitle,
      //fontColor: fontColor,
    );
  }
}

class NoticeTile extends StatelessWidget {
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
  final Widget chart;
  final textAlign;
  const NoticeTile(
      {Key key,
      this.padding,
      this.color,
      this.top = 10,
      this.left = 10,
      this.title,
      this.textAlign = TextAlign.center,
      this.onPressed,
      this.titleStyle,
      this.titleFontSize = 16,
      this.value,
      this.valueStyle,
      this.valueFontSize = 48,
      this.image,
      this.body,
      this.chart,
      this.appBar,
      this.topBar,
      this.bottomBar,
      this.elevation = 0.0,
      this.height,
      this.dividerHeight = 0,
      this.width})
      : super(key: key);

  static status(
      {padding,
      Widget image,
      String value,
      String title,
      Color color,
      double width}) {
    return NoticeTile(
      padding: padding ?? EdgeInsets.only(right: 5),
      value: value,
      title: title,
      color: color,
      image: image,
      valueStyle: TextStyle(
          color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold),
      titleStyle: TextStyle(color: Colors.white, fontSize: 18),
      width: width,
    );
  }

  static panel(
      {padding,
      Widget image,
      String value,
      String title,
      Color color,
      double width,
      Function onPressed}) {
    return NoticeTile(
      value: value,
      title: title,
      color: color,
      image: image,
      onPressed: onPressed,
      textAlign: TextAlign.end,
      padding: padding ?? EdgeInsets.only(right: 5),
      valueStyle: TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontFamily: 'Raleway',
          fontWeight: FontWeight.bold),
      titleStyle: TextStyle(color: Colors.white, fontSize: 14),
      width: width,
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    List<Widget> items = [];
    if (value != null)
      items.add(Text(value,
          textAlign: textAlign,
          style: valueStyle ??
              TextStyle(
                  color: theme.primaryColor,
                  fontSize: valueFontSize,
                  fontWeight: FontWeight.w200)));
    if (body != null) items.add(body);

    if (title != null)
      items.add(Text(title,
          textAlign: textAlign,
          style: titleStyle ??
              TextStyle(
                  fontFamily: 'Sans',
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.w500)));

    return NoticeBox(
        child: Container(
      padding: padding,
      decoration: createBoxDecoration(color: color),
      height: height,
      width: width,
      child: InkWell(
          onTap: onPressed,
          splashColor: Theme.of(context).primaryColor,
          child: Container(
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
    ));
  }
}

class NoticeButton extends StatelessWidget {
  final Widget child;
  final Function onPressed;
  const NoticeButton({Key key, this.child, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NoticeBox(
      child: MaterialButton(
        padding: EdgeInsets.all(0),
        child: child,
        onPressed: onPressed,
      ),
    );
  }
}

class NoticeInfo extends StatelessWidget {
  final Widget child;
  final Widget icon;
  final double width;
  final double height;
  final Color color;
  final Function onPressed;
  final double tagWidth;
  const NoticeInfo(
      {Key key,
      this.color,
      this.child,
      this.icon,
      this.width,
      this.height,
      this.onPressed,
      this.tagWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return NoticeBox(
      color: color,
      width: width,
      height: height,
      child: Container(
        alignment: Alignment.center,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                width: 60,
                padding: EdgeInsets.only(left: 8, right: 8, top: 4),
                child: InkWell(
                  child: icon ??
                      Icon(Icons.info, size: 40, color: theme.backgroundColor),
                  onTap: onPressed,
                )),
            Expanded(child: Center(child: child)),
          ],
        ),
      ),
    );
  }
}

class NoticeBox extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  final Color color;
  const NoticeBox({Key key, this.color, this.child, this.width, this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: theme.dividerColor),
        color: color ?? theme.primaryColor.withAlpha(50),
        borderRadius: BorderRadius.circular(5),
      ),
      child: child,
    );
  }
}

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

class NoticeContainer extends StatelessWidget {
  final Color color;
  final Widget child;
  final double width;
  final BorderRadius borderRadius;
  const NoticeContainer(
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
    return NoticeContainer(
      width: width,
      color: color,
      borderRadius: borderRadius,
      child: Text(value ?? '', style: style ?? TextStyle(fontSize: 32)),
    );
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
