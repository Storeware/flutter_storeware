// @dart=2.12
// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';

import 'strap_widgets.dart';
import 'dart:ui';
import 'package:controls_web/controls/dialogs_widgets.dart';
import 'package:controls_web/controls/tab_choice.dart';
import 'dotted_decoration.dart';

// Our design contains Neumorphism design and i made a extention for it
// We can apply it on any  widget

extension WidgetMorphism on Widget {
  Widget shadow({
    double borderRadius = 10.0,
    Offset offset = const Offset(5, 5),
    double blurRadius = 10,
    Color topShadowColor = Colors.white60,
    Color bottomShadowColor = const Color(0x26234395),
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        boxShadow: [
          BoxShadow(
            offset: offset,
            blurRadius: blurRadius,
            color: bottomShadowColor,
          ),
          BoxShadow(
            offset: Offset(-offset.dx, -offset.dx),
            blurRadius: blurRadius,
            color: topShadowColor,
          ),
        ],
      ),
      child: this,
    );
  }

  Widget paddingAll({double? all}) {
    return Padding(padding: EdgeInsets.all(all ?? 8.0), child: this);
  }

  Widget padding({EdgeInsets? padding}) {
    return Padding(padding: padding ?? const EdgeInsets.all(8.0), child: this);
  }

  Widget card(
      {Color? color,
      double elevation = 4.0,
      double radius = 5,
      ShapeBorder? shape}) {
    return Card(
      color: color,
      elevation: elevation,
      shape: shape,
      child: this,
    );
  }

  Widget sizedBox({
    Color? color,
    double? height,
    double? width,
  }) {
    return SizedBox(
      height: height,
      width: width,
      child: this,
    );
  }

  Widget rounded(
      {BoxDecoration? decoration,
      BoxBorder? border,
      double radius = 15.0,
      Color? color}) {
    return Container(
      decoration: decoration ??
          BoxDecoration(
            color: color,
            border: border,
            borderRadius: BorderRadius.circular(radius),
          ),
      child: this,
    );
  }

  Widget dottedLine({
    Color color = const Color(0xFF9E9E9E),
    EdgeInsets? padding,
    double? height,
    BorderRadius? borderRadius,
    double strokeWidth = 1,
    LinePosition linePosition = LinePosition.bottom,
  }) {
    return Container(
        padding: padding ?? const EdgeInsets.only(bottom: 3),
        height: height,
        width: double.infinity,
        decoration: DottedDecoration(
            color: color,
            borderRadius: borderRadius,
            linePosition: linePosition,
            strokeWidth: strokeWidth),
        child: this);
  }

  Widget center() => Center(child: this);

  Widget box(
      {Color? color,
      double borderWidth = 1.0,
      BoxBorder? border,
      BoxDecoration? decoration,
      double? width,
      double? height,
      BorderRadiusGeometry? borderRadius,
      Color borderColor = Colors.black26}) {
    return Container(
      width: width,
      height: height,
      decoration: decoration ??
          BoxDecoration(
            color: color,
            borderRadius: borderRadius,
            border:
                border ?? Border.all(width: borderWidth, color: borderColor),
          ),
      child: this,
    );
  }

  Widget inkWell({required Function() onPressed}) {
    return InkWell(
      child: this,
      onTap: () => onPressed(),
    );
  }

  Widget row(
      {CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
      MainAxisAlignment mainAxisAlignment = MainAxisAlignment.spaceBetween,
      List<Widget>? ledding,
      List<Widget>? actions}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      children: [
        if (ledding != null) ...ledding,
        this,
        if (actions != null) ...actions,
      ],
    );
  }

  Widget column(
      {CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
      MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
      List<Widget>? ledding,
      List<Widget>? actions}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      children: [
        if (ledding != null) ...ledding,
        this,
        if (actions != null) ...actions,
      ],
    );
  }

  Widget fittedBox({
    BoxFit fit = BoxFit.scaleDown,
    Alignment alignment = Alignment.center,
  }) {
    return FittedBox(alignment: alignment, fit: fit, child: this);
  }

  Widget materialButton({
    double? elevation,
    required Function() onPressed,
    Color? color,
  }) {
    return MaterialButton(
      onPressed: onPressed,
      color: color,
      elevation: elevation,
      child: this,
    );
  }

  Widget textButton({
    required onPressed,
    bool autofocus = false,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      autofocus: autofocus,
      child: this,
    );
  }

  Widget strapButton({
    required onPressed,
    StrapButtonType? type,
  }) {
    return StrapButton(
      image: this,
      onPressed: onPressed,
      type: type,
    );
  }

  Widget button(
      {required onPressed, bool autofocus = false, ButtonStyle? style}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: style,
      autofocus: autofocus,
      child: this,
    );
  }

  Widget expanded() {
    return SizedBox.expand(child: this);
  }

  Widget shrink() {
    return SizedBox.shrink(child: this);
  }

  Widget textStyle({Color? color, FontWeight? fontWeight, double? fontSize}) {
    return DefaultTextStyle(
        style:
            TextStyle(color: color, fontSize: fontSize, fontWeight: fontWeight),
        child: this);
  }

  Widget gradient({List<Color>? colors, TileMode tileMode = TileMode.clamp}) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) {
        return LinearGradient(
          colors: colors ?? [Colors.blue, Colors.lightBlue],
          tileMode: tileMode,
        ).createShader(bounds);
      },
      child: this,
    );
  }

  Widget rotatedBox({int quarterTurns = 2}) => RotatedBox(
        quarterTurns: quarterTurns,
        child: this,
      );
  Widget flexible({int flex = 1, FlexFit fit = FlexFit.tight}) => Flexible(
        fit: fit,
        flex: flex,
        child: this,
      );
  Widget draggable<D extends Object>(
    D data, {
    Widget? feedback,
    Widget? childWhenDragging,
  }) {
    return Draggable<D>(
        data: data,
        childWhenDragging: childWhenDragging ?? Container(),
        feedback: feedback ??
            Container(
              width: 80,
              height: 80,
              color: Colors.grey[200],
            ),
        child: this);
  }

  Widget dragTarget<D extends Object>({
    bool Function(D? value)? onWillAccept,
    void Function(D? value)? onAccept,
    void Function(D? value)? onLeave,
    Widget Function(BuildContext context, List<D?> value)? onBuilder,
    Widget? placeHolder,
  }) {
    bool accepted = false;
    return DragTarget<D>(
      builder: (context, list, value) {
        return accepted
            ? (onBuilder != null ? onBuilder(context, list) : this)
            : (placeHolder ?? Container());
      },
      onWillAccept: (data) {
        if (onWillAccept != null) return accepted = onWillAccept(data);
        if (data is D)
          accepted = true;
        else
          accepted = false;
        return accepted;
      },
      onAccept: (data) {
        if (onAccept != null) onAccept(data);
      },
      onLeave: (data) {
        if (onLeave != null) onLeave(data);
        accepted = false;
      },
    );
  }

  Future showDialog<T>(BuildContext context,
          {String? title,
          double? width,
          double? height,
          bool desktop = false,
          bool iconRight = false,
          List<Widget>? actions,
          bool fullPage = false}) =>
      Dialogs.showPage<T>(
        context,
        title: title,
        width: width,
        height: height,
        desktop: desktop,
        iconRight: iconRight,
        child: this,
        actions: actions,
        fullPage: fullPage,
      );
  alertDialog(
    context, {
    String? title,
    Color? color,
  }) {
    return Dialogs.alert(context,
        backgoundColor: color,
        title: (title == null) ? null : Text(title),
        content: this);
  }

  /// [willPopScope] pergunta se o APP pode ser encerrado
  Widget willPopScope(Future<bool> Function() onWillPop) =>
      WillPopScope(onWillPop: onWillPop, child: this);

  Widget animatedPadding({double padValue = 0}) {
    return AnimatedPadding(
      padding: EdgeInsets.all(padValue),
      curve: Curves.easeInOut,
      duration: const Duration(seconds: 1),
      child: this,
    );
  }

  Widget aspectRatio({double ratio = 1}) => AspectRatio(
        aspectRatio: ratio,
        child: this,
      );
  Widget singleChildScrollView({
    ScrollController? controller,
    EdgeInsets? padding,
  }) =>
      SingleChildScrollView(
        controller: controller,
        physics: const BouncingScrollPhysics(),
        padding: padding,
        child: this,
      );
  Widget sliverView({
    required List<Widget> slivers,
  }) {
    return CustomScrollView(slivers: [
      sliverContainer(),
      for (var item in slivers) item.sliverContainer()
    ]);
  }

  Widget sliverContainer() => (this is SingleChildRenderObjectWidget)
      ? this
      : SliverToBoxAdapter(child: this);
  Widget dismissible({
    Key? key,
    required Function(DismissDirection direction) onDismissed,
    Widget? background,
    Widget? secondaryBackground,
    DismissDirection direction = DismissDirection.endToStart,
  }) =>
      Dismissible(
        key: key ?? UniqueKey(),
        onDismissed: onDismissed,
        background: background,
        secondaryBackground: secondaryBackground,
        direction: direction,
        child: this,
      );

  bold({double size = 18.0}) {
    return DefaultTextStyle(
        style: TextStyle(
            fontSize: size, color: Colors.black87, fontWeight: FontWeight.bold),
        child: this);
  }

  bold16() => bold(size: 16);

  bold14() => bold(size: 14);

  width(double w) {
    // ignore: sized_box_for_whitespace
    return Container(
      width: w,
      child: this,
    );
  }
}

