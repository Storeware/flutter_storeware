import 'package:controls_web/controls/rounded_button.dart';
import 'package:flutter/material.dart';

class ActivityInfo extends StatelessWidget {
  final Widget title;
  final String buttonName;
  final onPressed;
  final double width;
  final double height;
  final String text;
  final Color color;
  final Widget image;
  const ActivityInfo(
      {Key key,
      this.title,
      this.buttonName = 'OK',
      this.onPressed,
      this.width = 400,
      this.height = 300,
      this.text,
      this.color,
      this.image})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: color ?? Colors.grey.withAlpha(20),
      width: width,
      height: height,
      child: Column(
        children: [
          Expanded(
              child: Stack(
            children: <Widget>[
              if (image != null) Positioned(left: 12, top: 12, child: image),
              Center(
                  child: title ?? Text(text, style: TextStyle(fontSize: 18))),
            ],
          )),
          SizedBox(height: 5),
          ActivityButton(
            //icon: Icons.check,
            title: buttonName,
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}

class ActivityPanel extends StatelessWidget {
  final Widget child;
  final Color color;
  final double height;
  final double width;
  final double topRadius;
  final double bottomRadius;
  final double leftRadius;
  final double rightRadius;
  const ActivityPanel(
      {Key key,
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
        topRight: Radius.circular(rightRadius ?? topRadius),
        topLeft: Radius.circular(leftRadius ?? topRadius),
        bottomLeft: Radius.circular(leftRadius ?? bottomRadius),
        bottomRight: Radius.circular(rightRadius ?? bottomRadius),
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

  static header({Key key, radius = 20, color, width, height, child}) =>
      ActivityPanel(
        child: child,
        topRadius: radius,
        bottomRadius: 0,
        color: color,
        height: height,
        width: width,
      );
  static bottom({Key key, radius = 20, color, width, height, child}) =>
      ActivityPanel(
        child: child,
        topRadius: 0,
        bottomRadius: radius,
        color: color,
        height: height,
        width: width,
      );
  static left({Key key, radius = 20, color, width, height, child}) =>
      ActivityPanel(
        child: child,
        leftRadius: radius,
        color: color,
        height: height,
        width: width,
      );
  static right({Key key, radius = 20, color, width, height, child}) =>
      ActivityPanel(
        child: child,
        rightRadius: radius,
        color: color,
        height: height,
        width: width,
      );
}

class ActivityTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final String subtitle;
  final Color avatarBackgroudColor;
  final Color iconColor;
  final Color color;
  final Function onTap;
  final Widget trailing;
  final double radius;
  const ActivityTile(
      {Key key,
      this.color,
      this.radius = 0,
      this.avatarBackgroudColor,
      this.title,
      this.subtitle,
      this.trailing,
      this.onTap,
      this.icon,
      this.iconColor})
      : super(key: key);

  @override
  Widget build(context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ActivityPanel(
        leftRadius: radius,
        rightRadius: radius,
        color: color ?? Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            onTap: onTap,
            contentPadding: EdgeInsets.all(1),
            trailing: trailing,
            leading: Container(
              width: 65,
              height: 65,
              child: ActivityAvatar(
                avatarBackgroudColor: avatarBackgroudColor,
                iconColor: iconColor,
                icon: icon,
              ),
            ),
            title: ActivityTextTitle(title: title),
            subtitle: ActivityTextSubtitle(subtitle: subtitle),
          ),
        ),
      ),
    );
  }
}

class ActivityTextSubtitle extends StatelessWidget {
  const ActivityTextSubtitle({
    Key key,
    @required this.subtitle,
  }) : super(key: key);

  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Text(subtitle ?? '',
        style: TextStyle(
          fontSize: 20,
        ));
  }
}

class ActivityTextTitle extends StatelessWidget {
  const ActivityTextTitle({
    Key key,
    @required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title ?? '',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w500,
        ));
  }
}

class ActivityAvatar extends StatelessWidget {
  const ActivityAvatar({
    Key key,
    @required this.avatarBackgroudColor,
    @required this.iconColor,
    @required this.icon,
  }) : super(key: key);

  final Color avatarBackgroudColor;
  final Color iconColor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        backgroundColor: avatarBackgroudColor ?? Colors.deepOrange,
        foregroundColor: iconColor ?? Colors.white,
        child: Icon(
          icon ?? Icons.pets,
          size: 32,
        ));
  }
}

