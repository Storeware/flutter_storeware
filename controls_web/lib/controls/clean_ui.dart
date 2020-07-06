import 'package:flutter/material.dart';

class TabButton extends StatelessWidget {
  final Widget icon;
  final String label;
  final Widget child;
  final Widget footer;
  final double width;
  final Function() onPressed;
  const TabButton(
      {Key key,
      this.icon,
      this.label,
      this.onPressed,
      this.footer,
      this.child,
      this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (onPressed == null)
        ? buildContainer()
        : FlatButton(
            child: buildContainer(),
            onPressed: onPressed,
          );
  }

  Container buildContainer() {
    return Container(
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) icon,
          if (label != null) Text(label ?? ''),
          if (child != null) child,
          if (footer != null) footer,
        ],
      ),
    );
  }
}

class CleanButton extends StatelessWidget {
  final Widget icon;
  final String label;
  final Color labelColor;
  final String subLabel;
  final Function() onPressed;
  final Color color;
  final double elevation;
  final double width;
  final double radius;
  const CleanButton(
      {Key key,
      this.icon,
      this.label,
      this.width,
      this.elevation = 1,
      this.onPressed,
      this.subLabel,
      this.color,
      this.labelColor,
      this.radius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return CleanContainer(
      radius: radius,
      elevation: elevation,
      width: width,
      color: color, //?? theme.cardColor,
      child: (onPressed == null)
          ? buildContainer(context)
          : MaterialButton(
              padding: EdgeInsets.all(0),
              child: buildContainer(context),
              onPressed: onPressed,
            ),
    );
  }

  Widget buildContainer(context) {
    //ThemeData theme = Theme.of(context);
    var _color = labelColor; //?? theme.primaryTextTheme.bodyText1.color;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) icon,
          Text(label ?? '',
              style: TextStyle(
                color: _color,
                fontSize: 12,
              )),
          if (subLabel != null)
            Text(subLabel,
                style: TextStyle(
                  fontSize: 10,
                  color: _color,
                )),
        ],
      ),
    );
  }
}

class CleanContainer extends StatelessWidget {
  final Widget child;
  final Color color;
  final bool selected;
  final Color selectedColor;
  final double radius;
  final double leftRadius;
  final double rightRadius;
  final double width;
  final double height;
  final double elevation;
  final double border;
  final Color borderColor;
  const CleanContainer({
    Key key,
    this.child,
    this.color,
    this.radius,
    this.elevation = 1,
    this.width,
    this.height,
    this.leftRadius,
    this.rightRadius,
    this.selected = false,
    this.selectedColor,
    this.border,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    var _selectedColor = selectedColor ?? Colors.grey.shade300;
    var _color = color ?? theme.scaffoldBackgroundColor;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: (selected) ? _selectedColor : _color,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(leftRadius ?? radius ?? 10),
          topRight: Radius.circular(rightRadius ?? radius ?? 10),
          bottomLeft: Radius.circular(leftRadius ?? radius ?? 10),
          bottomRight: Radius.circular(rightRadius ?? radius ?? 10),
        ),
        border: (border == null)
            ? null
            : Border.all(
                color: borderColor ??
                    theme.dividerColor, //                   <--- border color
                width: border ?? 1,
              ),
        boxShadow: (elevation == 0)
            ? []
            : [
                BoxShadow(
                  color: Colors.black26, // theme.dividerColor,
                  blurRadius: elevation,
                  // spreadRadius: elevation,
                  offset: Offset(0, 2), // shadow direction: bottom right
                )
              ],
      ),
      child: child,
    );
  }
}

class ActionButton extends StatelessWidget {
  final String label;
  final Function() onPressed;
  final Color color;
  final TextStyle style;
  final bool selected;
  final Color selectedColor;
  final double width;
  final double height;
  final Widget child;
  final double radius;
  const ActionButton(
      {Key key,
      this.label,
      this.onPressed,
      this.radius = 15,
      this.color,
      this.selectedColor,
      this.style,
      this.width,
      this.height,
      this.child,
      this.selected = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(radius),
      onTap: onPressed,
      child: CleanContainer(
        radius: 30,
        width: width, height: height,
        color: (selected) ? selectedColor ?? theme.dividerColor : color,
        // label: label,
        // labelColor: Colors.black87,
        // onPressed: onPressed,
        border: 1,
        elevation: 0,
        //child: FlatButton(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
          child: DefaultTextStyle(
              style: style ??
                  theme.textTheme.subtitle2
                      .copyWith(fontWeight: FontWeight.w300),
              child: Column(children: [
                if (child != null) child,
                if (label != null)
                  Text(
                    label,
                    textAlign: TextAlign.center,
                  ),
              ])),
        ),
      ),
    );
  }
}

