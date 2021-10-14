// @dart=2.12
import 'package:flutter/material.dart';
import 'package:controls_extensions/extensions.dart';

class GroupButtons extends StatefulWidget {
  final List<String> options;
  final List<String>? tooltips;
  final Function(int index) onChanged;
  final int itemIndex;
  final Color? color;
  final ValueNotifier<int>? notifier;
  const GroupButtons(
      {Key? key,
      required this.options,
      this.itemIndex = -1,
      this.color,
      this.notifier,
      this.tooltips,
      required this.onChanged})
      : super(key: key);

  @override
  _GroupButtonsState createState() => _GroupButtonsState();
}

class _GroupButtonsState extends State<GroupButtons> {
  late ValueNotifier<int> focused;

  @override
  void initState() {
    super.initState();
    focused = widget.notifier ?? ValueNotifier(widget.itemIndex);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return ValueListenableBuilder<int>(
      valueListenable: focused,
      builder: (a, value, c) => Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          alignment: WrapAlignment.start,
          children: [
            for (var i = 0; i < widget.options.length; i++)
              Padding(
                padding: const EdgeInsets.only(right: 2.0),
                //child: InkWell(
                child: ChoiceChip(
                  tooltip:
                      (widget.tooltips == null) ? null : widget.tooltips![i],
                  selected: value == i,
                  key: ValueKey(i),
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity(horizontal: 0.0, vertical: -4),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  backgroundColor:
                      theme.dividerColor.lighten(60), // ?? Colors.transparent,
                  label: Text(widget.options[i],
                      style: TextStyle(
                          fontSize: 12,
                          color: (value == i) ? theme.primaryColor : null)),
                  onSelected: (b) {
                    saved(i);
                  },
                ),
                //onTap: () {
                //  saved(i);
                //}),
              ),
          ],
        ),
      ),
    );
  }

  saved(int index) {
    widget.onChanged(index);
    focused.value = index;
  }
}
