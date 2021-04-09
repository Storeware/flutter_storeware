import 'package:flutter/material.dart';

class IconBadge extends StatefulWidget {
  final IconData? icon;
  final int? value;

  IconBadge({Key? key, this.icon, this.value = 0}) : super(key: key);

  @override
  _IconBadgeState createState() => _IconBadgeState();
}

class _IconBadgeState extends State<IconBadge> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        if (widget.icon != null)
          Icon(
            widget.icon,
          ),
        Positioned(
            right: 0.0, child: BadgeText(value: widget.value.toString())),
      ],
    );
  }
}

class BadgeText extends StatelessWidget {
  final String? value;
  final Color? color;
  const BadgeText({
    Key? key,
    this.value,
    this.color,
    //@required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor,
        borderRadius: BorderRadius.circular(6),
      ),
      constraints: BoxConstraints(
        minWidth: 13,
        minHeight: 13,
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 1),
        child: Text(
          value ?? '',
          style: TextStyle(
            color: color ?? Colors.white,
            fontSize: 8,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
