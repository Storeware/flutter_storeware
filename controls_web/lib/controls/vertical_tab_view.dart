import 'package:flutter/material.dart';
import 'tab_choice.dart';

/*
class TabChoice {
  int index;
  String text;
  Widget title;
  Widget child;
  String tooltip;
  List<TabChoice> items;
  TabChoice(
      {this.index,
      this.text,
      this.child,
      this.title,
      this.tooltip,
      this.items});
}
*/

class VerticalTabViewController {
  final Function(int, TabChoice)? onSelectedItem;
  VerticalTabViewController({this.onSelectedItem});
  _VerticalTabViewState? tabView;
  animateTo(int index) {
    if (tabView != null) tabView!.animateTo(index);
  }

  animateChild(Widget child) {
    if (tabView != null) tabView!.animateChild(child);
  }

  goHome() {
    if (tabView != null) tabView!.goHome();
  }

  selectedItem(int index, TabChoice item) {
    if (tabView != null) tabView!.selectedItem(index, item);
    if (onSelectedItem != null) onSelectedItem!(index, item);
  }
}

class VerticalTabView extends StatefulWidget {
  final List<TabChoice>? choices;
  final Drawer? drawer;
  final Widget? leading;
  final int? initialIndex;
  final Widget? title;
  final Widget? home;
  final double? elevation;
  final double? height;
  final List<Widget>? actions;
  final VerticalTabViewController? controller;
  final Color? titleColor;
  final Color? indicatorColor;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Widget? bottomSheet;
  final Color? backgroundColor;

  const VerticalTabView(
      {Key? key,
      this.choices,
      this.home,
      this.leading,
      this.actions,
      this.height = 80,
      this.elevation = 0,
      this.titleColor,
      this.indicatorColor,
      this.title,
      this.controller,
      this.drawer,
      this.initialIndex = 0,
      this.floatingActionButton,
      this.bottomNavigationBar,
      this.bottomSheet,
      this.backgroundColor})
      : super(key: key);

  @override
  _VerticalTabViewState createState() => _VerticalTabViewState();
}

class _VerticalTabViewState extends State<VerticalTabView> {
  ValueNotifier<int> _index = ValueNotifier<int>(0);
  Widget? _child;
  VerticalTabViewController? _controller;

  @override
  void initState() {
    _index.value = widget.initialIndex!;
    _controller = widget.controller ?? VerticalTabViewController();
    _controller!.tabView = this;

    _child = widget.home ?? widget.choices![_index.value].child;
    super.initState();
  }

  animateTo(int index) {
    _index.value = index;
    if (widget.choices![_index.value].child != null)
      selectedItem(index, widget.choices![_index.value]);
  }

  animateChild(Widget child) {
    setState(() {
      _child = child;
    });
  }

  selectedItem(int index, TabChoice item) {
    _index.value = index;
    animateChild(item.child!);
  }

  goHome() {
    animateChild(widget.home!);
  }

  @override
  Widget build(BuildContext context) {
    //ThemeData theme = Theme.of(context);
    var appBar = AppBar(
        leading: widget.leading,
        elevation: widget.elevation,
        title: TopAppBar(
          controller: _controller,
          title: widget.title,
          elevation: widget.elevation,
          actions: widget.actions,
          height: widget.height,
          indicatorColor: widget.indicatorColor,
          choices: widget.choices,
          selected: _index.value,
          titleColor: widget.titleColor,
        ));
    return Scaffold(
      drawer: widget.drawer,
      floatingActionButton: widget.floatingActionButton,
      bottomNavigationBar: widget.bottomNavigationBar,
      bottomSheet: widget.bottomSheet,
      backgroundColor: widget.backgroundColor,
      appBar: appBar,
      body: Column(
        children: [
          Expanded(child: _child ?? Container()),
        ],
      ),
    );
  }
}

class TopAppBar extends StatefulWidget {
  final Color? titleColor, indicatorColor;
  final Widget? leading;
  final List<TabChoice>? choices;
  final double? elevation;
  final List<Widget>? actions;
  final Widget? title;
  final int? selected;
  final double? height;
  final VerticalTabViewController? controller;
  TopAppBar(
      {Key? key,
      this.titleColor,
      this.leading,
      this.choices,
      this.elevation = 0,
      this.actions,
      this.title,
      this.selected,
      this.height,
      @required this.controller,
      this.indicatorColor})
      : super(key: key);

  @override
  _TopAppBarState createState() => _TopAppBarState();
}

class _TopAppBarState extends State<TopAppBar> {
  ValueNotifier<int> _index = ValueNotifier<int>(0);

  Color? _indicatorColor, _titleColor;

  index(int idx) {
    _index.value = idx;
  }

  @override
  Widget build(BuildContext context) {
    // print('build');
    _index.value = widget.selected!;
    ThemeData theme = Theme.of(context);

    var _color = widget.titleColor ?? theme.primaryColor;
    _titleColor = _color;
    _indicatorColor = widget.indicatorColor ?? Colors.white.withAlpha(50);

    return AppBar(
      backgroundColor: widget.titleColor,
      automaticallyImplyLeading: false,
      leading: widget.leading,
      elevation: widget.elevation,
      actions: [
        for (var i = 0; i < widget.choices!.length; i++)
          (widget.choices![i].items != null)
              ? buildPopupMenuButton(i, theme)
              : (widget.choices![i].tooltip != null)
                  ? Tooltip(
                      message: widget.choices![i].tooltip!,
                      child: buildMaterialButton(i, theme))
                  : buildMaterialButton(i, theme),
        if (widget.actions != null) ...widget.actions!,
      ],
      title: widget.title,
    );
  }

  Widget buildPopupMenuButton(int i, ThemeData theme) {
    return ValueListenableBuilder(
        valueListenable: _index,
        builder: (ctx, x, w) => PopupMenuButton<int>(
              tooltip: widget.choices![i].tooltip ?? 'Mostrar itens',
              child: Container(
                color: (x == i) ? _indicatorColor : _titleColor,
                padding: EdgeInsets.only(left: 14, right: 14),
                alignment: Alignment.center,
                height: widget.height,
                child: widget.choices![i].title ??
                    Text(widget.choices![i].label!,
                        textAlign: TextAlign.center,
                        style: theme.primaryTextTheme.bodyText1),
              ),
              onSelected: (x) {
                selectedItem(i, widget.choices![i].items![x]);
              },
              itemBuilder: (x) {
                return [
                  for (var x = 0; x < widget.choices![i].items!.length; x++)
                    PopupMenuItem<int>(
                        value: x,
                        child: Text(widget.choices![i].items![x].label!))
                ];
              },
            ));
  }

  Widget buildMaterialButton(int i, ThemeData theme) {
    return ValueListenableBuilder(
        valueListenable: _index,
        builder: (ctx, x, w) => MaterialButton(
            color: (x == i) ? _indicatorColor : _titleColor,
            child: widget.choices![i].title ??
                Text(widget.choices![i].label ?? '',
                    style: theme.primaryTextTheme
                        .bodyText1), //TextStyle(color:theme.primaryTextTheme.bodyText1.color ) ),
            onPressed: () {
              selectedItem(i, widget.choices![i]);
            }));
  }

  selectedItem(int idx, TabChoice item) {
    _index.value = idx;
    widget.controller!.selectedItem(idx, item);
  }
}
