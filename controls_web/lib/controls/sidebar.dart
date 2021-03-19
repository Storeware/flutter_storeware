import 'dart:async';

import 'package:flutter/material.dart';

enum SidebarPosition { none, left, right }

class SidebarScaffold extends StatefulWidget {
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? floatingActionButton;
  final Widget? sidebar;
  final SidebarPosition? sidebarPosition;
  final SidebarController? controller;
  final bool? sidebarVisible;
  final bool? canShowCompact;
  final Widget? bottomNavigationBar;

  final bool? resizeToAvoidBottomInset;
  final Key? scaffoldKey;

  final Color? backgroundColor;
  final Color? sidebarColor;
  SidebarScaffold(
      {Key? key,
      this.appBar,
      this.sidebarVisible = true,
      this.sidebar,
      this.body,
      @required this.controller,
      this.canShowCompact = false,
      this.sidebarPosition = SidebarPosition.left,
      this.floatingActionButton,
      this.bottomNavigationBar,
      this.resizeToAvoidBottomInset,
      this.scaffoldKey,
      this.backgroundColor,
      this.drawer,
      this.sidebarColor})
      : super(key: key);

  final Widget? drawer;

  @override
  _SidebarScaffoldState createState() => _SidebarScaffoldState();
}

class _SidebarScaffoldState extends State<SidebarScaffold> {
  SidebarController? _controller;
  @override
  void initState() {
    _controller = widget.controller ?? SidebarController();
    _controller!.visible = widget.sidebarVisible!;
    super.initState();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  ThemeData? theme;
  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    _controller!.position = widget.sidebarPosition!;
    _controller!.canShowCompact = widget.canShowCompact!;
    if (_controller!.homeWidget == null) _controller!.homeWidget = widget.body!;
    return Scaffold(
      appBar: (widget.appBar == null)
          ? null
          : widget.appBar!, //?? AppBar(title: Text('sidebar')),
      drawer: widget.drawer,
      key: widget.scaffoldKey,
      backgroundColor: _controller!.backgroudColor ??
          widget.backgroundColor ??
          theme!.scaffoldBackgroundColor,
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
      body: Stack(
        children: <Widget>[
          if (_controller!.position == SidebarPosition.left)
            buildHiddenButton(),
          Row(
            children: <Widget>[
              if ((widget.sidebarPosition == SidebarPosition.left) &&
                  (widget.sidebar != null))
                buildSidebar(widget.sidebar!),
              Expanded(
                child: StreamBuilder<Widget>(
                    stream: _controller!.pageStream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return widget.body ?? Container();
                      return snapshot.data!;
                    }),
              ),
              if ((widget.sidebarPosition == SidebarPosition.right) &&
                  (widget.sidebar != null))
                buildSidebar(widget.sidebar!),
            ],
          ),
          if (_controller!.position == SidebarPosition.right)
            Positioned(right: 1, child: buildHiddenButton()),
        ],
      ),
      floatingActionButton: widget.floatingActionButton,
      bottomNavigationBar: widget.bottomNavigationBar,
    );
  }

  StreamBuilder<bool> buildHiddenButton() {
    return StreamBuilder<bool>(
        stream: _controller!.visibleStream,
        initialData: widget.sidebarVisible,
        builder: (context, snapshot) {
          if (snapshot.data!) return Container();
          return InkWell(
            child: buildExpandIcon(),
            onTap: () {
              _controller!.show();
            },
            //hoverColor: Colors.blue,
          );
        });
  }

  Widget buildExpandIcon() {
    if (_controller!.position == SidebarPosition.right)
      return ClipPath(
        clipper: CustomMenuClipperRight(),
        child: Container(
          decoration: BoxDecoration(
            color: theme!.primaryColor.withAlpha(50),
          ),
          width: 20,
          height: 70,
          child: Align(
            child: Text('|', style: TextStyle(color: Colors.black45)),
          ),
        ),
      );
    return ClipPath(
      clipper: CustomMenuClipperLeft(),
      child: Container(
        decoration: BoxDecoration(
          color: theme!.primaryColor.withAlpha(50),
        ),
        width: 20,
        height: 70,
        child: Align(
          child: Text('|', style: TextStyle(color: Colors.black45)),
        ),
      ),
    );
  }

  StreamBuilder<bool> buildSidebar(Widget wg) {
    return StreamBuilder<bool>(
        stream: _controller!.visibleStream,
        initialData: widget.sidebarVisible,
        builder: (context, snapshot) {
          //print(snapshot.data);
          if ((!snapshot.hasData) || (!snapshot.data!)) return SizedBox();
          return Expanded(
            flex: 0,
            child: Container(
              color: widget.sidebarColor,
              child: wg,
            ),
          );
        });
  }
}

