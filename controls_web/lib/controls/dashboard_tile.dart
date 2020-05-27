import 'package:controls_web/controls/home_elements.dart';
import 'package:flutter/material.dart';

class DashboardIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  const DashboardIcon({Key key, this.icon, this.size = 32}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: size,
      color: Theme.of(context).primaryColor.withOpacity(0.5),
    );
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
        data: theme.copyWith(primaryColor: _color),
        child: Card(
          color: _color.withAlpha(150),
          child: Container(
            width: width,
            height: height,
            //constraints: BoxConstraints(minHeight: 80),
            child: Stack(
              children: [
                if (image != null)
                  Positioned(
                    bottom: this.titleHeight / 2,
                    right: 4,
                    child: Container(color: Colors.transparent, child: image),
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
                                        color: theme
                                            .primaryTextTheme.bodyText1.color),
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
                                color: theme.primaryTextTheme.bodyText1.color),
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
