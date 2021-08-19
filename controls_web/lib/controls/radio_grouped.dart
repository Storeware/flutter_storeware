import 'package:flutter/material.dart';

class RadioGrouped extends StatelessWidget {
  final List<String>? children;
  final Function(int)? onChanged;
  final Axis? direction;
  final int? selected;
  final Widget? title;
  final double? itemWidth;
  final Color? activeColor;
  final CrossAxisAlignment? crossAxisAlignment;
  const RadioGrouped(
      {Key? key,
      @required this.children,
      //  this.groupValue = 0,
      this.onChanged,
      this.direction,
      this.crossAxisAlignment,
      this.selected = 0,
      this.title,
      this.itemWidth,
      this.activeColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ValueNotifier<int> notifier = ValueNotifier<int>(selected!);
    return ValueListenableBuilder(
      valueListenable: notifier,
      builder: (a, _selected, w) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
          children: [
            if (title != null) title!,
            Wrap(
              runAlignment: WrapAlignment.start,
              direction: direction ?? Axis.vertical,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                for (var index = 0; index < children!.length; index++) ...[
                  Container(
                    width: itemWidth,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Radio(
                            value: index,
                            groupValue: _selected,
                            activeColor: activeColor,
                            toggleable: true,
                            onChanged: (b) {
                              if (onChanged != null) onChanged!(index);
                              notifier.value = index;
                            }),
                        Text(children![index]),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ],
        );
      },
    );
  }
}