class ActivityButton extends StatelessWidget {
  final Widget image;
  final IconData icon;
  final String title;
  final Function onPressed;
  final Color fontColor;
  final Color iconColor;
  final TextStyle textStyle;
  const ActivityButton({
    Key key,
    this.icon,
    this.image,
    this.title,
    this.onPressed,
    this.fontColor,
    this.iconColor,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          if (image != null) image,
          if (icon != null)
            Icon(
              icon,
              size: 32,
              color: iconColor ?? Colors.black87,
            ),
          SizedBox(
            height: 10,
          ),
          RoundedButton(
            buttonName: title,
            onTap: onPressed,
          )
        ],
      ),
    );
  }
}

class ActivityCount extends StatelessWidget {
  final String value;
  final String title;
  final Color fontColor;
  const ActivityCount(
      {Key key, this.fontColor, this.value = 'xxx', this.title = 'yyyyyyyy'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text(
            value,
            style: TextStyle(fontSize: 30, color: fontColor ?? Colors.white),
          ),
          Text(title,
              style: TextStyle(
                fontSize: 18,
                color: fontColor ?? Colors.white60,
                fontWeight: FontWeight.w300,
              )),
        ],
      ),
    );
  }
}

class ActivityCard extends StatelessWidget {
  final double height;
  final double width;
  final List<Widget> children;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final double spacing;
  const ActivityCard(
      {Key key,
      this.color,
      this.title,
      this.subtitle,
      this.icon,
      this.children,
      this.spacing,
      this.height,
      this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ActivityPanel(
      color: color ?? Theme.of(context).primaryColor.withAlpha(200),
      height: height,
      width: width,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: 60,
                    height: 60,
                    child: ActivityAvatar(
                      avatarBackgroudColor: Colors.white,
                      iconColor: Colors.black,
                      icon: icon ?? Icons.person_pin,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(title ?? '',
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                        )),
                    Text(subtitle ?? '',
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                        )),
                  ],
                ),
              ],
            ),
            Wrap(
              //direction: Axis.vertical,
              direction: Axis.horizontal,
              runAlignment: WrapAlignment.spaceAround,
              //crossAxisAlignment: WrapCrossAlignment.center,
              runSpacing: 2,

              spacing: spacing ?? 24,
              //alignment: WrapAlignment.start,
              //scrollDirection: Axis.horizontal,
              //mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[...children ?? []],
            )
          ],
        ),
      ),
    );
  }
}

enum ActivitySummaryPosition { none, left, right }

class ActivitySummary extends StatelessWidget {
  final String title;
  final double fontSize;
  final Color color;
  final Color fontColor;
  final String value;
  final Color valueFontColor;
  final double percent;
  final int percentDec;
  final String percentLabel;
  final Widget image;
  final double radius;
  final ActivitySummaryPosition position;
  const ActivitySummary(
      {Key key,
      this.fontSize = 72,
      this.radius = 15,
      this.value,
      this.valueFontColor = Colors.black45,
      this.position = ActivitySummaryPosition.right,
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
    return ActivityPanel(
        width: 300,
        height: 150,
        topRadius: radius,
        bottomRadius: radius,
        color: cor.withAlpha(50),
        child: Column(
          children: <Widget>[
            Container(
              height: 32,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(radius),
                  topRight: Radius.circular(radius),
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
                    (position == ActivitySummaryPosition.left))
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
                    ActivityBar(
                      value: percent,
                      showValue: false,
                    ),
                    SizedBox(
                      height: 6,
                    )
                  ],
                ),
                if ((percent != null) &&
                    (position == ActivitySummaryPosition.right))
                  buildActivityPercentValue(),
              ],
            )),
          ],
        ));
  }

  ActivityPercentValue buildActivityPercentValue() {
    return ActivityPercentValue(
        fontColor: valueFontColor,
        image: image,
        percentLabel: percentLabel,
        percent: percent,
        percentDec: percentDec);
  }
}

