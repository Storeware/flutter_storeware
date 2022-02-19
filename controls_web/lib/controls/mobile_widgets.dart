// @dart=2.12
import 'package:flutter/material.dart';
import 'package:controls_web/controls.dart';
import 'package:get/get.dart';
import 'package:controls_data/data.dart';

extension ColorGreyScale on Color {
  isLigth() => (red * 0.299 + green * 0.587 + blue * 0.114) > 186.0;
}

class MobileToolbar extends StatelessWidget {
  final Widget toolbar;
  final Widget Function(BuildContext context, Widget toolbar) builder;

  MobileToolbar({Key? key, required this.toolbar, required this.builder})
      : super(key: key);

  static MobileToolbar? of(BuildContext context) =>
      context.findAncestorWidgetOfExactType<MobileToolbar>();
  static Widget? consumer(BuildContext context) {
    var rt = MobileToolbar.of(context);
    if (rt != null) return rt.toolbar;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return builder(context, toolbar);
  }
}

class MobileMenuBox extends StatelessWidget {
  MobileMenuBox({
    Key? key,
    this.bottomNavigationBar,
    this.actions,
    required this.choices,
    this.extendBody = false,
    this.appBar,
    this.elevation = 0,
    this.buttonWidth = 200,
    this.childBottomNavigatorBar,
    this.automaticallyImplyLeading = true,
    this.drawer,
    this.style,
    this.shape,
    this.sideLeft,
    this.flex = 5,
  }) : super(key: key);
  final AppBar? appBar;
  final List<TabChoice> choices;
  final List<Widget>? actions;
  final Widget? bottomNavigationBar;
  final Widget? childBottomNavigatorBar;
  final bool extendBody;
  final Widget? drawer;
  final double elevation;
  final double buttonWidth;
  final bool automaticallyImplyLeading;
  final TextStyle? style;
  final ShapeBorder? shape;
  final Widget? sideLeft;
  final int flex;

  @override
  Widget build(BuildContext context) {
    //ThemeData theme = Theme.of(context);
    final responsive = ResponsiveInfo(context);

    return MobileScaffold(
      appBar: appBar,
      //extendBody: extendBody,
      drawer: drawer,
      body: Row(
        children: [
          if (sideLeft != null) ...[
            Expanded(
              flex: 1,
              child: sideLeft!,
            ),
            Container(
                color: responsive.theme!.dividerColor,
                width: 1,
                height: double.infinity),
          ],
          Expanded(
            flex: flex,
            child: createBody(
              context,
              responsive,
            ),
          ),
        ],
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  createBody(context, responsive) {
    int nCols = responsive.size.width ~/ buttonWidth;
    if (nCols < 2) nCols = 2;
    int index = 0;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.count(crossAxisCount: nCols, children: [
        for (var item in choices)
          Builder(builder: (x) {
            index++;
            Color? color = item.color ?? genColor(index);

            TextStyle? textStyle = style ??
                item.style ??
                TextStyle(
                    color: color.isDark ? Colors.white : Colors.black87,
                    fontSize: 18);
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: shape,
                color: color,
                child: InkButton(
                  onTap: () {
                    if (item.onPressed != null) {
                      item.onPressed!();
                      return;
                    }
                    Get.to(
                      () => (item.primary)
                          ? Scaffold(
                              body: item.builder!(),
                              bottomNavigationBar: childBottomNavigatorBar ??
                                  MobileToolbar.consumer(context),
                            )
                          : MobileScaffold(
                              appBar: (item.primary)
                                  ? null
                                  : AppBar(
                                      elevation: elevation,
                                      automaticallyImplyLeading:
                                          automaticallyImplyLeading,
                                      title: Text(item.label!),
                                      actions: (item.items != null)
                                          ? [
                                              for (var sb in item.items ?? [])
                                                InkWell(
                                                    child: sb.image,
                                                    onTap: () {
                                                      if (sb.onPressed !=
                                                          null) {
                                                        sb.onPressed!();
                                                      }
                                                    })
                                            ]
                                          : null,
                                    ),
                              body: item.child ?? item.builder!(),
                              bottomNavigationBar: childBottomNavigatorBar ??
                                  MobileToolbar.consumer(context),
                            ),
                    );
                  },
                  child: Card(
                      color: color,
                      shape: shape,
                      semanticContainer: true,
                      elevation: 0.0,
                      child: Column(children: [
                        SizedBox(height: 10),
                        Expanded(
                            child: (item.image != null)
                                ? FittedBox(
                                    child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: item.image,
                                  ))
                                : Container()),
                        FittedBox(
                            child: Text(item.label ?? '',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: textStyle)),
                        SizedBox(
                          height: 20,
                        ),
                      ])),
                ),
              ),
            );
          }),
      ]),
    );
  }
}

