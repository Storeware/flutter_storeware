import 'package:flutter/material.dart';

class ShipsImage extends StatelessWidget {
  final Widget? image;
  final Function? onPressed;
  const ShipsImage({Key? key, this.image, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        child: image,
      ),
      onTap: () => onPressed!(),
    );
  }
}

class ShipsValue extends StatelessWidget {
  final String? title;
  final dynamic? value;
  const ShipsValue({Key? key, this.title, this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title!,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 22,
          ),
        ),
      ],
    );
  }
}

class ShipsTile extends StatelessWidget {
  final String? title;
  final String? subTitle;
  final List<Widget>? children;
  final Widget? image;
  final Widget? action;
  final Function? onPressed;
  const ShipsTile(
      {Key? key,
      this.image,
      this.title,
      this.subTitle,
      this.action,
      this.onPressed,
      this.children})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: image,
      trailing: action,
      onTap: () => onPressed!(),
      title: Text(
        title!,
        style: TextStyle(
          fontSize: 18,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (subTitle != null) Text(subTitle!),
          if (children != null) ...children!,
        ],
      ),
    );
  }
}

class ShipsBar extends StatelessWidget {
  final double? width;
  final double? height;
  final double? value;
  final Color? color;
  final Color? backgroundColor;
  final bool? showValue;
  ShipsBar(
      {Key? key,
      this.value,
      this.color,
      this.showValue = true,
      this.backgroundColor,
      this.width = 180,
      this.height = 16})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var w = width! * (value! / 100);
    print('$width $w');
    return Container(
      padding: EdgeInsets.only(left: 2, right: 2, bottom: 2, top: 2),
      width: width,
      height: height,

      //color: Colors.amber,
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.backgroundColor,
        border:
            Border.all(color: theme.textTheme.overline!.color!.withAlpha(50)),
        //shape: BoxShape.circle,
      ),
      child: Row(
        children: <Widget>[
          Container(
              width: w,
              height: height,
              color: color ?? theme.primaryColor, //Colors.amber,
              child: Center(
                child: showValue!
                    ? Text(
                        '$value %',
                        style: TextStyle(fontSize: 10),
                      )
                    : null,
              )
              //color: ,
              ),
        ],
      ),
    );
  }
}

class ShipsHorizontal extends StatelessWidget {
  final List<Widget>? children;
  const ShipsHorizontal({Key? key, this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [...children!],
    );
  }
}

class ShipsIconButton extends StatelessWidget {
  final Widget? icon;
  final String? title;
  final Function? onPressed;
  const ShipsIconButton({Key? key, this.icon, this.title, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPressed!(),
      child: Column(
        children: <Widget>[
          icon!,
          if (title != null) Text(title!),
        ],
      ),
    );
  }
}

class ShipsButtons extends StatelessWidget {
  final List<Widget>? children;
  const ShipsButtons({Key? key, this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (children != null) ...children!,
      ],
    );
  }
}

class ShipsRoundedButton extends StatelessWidget {
  final Color? color;
  final Function? onPressed;
  final String? label;
  final Color? labelColor;
  final double? width;
  final double? border;
  final Color? borderColor;
  final Widget? child;
  const ShipsRoundedButton(
      {Key? key,
      this.color,
      this.onPressed,
      this.label,
      this.width,
      this.labelColor,
      this.border = 1,
      this.borderColor,
      this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
          constraints: BoxConstraints(
            minWidth: width ?? 50,
          ),
          decoration: BoxDecoration(
            color: color ?? Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: borderColor ?? Colors.black26,
              width: border!,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 8,
              right: 8,
            ),
            child: Align(
              child: Row(children: [
                if (label != null)
                  Text(
                    label ?? '',
                    style: TextStyle(color: labelColor ?? Colors.black),
                  ),
                if (child != null) child!,
              ]),
            ),
          )),
      onTap: () => onPressed!(),
    );
  }
}

class ShipsListView extends StatelessWidget {
  final List<Widget>? children;
  final Axis? direction;
  final double? spaces;
  const ShipsListView(
      {Key? key,
      this.children,
      this.direction = Axis.horizontal,
      this.spaces = 4})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: direction!,
      primary: true,
      children: [
        if (children != null)
          for (var item in children!)
            Padding(
              padding: EdgeInsets.only(right: spaces!),
              child: item,
            ),
      ],
    );
  }
}

class ShipsDetail extends StatelessWidget {
  final Widget? image;
  final Function? onPressed;
  final List<Widget>? buttons;
  final Widget? action;
  final Widget? leading;
  final String? title;
  final String? subTitle;
  final List<Widget>? children;
  const ShipsDetail({
    Key? key,
    this.image,
    this.buttons,
    this.action,
    this.leading,
    this.title,
    this.subTitle,
    this.children,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (image != null)
          ShipsImage(
            image: image,
            onPressed: onPressed,
          ),
        if (buttons != null)
          ShipsButtons(
            children: <Widget>[...buttons!],
          ),
        ShipsTile(
            action: action,
            image: leading,
            title: title ?? '',
            subTitle: subTitle ?? '',
            children: [...children ?? []]),
      ],
    );
  }
}

