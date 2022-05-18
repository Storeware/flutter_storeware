// @dart=2.12
import 'dart:async';
import 'dart:ui';

//import 'package:console/views/agenda/dropdown_menu.dart';
import 'package:controls_web/controls/responsive.dart';
import 'package:flutter/material.dart';
import 'package:controls_web/controls/tab_choice.dart';
import 'package:flutter/widgets.dart';
import 'package:controls_web/controls/widget_extensions.dart';

enum HorizontalTabViewSiderBarType { hide, compact, show }

class HorizontalTabViewController {
  _HorizontalTabViewState? tabControl;
  animateTo(int index) {
    if (tabControl != null) tabControl!.animateTo(index);
  }
}

class HorizontalTabView extends StatefulWidget {
  final List<TabChoice>? choices;
  final double? top, bottom, left, right;
  final HorizontalTabViewController? controller;
  final Color? tabColor;
  final Color? sidebarBackgroundColor;
  final Color? indicatorColor;
  final Color? iconColor;
  final AppBar? appBar;
  final Widget? topBar, bottomBar;
  final Widget? sidebarHeader, sidebarFooter;
  final int? mobileCrossCount;
  final Color? color;
  final double? width;
  final double? minWidth;
  final Color? backgroundColor;
  final Widget? pageBottom;
  final EdgeInsets? padding;
  final HorizontalTabViewSiderBarType? sidebarType;
  final double? elevation;
  final Widget? floatingActionButton;
  final Color? tagColor;
  final bool? isMobile;
  final double? tabHeight;
  final Widget Function(TabChoice choice)? tabBuilder;
  final double? tabPadding;
  final TextStyle? tabStyle;
  //final double tabHeightCompact;
  final AppBar? sidebarAppBar;
  final Drawer? sidebarDrawer;
  final Widget? sidebarRight;
  final Function(int)? onChanged;
  final int? activeIndex;
  final Color? selectedColor;
  final double? leftRadius;
  HorizontalTabView({
    Key? key,
    @required this.choices,
    this.appBar,
    this.sidebarAppBar,
    this.sidebarDrawer,
    this.padding,
    this.width = 220,
    this.tabHeight = kToolbarHeight,
    this.tabStyle,
    this.top = 0,
    this.bottom = 0,
    this.left = 0,
    this.tabPadding = 4,
    this.selectedColor,
    this.leftRadius = 0,
    this.right = 0,
    this.topBar,
    this.bottomBar,
    //this.tabHeightCompact,
    this.sidebarBackgroundColor,
    this.sidebarType,
    this.controller,
    this.tagColor = Colors.amber,
    this.mobileCrossCount,
    this.indicatorColor = Colors.blue,
    this.backgroundColor,
    this.tabBuilder,
    this.iconColor, //= Colors.white,
    this.tabColor = Colors.lightBlue,
    this.pageBottom,
    this.isMobile,
    this.minWidth = 100,
    this.color, //= Colors.lightBlue,
    this.elevation = 0,
    this.sidebarHeader,
    this.sidebarFooter,
    this.floatingActionButton,
    this.sidebarRight,
    this.onChanged,
    this.activeIndex,
  })  : assert(choices != null, 'Nao passou "choices"'),
        super(key: key);

  @override
  _HorizontalTabViewState createState() => _HorizontalTabViewState();
}

class _HorizontalTabViewState extends State<HorizontalTabView> {
  final ValueNotifier<int> _index = ValueNotifier<int>(-1);
  ValueNotifier<Widget> pageChild = ValueNotifier<Widget>(Container());

  animateTo(int index) {
    if (index < 0) index = 0;
    if (index >= widget.choices!.length) index = widget.choices!.length - 1;
    if (mounted) {
      _index.value = index;
      jumpTo(index);
    }
  }

  jumpTo(int? index) {
    // ignore: invalid_use_of_protected_member
    if (mounted && index != null && scrollController!.positions.isNotEmpty)
      scrollController!.animateTo(
        (index) * widget.tabHeight!,
        duration: Duration(milliseconds: 500),
        curve: Curves.linear,
      );
  }

  Color? _iconColor;
  HorizontalTabViewSiderBarType? _sidebarType;
  ThemeData? theme;
  late Color _selectedColor;

