import 'package:flutter/material.dart';

import 'fonts.dart';

class ApplienceValue extends StatelessWidget {
  final Color? titleColor;
  final String? title;
  final String? value;
  final double? spaces;
  final double? width;
  final double? height;
  const ApplienceValue(
      {Key? key,
      this.title,
      this.spaces = 2,
      this.titleColor,
      this.value,
      this.width,
      this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.all(spaces!),
      child: Container(
        width: width,
        height: height,
        child: Column(children: [
          Container(
              width: double.maxFinite,
              alignment: Alignment.center,
              child: Text(title!,
                  style: TextStyle(color: theme.scaffoldBackgroundColor)),
              color: titleColor ?? theme.primaryColor),
          Text(value!,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w300)),
        ]),
      ),
    );
  }
}

class ApplienceContainer extends StatefulWidget {
  final String? title;
  final Widget? child;
  final Color? color;
  final double? width;
  final double? height;
  final double? elevation;
  final double? radius;
  ApplienceContainer({
    Key? key,
    this.child,
    this.color,
    this.width,
    this.height,
    this.elevation = 10,
    this.radius = 4,
    this.title,
  }) : super(key: key);

  @override
  _ApplienceContainerState createState() => _ApplienceContainerState();
}

class _ApplienceContainerState extends State<ApplienceContainer> {
  ThemeData? theme;

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return (widget.title == null)
        ? buildPainel()
        : Column(
            children: <Widget>[
              if (widget.title != null)
                Align(
                    alignment: Alignment.centerLeft,
                    child: textBold(widget.title, size: 18)),
              buildPainel(),
            ],
          );
  }

  buildPainel() {
    return Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
            boxShadow: [
              new BoxShadow(
                color: theme!.scaffoldBackgroundColor.withAlpha(50),
                //color: Colors.grey.withAlpha(50),
                blurRadius: widget.elevation!,
              ),
              new BoxShadow(
                color: theme!.scaffoldBackgroundColor.withAlpha(50),
//                color: Colors.grey.withAlpha(50),
                blurRadius: widget.elevation!,
              ),
            ],
            color: widget.color ?? theme!.dividerColor,
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(widget.radius!))),
        child: widget.child);
  }
}

class ApplienceBody extends StatelessWidget {
  final Widget? child;
  final EdgeInsets? padding;
  final BoxConstraints? constraints;
  const ApplienceBody({Key? key, this.child, this.padding, this.constraints})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: padding ?? EdgeInsets.all(8.0),
        child: Container(
          //constraints: constraints,
          child: child,
        ),
      ),
    );
  }
}