class LabeledRow extends StatelessWidget {
  final String label;
  final Widget title;
  final double spacing;
  final MainAxisAlignment mainAxisAlignment;
  final List<Widget> children;
  final TextStyle style;
  const LabeledRow(
      {Key key,
      this.label,
      this.children,
      this.title,
      this.mainAxisAlignment,
      this.spacing = 2,
      this.style})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title ??
            Text(label ?? '',
                style: theme.textTheme
                    .headline6), //(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(
          height: 5,
        ),
        DefaultTextStyle(
          style: (style ?? theme.textTheme.subtitle2).copyWith(
              fontWeight: FontWeight.w300,
              color: theme.textTheme.subtitle2.color),
          child: SafeArea(
            child: Row(
                mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
                children: [for (var item in children) ...doitem(item)]),
          ),
        ),
      ],
    );
  }

  doitem(item) => [
        item,
        SizedBox(
          width: spacing,
        )
      ];
}

class LabeledColumn extends StatelessWidget {
  final String label;
  final List<Widget> children;
  final Widget title;
  final double spacing;
  const LabeledColumn(
      {Key key, this.label, this.children, this.title, this.spacing = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    var fs = theme.textTheme.subtitle1.fontSize - 2;
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title ??
              Text(label ?? '',
                  style: theme.textTheme
                      .headline6), //.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(
            height: 5,
          ),
          DefaultTextStyle(
            style:
                theme.textTheme.subtitle2.copyWith(fontWeight: FontWeight.w300),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [for (var item in children) ...doitem(item)]),
          ),
        ]);
  }

  doitem(item) => [
        item,
        SizedBox(
          height: spacing,
        )
      ];
}

class ButtonAvatar extends StatelessWidget {
  final Widget icon;
  final String label;
  final Widget child;
  final Widget footer;
  final double width;
  final Color color;
  final Color avatarBackgoundColor;
  final Color avatarForegoundColor;
  final Function() onPressed;
  const ButtonAvatar(
      {Key key,
      this.icon,
      this.label,
      this.onPressed,
      this.footer,
      this.child,
      this.width,
      this.color,
      this.avatarBackgoundColor,
      this.avatarForegoundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (onPressed == null)
        ? buildContainer(context)
        : InkWell(
            child: buildContainer(context),
            onTap: onPressed,
          );
  }

  Widget buildContainer(context) {
    ThemeData theme = Theme.of(context);
    return CleanContainer(
      elevation: 0,
      border: 0,
      color: color,
      width: width,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              CircleAvatar(
                child: icon,
                backgroundColor: avatarBackgoundColor,
                foregroundColor: avatarForegoundColor,
              ),
            if (label != null)
              Text(
                label ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            if (child != null) child,
            if (footer != null)
              DefaultTextStyle(
                style: TextStyle(
                    fontSize: 12, color: theme.textTheme.bodyText1.color),
                child: footer,
              ),
          ],
        ),
      ),
    );
  }
}

class ActionText extends StatelessWidget {
  final String label;
  final String sublabel;
  final Color color;
  final TextStyle style;
  final double radius;
  const ActionText(
      {Key key,
      this.label,
      this.sublabel,
      this.color,
      this.style,
      this.radius = 5})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextStyle _style = style ?? theme.textTheme.button;
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: color ?? theme.scaffoldBackgroundColor,
          border: Border.all(width: 1, color: theme.dividerColor)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(label, style: _style),
            Text(sublabel,
                style: _style.copyWith(fontSize: (_style.fontSize ?? 12) * 0.8))
          ],
        ),
      ),
    );
  }
}