extension ListViewExtension on ListView {
  Widget wheelScroller(context) {
    return ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        }),
        child: this);
  }
}

extension ListExtension on List {
  popupButton(context, {Widget? icon, Function(int index)? onSelected}) {
    return PopupMenuButton<int>(
      icon: icon,
      onSelected: (i) {
        if (onSelected != null) onSelected(i);
      },
      itemBuilder: (context) => [
        for (var i = 0; i < length; i++)
          PopupMenuItem(child: this[i], value: i),
      ],
    );
  }

  Widget animatedList<T>({
    Key? key,
    ScrollController? scrollController,
    Axis scrollDirection = Axis.vertical,
    bool reverse = true,
    EdgeInsets? padding,
    required Widget Function(BuildContext context, T item) itemBuilder,
  }) {
    final _key = key ?? GlobalKey<AnimatedListState>();
    final myTween = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    );
    return AnimatedList(
      key: _key,
      controller: scrollController,
      scrollDirection: scrollDirection,
      initialItemCount: length,
      reverse: reverse,
      padding: padding,
      itemBuilder: (context, index, Animation<double> animation) {
        return SlideTransition(
            position: animation.drive(myTween),
            child: itemBuilder(context, this[index]));
      },
    );
  }

  Widget listView<T>({
    required Widget Function(BuildContext context, T data) itemBuilder,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    String? restorationId,
    EdgeInsets? padding,
    double? itemExtent,
  }) =>
      ListView.builder(
          itemCount: length,
          scrollDirection: scrollDirection,
          reverse: reverse,
          restorationId: restorationId,
          padding: padding,
          itemExtent: itemExtent,
          itemBuilder: (ctx, index) => itemBuilder(ctx, this[index]));

  Widget listViewCount<T>({
    required Widget Function(BuildContext context, T data, int index)
        itemBuilder,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    String? restorationId,
    EdgeInsets? padding,
    double? itemExtent,
  }) =>
      ListView.builder(
          itemCount: length,
          scrollDirection: scrollDirection,
          reverse: reverse,
          restorationId: restorationId,
          padding: padding,
          itemExtent: itemExtent,
          itemBuilder: (ctx, index) => itemBuilder(ctx, this[index], index));

  Widget flex<T>({
    required Widget Function(T data) itemBuilder,
    Axis direction = Axis.vertical,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    Clip clipBehavior = Clip.hardEdge,
  }) =>
      Flex(
        direction: direction,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        clipBehavior: clipBehavior,
        children: [for (var item in this) itemBuilder(item)],
      );
  Widget sliverList({
    required Widget Function(BuildContext context, dynamic data) itemBuilder,
  }) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => itemBuilder(context, this[index]),
        childCount: length,
      ),
    );
  }

  Widget sliverGrid<T>({
    int crossAxisCount = 2,
    required Widget Function(BuildContext context, T data) itemBuilder,
    double mainAxisSpacing = 5,
    double crossAxisSpacing = 5,
    double childAspectRatio = 1,
  }) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (context, index) => itemBuilder(context, this[index]),
        childCount: length,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: mainAxisSpacing,
          crossAxisSpacing: crossAxisSpacing,
          childAspectRatio: childAspectRatio),
    );
  }

  Widget expansionList<T>({
    double elevation = 2,
    required Widget Function(BuildContext context, dynamic data, bool)
        headerBuilder,
    required Widget Function(T data) bodyBuilder,
    EdgeInsets? expandedHeaderPadding,
    bool canTapOnHeader = true,
    Map<int, bool>? expanded,
  }) {
    Map<int, bool> opened = expanded ?? {};
    ValueNotifier<int> selected = ValueNotifier<int>(-1);
    return ValueListenableBuilder(
        valueListenable: selected,
        builder: (context, a, b) => ExpansionPanelList(
              animationDuration: const Duration(seconds: 1),
              elevation: elevation,
              expandedHeaderPadding:
                  expandedHeaderPadding ?? const EdgeInsets.all(2),
              children: [
                for (var i = 0; i < length; i++)
                  ExpansionPanel(
                    headerBuilder: (context, open) =>
                        headerBuilder(context, this[i], open),
                    body: bodyBuilder(this[i]),
                    canTapOnHeader: canTapOnHeader,
                    isExpanded: opened[i] ?? false,
                  ),
              ],
              expansionCallback: (index, open) {
                opened[index] = !open;
                selected.value = open ? index : -index;
              },
            ));
  }

  Widget wheelScrollView<T>({
    required Widget Function(T data) itemBuilder,
    double itemExtent = 200,
    double diameterRatio = 1,
    double magnification = 1,
    Function(T data, int index)? onSelectedItemChanged,
  }) {
    return ListWheelScrollView.useDelegate(
      itemExtent: itemExtent,
      diameterRatio: diameterRatio,
      onSelectedItemChanged: (index) {
        if (onSelectedItemChanged != null)
          onSelectedItemChanged(this[index], index);
      },
      magnification: magnification,
      useMagnifier: magnification > 1,
      childDelegate: ListWheelChildListDelegate(
        children: [for (var item in this) itemBuilder(item)],
      ),
    ); /*(
      
      itemExtent: itemExtent,
      diameterRatio: diameterRatio,
      useMagnifier: magnification > 1,
      magnification: magnification,
      children: [
        for (var item in this) itemBuilder(item),
      ],
    );*/
  }

  Widget pageView<T>({
    Key? key,
    PageController? controller,
    Axis scrollDirection = Axis.horizontal,
    required Widget Function(BuildContext context, T item) itemBuilder,
    Function(int)? onPageChanged,
  }) {
    return PageView.builder(
      key: key,
      itemCount: length,
      scrollDirection: scrollDirection,
      controller: controller,
      onPageChanged: (page) {
        if (onPageChanged != null) onPageChanged(page);
      },
      itemBuilder: (context, index) => itemBuilder(context, this[index]),
    );
  }

  Widget stepper<T>({
    List<TabChoice>? choices,
    int currentStep = 0,
    Step Function(BuildContext context, T data)? itemBuilder,
    StepperType type = StepperType.vertical,
    void Function(int index)? onStepTapped,
    double elevation = 2,
  }) {
    return StepperWidget(
      choices: choices,
      currentStep: currentStep,
      itemBuilder: (context, index) {
        return itemBuilder!(context, this[index]);
      },
      onStepTapped: onStepTapped,
      itemCount: length,
      type: type,
      elevation: elevation,
    );
  }
}