  @override
  Widget build(BuildContext context) {
    var _controller = widget.controller ?? HorizontalTabViewController();
    _controller.tabControl = this;
    ResponsiveInfo responsive = ResponsiveInfo(context);

    if (widget.isMobile ?? responsive.isSmall) return mobileBuild(context);

    _sidebarType = widget.sidebarType ??
        (widget.isMobile ?? responsive.isMobile
            ? HorizontalTabViewSiderBarType.compact
            : HorizontalTabViewSiderBarType.show);
    theme = Theme.of(context);
    _iconColor =
        widget.iconColor ?? theme!.tabBarTheme.labelColor ?? theme!.cardColor;
    _selectedColor =
        widget.selectedColor ?? widget.indicatorColor ?? Colors.amber;

    return Theme(
        data: theme!.copyWith(scaffoldBackgroundColor: Colors.transparent),
        child: Scaffold(
          backgroundColor: widget.backgroundColor,
          appBar: widget.appBar,
          bottomNavigationBar: widget.pageBottom,
          floatingActionButton: widget.floatingActionButton,
          body: Row(
            children: [
              if (_sidebarType != HorizontalTabViewSiderBarType.hide)
                buildItems(),
              Expanded(
                  child: ValueListenableBuilder<Widget>(
                      valueListenable: pageChild,
                      builder: (a, b, c) {
                        return b;
                      })),
              if (widget.sidebarRight != null) widget.sidebarRight!,
            ],
          ),
        ));
  }

  ScrollController? scrollController;
  bool hitTop = false;
  bool hitBottom = false;
  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController!.addListener(_scrollListener);
    if (_index.value < 0) _index.value = widget.activeIndex ?? 0;
    buildPages();