class SidebarButton extends StatelessWidget {
  final Widget? image;
  final String? title;
  final Color? color;
  final Function? onPressed;
  final double? width;
  final double? height;
  final SidebarController? controller;
  //final bool compact;
  SidebarButton(
      {Key? key,
      this.height = 70,
      this.width = double.maxFinite,
      @required this.controller,
      this.onPressed,
      this.color,
      this.image,
      //this.compact = false,
      this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: controller!.compactStream,
        initialData: controller!.compacted,
        builder: (context, snapshot) {
          bool cmpt = snapshot.data!;
          //print('cmpt');
          return Padding(
            padding:
                const EdgeInsets.only(top: 1, left: 2, right: 2, bottom: 1),
            child: InkWell(
              hoverColor: Colors.blue,
              highlightColor: Colors.red,
              onTap: () {
                //print('onPressed');
                if (onPressed != null) onPressed!();
              },
              child: Container(
                width: width,
                height: (!cmpt) ? height : controller!.compactSize,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: color ?? Theme.of(context).buttonColor,
                ),
                child: Center(
                  child: (cmpt)
                      ? image
                      : Column(
                          children: <Widget>[image!, Text(title!)],
                        ),
                ),
              ),
            ),
          );
        });
  }
}

class SidebarController {
  final Widget? bottom;
  final AppBar? appBar;
  final Widget? body;
  final Widget? bottomNavigationBar;
  final Widget Function(BuildContext)? backgroundBuilder;
  bool? compacted;
  double? compactSize;
  double? width;
  Color? backgroudColor;
  Color? color;
  bool? isMobile;
  double get currentWidth =>
      (visible) ? ((compacted!) ? compactSize! : width!) : 0.0;
  bool visible;
  SidebarController(
      {this.color,
      this.width = 180,
      this.backgroudColor,
      this.backgroundBuilder,
      this.visible = true,
      this.position,
      this.isMobile = false,
      this.canShowCompact = false,
      this.compacted = false,
      this.compactSize = 60,
      this.appBar,
      this.bottom,
      this.body,
      this.bottomNavigationBar,
      this.homeWidget});
  SidebarPosition? position = SidebarPosition.left;

  bool canShowCompact;
  var _pageStream = StreamController<Widget>.broadcast();

  List<Widget> _navigators = [];
  dispose() {
    _pageStream.close();
    _visibleStream.close();
    _showCompactStream.close();
  }

  push(Widget wg) {
    _navigators.add(wg);
    _pageStream.sink.add(wg);
  }

  Widget? homeWidget;
  pop() {
    if (_navigators.length == 0) return homeWidget;
    var p = _navigators.removeLast();
    _pageStream.sink.add(p);
  }

  goHome() {
    _pageStream.sink.add(homeWidget!);
  }

  get pageStream => _pageStream.stream;

  //------------- visibility
  var _visibleStream = StreamController<bool>.broadcast();
  get visibleStream => _visibleStream.stream;
  show() {
    visible = true;
    //print(visible);
    return _visibleStream.sink.add(true);
  }

  hide() {
    visible = false;
    return _visibleStream.sink.add(false);
  }

  switchBar() {
    if (visible)
      hide();
    else
      show();
  }

  var _showCompactStream = StreamController<bool>.broadcast();
  get compactStream => _showCompactStream.stream;
  showCompact({compact = false}) {
    compacted = compact;
    _showCompactStream.sink.add(compact);
  }
}

