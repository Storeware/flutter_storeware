import 'package:flutter/material.dart';

class RadioGrouped extends StatelessWidget {
  final List<String>? children;
  final Function(int)? onChanged;
  final Axis? direction;
  final int? selected;
  final Widget? title;
  final double? itemWidth;
  final Color? activeColor;
  const RadioGrouped(
      {Key? key,
      @required this.children,
      //  this.groupValue = 0,
      this.onChanged,
      this.direction,
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
        print('selected $selected');
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) title!,
            Wrap(
              direction: direction ?? Axis.vertical,
              children: [
                for (var index = 0; index < children!.length; index++)
                  Container(
                    width: itemWidth,
                    alignment: Alignment.centerLeft,
                    child: RadioListTile(
                        value: index,
                        selected: index == _selected,
                        groupValue: _selected,
                        title: Text(children![index]),
                        activeColor: activeColor,
                        dense: true,
                        toggleable: true,
                        onChanged: (b) {
                          if (onChanged != null) onChanged!(index);

                          notifier.value = index;
                        }),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}
