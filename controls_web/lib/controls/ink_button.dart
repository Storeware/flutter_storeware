import 'package:flutter/material.dart';

class InkButton extends StatelessWidget {
  final Widget child;
  final Function() onTap;
  final String tooltip;
  const InkButton({Key key, this.child, this.onTap, this.tooltip})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: child,
      ),
    );
  }
}