class StepperWidget extends StatefulWidget {
  final int currentStep;
  final int itemCount;
  final void Function(int index)? onStepTapped;
  final double elevation;
  final Step Function(BuildContext context, int index)? itemBuilder;
  final StepperType type;
  final List<TabChoice>? choices;
  final StepState Function(int selected, int current)? onState;
  const StepperWidget({
    Key? key,
    this.currentStep = 0,
    this.itemCount = 0,
    this.itemBuilder,
    this.onStepTapped,
    this.type = StepperType.vertical,
    this.elevation = 2,
    this.choices,
    this.onState,
  }) : super(key: key);

  @override
  State<StepperWidget> createState() => _StepperViewerState();
}

class _StepperViewerState extends State<StepperWidget> {
  late ValueNotifier<int> _currentStep;
  late int count;

  @override
  void initState() {
    super.initState();
    _currentStep = ValueNotifier<int>(widget.currentStep);
    count =
        (widget.choices != null) ? widget.choices!.length : widget.itemCount;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
        valueListenable: _currentStep,
        builder: (BuildContext context, int value, Widget? child) {
          return Stepper(
            currentStep: value,
            physics: const ScrollPhysics(),
            steps: [
              if (widget.choices != null)
                for (var i = 0; i < widget.choices!.length; i++)
                  buildStep(value, i),
              if (widget.choices == null && widget.itemBuilder != null)
                for (var i = 0; i < widget.itemCount; i++)
                  widget.itemBuilder!(context, i),
            ],
            type: widget.type,
            onStepTapped: (index) {
              _currentStep.value = index;
              if (widget.onStepTapped != null) widget.onStepTapped!(index);
            },
            elevation: widget.elevation,
            onStepCancel: () {
              if (_currentStep.value > 0) {
                _currentStep.value -= 1;
              } else {
                _currentStep.value = 0;
              }
            },
            onStepContinue: () {
              if (_currentStep.value < count - 1) {
                _currentStep.value += 1;
              } else {
                _currentStep.value = 0;
              }
            },
          );
        });
  }

  buildStep(value, i) {
    var item = widget.choices![i];
    return Step(
      content: item.child ?? item.builder!(),
      title: item.title ?? Text(item.label ?? 'Label Indef'),
      subtitle: item.tooltip == null ? null : Text(item.tooltip!),
      isActive: value == i,
      state: (widget.onState != null)
          ? widget.onState!(value, i)
          : (value == i)
              ? StepState.editing
              : StepState.indexed,
    );
  }
}

