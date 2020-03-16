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
    this.tagWidth = 3,
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
          Expanded(
            child: ListTile(
              onTap: onPressed,
              leading: icon ?? Icon(Icons.info),
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
      fontSize: fontSize,
      subtitle: subtitle,
      fontColor: fontColor,
    );
  }
}

class NoticeTile extends StatelessWidget {
  final Color color;
  final String title;
  final double fontSize;
  final String subtitle;
  final Color fontColor;
  final Widget leading;
  final Widget trailing;
  final Function onTap;
  final bool selected;
  final Widget child;

  NoticeTile(
      {this.title,
      Key key,
      this.fontSize = 18,
      this.subtitle,
      this.fontColor,
      this.color,
      this.leading,
      this.trailing,
      this.selected = false,
      this.child,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
        decoration: BoxDecoration(color: color ?? theme.backgroundColor),
        child: ListTile(
          leading: leading,
          trailing: trailing,
          onTap: onTap,
          dense: true,
          selected: selected,
          title: Text(title ?? '',
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: fontColor ?? theme.scaffoldBackgroundColor,
              )),
          subtitle: Column(children: [
            Text(subtitle ?? '',
                style: TextStyle(
                  color: fontColor ?? theme.scaffoldBackgroundColor,
                  fontSize: fontSize * 0.7,
                )),
            if (child != null) child,
          ]),
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
