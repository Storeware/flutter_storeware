// @dart=2.12
import 'package:flutter/material.dart';
import 'package:controls_web/controls.dart';
import 'package:get/get.dart';
import 'package:controls_data/data.dart';

class MobileMenuBox extends StatelessWidget {
  const MobileMenuBox(
      {Key? key,
      this.bottomNavigationBar,
      this.actions,
      required this.choices,
      this.extendBody = false,
      this.appBar,
      this.elevation = 0,
      this.buttonWidth = 200,
      this.childBottomNavigatorBar,
      this.automaticallyImplyLeading = true,
      this.drawer})
      : super(key: key);
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

  @override
  Widget build(BuildContext context) {
    //ThemeData theme = Theme.of(context);
    ResponsiveInfo responsive = ResponsiveInfo(context);
    int nCols = responsive.size.width ~/ buttonWidth;
    if (nCols < 2) nCols = 2;

    return MobileScaffold(
      appBar: appBar,
      //extendBody: extendBody,
      drawer: drawer,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(crossAxisCount: nCols, children: [
          for (var item in choices)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: item.color,
                child: InkButton(
                  onTap: () {
                    Get.to(
                      () => (item.primary)
                          ? Scaffold(
                              body: item.builder!(),
                              bottomNavigationBar: childBottomNavigatorBar,
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
                                                      sb.onPressed!();
                                                    })
                                            ]
                                          : null,
                                    ),
                              body: item.builder!(),
                              bottomNavigationBar: childBottomNavigatorBar,
                            ),
                    );
                  },
                  child: Container(
                      color: item.color,
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
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18))),
                        SizedBox(
                          height: 20,
                        ),
                      ])),
                ),
              ),
            ),
        ]),
      ),
      bottomNavigationBar: bottomNavigationBar,
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
                                            color:
                                                theme.scaffoldBackgroundColor);
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
                          /* Expanded(
                            child:
                                /* (scrolling)
                                ? SingleChildScrollView(child: body)
                                :*/
                                body),*/
                        ],
                      )),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                )),
            //Expanded(child: body),
          ],
        ),
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}

class MobileBottonNavigatorButton extends StatefulWidget {
  const MobileBottonNavigatorButton({
    Key? key,
    required this.choices,
    this.selected = 0,
    this.hideSelected = false,
  }) : super(key: key);
  final List<TabChoice> choices;
  final int selected;
  final bool hideSelected;

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
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30)),
          boxShadow: [
            BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
          ],
        ),
        child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            child: ValueListenableBuilder<int>(
              valueListenable: index!,
              builder: (a, b, c) => Container(
                  color: Colors.white,
                  height: 55,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      for (int i = 0; i < widget.choices.length; i++)
                        Container(
                          height: 55,
                          width: 55,
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
