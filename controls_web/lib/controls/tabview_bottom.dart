import 'package:controls_web/controls/tab_choice.dart';
import 'package:console/widgets/tabview_widget.dart';
import 'package:flutter/material.dart';

class TabViewBottom extends StatefulWidget {
  final List<TabChoice> choices;
  final int activeIndex;
  final Color tabColor;
  final Color iconColor;
  final Color tagColor;
  final Color color;
  final Color indicatorColor;
  final double tabHeight;
  const TabViewBottom({
    Key key,
    this.choices,
    this.activeIndex = 0,
    this.tabColor = Colors.transparent,
    this.color,
    this.iconColor,
    this.tagColor = Colors.amber,
    this.indicatorColor,
    this.tabHeight = kToolbarHeight,
  }) : super(key: key);

  @override
  _TabViewBottomState createState() => _TabViewBottomState();
}

class _TabViewBottomState extends State<TabViewBottom> {
  Widget getChild(int idx) {
    return widget.choices[idx].child ??= widget.choices[idx].builder();
  }

  TabController tabController;

  @override
  Widget build(BuildContext context) {
    ValueNotifier<int> index = ValueNotifier<int>(widget.activeIndex);
//    ValueNotifier<Widget> activeChild =
//        ValueNotifier<Widget>(getChild(activeIndex));
    ThemeData theme = Theme.of(context);
    Color _color = widget.color ?? theme.appBarTheme.color;
    Color _tabColor =
        widget.tabColor ?? theme.appBarTheme.color ?? Colors.amber;
    Color _iconColor = widget.iconColor ?? theme.tabBarTheme.labelColor;
    Color _indicatorColor = widget.indicatorColor ?? widget.tabColor;
    return Column(children: [
      Expanded(
          child: TabBarViewDynamic(
        //key: UniqueKey(),
        itemCount: widget.choices.length,
        activeIndex: widget.activeIndex,
        onControllerChange: (t) {
          tabController = t;
        },
        onPositionChange: (i) => index.value = i,
        builder: (i) {
          //  print(i);
          return getChild(i);
        },
      )),
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: [
            Container(
                height: 1,
                color: theme.dividerColor,
                child: SizedBox.expand(
                    //child: Container(height: 2, color: theme.dividerColor),
                    )),
            Container(
                color: _color,
                height: widget.tabHeight,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.choices.length,
                  itemBuilder: (ctx, i) {
                    var choice = widget.choices[i];
                    return ValueListenableBuilder<int>(
                      valueListenable: index,
                      builder: (BuildContext context, int idx, Widget child) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 4.0, right: 0, top: 4.0),
                          child: InkWell(
                            onTap: () {
                              //activeChild.value = getChild(i);
                              tabController.animateTo(i);
                              //index.value = i;
                            },
                            child: Container(
                                alignment: Alignment.center,
                                color: (idx == i) ? _indicatorColor : _tabColor,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if (choice.image != null)
                                      Flexible(
                                          flex: 2,
                                          child: Center(
                                            child: Padding(
                                                padding: EdgeInsets.all(2),
                                                child: (choice.icon != null)
                                                    ? Icon(choice.icon)
                                                    : choice.image),
                                          )),
                                    if (choice.label != null)
                                      Flexible(
                                        flex: 1,
                                        child: Container(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              if (choice.label != null)
                                                Expanded(
                                                    child: Text(choice.label,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: theme.tabBarTheme
                                                            .labelStyle
                                                            .copyWith(
                                                                color:
                                                                    _iconColor))),
                                              Container(
                                                  height: 2,
                                                  width: choice.width ?? 60,
                                                  color: (idx == i)
                                                      ? widget.tagColor
                                                      : null)
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                )),
                          ),
                        );
                      },
                    );
                  },
                )),
          ],
        ),
      )
    ]);
  }
}
