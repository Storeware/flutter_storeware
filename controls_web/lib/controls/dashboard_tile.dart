import 'package:controls_web/controls/home_elements.dart';
import 'package:flutter/material.dart';

/*
class DashboardTile extends StatelessWidget {
  final String value;
  final Widget body;
  final Widget image;
  final String title;
  final double width;
  final Color color;
  const DashboardTile(
      {Key key,
      this.value,
      this.body,
      this.image,
      this.title,
      this.color,
      this.width = 200})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    Color _textColor = theme.primaryTextTheme.bodyText1.color;
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: ApplienceTile(
        color: color ?? theme.primaryColor,
        titleStyle: TextStyle(color: _textColor, fontSize: 18),
        valueStyle: TextStyle(color: _textColor, fontSize: 28),
        width: width,
        value: value,
        body: body,
        image: image,
        title: title,
      ),
    );
  }
}
*/

class DashboardIcon extends StatelessWidget {
  final IconData icon;
  const DashboardIcon({Key key, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(icon,
        size: 32, color: Theme.of(context).primaryColor.withOpacity(0.5));
  }
}

class DashboardTile extends StatelessWidget {
  final String value;
  final String title;
  final double titleHeight;
  final Color color;
  final Widget image;
  final Widget icon;
  final Widget body;
  final double width;
  final double height;
  const DashboardTile(
      {Key key,
      this.value,
      this.title,
      this.color,
      this.image,
      this.icon,
      this.titleHeight = 25,
      this.width = 180,
      this.height = 80,
      this.body})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color _color = color ?? theme.primaryColor;
    return Theme(
        debugShowCheckedModeBanner: false,
        theme: theme.copyWith(primaryColor: _color),
        builder: (x, w) => Card(
              color: _color.withAlpha(150),
              child: Container(
                width: width,
                height: height,
                //constraints: BoxConstraints(minHeight: 80),
                child: Stack(
                  children: [
                    if (image != null)
                      Positioned(
                        bottom: 10,
                        right: 1,
                        child:
                            Container(color: Colors.transparent, child: image),
                      ),
                    if (icon != null)
                      Positioned(
                        left: 10,
                        top: 10,
                        child: icon,
                      ),
                    Positioned(
                      child: Column(mainAxisSize: MainAxisSize.min,
                          //crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (value != null)
                                    Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                            fontSize: 32,
                                            color: theme.primaryTextTheme
                                                .bodyText1.color),
                                      ),
                                    ),
                                  if (body != null) body,
                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              height: titleHeight,
                              color: _color.withOpacity(0.2),
                              child: Text(
                                title ?? '',
                                style: TextStyle(
                                    fontSize: 18,
                                    color:
                                        theme.primaryTextTheme.bodyText1.color),
                              ),
                            ),
                          ]),
                    ),
                  ],
                ),
              ),
            ));
  }
}
