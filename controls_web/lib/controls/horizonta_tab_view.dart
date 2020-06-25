import 'package:controls_web/controls/responsive.dart';
import 'package:flutter/material.dart';
import 'package:controls_web/controls/tab_choice.dart';

enum HorizontalTabViewSiderBarType { hide, compact, show }

class HorizontalTabViewController {
  HorizontalTabView tabControl;
  animateTo(int index) {
    tabControl.animateTo(index);
  }
}

class HorizontalTabView extends StatelessWidget {
  final List<TabChoice> choices;
  final HorizontalTabViewController controller;
  final Color tabColor;
  final Color indicatorColor;
  final Color iconColor;
  final AppBar appBar;
  final Color color;
  final double width;
  final Color backgroundColor;
  final Widget pageBottom;
  final EdgeInsets padding;
  final HorizontalTabViewSiderBarType sidebarType;
  final double elevation;
  final Widget floatingActionButton;
  final Color tagColor;
  final bool isMobile;
  HorizontalTabView({
    Key key,
    this.choices,
    this.appBar,
    this.padding,
    this.width,
    this.sidebarType,
    this.controller,
    this.tagColor = Colors.amber,
    this.indicatorColor = Colors.blue,
    this.backgroundColor,
    this.iconColor = Colors.white,
    this.tabColor = Colors.lightBlue,
    this.pageBottom,
    this.isMobile,
    this.color, //= Colors.lightBlue,
    this.elevation = 0,
    this.floatingActionButton,
  }) : super(key: key);
  final ValueNotifier<int> _index = ValueNotifier<int>(0);

  animateTo(int index) {
    _index.value = index;
  }

  @override
  Widget build(BuildContext context) {
    var _controller = controller ?? HorizontalTabViewController();
    _controller.tabControl = this;
    ResponsiveInfo responsive = ResponsiveInfo(context);

    if (isMobile ?? responsive.isSmall) return mobileBuild(context);

    HorizontalTabViewSiderBarType _sidebarType = sidebarType ??
        (isMobile ?? responsive.isMobile
            ? HorizontalTabViewSiderBarType.compact
            : HorizontalTabViewSiderBarType.show);

    return ValueListenableBuilder(
        valueListenable: _index,
        builder: (a, b, c) {
          return Theme(
              data: ThemeData.light()
                  .copyWith(scaffoldBackgroundColor: Colors.transparent),
              child: Scaffold(
                backgroundColor: backgroundColor,
                appBar: appBar,
                bottomNavigationBar: pageBottom,
                floatingActionButton: floatingActionButton,
                body: Row(
                  children: [
                    if (_sidebarType != HorizontalTabViewSiderBarType.hide)
                      Container(
                          width:
                              width ?? [0.0, 100.0, 180.0][_sidebarType.index],
                          color: color ?? Colors.transparent,
                          child: SizedBox.expand(
                            child: Column(
                              children: [
                                for (var index = 0;
                                    index < choices.length;
                                    index++)
                                  Container(
                                    color: (_index.value == index)
                                        ? indicatorColor
                                        : tabColor,
                                    child: (_sidebarType !=
                                            HorizontalTabViewSiderBarType.show)
                                        ? MaterialButton(
                                            padding: EdgeInsets.zero,
                                            child: Column(
                                              children: [
                                                if (choices[index].image !=
                                                    null)
                                                  choices[index].image,
                                                if (choices[index].icon != null)
                                                  Icon(choices[index].icon,
                                                      color: iconColor),
                                                if (_index.value == index)
                                                  choices[index].title ??
                                                      Text(choices[index].label,
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: iconColor,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          )),
                                              ],
                                            ),
                                            onPressed: () {
                                              _index.value = index;
                                            })
                                        : Row(children: [
                                            Container(
                                                height: kToolbarHeight,
                                                width: 5,
                                                color: (_index.value == index)
                                                    ? tagColor
                                                    : tabColor),
                                            Expanded(
                                                child: ListTile(
                                              leading:
                                                  (choices[index].image != null)
                                                      ? choices[index].image
                                                      : Icon(
                                                          choices[index].icon,
                                                          color: iconColor,
                                                        ),
                                              title: choices[index].title ??
                                                  Text(choices[index].label,
                                                      style: TextStyle(
                                                          color: iconColor)),
                                              onTap: () {
                                                _index.value = index;
                                              },
                                            )),
                                          ]),
                                  ),
                              ],
                            ),
                          )),
                    //VerticalDivider(),
                    Expanded(
                      child: Scaffold(
                          backgroundColor: Colors.transparent,
                          body: Builder(builder: (x) {
                            if (choices[_index.value].child == null)
                              choices[_index.value].child =
                                  choices[_index.value].builder();
                            return choices[_index.value].child;
                          })),
                    )
                  ],
                ),
              ));
        });
  }

  mobileBuild(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ThemeData theme = Theme.of(context);
    int cols = size.width ~/ 200;
    if (size.width < 411) cols = 2;
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: appBar,
        bottomNavigationBar: pageBottom,
        floatingActionButton: floatingActionButton,
        body: Stack(children: [
          Center(
            child: GridView.count(
              primary: false,
              crossAxisCount: cols,
              children: List.generate(
                choices.length,
                (index) {
                  TabChoice tab = choices[index];
                  return Padding(
                      padding: padding ?? EdgeInsets.all(8),
                      child: InkWell(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                tab.image ??
                                    Icon(
                                      tab.icon,
                                      size: 80,
                                      color: iconColor ??
                                          theme
                                              .primaryTextTheme.bodyText1.color,
                                    ),
                                tab.title ??
                                    Text(
                                      tab.label,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: iconColor ??
                                            theme.primaryTextTheme.bodyText1
                                                .color,
                                      ),
                                    ),
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          if (tab.primary)
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (x) {
                                if (tab.child == null)
                                  tab.child = tab.builder();
                                return tab.child;
                              }),
                            );
                          else
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (x) {
                                if (tab.child == null)
                                  tab.child = tab.builder();
                                return Scaffold(
                                  appBar: AppBar(
                                      title: tab.title ??
                                          Text(
                                            tab.label,
                                          )),
                                  body: tab.child,
                                );
                              }),
                            );
                        },
                      ));
                },
              ),
            ),
          ),
        ]));
  }
}
