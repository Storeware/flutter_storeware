import 'package:controls_web/controls/tab_choice.dart';
import 'package:flutter/material.dart';

class HorizontalTab<T> extends StatefulWidget {
  final List<TabChoice<T>>? choices;
  final double? width;
  final int? initialIndex;
  final Color? indicatorColor;
  final Color? iconColor;
  final Color? color;
  final Color? selectedColor;
  final Widget? footer;
  final Widget? header;
  final Widget? body;

  final Function(int, TabChoice<T>)? onSelectItem;
  const HorizontalTab({
    Key? key,
    this.choices,
    this.width = 120,
    this.initialIndex = 0,
    this.indicatorColor = Colors.amber,
    this.onSelectItem,
    this.color,
    this.iconColor,
    this.selectedColor,
    this.footer,
    this.header,
    this.body,
  }) : super(key: key);

  @override
  _HorizontalTabState createState() => _HorizontalTabState();
}

class _HorizontalTabState extends State<HorizontalTab> {
  ValueNotifier<int>? _index;
  get index => _index!.value;
  Color? color;
  Color? selectedColor;
  Color? _iconColor;
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    _iconColor = widget.iconColor ?? Colors.black87;
    color = widget.color ?? theme.primaryColor;
    selectedColor =
        widget.selectedColor ?? color!.withOpacity(0.5); //color.withAlpha(100);
    _index = ValueNotifier<int>(widget.initialIndex!);
    if (widget.initialIndex! >= 0) if (widget.onSelectItem != null)
      widget.onSelectItem!(
          widget.initialIndex!, widget.choices![widget.initialIndex!]);
    return Container(
      width: widget.width,
      child: Column(
        children: [
          if (widget.header != null) widget.header!,
          Expanded(
            child: ListView(
              children: [
                for (var i = 0; i < widget.choices!.length; i++) buildItem(i)
              ],
            ),
          ),
          if (widget.body != null) widget.body!,
          if (widget.footer != null) widget.footer!,
        ],
      ),
    );
  }

  buildItem(idx) {
    TabChoice tab = widget.choices![idx];
    if (tab.icon != null) tab.image = Icon(tab.icon, color: _iconColor);
    return GestureDetector(
      child: ValueListenableBuilder(
        valueListenable: _index!,
        builder: (x, y, z) => Container(
            color: (y == idx) ? selectedColor : color,
            alignment: Alignment.center,
            height: kMinInteractiveDimension,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (tab.image != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: tab.image,
                      ),
                    Container(
                        //width: double.maxFinite,
                        alignment: Alignment.center,
                        child: tab.title ??
                            Text(tab.label,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: _iconColor))),
                    if (tab.image != null) Expanded(child: Container()),
                    if (tab.trailing != null) tab.trailing
                  ],
                )),
                Container(
                    height: 2, color: (y == idx) ? widget.indicatorColor : null)
              ],
            )),
      ),
      onTap: () {
        if (widget.onSelectItem != null) widget.onSelectItem!(idx, tab);
        _index!.value = idx;
      },
    );
  }
}
