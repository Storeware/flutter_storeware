// @dart=2.12

//import 'package:console/widgets/menu_button.dart';
import 'package:flutter/material.dart';

class DropdownMenuEx extends StatefulWidget {
  final Widget? title;
  final int itemCount;
  final Widget Function(BuildContext context, int index) builder;
  final Function(int)? onChanged;
  final Color? color;
  const DropdownMenuEx(
      {Key? key,
      this.title,
      required this.builder,
      required this.itemCount,
      this.color,
      this.onChanged})
      : super(key: key);

  @override
  _DropdownMenuExState createState() => _DropdownMenuExState();
}

class _DropdownMenuExState extends State<DropdownMenuEx> {
  late ValueNotifier<bool> toggle;
  @override
  void initState() {
    super.initState();
    toggle = ValueNotifier<bool>(false);
  }

  @override
  Widget build(BuildContext context) {
    return buildButtonDown2(context);
  }

  Widget buildButtonDown2(contex) {
    return ExpansionTile(
      title: FittedBox(child: widget.title!),
      children: [
        for (var i = 0; i < widget.itemCount; i++)
          DropdownMenuItem<int>(value: i, child: widget.builder(context, i))
      ],
    );
  }
}
