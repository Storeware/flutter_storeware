import 'package:flutter/material.dart';

/// [LigthButton] apresentação para dash
class LightButton extends StatelessWidget {
  final double? width, height;
  final Color? color, backgroundColor;
  final Widget? image;
  final Widget? title;
  final Function? onPressed;
  final String? value;

  /// indicar [label] para mostra o titulo
  final String? label, sublabel;
  const LightButton({
    Key? key,
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
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (value != null)
                          Text(value!,
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                  color: backgroundColor ?? Colors.white)),
                        for (var s in label!.split('|'))
                          Text(s,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              )),
                        if (title != null) title!,
                        if (sublabel != null) ...[
                          for (var s in sublabel!.split('|'))
                            Text(s,
                                style: TextStyle(fontSize: 12, color: _color))
                        ],
                      ],
                    ))
            ],
          ),
        ),
        onTap: () => onPressed!());
  }
}

class LightAmmount extends StatelessWidget {
  final String? value, label, sublabel;
  final Widget? child;
  const LightAmmount(
      {Key? key, this.value, this.label, this.sublabel, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (value != null)
              Text(value!,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
            if (label != null)
              Text(
                label!,
                style: TextStyle(color: theme.textTheme.caption!.color),
              ),
            if (sublabel != null)
              Text(
                sublabel!,
                style: TextStyle(color: theme.textTheme.caption!.color),
              ),
            if (child != null) child!,
          ]),
    );
  }
}

class LightTile extends StatelessWidget {
  final Widget? title, subtitle, leading, trailing;
  final Function()? onPressed;
  final double? height;
  final Color? tagColor;
  const LightTile(
      {Key? key,
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
    return Row(mainAxisSize: MainAxisSize.min, children: [
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

class LightInfo extends StatelessWidget {
  final Widget? image, title, subtitle;
  final String? label, sublabel;
  final Function()? onPressed;
  final Widget? leading, trailing;
  const LightInfo(
      {Key? key,
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
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (image != null) CircleAvatar(child: image),
        if (label != null)
          for (var s in label!.split('|'))
            Text(s,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        if (sublabel != null)
          Text(
            sublabel!,
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

class LightImageTile extends StatelessWidget {
  final Widget? image;
  final Widget? title, subtitle;
  final String? label, sublabel;
  const LightImageTile(
      {Key? key,
      this.image,
      this.title,
      this.subtitle,
      this.label,
      this.sublabel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      if (image != null) image!,
      if (title != null) ListTile(title: title, subtitle: subtitle),
      if (label != null)
        Text(label!,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            )),
      if (sublabel != null)
        Text(sublabel!,
            style: TextStyle(
              fontSize: 12,
            )),
    ]);
  }
}

class LightValueButton extends StatelessWidget {
  final String? label, sublabel;
  final Function()? onPressed;
  final Widget? image;
  final Widget? leading;
  //final double width, height;
  const LightValueButton({
    Key? key,
    this.label,
    this.sublabel,
    this.onPressed,
    this.image,
    this.leading,
    //this.width = 120,
    //this.height = 120,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return InkWell(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (leading != null) leading!,
                      if (image != null) image!,
                    ]),
              ),
              if (label != null)
                Text(label!,
                    style: theme.textTheme.button!.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    )),
              if (sublabel != null)
                Text(sublabel!, style: theme.textTheme.caption),
            ]),
        onTap: onPressed);
  }
}

class LightContainer extends StatelessWidget {
  final List<Widget>? children;
  final String? label, sublabel;
  final Function()? onPressed;
  final double? elevation;
  final double? width, height;
  final Color? color;
  const LightContainer(
      {Key? key,
      this.children,
      this.label,
      this.sublabel,
      this.onPressed,
      this.elevation = 0,
      this.width,
      this.height,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Card(
      color: color ?? theme.primaryColor.withAlpha(20),
      elevation: elevation,
      child: Container(
        width: width,
        height: height,
        child: SizedBox.expand(
          child: ListView(
            //scrollDirection: Axis.horizontal,
            //mainAxisSize: MainAxisSize.min,
            children: [
              if (children != null)
                Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      for (var item in children!)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: item,
                        )
                    ]),
              Center(
                  child: LightInfo(
                      label: label, sublabel: sublabel, onPressed: onPressed)),
            ],
          ),
        ),
      ),
      // ),
    );
  }
}