class MobileScaffold extends StatelessWidget {
  const MobileScaffold({
    Key? key,
    this.bottomNavigationBar,
    this.appBar,
    required this.body,
    this.drawer,
    this.extendedBar,
    this.scrolling = false,

    //this.extendBody = false,
  }) : super(key: key);

  final bool scrolling;
  final Widget body;
  final AppBar? appBar;
  final Widget? bottomNavigationBar;
  //final bool extendBody;
  final Widget? drawer;
  final Widget? extendedBar;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    ResponsiveInfo responsive = ResponsiveInfo(context);
    return Scaffold(
      drawer: drawer,
      appBar: appBar,
      resizeToAvoidBottomInset: true,
      //isScrollView: false,
      //extendedBody: extendedBody,
      body: SingleChildScrollView(
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
                //      height: kMinInteractiveDimension,
                //width: double.infinity,
                color: theme.primaryColor,
                child: ClipRRect(
                  child: Container(
                      // height: double.infinity,
                      width: double.infinity,
                      color: theme.scaffoldBackgroundColor,
                      child: Column(
                        children: [
                          Container(
                              child: StreamBuilder<bool>(
                                  initialData: false,
                                  stream: DataProcessingNotifier().stream,
                                  builder: (context, snapshot) {
                                    return snapshot.data!
                                        ? LinearProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.red),
                                          )
                                        : Container(
                                            width: double.infinity,
                                            color: theme.primaryColor);
                                  }),
                              width: responsive.size.width - 0, //120,
                              height: 2),
                          if (extendedBar != null) extendedBar!,
                          Container(
                              height: responsive.size.height -
                                  (bottomNavigationBar != null
                                      ? kBottomNavigationBarHeight
                                      : 0.0) -
                                  (appBar != null ? kToolbarHeight : 0.0),
                              child: body),
                        ],
                      )),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                )),
          ],
        ),
      ),
      bottomNavigationBar:
          bottomNavigationBar ?? MobileToolbar.consumer(context),
    );
  }
}

class MobileBottonNavigatorButton extends StatefulWidget {
  const MobileBottonNavigatorButton({
    Key? key,
    required this.choices,
    this.selected = 0,
    this.hideSelected = false,
    this.borderRadius,
    this.radius = 30,
    this.height = kToolbarHeight,
  }) : super(key: key);
  final List<TabChoice> choices;
  final int selected;
  final bool hideSelected;
  final BorderRadius? borderRadius;
  final double radius;
  final double height;

  @override
  _MobileBottonNavigatorButtonState createState() =>
      _MobileBottonNavigatorButtonState();
}

class _MobileBottonNavigatorButtonState
    extends State<MobileBottonNavigatorButton> {
  ValueNotifier<int>? index;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    index = ValueNotifier<int>(widget.selected);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
        decoration: BoxDecoration(
          borderRadius: widget.borderRadius ??
              BorderRadius.only(
                  topRight: Radius.circular(widget.radius),
                  topLeft: Radius.circular(widget.radius)),
          boxShadow: [
            BoxShadow(
                color: Colors.black38,
                spreadRadius: 0,
                blurRadius: widget.radius / 3),
          ],
        ),
        child: ClipRRect(
            borderRadius: widget.borderRadius ??
                BorderRadius.only(
                  topLeft: Radius.circular(widget.radius),
                  topRight: Radius.circular(widget.radius),
                ),
            child: ValueListenableBuilder<int>(
              valueListenable: index!,
              builder: (a, b, c) => Container(
                  color: Colors.white,
                  height: widget.height,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      for (int i = 0; i < widget.choices.length; i++)
                        Container(
                          height: widget.height,
                          width: widget.height,
                          child: InkWell(
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                        child:
                                            (widget.choices[i].builder != null)
                                                ? widget.choices[i].builder!()
                                                : widget.choices[i].image!),
                                    Container(
                                        height: 4,
                                        width: double.infinity,
                                        color: (!widget.hideSelected)
                                            ? ((index!.value == i)
                                                ? theme.primaryColor
                                                : null)
                                            : null),
                                    SizedBox(
                                      height: 4,
                                    )
                                  ]),
                              onTap: () {
                                if (index!.value != i) {
                                  index!.value = i;
                                  widget.choices[i].onPressed!();
                                }
                              }),
                        )
                    ],
                  )),
            )));
  }
}
