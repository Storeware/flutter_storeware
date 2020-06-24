import 'package:flutter/material.dart';

class TabChoice {
  Widget Function() builder;
  String text;
  bool visible;
  TabChoice({this.builder, this.text, this.visible = true});
}

class VerticalToptabNavigator extends StatefulWidget {
  final List<TabChoice> choices;
  final Function(int, TabChoice) onSelectItem;
  final int initialIndex;
  final Color indicatorColor;
  final Color selectedColor;
  VerticalToptabNavigator(
      {Key key,
      @required this.choices,
      this.onSelectItem,
      this.initialIndex = 0,
      this.selectedColor,
      this.indicatorColor = Colors.amber})
      : super(key: key);

  @override
  _VerticalToptabNavigatorState createState() =>
      _VerticalToptabNavigatorState();
}

class _VerticalToptabNavigatorState extends State<VerticalToptabNavigator> {
  ValueNotifier<int> active;

  @override
  Widget build(BuildContext context) {
    if (active == null) {
      active = ValueNotifier<int>(widget.initialIndex);
      if (active.value >= 0)
        widget.onSelectItem(active.value, widget.choices[active.value]);
    }
    return Container(
      padding: const EdgeInsets.all(3.0),
      height: 36,
      width: double.maxFinite,
      child: ValueListenableBuilder<int>(
        valueListenable: active,
        builder: (a, b, w) => Row(children: [
          Expanded(child: Container()),
          for (var index = 0; index < widget.choices.length; index++)
            Container(
              color: (active.value == index) ? widget.selectedColor : null,
              child: InkWell(
                //color: (active.value == index) ? widget.selectedColor : null,
                child: (!widget.choices[index].visible)
                    ? Container()
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(widget.choices[index].text))),
                          Container(
                              height: 2,
                              width: widget.choices[index].text.length * 14.0,
                              color: (active.value == index)
                                  ? widget.indicatorColor
                                  : null)
                        ],
                      ),
                onTap: () {
                  widget.onSelectItem(index, widget.choices[index]);
                  active.value = index;
                },
              ),
            )
        ]),
      ),
    );
  }
}
