import 'package:flutter/material.dart';
import '../controls/panel_widget.dart';

class ModalScaffold extends StatelessWidget {
  final Widget? body;
  final Widget? appBar;
  final List<Widget>? actions;
  final double? elevation;
  final Function? onExit;
  const ModalScaffold(
      {Key? key,
      this.body,
      this.appBar,
      this.actions,
      this.elevation,
      this.onExit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var acts = actions ?? [];
    acts.add(IconButton(
      icon: Icon(Icons.close),
      onPressed: () {
        Navigator.of(context).pop();
      },
    ));
    return Panel(
        title: appBar, actions: acts, elevation: elevation, child: body);
  }
}
