import 'dart:async';

import 'package:flutter/material.dart';

enum SidebarPosition { none, left, right }

class SidebarScaffold extends StatefulWidget {
  final Widget appBar;
  final Widget body;
  final Widget floatingActionButton;
  final Widget sidebar;
  final SidebarPosition sidebarPosition;

  final bool sidebarVisible;
  final bool canShowCompact;
  final Widget bottomNavigationBar;

  final bool resizeToAvoidBottomInset;
  final Key scaffoldKey;

  final Color backgroundColor;
  final Color sidebarColor;
  SidebarScaffold(
      {Key key,
      this.appBar,
      this.sidebarVisible = true,
      this.sidebar,
      this.body,
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

  final Widget drawer;

  @override
  _SidebarScaffoldState createState() => _SidebarScaffoldState();
}

class _SidebarScaffoldState extends State<SidebarScaffold> {
  @override
  void initState() {
    Sidebar().visible = widget.sidebarVisible;
    super.initState();
  }

  ThemeData theme;
  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    Sidebar.position = widget.sidebarPosition;
    Sidebar.canShowCompact = widget.canShowCompact;
    if (Sidebar().homeWidget == null) Sidebar().homeWidget = widget.body;
    return Scaffold(
      appBar: widget.appBar ?? AppBar(title: Text('sidebar')),
      drawer: widget.drawer,
      key: widget.scaffoldKey,
      backgroundColor: widget.backgroundColor,
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
      body: Stack(
        children: <Widget>[
          if (Sidebar.position == SidebarPosition.left) buildHiddenButton(),
          Row(
            children: <Widget>[
              if ((widget.sidebarPosition == SidebarPosition.left) &&
                  (widget.sidebar != null))
                buildSidebar(widget.sidebar),
              Expanded(
                child: StreamBuilder<Widget>(
                    stream: Sidebar().pageStream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return widget.body;
                      return snapshot.data;
                    }),
              ),
              if ((widget.sidebarPosition == SidebarPosition.right) &&
                  (widget.sidebar != null))
                buildSidebar(widget.sidebar),
            ],
          ),
          if (Sidebar.position == SidebarPosition.right)
            Positioned(right: 1, child: buildHiddenButton()),
        ],
      ),
      floatingActionButton: widget.floatingActionButton,
      bottomNavigationBar: widget.bottomNavigationBar,
    );
  }

  StreamBuilder<bool> buildHiddenButton() {
    return StreamBuilder<bool>(
        stream: Sidebar().visibleStream,
        initialData: Sidebar().visible,
        builder: (context, snapshot) {
          if (snapshot.data) return Container();
          return InkWell(
            child: buildExpandIcon(),
            onTap: () {
              Sidebar().show();
            },
            //hoverColor: Colors.blue,
          );
        });
  }

