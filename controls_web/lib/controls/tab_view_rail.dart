import 'package:flutter/material.dart';

class TabChoice {
  IconData icon;
  IconData selectedIcon;
  String label;
  Widget child;
  Widget image;
  int index;
  TabChoice({
    this.icon,
    this.image,
    this.selectedIcon,
    this.label,
    this.index,
    this.child,
  });
}

enum TabViewRailPosition { left, rigth }

class TabViewRailController {
  int activeIndex = 0;
  Function(TabChoice) onTabChanged;
}

class TabViewRail extends StatelessWidget {
  final AppBar appBar;
  final TabViewRailPosition position;
  final List<TabChoice> choices;
  final double divider;
  final TabViewRailController controller;
  final Function(TabChoice) builder;
  TabViewRail(
      {Key key,
      this.appBar,
      this.choices,
      this.position = TabViewRailPosition.left,
      this.divider = 1,
      this.controller,
      this.builder})
      : super(key: key);

  final ValueNotifier<int> _selectedIndex = ValueNotifier<int>(0);
  get isLeft => position == TabViewRailPosition.left;
  get isRight => position == TabViewRailPosition.rigth;
  @override
  Widget build(BuildContext context) {
    final _controller = controller ?? TabViewRailController();

    _selectedIndex.value = _controller.activeIndex;
    return Scaffold(
      appBar: appBar,
      body: ValueListenableBuilder(
        valueListenable: _selectedIndex,
        builder: (a, b, c) => Row(
          children: <Widget>[
            // This is the main content.
            if (isRight)
              Expanded(
                child: (builder != null)
                    ? builder(choices[_selectedIndex.value])
                    : choices[_selectedIndex.value].child,
              ),
            if (isRight && (divider > 0))
              VerticalDivider(thickness: 1, width: divider),

            NavigationRail(
              selectedIndex: _selectedIndex.value,
              onDestinationSelected: (int index) {
                if (_controller.onTabChanged != null)
                  _controller.onTabChanged(choices[index]);
                _selectedIndex.value = index;
              },
              labelType: NavigationRailLabelType.selected,
              destinations: [
                for (var tab in choices)
                  NavigationRailDestination(
                    label: Text(tab.label),
                    icon: tab.image ?? Icon(tab.icon),
                    selectedIcon: (tab.selectedIcon != null)
                        ? Icon(tab.selectedIcon)
                        : null,
                  ),
              ],
            ),
            if (isLeft && (divider > 0))
              VerticalDivider(thickness: 1, width: divider),
            // This is the main content.
            if (isLeft)
              Expanded(
                child: (builder != null)
                    ? builder(choices[_selectedIndex.value])
                    : choices[_selectedIndex.value].child,
              )
          ],
        ),
      ),
    );
  }
}