class ActivityPercentValue extends StatelessWidget {
  const ActivityPercentValue({
    Key key,
    this.fontColor,
    this.image,
    this.percentLabel = '%',
    this.percent,
    this.percentDec = 1,
  }) : super(key: key);
  final Color fontColor;
  final Widget image;
  final String percentLabel;
  final double percent;
  final int percentDec;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(child: Container(child: image)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(percentLabel ?? '',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: fontColor,
                  )),
              Text(percent.toStringAsFixed(percentDec),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: fontColor,
                  )),
            ],
          ),
          SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}

class ActivityBar extends StatelessWidget {
  final double width;
  final double height;
  final double value;
  final Color color;
  final Color backgroundColor;
  final bool showValue;
  ActivityBar(
      {Key key,
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
    var w = width * (value / 100);
    //('$width $w');
    return Container(
      padding: EdgeInsets.only(left: 2, right: 2, bottom: 2, top: 2),
      width: width,
      height: height,

      //color: Colors.amber,
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.backgroundColor,
        border: Border.all(color: theme.textTheme.overline.color.withAlpha(50)),
        //shape: BoxShape.circle,
      ),
      child: Row(
        children: <Widget>[
          Container(
              width: w,
              height: height,
              color: color ?? theme.primaryColor, //Colors.amber,
              child: Center(
                child: showValue
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

class ActivityTextSection extends StatelessWidget {
  final Widget appBar;
  final String title;
  final String text;
  final Widget body;
  final Widget bottom;
  final Color color;
  final Color fontColor;
  final double fontSize;
  final int ordem;
  final String ordemLabel;
  final String Function(BuildContext, String) builder;
  const ActivityTextSection(
      {Key key,
      this.color,
      this.fontColor,
      this.ordem,
      this.ordemLabel,
      this.appBar,
      this.title,
      this.fontSize = 18,
      this.text,
      this.builder,
      this.body,
      this.bottom})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //echo(MediaQuery.of(context).size);
    var t = this.text;
    if (this.builder != null) t = builder(context, text);
    return ActivityPanel(
      color: color ?? Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (appBar != null) appBar,
            if (title != null)
              Text(
                  ((ordem != null)
                          ? (((ordemLabel != null) ? '$ordemLabel ' : '') +
                              '$ordem - ')
                          : '') +
                      (title ?? ''),
                  style: TextStyle(
                    fontSize: fontSize + 10,
                    fontWeight: FontWeight.w300,
                    color: fontColor ?? Colors.black45,
                  )),
            if (body != null) body,
            if (text != null)
              Padding(
                padding: const EdgeInsets.only(
                  top: 2,
                  bottom: 2,
                ),
                child: Text(t,
                    style: TextStyle(
                      fontSize: fontSize,
                      color: fontColor ?? Colors.black54,
                    )),
              ),
            if (bottom != null) bottom,
          ],
        ),
      ),
    );
  }
}

class ActivityImage extends StatelessWidget {
  final double width;
  final double height;
  final Widget image;
  final Widget child;
  final Widget title;

  final Widget body;
  final Color color;
  final Color titleColor;
  final Color childColor;
  final double radius;
  final Widget background;
  const ActivityImage(
      {Key key,
      this.title,
      this.body,
      this.width,
      this.height = 200,
      this.image,
      this.childColor,
      this.child,
      this.color,
      this.titleColor,
      this.radius = 20,
      this.background})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return ActivityPanel(
      width: width,
      height: height,
      topRadius: radius,
      bottomRadius: radius,
      color: color ?? theme.scaffoldBackgroundColor,
      child: Stack(
        children: <Widget>[
          if (background != null) background,
          Column(
            children: <Widget>[
              if (title != null)
                Container(
                  decoration: BoxDecoration(
                    color: titleColor ?? theme.primaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(radius),
                      topRight: Radius.circular(radius),
                      bottomRight: Radius.circular(radius),
                    ),
                  ),
                  constraints: BoxConstraints(minHeight: 30),
                  width: double.maxFinite,
                  child: Align(child: title),
                ),
              (image != null)
                  ? Expanded(child: image)
                  : Expanded(child: body ?? Container()),
              if (child != null)
                Container(
                  width: double.maxFinite,
                  constraints: BoxConstraints(
                    maxHeight: height,
                  ),
                  decoration: BoxDecoration(
                    color: childColor ?? theme.primaryColor.withAlpha(150),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(radius),
                      topRight: Radius.circular(radius),
                      bottomRight: Radius.circular(radius),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: child,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