    Timer.run(() {
      jumpTo(widget.activeIndex);
    });
  }

  @override
  void dispose() {
    scrollController!.dispose();
    super.dispose();
  }

  _scrollListener() {
    if (scrollController!.offset >=
            scrollController!.position.maxScrollExtent &&
        !scrollController!.position.outOfRange) {
      setState(() {
        hitBottom = true;
        hitTop = false;
      });
    }
    if (scrollController!.offset <=
            scrollController!.position.minScrollExtent &&
        !scrollController!.position.outOfRange) {
      setState(() {
        hitBottom = false;
        hitTop = true;
      });
    }
  }

  buildItems() => Container(
      // lateral
      width: [0.0, widget.minWidth, widget.width][_sidebarType!.index],
      color:
          widget.sidebarBackgroundColor ?? widget.color ?? Colors.transparent,
      child: SizedBox.expand(
        child: Scaffold(
            appBar: widget.sidebarAppBar,
            drawer: widget.sidebarDrawer,
            body: Column(
              children: [
                if (widget.sidebarHeader != null) widget.sidebarHeader!,
                Expanded(
                    child: Stack(
                  children: [
                    ListView.builder(
                            controller: scrollController,
                            itemCount: widget.choices!.length,
                            itemBuilder: (context, index) => buildItem(index))
                        .wheelScroller(context),
                    if (hitBottom)
                      Positioned(
                        right: 0,
                        child: InkWell(
                            child: Icon(Icons.arrow_drop_up),
                            onTap: () {
                              animateTo(0);
                            }),
                      ),
                    if (hitTop)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                            child: Icon(Icons.arrow_drop_down),
                            onTap: () {
                              animateTo(99999);
                            }),
                      ),
                  ],
                )),
                if (widget.sidebarFooter != null) widget.sidebarFooter!,
              ],
            )),
      ));

  buildChild(Widget? child) {
    if (child == null) {
      if (widget.choices![_index.value].child ==
          null) if (widget.choices![_index.value].builder != null)
        widget.choices![_index.value].child =
            widget.choices![_index.value].builder!();
      if (widget.onChanged != null) widget.onChanged!(_index.value);
      child = widget.choices![_index.value].child;
    }
    return child;
  }

  buildPages([Widget? child]) {
    child = buildChild(child);
    return (widget.choices!.length == 0)
        ? Container()
        : Scaffold(

            /// paginas
            backgroundColor: Colors.transparent,
            body: Builder(builder: (x) {
              if (child == null) return Container();
              return Stack(children: [
                if (widget.topBar != null)
                  Positioned(top: 0, left: 0, right: 0, child: widget.topBar!),
                Positioned(
                    top: widget.top,
                    bottom: widget.bottom,
                    left: widget.left,
                    right: widget.right,
                    child: child),
                if (widget.bottomBar != null)
                  Positioned(
                      bottom: 0, left: 0, right: 0, child: widget.bottomBar!),
              ]);
            }));
  }

  Widget buildSubMenu(int index, TabChoice item) {
    bool compacto = _sidebarType == HorizontalTabViewSiderBarType.compact;
    _index.value = index;
    return PopupDropdownMenu(
      tooltip: 'Mostrar opções',
      axis: compacto ? Axis.vertical : Axis.horizontal,
      offset: Offset(
          (widget.width == null)
              ? 150
              : ((compacto ? widget.minWidth! : widget.width!) * 0.75),
          50),
      label: compacto
          ? null
          : (widget.tabBuilder != null)
              ? widget.tabBuilder!(item)
              : Text(item.label!),
      image: Padding(
        padding:
            EdgeInsets.only(left: compacto ? 0 : 18, right: compacto ? 0 : 24),
        child: (item.icon != null) ? Icon(item.icon!) : item.image,
      ),
      onSelected: (idx) {
        Widget? child = item.items![idx].child;
        if (child == null) {
          child = item.items![idx].builder!();
        }
        pageChild.value = child;
      },
      children: [
        for (int idx = 0; idx < item.items!.length; idx++)
          Text(item.items![idx].label!),
      ],
      onPressed: () {
        _index.value = index;
      },
    );
  }

  buildImage(TabChoice item) {
    return Container(
        width: 32,
        height: 32,
        child: FittedBox(
            fit: BoxFit.contain,
            child: (item.image != null)
                ? item.image
                : (item.icon != null)
                    ? Icon(
                        item.icon,
                        color: _iconColor,
                      )
                    : Container()));
  }

  bool get isCompacto => _sidebarType == HorizontalTabViewSiderBarType.compact;
  buildItemSingleMenu(int index, TabChoice item) {
    return InkWell(
      //child: Text('xx'),
      child: (widget.tabBuilder != null)
          ? widget.tabBuilder!(item)
          : (isCompacto
              ? buildImage(item)
              : ListTile(
                  leading: isCompacto
                      ? Align(child: buildImage(item))
                      : buildImage(item),
                  title: isCompacto ? null : Text(item.label!),
                )),

      onTap: () {
        _index.value = index;
        Widget? child = item.child;
        if (child == null) {
          child = item.builder!();
        }
        pageChild.value = child;
      },
    );
  }

  buildItemMenu(int index, TabChoice item) {
    if (item.title != null) return item.title;
    if (item.items != null)
      return buildSubMenu(index, item);
    else
      return buildItemSingleMenu(index, item);
  }

  buildItem(int index) => Container(
        key: ValueKey(widget.choices![index].label ?? '$index'),
        alignment: Alignment.centerLeft,
        color: (_index.value == index)
            ? widget.indicatorColor
            : widget.sidebarBackgroundColor ?? widget.tabColor,
        child: (_sidebarType != HorizontalTabViewSiderBarType.show)
            ? Container(
                padding: EdgeInsets.symmetric(vertical: widget.tabPadding!),
                child: Row(children: [
                  ValueListenableBuilder<int>(
                      valueListenable: _index,
                      builder: (a, b, c) => Container(
                          height: widget.tabHeight ?? kMinInteractiveDimension,
                          width: 5,
                          color: (b == index)
                              ? widget.tagColor ?? theme!.indicatorColor
                              : widget.tabColor)),
                  Expanded(
                    child: Container(
                      constraints: BoxConstraints(minHeight: 35),
                      decoration: BoxDecoration(
                        color: (_index.value == index)
                            ? widget.indicatorColor
                            : widget.tabColor,
                      ),
                      padding: EdgeInsets.zero,
                      child: (widget.tabBuilder != null)
                          ? widget.tabBuilder!(widget.choices![index])
                          : buildItemMenu(index, widget.choices![index]),
                    ),
                  )
                ]))
            : Row(children: [
                if (widget.leftRadius! == 0)
                  ValueListenableBuilder<int>(
                      valueListenable: _index,
                      builder: (a, b, c) => Container(
                          height: widget.tabHeight ?? kToolbarHeight,
                          width: 5,
                          color: (_index.value == index)
                              ? widget.tagColor ?? theme!.indicatorColor
                              : null)),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 1.0, bottom: 1.0),
                  child: Container(
                      decoration: BoxDecoration(
                        color: (_index.value == index)
                            ? _selectedColor
                            : widget.tabColor!,
                        borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(widget.leftRadius!)),
                      ),
                      height: widget.tabHeight,
                      child: buildItemMenu(index, widget.choices![index])),
                )),
              ]),
      );

  mobileBuild(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ThemeData? theme = Theme.of(context);
    int cols = widget.mobileCrossCount ?? size.width ~/ 150;
    if (size.width < (widget.mobileCrossCount ?? 2))
      cols = widget.mobileCrossCount ?? 2;

    return Scaffold(
        backgroundColor: widget.backgroundColor,
        appBar: widget.appBar,
        bottomNavigationBar: widget.pageBottom,
        floatingActionButton: widget.floatingActionButton,
        body: Stack(children: [
          Center(
            child: GridView.count(
              primary: false,
              crossAxisCount: cols,
              children: List.generate(
                widget.choices!.length,
                (index) {
                  TabChoice tab = widget.choices![index];
                  return Padding(
                      padding:
                          widget.padding ?? EdgeInsets.all(widget.tabPadding!),
                      child: InkWell(
                        child: widget.tabBuilder != null
                            ? widget.tabBuilder!(tab)
                            : Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      tab.image ??
                                          Icon(
                                            tab.icon,
                                            size: 80,
                                            color: _iconColor ??
                                                theme.primaryTextTheme
                                                    .bodyText1!.color,
                                          ),
                                      tab.title ??
                                          Text(
                                            tab.label ?? '',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              color: _iconColor ??
                                                  theme.textTheme.button!.color,
                                            ),
                                          ),
                                    ],
                                  ),
                                ),
                              ),
                        onTap: () {
                          if (widget.onChanged != null)
                            widget.onChanged!(index);
                          if (tab.primary)
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (x) {
                                if (tab.child == null)
                                  tab.child = tab.builder!();
                                return tab.child!;
                              }),
                            );
                          else
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (x) {
                                if (tab.child == null)
                                  tab.child = tab.builder!();
                                return Scaffold(
                                  appBar: AppBar(
                                      title: tab.title ??
                                          Text(
                                            tab.label!,
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

class PopupDropdownMenu extends StatelessWidget {
  final Widget? label;
  final List<Widget> children;
  final Function(int index) onSelected;
  final Widget? icon;
  final Widget? image;
  final Offset? offset;
  final Axis axis;
  final String? tooltip;
  final Function()? onPressed;
  const PopupDropdownMenu(
      {Key? key,
      required this.onSelected,
      this.label,
      this.onPressed,
      required this.children,
      this.icon,
      this.offset,
      this.tooltip,
      this.axis = Axis.horizontal,
      this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabViewMenuButton<int>(
      tooltip: tooltip,
      offset: offset ?? Offset(100, 50),
      enableFeedback: false,
      onPressed: onPressed,
      child: (axis == Axis.vertical)
          ? Column(children: [
              if (image != null) image!,
              if (label != null) Expanded(child: label!),
            ])
          : Row(children: [
              if (image != null) image!,
              if (label != null) Expanded(child: label!),
              (icon != null) ? icon! : Icon(Icons.arrow_drop_down),
            ]),
      onSelected: this.onSelected,
      itemBuilder: (ctx) => <PopupMenuEntry<int>>[
        for (int idx = 0; idx < children.length; idx++)
          PopupMenuItem(
            value: idx,
            child: this.children[idx],
          ),
      ],
    );
  }
}

class TabViewScaffold extends StatelessWidget {
  final Widget? title;
  final List<Widget>? actions;
  final Widget body;
  final double titleHeight;
  const TabViewScaffold(
      {Key? key,
      this.title,
      this.titleHeight = 48,
      this.actions,
      required this.body})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Column(
      children: [
        if (title != null || actions != null)
          Padding(
              padding: const EdgeInsets.only(left: 4.0, right: 4),
              child: Container(
                color: theme.primaryColor,
                height: titleHeight,
                child: Row(
                  children: [
                    DefaultTextStyle(
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: theme.primaryTextTheme.bodyText1!.color),
                        child: Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: title ?? Container()),
                        ))),
                    if (actions != null) ...actions!,
                  ],
                ),
              )),
        Expanded(child: body)
      ],
    );
  }
}

class TabViewMenuButton<T> extends StatefulWidget {
  /// Creates a button that shows a popup menu.
  ///
  /// The [itemBuilder] argument must not be null.
  const TabViewMenuButton({
    Key? key,
    required this.itemBuilder,
    this.initialValue,
    this.onSelected,
    this.onCanceled,
    this.tooltip,
    this.elevation,
    this.padding = const EdgeInsets.all(8.0),
    this.child,
    this.icon,
    this.iconSize,
    this.offset = Offset.zero,
    this.enabled = true,
    this.shape,
    this.color,
    this.enableFeedback,
    this.onPressed,
  })  : assert(
          !(child != null && icon != null),
          'You can only pass [child] or [icon], not both.',
        ),
        super(key: key);
  final Function()? onPressed;
  final PopupMenuItemBuilder<T> itemBuilder;
  final T? initialValue;
  final PopupMenuItemSelected<T>? onSelected;
  final PopupMenuCanceled? onCanceled;
  final String? tooltip;
  final double? elevation;
  final EdgeInsetsGeometry padding;
  final Widget? child;
  final Widget? icon;
  final Offset offset;
  final bool enabled;
  final ShapeBorder? shape;
  final Color? color;
  final bool? enableFeedback;
  final double? iconSize;
  @override
  TabViewMenuButtonState<T> createState() => TabViewMenuButtonState<T>();
}

class TabViewMenuButtonState<T> extends State<TabViewMenuButton<T>> {
  /// A method to show a popup menu with the items supplied to
  /// [PopupMenuButton.itemBuilder] at the position of your [PopupMenuButton].
  ///
  /// By default, it is called when the user taps the button and [PopupMenuButton.enabled]
  /// is set to `true`. Moreover, you can open the button by calling the method manually.
  ///
  /// You would access your [PopupMenuButtonState] using a [GlobalKey] and
  /// show the menu of the button with `globalKey.currentState.showButtonMenu`.
  void showButtonMenu() {
    if (widget.onPressed != null) widget.onPressed!();
    final PopupMenuThemeData popupMenuTheme = PopupMenuTheme.of(context);
    final RenderBox button = context.findRenderObject()! as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(widget.offset, ancestor: overlay),
        button.localToGlobal(
            button.size.bottomRight(Offset.zero) + widget.offset,
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );
    final List<PopupMenuEntry<T>> items = widget.itemBuilder(context);
    // Only show the menu if there is something to show
    if (items.isNotEmpty) {
      showMenu<T?>(
        context: context,
        elevation: widget.elevation ?? popupMenuTheme.elevation,
        items: items,
        initialValue: widget.initialValue,
        position: position,
        shape: widget.shape ?? popupMenuTheme.shape,
        color: widget.color ?? popupMenuTheme.color,
      ).then<void>((T? newValue) {
        if (!mounted) return null;
        if (newValue == null) {
          widget.onCanceled?.call();
          return null;
        }
        widget.onSelected?.call(newValue);
      });
    }
  }

  bool get _canRequestFocus {
    final NavigationMode mode = MediaQuery.maybeOf(context)?.navigationMode ??
        NavigationMode.traditional;
    switch (mode) {
      case NavigationMode.traditional:
        return widget.enabled;
      case NavigationMode.directional:
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool enableFeedback = widget.enableFeedback ??
        PopupMenuTheme.of(context).enableFeedback ??
        true;

    assert(debugCheckHasMaterialLocalizations(context));

    if (widget.child != null)
      return Tooltip(
        message:
            widget.tooltip ?? MaterialLocalizations.of(context).showMenuTooltip,
        child: InkWell(
          onTap: widget.enabled ? showButtonMenu : null,
          canRequestFocus: _canRequestFocus,
          enableFeedback: enableFeedback,
          child: widget.child,
        ),
      );

    return IconButton(
      icon: widget.icon ?? Icon(Icons.adaptive.more),
      padding: widget.padding,
      iconSize: widget.iconSize ?? 24.0,
      tooltip:
          widget.tooltip ?? MaterialLocalizations.of(context).showMenuTooltip,
      onPressed: widget.enabled ? showButtonMenu : null,
      enableFeedback: enableFeedback,
    );
  }
}
