import 'package:flutter/material.dart';

class ActivityPanel extends StatelessWidget {
  final Widget child;
  final Color color;
  final double height;
  final double width;
  const ActivityPanel(
      {Key key, this.color, this.width, this.height, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color,
      ),
      child: child,
    );
  }
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
  const ActivityTile(
      {Key key,
      this.color,
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
  const ActivityButton({
    Key key,
    this.icon,
    this.image,
    this.title,
    this.onPressed,
    this.fontColor,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
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
            Text(
              title ?? '',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w300,
                color: fontColor ?? Colors.black54,
              ),
            ),
          ],
        ),
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