class SidebarHeader extends StatelessWidget {
  final String? title;
  final Widget? leading;
  final Widget? trailing;
  final Color? color;
  final Color? titleColor;
  final double? height;
  final SidebarController? controller;
  const SidebarHeader({
    Key? key,
    this.color,
    this.titleColor,
    this.title,
    this.leading,
    @required this.controller,
    this.trailing,
    this.height = 40,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: controller!.color ?? color ?? theme.primaryColor,
      ),
      child: StreamBuilder<bool>(
          stream: controller!.compactStream,
          initialData: controller!.compacted,
          builder: (context, snapshot) {
            if (snapshot.data!)
              return IconButton(
                icon: Icon(
                  (controller!.position == SidebarPosition.left)
                      ? Icons.arrow_right
                      : Icons.arrow_left,
                  color: titleColor ?? theme.primaryTextTheme.headline6!.color,
                ),
                onPressed: () {
                  //print('showCompact');
                  controller!.showCompact(compact: false);
                },
              );
            return Row(
              children: [
                if (leading != null) Align(child: leading),
                if (controller!.position == SidebarPosition.left)
                  InkWell(
                    child: Icon(
                      Icons.arrow_left,
                      color:
                          titleColor ?? theme.primaryTextTheme.headline6!.color,
                    ),
                    onTap: () {
                      //print('hide');
                      controller!.hide();
                    },
                  ),
                Expanded(
                    child: Align(
                  alignment: (controller!.position == SidebarPosition.left)
                      ? Alignment.centerLeft
                      : Alignment.center,
                  child: Text(
                    title ?? '',
                    style: TextStyle(
                      color:
                          titleColor ?? theme.primaryTextTheme.headline6!.color,
                      fontSize: theme.primaryTextTheme.headline6!.fontSize,
                    ),
                  ),
                )),
                if (controller!.canShowCompact)
                  InkWell(
                    child: Icon(
                      Icons.view_compact,
                      color:
                          titleColor ?? theme.primaryTextTheme.headline6!.color,
                    ),
                    onTap: () {
                      //print('showCompact-true');
                      controller!.showCompact(compact: true);
                    },
                  ),
                if (trailing != null) Align(child: trailing),
                if (controller!.position == SidebarPosition.right)
                  InkWell(
                    child: Icon(
                      Icons.arrow_right,
                      color:
                          titleColor ?? theme.primaryTextTheme.headline6!.color,
                    ),
                    onTap: () {
                      //print('hide_');
                      controller!.hide();
                    },
                  ),
              ],
            );
          }),
    );
  }
}

class SidebarContainer extends StatelessWidget {
  final double? width;
  final Widget? child;
  final Color? color;
  final bool? compact;
  final double? compactWidth;
  final SidebarController? controller;
  final Widget Function(BuildContext)? backgroundBuilder;
  const SidebarContainer({
    Key? key,
    this.width = 150,
    @required this.controller,
    this.compactWidth = 50,
    this.compact = false,
    this.child,
    this.color,
    this.backgroundBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (controller!.compactSize == null) {
      controller!.compactSize = this.compactWidth;
      controller!.compacted = this.compact;
      controller!.width = this.width;
    }
    return StreamBuilder<bool>(
        stream: controller!.compactStream,
        initialData: controller?.compacted ?? false,
        builder: (context, snapshot) {
          return Container(
              color: color ?? Colors.transparent,
              width: controller!
                  .currentWidth, //(!snapshot.data) ? width : compactWidth,
              child: Scaffold(
                  appBar: controller?.appBar,
                  backgroundColor: controller?.color,
                  body: Stack(children: [
                    if (backgroundBuilder != null) backgroundBuilder!(context),
                    ((controller!.body == null) && (controller!.bottom == null))
                        ? child ?? Container()
                        : Column(children: [
                            if (controller!.body != null) controller!.body!,
                            if (child != null) Expanded(child: child!),
                            if (controller!.bottom != null) controller!.bottom!
                          ])
                  ]),
                  bottomNavigationBar: controller?.bottomNavigationBar));
        });
  }
}

class CustomMenuClipperLeft extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    //print(size);
    var path = new Path();
    path.moveTo(0, 0);
    path.lineTo(20, 10);
    path.lineTo(20, 60);
    path.lineTo(0, 70);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class CustomMenuClipperRight extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    //print(size);
    var path = new Path();
    path.moveTo(size.width, 0);
    path.lineTo(0, 10);
    path.lineTo(0, size.height - 10);
    path.lineTo(size.width, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
