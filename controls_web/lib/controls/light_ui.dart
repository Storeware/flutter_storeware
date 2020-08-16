import 'package:flutter/material.dart';

/// [LigthButton] apresentação para dash
class LightButton extends StatelessWidget {
  final double width, height;
  final Color color, backgroundColor;
  final Widget image;
  final Widget title;
  final Function onPressed;
  final String value;

  /// indicar [label] para mostra o titulo
  final String label, sublabel;
  const LightButton({
    Key key,
    this.width = 140,
    this.height = 160,
    this.color,
    this.label,
    this.image,
    this.title,
    this.onPressed,
    this.sublabel,
    this.value,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //ThemeData theme = Theme.of(context);
    Color _color = color ?? Colors.green;
    return InkWell(
        child: Container(
          padding: EdgeInsets.all(8),
          width: width,
          height: height,
          color: _color.withAlpha(50),
          child: Stack(
            children: [
              if (image != null)
                Positioned(
                    right: 8,
                    top: 8,
                    child: CircleAvatar(
                      child: image,
                      radius: 25,
                      backgroundColor: backgroundColor ?? Colors.white,
                    )),
              if (label != null)
                Positioned(
                    bottom: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (value != null)
                          Text(value,
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                  color: backgroundColor ?? Colors.white)),
                        for (var s in label.split('|'))
                          Text(s,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              )),
                        if (title != null) title,
                        if (sublabel != null) ...[
                          for (var s in sublabel.split('|'))
                            Text(s,
                                style: TextStyle(fontSize: 12, color: _color))
                        ],
                      ],
                    ))
            ],
          ),
        ),
        onTap: onPressed);
  }
}

class LightAmmount extends StatelessWidget {
  final String value, label, sublabel;
  final Widget child;
  const LightAmmount(
      {Key key, this.value, this.label, this.sublabel, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (value != null)
          Text(value,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        if (label != null)
          Text(
            label,
            style: TextStyle(color: theme.textTheme.caption.color),
          ),
        if (sublabel != null)
          Text(
            sublabel,
            style: TextStyle(color: theme.textTheme.caption.color),
          ),
        if (child != null) child,
      ]),
    );
  }
}

class LightTile extends StatelessWidget {
  final Widget title, subtitle, leading, trailing;
  final Function() onPressed;
  final double height;
  final Color tagColor;
  const LightTile(
      {Key key,
      this.title,
      this.subtitle,
      this.leading,
      this.onPressed,
      this.trailing,
      this.tagColor,
      this.height = 60})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(width: 4, height: height, color: tagColor ?? Colors.amber),
      SizedBox(width: 8),
      Expanded(
        child: ListTile(
          leading: leading,
          title: title,
          subtitle: subtitle,
          trailing: trailing,
        ),
      )
    ]);
  }
}

class LigthInfo extends StatelessWidget {
  final Widget image, title, subtitle;
  final String label, sublabel;
  final Function() onPressed;
  final Widget leading, trailing;
  const LigthInfo(
      {Key key,
      this.image,
      this.title,
      this.subtitle,
      this.label,
      this.sublabel,
      this.onPressed,
      this.leading,
      this.trailing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (image != null) CircleAvatar(child: image),
        if (label != null)
          Text(label,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        if (sublabel != null)
          Text(
            sublabel,
          ),
        if (title != null)
          ListTile(
            leading: leading,
            title: title,
            subtitle: subtitle,
            trailing: trailing,
          )
      ],
    );
  }
}
