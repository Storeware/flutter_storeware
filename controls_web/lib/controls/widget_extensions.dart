// @dart=2.12
import 'package:flutter/material.dart';

import 'strap_widgets.dart';
import 'dart:ui';
import 'package:controls_web/controls/dialogs_widgets.dart';

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
    return Padding(padding: padding ?? EdgeInsets.all(8.0), child: this);
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
      child: this,
      color: color,
      elevation: elevation,
    );
  }

  Widget textButton({
    required onPressed,
    bool autofocus = false,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      child: this,
      autofocus: autofocus,
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
      child: this,
      style: style,
      autofocus: autofocus,
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
        child: this,
        style: TextStyle(
            color: color, fontSize: fontSize, fontWeight: fontWeight));
  }

  Widget gradient({List<Color>? colors, TileMode tileMode = TileMode.clamp}) {
    return ShaderMask(
      child: this,
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) {
        return LinearGradient(
          colors: colors ?? [Colors.blue, Colors.lightBlue],
          tileMode: tileMode,
        ).createShader(bounds);
      },
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
        child: this,
        childWhenDragging: childWhenDragging ?? Container(),
        feedback: feedback ??
            Container(
              width: 80,
              height: 80,
              color: Colors.grey[200],
            ));
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
          bool fullPage = false}) =>
      Dialogs.showPage<T>(
        context,
        title: title,
        width: width,
        height: height,
        child: this,
        fullPage: fullPage,
      );

  /// [willPopScope] pergunta se o APP pode ser encerrado
  Widget willPopScope(Future<bool> Function() onWillPop) =>
      WillPopScope(onWillPop: onWillPop, child: this);

  Widget animatedPadding({double padValue = 0}) {
    return AnimatedPadding(
      padding: EdgeInsets.all(padValue),
      child: this,
      curve: Curves.easeInOut,
      duration: const Duration(seconds: 1),
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
        physics: BouncingScrollPhysics(),
        padding: padding,
        child: this,
      );
  Widget sliverView({
    required List<Widget> slivers,
  }) {
    return CustomScrollView(slivers: [
      this.sliverContainer(),
      for (var item in slivers) item.sliverContainer()
    ]);
  }

  Widget sliverContainer() => (this is SingleChildRenderObjectWidget)
      ? this
      : SliverToBoxAdapter(child: this);
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
      initialItemCount: this.length,
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
    bool reverse = true,
    String? restorationId,
    EdgeInsets? padding,
    double? itemExtent,
  }) =>
      ListView.builder(
          itemCount: this.length,
          scrollDirection: scrollDirection,
          reverse: reverse,
          restorationId: restorationId,
          padding: padding,
          itemExtent: itemExtent,
          itemBuilder: (ctx, index) => itemBuilder(ctx, this[index]));

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
        childCount: this.length,
      ),
    );
  }

  Widget sliverGrid({
    int crossAxisCount = 2,
    required Widget Function(BuildContext context, dynamic data) itemBuilder,
    double mainAxisSpacing = 5,
    double crossAxisSpacing = 5,
    double childAspectRatio = 1,
  }) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (context, index) => itemBuilder(context, this[index]),
        childCount: this.length,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: mainAxisSpacing,
          crossAxisSpacing: crossAxisSpacing,
          childAspectRatio: childAspectRatio),
    );
  }

  Widget expansionList({
    double elevation = 2,
    required Widget Function(BuildContext context, dynamic data, bool)
        headerBuilder,
    required Widget Function(dynamic data) bodyBuilder,
    EdgeInsets? expandedHeaderPadding,
    bool canTapOnHeader = true,
    Map<int, bool>? expanded,
  }) {
    Map<int, bool> opened = expanded ?? {};
    return ExpansionPanelList(
      animationDuration: const Duration(seconds: 1),
      elevation: elevation,
      expandedHeaderPadding: expandedHeaderPadding ?? EdgeInsets.all(2),
      children: [
        for (var i = 0; i < this.length; i++)
          ExpansionPanel(
            headerBuilder: (context, open) =>
                headerBuilder(context, this[i], open),
            body: bodyBuilder(this[i]),
            canTapOnHeader: canTapOnHeader,
            isExpanded: opened[i] ?? false,
          ),
      ],
      expansionCallback: (index, open) {
        opened[index] = open;
      },
    );
  }

  Widget wheelScrollView({
    required Widget Function(dynamic data) itemBuilder,
    double itemExtent = 200,
    double diameterRatio = 1,
    double magnification = 1,
  }) {
    return ListWheelScrollView(
      itemExtent: itemExtent,
      diameterRatio: diameterRatio,
      useMagnifier: magnification > 1,
      magnification: magnification,
      children: [
        for (var item in this) itemBuilder(item),
      ],
    );
  }
}

//extension TextStyleExtension on TextStyle{

//}
