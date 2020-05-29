import 'package:controls_web/controls/responsive.dart';
import 'package:flutter/material.dart';

class TabChoice {
  final Widget child;
  final IconData icon;
  final String title;
  final int index;
  final Widget image;
  final bool primary;
  TabChoice({
    this.icon,
    this.child,
    this.title,
    this.image,
    this.index,
    this.primary = false,
  });
}

enum HorizontalTabViewSiderBarType { hide, compact, show }

class HorizontalTabView extends StatelessWidget {
  final List<TabChoice> choices;
  final Color tabColor;
  final Color indicatorColor;
  final Color iconColor;
  final AppBar appBar;
  final Color backgroundColor;
  final Widget pageBottom;
  final HorizontalTabViewSiderBarType sidebarType;
  final double elevation;
  final Widget floatingActionButton;
  HorizontalTabView({
    Key key,
    this.choices,
    this.appBar,
    this.sidebarType,
    this.indicatorColor = Colors.blue,
    this.backgroundColor,
    this.iconColor = Colors.white,
    this.tabColor = Colors.blue,
    this.pageBottom,
    this.elevation = 0,
    this.floatingActionButton,
  }) : super(key: key);
  final ValueNotifier<int> _index = ValueNotifier<int>(0);
  @override
  Widget build(BuildContext context) {
    ResponsiveInfo responsive = ResponsiveInfo(context);

    if (responsive.isSmall) return mobileBuild(context);

    HorizontalTabViewSiderBarType _sidebarType = sidebarType ??
        (responsive.isSmall
            ? HorizontalTabViewSiderBarType.hide
            : (responsive.isMobile
                ? HorizontalTabViewSiderBarType.compact
                : HorizontalTabViewSiderBarType.show));

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
                          width: [0.0, 100.0, 180.0][_sidebarType.index],
                          color: Colors.transparent,
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
                                            child: Column(
                                              children: [
                                                if (choices[index].image !=
                                                    null)
                                                  choices[index].image,
                                                if (choices[index].icon != null)
                                                  Icon(choices[index].icon,
                                                      color: iconColor),
                                                if (_index.value == index)
                                                  Text(choices[index].title,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: iconColor,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ))
                                              ],
                                            ),
                                            onPressed: () {
                                              _index.value = index;
                                            })
                                        : ListTile(
                                            leading:
                                                (choices[index].image != null)
                                                    ? choices[index].image
                                                    : Icon(
                                                        choices[index].icon,
                                                        color: iconColor,
                                                      ),
                                            title: Text(choices[index].title,
                                                style: TextStyle(
                                                    color: iconColor)),
                                            onTap: () {
                                              _index.value = index;
                                            },
                                          ),
                                  )
                              ],
                            ),
                          )),
                    //VerticalDivider(),
                    Expanded(
                      child: Scaffold(
                          backgroundColor: Colors.transparent,
                          body: choices[_index.value].child),
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
                      padding: EdgeInsets.all(8),
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
                                Text(
                                  tab.title,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: iconColor ??
                                        theme.primaryTextTheme.bodyText1.color,
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
                              MaterialPageRoute(builder: (x) => tab.child),
                            );
                          else
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (x) => Scaffold(
                                  appBar: AppBar(
                                      title: Text(
                                    tab.title,
                                  )),
                                  body: tab.child,
                                ),
                              ),
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
