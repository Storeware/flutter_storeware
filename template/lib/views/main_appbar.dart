import 'package:flutter/material.dart';

class MainAppBar extends StatelessWidget {
  final String? title;
  final List<Widget>? children;
  const MainAppBar({Key? key, this.title, this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(children: [
        if (title != null) Text(title!),
        ...children ?? [],
      ]),
    );
  }
}