  Widget buildExpandIcon() {
    if (Sidebar.position == SidebarPosition.right)
      return ClipPath(
        clipper: CustomMenuClipperRight(),
        child: Container(
          decoration: BoxDecoration(
            color: theme.primaryColor.withAlpha(50),
          ),
          width: 20,
          height: 70,
          child: Align(
            child: Text('|', style: TextStyle(color: Colors.black45)),
          ),
        ),
      );
//      return Icon(Icons.view_column);
    //return Icon(Icons.view_column);
    return ClipPath(
      clipper: CustomMenuClipperLeft(),
      child: Container(
        decoration: BoxDecoration(
          color: theme.primaryColor.withAlpha(50),
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
        stream: Sidebar().visibleStream,
        initialData: widget.sidebarVisible,
        builder: (context, snapshot) {
          print(snapshot.data);
          if ((!snapshot.hasData) || (!snapshot.data)) return Container();
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
  final Widget image;
  final String title;
  final Color color;
  final Function onPressed;
  final double width;
  final double height;
  //final bool compact;
  SidebarButton(
      {Key key,
      this.height = 70,
      this.width = double.maxFinite,
      this.onPressed,
      this.color,
      this.image,
      //this.compact = false,
      this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: Sidebar().compactStream,
        initialData: Sidebar.compacted,
        builder: (context, snapshot) {
          bool cmpt = snapshot.data;
          return Padding(
            padding:
                const EdgeInsets.only(top: 1, left: 2, right: 2, bottom: 1),
            child: InkWell(
              hoverColor: Colors.blue,
              highlightColor: Colors.red,
              onTap: () {
                if (onPressed != null) onPressed();
              },
              child: Container(
                width: width,
                height: (!cmpt) ? height : Sidebar.compactSize,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: color ?? Theme.of(context).buttonColor,
                ),
                child: Center(
                  child: (cmpt)
                      ? image
                      : Column(
                          children: <Widget>[image, Text(title)],
                        ),
                ),
              ),
            ),
          );
        });
  }
}

class Sidebar {
  static final _singleton = Sidebar._create();

  static var position = SidebarPosition.left;

  static bool canShowCompact = false;
  Sidebar._create();
  factory Sidebar() => _singleton;
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

  Widget homeWidget;
  pop() {
    if (_navigators.length == 0) return homeWidget;
    var p = _navigators.removeLast();
    _pageStream.sink.add(p);
  }

  goHome() {
    _pageStream.sink.add(homeWidget);
  }

  get pageStream => _pageStream.stream;

  //------------- visibility
  bool visible = true;
  var _visibleStream = StreamController<bool>.broadcast();
  get visibleStream => _visibleStream.stream;
  show() {
    visible = true;
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
  bool _compact = false;
  showCompact({compact = false}) {
    _compact = compact;
    _showCompactStream.sink.add(compact);
  }

  static get compacted => _singleton._compact;
  static set compacted(value) {
    _singleton._compact = value;
  }

  static double compactSize;
  static double width = 150;
}

class SidebarHeader extends StatelessWidget {
  final String title;
  final Widget leading;
  final Widget trailing;
  final Color color;
  final Color titleColor;
  final double height;
  const SidebarHeader({
    Key key,
    this.color,
    this.titleColor,
    this.title,
    this.leading,
    this.trailing,
    this.height = 40,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: color ?? theme.primaryColor,
      ),
      child: StreamBuilder<bool>(
          stream: Sidebar().compactStream,
          initialData: Sidebar.compacted,
          builder: (context, snapshot) {
            if (snapshot.data)
              return IconButton(
                icon: Icon(
                  (Sidebar.position == SidebarPosition.left)
                      ? Icons.arrow_right
                      : Icons.arrow_left,
                  color: titleColor ?? theme.primaryTextTheme.title.color,
                ),
                onPressed: () {
                  Sidebar().showCompact(compact: false);
                },
              );
            return Row(
              children: [
                if (leading != null) Align(child: leading),
                if (Sidebar.position == SidebarPosition.left)
                  InkWell(
                    child: Icon(
                      Icons.arrow_left,
                      color: titleColor ?? theme.primaryTextTheme.title.color,
                    ),
                    onTap: () {
                      Sidebar().hide();
                    },
                  ),
                Expanded(
                    child: Align(
                  alignment: (Sidebar.position == SidebarPosition.left)
                      ? Alignment.centerLeft
                      : Alignment.center,
                  child: Text(
                    title ?? '',
                    style: TextStyle(
                      color: titleColor ?? theme.primaryTextTheme.title.color,
                      fontSize: theme.primaryTextTheme.title.fontSize,
                    ),
                  ),
                )),
                if (Sidebar.canShowCompact)
                  InkWell(
                    child: Icon(
                      Icons.view_compact,
                      color: titleColor ?? theme.primaryTextTheme.title.color,
                    ),
                    onTap: () {
                      Sidebar().showCompact(compact: true);
                    },
                  ),
                if (trailing != null) Align(child: trailing),
                if (Sidebar.position == SidebarPosition.right)
                  InkWell(
                    child: Icon(
                      Icons.arrow_right,
                      color: titleColor ?? theme.primaryTextTheme.title.color,
                    ),
                    onTap: () {
                      Sidebar().hide();
                    },
                  ),
              ],
            );
          }),
    );
  }
}

class SidebarContainer extends StatelessWidget {
  final double width;
  final Widget child;
  final bool compact;
  final double compactWidth;
  const SidebarContainer({
    Key key,
    this.width = 150,
    this.compactWidth = 50,
    this.compact = false,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Sidebar.compactSize == null) {
      Sidebar.compactSize = this.compactWidth;
      Sidebar.compacted = this.compact;
      Sidebar.width = this.width;
    }
    return StreamBuilder<bool>(
        stream: Sidebar().compactStream,
        initialData: Sidebar.compacted,
        builder: (context, snapshot) {
          return Container(
            width: (!snapshot.data) ? width : compactWidth,
            child: child,
          );
        });
  }
}

class CustomMenuClipperLeft extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    print(size);
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
    print(size);
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
