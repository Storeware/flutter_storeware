import 'package:flutter/material.dart';

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

class TopTabViewController {
  _VerticalTabViewState tabView;
  animateTo(int index) => tabView.animateTo(index);
  animateChild(Widget child) => tabView.animateChild(child);
}

class VerticalTabView extends StatefulWidget {
  final List<TabChoice> choices;
  final Drawer drawer;
  final Widget leading;
  final int activeIndex;
  final Widget title;
  final Widget body;
  final double elevator;
  final double height;
  final List<Widget> actions;
  final TopTabViewController controller;
  final Color titleColor;
  final Color indicatorColor;
  final FloatingActionButton floatingActionButton;
  final BottomNavigationBar bottomNavigationBar;
  final Widget bottomSheet;
  final Color backgroundColor;

  const VerticalTabView(
      {Key key,
      this.choices,
      this.body,
      this.leading,
      this.actions,
      this.height = 80,
      this.elevator = 0,
      this.titleColor,
      this.indicatorColor,
      this.title,
      this.controller,
      this.drawer,
      this.activeIndex = 0,
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
  Widget _child;
  TopTabViewController _controller;

  @override
  void initState() {
    _index.value = widget.activeIndex;
    _controller = widget.controller ?? TopTabViewController();
    _controller.tabView = this;

    _child = widget.body ?? widget.choices[_index.value].child;
    super.initState();
  }

  animateTo(int index) {
    _index.value = index;
    if (widget.choices[_index.value].child != null)
      animateChild(widget.choices[_index.value].child);
  }

  animateChild(Widget child) {
    setState(() {
      _child = child;
    });
  }

  selectedItem(int index, int item) {
    _index.value = index;
    animateChild(widget.choices[index].items[item].child);
  }

  Color _indicatorColor;
  Color _titleColor;
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    var _color = widget.titleColor ?? theme.primaryColor;
    _titleColor = _color;
    _indicatorColor = widget.indicatorColor ?? Colors.white.withAlpha(50);
    return Scaffold(
      drawer: widget.drawer,
      floatingActionButton: widget.floatingActionButton,
      bottomNavigationBar: widget.bottomNavigationBar,
      bottomSheet: widget.bottomSheet,
      backgroundColor: widget.backgroundColor,
      appBar: AppBar(
        backgroundColor: widget.titleColor,
        automaticallyImplyLeading: false,
        leading: widget.leading,
        elevation: widget.elevator,
        actions: [
          for (var i = 0; i < widget.choices.length; i++)
            (widget.choices[i].items != null)
                ? buildPopupMenuButton(i, theme)
                : (widget.choices[i].tooltip != null)
                    ? Tooltip(
                        message: widget.choices[i].tooltip,
                        child: buildMaterialButton(i, theme))
                    : buildMaterialButton(i, theme),
          if (widget.actions != null) ...widget.actions,
        ],
        title: widget.title,
      ),
      body: Column(
        children: [
          Expanded(child: _child ?? Container()),
        ],
      ),
    );
  }

  Widget buildPopupMenuButton(int i, ThemeData theme) {
    return ValueListenableBuilder(
        valueListenable: _index,
        builder: (ctx, x, w) => PopupMenuButton<int>(
              tooltip: widget.choices[i].tooltip ?? 'Mostrar itens',
              child: Container(
                color: (x == i) ? _indicatorColor : _titleColor,
                padding: EdgeInsets.only(left: 14, right: 14),
                alignment: Alignment.center,
                height: widget.height,
                child: widget.choices[i].title ??
                    Text(widget.choices[i].text,
                        textAlign: TextAlign.center,
                        style: theme.primaryTextTheme.bodyText1),
              ),
              onSelected: (x) {
                selectedItem(i, x);
              },
              itemBuilder: (x) {
                return [
                  for (var x = 0; x < widget.choices[i].items.length; x++)
                    PopupMenuItem<int>(
                        value: x, child: Text(widget.choices[i].items[x].text))
                ];
              },
            ));
  }

  Widget buildMaterialButton(int i, ThemeData theme) {
    return ValueListenableBuilder(
        valueListenable: _index,
        builder: (ctx, x, w) => MaterialButton(
            color: (x == i) ? _indicatorColor : _titleColor,
            child: widget.choices[i].title ??
                Text(widget.choices[i].text ?? '',
                    style: theme.primaryTextTheme
                        .bodyText1), //TextStyle(color:theme.primaryTextTheme.bodyText1.color ) ),
            onPressed: () {
              animateTo(i);
            }));
  }
}