enum ShipsSummaryPosition { none, left, right }

class ShipsSummary extends StatelessWidget {
  final String? title;
  final double? fontSize;
  final Color? color;
  final Color? fontColor;
  final String? value;
  final Color? valueFontColor;
  final double? percent;
  final int? percentDec;
  final String? percentLabel;
  final Widget? image;
  final double? radius;
  final ShipsSummaryPosition? position;
  const ShipsSummary(
      {Key? key,
      this.fontSize = 72,
      this.radius = 15,
      this.value,
      this.valueFontColor = Colors.black45,
      this.position = ShipsSummaryPosition.right,
      this.percent,
      this.percentDec = 1,
      this.percentLabel = '%',
      this.title,
      this.image,
      this.fontColor,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color cor = color ?? Theme.of(context).primaryColor;
    //Size size = MediaQuery.of(context).size;
    return ShipsPanel(
        width: 300,
        height: 150,
        topRadius: radius!,
        bottomRadius: radius!,
        color: cor.withAlpha(50),
        child: Column(
          children: <Widget>[
            Container(
              height: 32,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(radius!),
                  topRight: Radius.circular(radius!),
                ),
                color: cor,
              ),
              child: Align(
                child: Text(
                  title ?? 'titulo somas',
                  style: TextStyle(
                    fontSize: 18,
                    color: fontColor ?? Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
                child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                if ((percent != null) &&
                    (position == ShipsSummaryPosition.left))
                  buildActivityPercentValue(),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  textBaseline: TextBaseline.alphabetic,
                  children: <Widget>[
                    Expanded(
                      child: Center(
                          child: Text(
                        value ?? '0000',
                        style: TextStyle(
                          fontSize: fontSize,
                          color: valueFontColor,
                        ),
                      )),
                    ),
                    ShipsBar(
                      value: percent,
                      showValue: false,
                    ),
                    SizedBox(
                      height: 6,
                    )
                  ],
                ),
                if ((percent != null) &&
                    (position == ShipsSummaryPosition.right))
                  buildActivityPercentValue(),
              ],
            )),
          ],
        ));
  }

  Widget buildActivityPercentValue() {
    return Column(
      children: <Widget>[
        if (image != null) image!,
        ShipsValue(
          title: percentLabel,
          value: percent!.toStringAsFixed(percentDec!),
        ),
      ],
    );
  }
}

class ShipsPanel extends StatelessWidget {
  final Widget? child;
  final Color? color;
  final double? height;
  final double? width;
  final double? topRadius;
  final double? bottomRadius;
  final double? leftRadius;
  final double? rightRadius;
  const ShipsPanel(
      {Key? key,
      this.topRadius = 20,
      this.bottomRadius = 20,
      this.leftRadius,
      this.rightRadius,
      this.color,
      this.width,
      this.height,
      this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(leftRadius ?? bottomRadius!),
        topRight: Radius.circular(rightRadius ?? topRadius!),
        topLeft: Radius.circular(leftRadius ?? topRadius!),
        bottomRight: Radius.circular(rightRadius ?? bottomRadius!),
      ),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: color,
        ),
        child: child,
      ),
    );
  }

  static header({Key? key, radius = 20, color, width, height, child}) =>
      ShipsPanel(
        child: child,
        topRadius: radius,
        bottomRadius: 0,
        color: color,
        height: height,
        width: width,
      );
  static bottom({Key? key, radius = 20, color, width, height, child}) =>
      ShipsPanel(
        child: child,
        topRadius: 0,
        bottomRadius: radius,
        color: color,
        height: height,
        width: width,
      );
  static left({Key? key, radius = 20, color, width, height, child}) =>
      ShipsPanel(
        child: child,
        leftRadius: radius,
        color: color,
        height: height,
        width: width,
      );
  static right({Key? key, radius = 20, color, width, height, child}) =>
      ShipsPanel(
        child: child,
        rightRadius: radius,
        color: color,
        height: height,
        width: width,
      );
}

class ShipsStars extends StatefulWidget {
  final int? max;
  final int? value;
  final Function(int)? onPressed;
  final Color? color;
  final double? width;
  final double? height;
  const ShipsStars(
      {Key? key,
      this.max,
      this.onPressed,
      this.value = 0,
      this.color,
      this.width,
      this.height})
      : super(key: key);

  @override
  _ShipsStarsState createState() => _ShipsStarsState();
}

class _ShipsStarsState extends State<ShipsStars> {
  int _v = 0;
  @override
  void initState() {
    _v = widget.value!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.width ?? 150,
        height: widget.height ?? 25,
        color: widget.color ?? Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            for (var i = 1; i <= widget.max!; i++)
              InkWell(
                child: Icon(Icons.star,
                    size: 18, color: (_v >= i) ? Colors.red : Colors.amber),
                onTap: () {
                  _v = i;
                  if (widget.onPressed != null) widget.onPressed!(_v);
                  setState(() {});
                },
              ),
          ],
        ));
  }
}