extension DesktopAppBar on AppBar {
  desktop(context) {
    return AppBar(
      title: title,
      automaticallyImplyLeading: false,
      elevation: elevation ?? 0,
      leading: leading,
      backgroundColor: backgroundColor,
      flexibleSpace: flexibleSpace,
      shape: shape,
      actions: [
        if (actions != null) ...actions!,
        IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            }),
      ],
    );
  }
}

popupDialog(context,
    {String? title,
    bool desktop = false,
    double width = 300,
    double? left,
    double? top,
    double? height,
    required List<Widget> children,
    Color? color,
    Offset? position,
    Offset Function()? onPosition,
    required Function(int index) onSelected}) {
  Offset p = (onPosition != null) ? onPosition() : position ?? Offset.zero;
  double? _left = left ?? p.dx;
  double? _top = top ?? p.dy;
  List<PopupMenuEntry<int>> its = [
    for (var i = 0; i < children.length; i++)
      _buildPopupItem(i, children[i], onSelected)
  ];
  return showMenu(
    context: context,
    color: color,
    initialValue: 0,
//    semanticLabel: 'xxxx',
    useRootNavigator: false,
    position: RelativeRect.fromLTRB(_left, _top, width,
        height ?? kMinInteractiveDimension * (children.length + 1)),
    items: its,
  );
}

_buildPopupItem(i, element, Function(int index) onSelected) {
  if (element is PopupMenuDivider) return element;
  if (element is PopupMenuItem) return element;
  return PopupMenuItem<int>(
    value: i,
    child: element,
    onTap: () {
      onSelected(i);
    },
  );
}
