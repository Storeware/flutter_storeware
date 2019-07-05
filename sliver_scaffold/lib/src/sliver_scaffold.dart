import 'package:flutter/material.dart';

typedef WidgetListBuilderContext(BuildContext context, int index);

class WidgetList {
  static List<Widget> count(context,
      {int itemCount = 0, WidgetListBuilderContext itemBuilder}) {
    List<Widget> rt = [];
    for (var i = 0; i < itemCount; i++) {
      rt.add(itemBuilder(context, i));
    }
    return rt;
  }
}

//@immutable
class SliverScaffold extends StatefulWidget {
  final AppBar appBar;
  final SliverAppBar sliverAppBar;
  final List<Widget> slivers;
  final List<Widget> grid;
  final Widget body;
  final Widget drawer;
  final Widget endDrawer;
  final double radius;
  final Color backgroundColor;
  final Widget floatingActionButton;
  final Widget bottomNavigationBar;
  final afterLoaded;
  final ScrollController controller;
  final bool isScrollView;
  final double topRadius;
  final double bottomRadius;
  final bool reverse;
  final bool resizeToAvoidBottomPadding;
  //final double gridMaxCrossAxisExtend;
  final double gridMainAxisSpacing;
  final double gridCrossAxisSpacing;
  final double gridChildAspectRatio;
  final int gridCrossAxisCount;
  final ExtendedAppBar extendedBar;
  final double bodyTop;
  SliverScaffold(
      {Key key,
      this.appBar,
      this.sliverAppBar,
      this.slivers,
      this.grid,
      //this.gridMaxCrossAxisExtend = 200.0,
      this.gridMainAxisSpacing = 10.0,
      this.gridCrossAxisSpacing = 10.0,
      this.gridChildAspectRatio = 2.0,
      this.gridCrossAxisCount = 1,
      this.resizeToAvoidBottomPadding = false,
      this.body,
      this.isScrollView = false,
      this.controller,
      this.reverse = false,
      this.drawer,
      this.endDrawer,
      this.floatingActionButton,
      this.backgroundColor,
      this.bottomNavigationBar,
      this.afterLoaded,
      this.radius = 0.0,
      this.topRadius = 0.0,
      this.bottomRadius = 0.0,
      this.extendedBar,
      this.bodyTop = 0})
      : super(key: key);

  static scrollable(
      {Key key,
      appBar,
      sliverAppBar,
      slivers,
      body,
      controller,
      reverse = false,
      drawer,
      endDrawer,
      floatingActionButton,
      backgroundColor,
      bottomNavigationBar,
      afterLoaded,
      radius = 0.0}) {
    return SliverScaffold(
        key: key,
        appBar: appBar,
        sliverAppBar: sliverAppBar,
        slivers: slivers,
        body: body,
        isScrollView: true,
        controller: controller,
        reverse: reverse,
        drawer: drawer,
        endDrawer: endDrawer,
        floatingActionButton: floatingActionButton,
        backgroundColor: backgroundColor,
        bottomNavigationBar: bottomNavigationBar,
        afterLoaded: afterLoaded,
        radius: radius);
  }

  static nested(
      {AppBar appBar,
      SliverAppBar sliverAppBar,
      @required Widget body,
      double radius = 0.0,
      bottomNavigationBar,
      bool isScrollView = false}) {
    return SliverScaffold(
        appBar: appBar,
        sliverAppBar: sliverAppBar,
        isScrollView: isScrollView,
        body: body,
        radius: radius,
        bottomNavigationBar: bottomNavigationBar);
  }

  static sliverGrid(
      {AppBar appBar,
      SliverAppBar sliverAppBar,
      List<Widget> grid,
      @required Widget body,
      double radius = 0.0,
      bottomNavigationBar,
      bool isScrollView = false}) {
    return SliverScaffold(
        appBar: appBar,
        sliverAppBar: sliverAppBar,
        grid: grid,
        isScrollView: isScrollView,
        body: body,
        radius: radius,
        bottomNavigationBar: bottomNavigationBar);
  }

  @override
  _SliverScaffoldState createState() => _SliverScaffoldState();
}

class _SliverScaffoldState extends State<SliverScaffold> {
  List<Widget> _builder() {
    List<Widget> rt = [];
    if (widget.sliverAppBar != null) rt.add(widget.sliverAppBar);
    //if (widget.extendedBar!=null) rt.add(widget.extendedBar);
    if (widget.slivers != null)
      widget.slivers.forEach((f) {
        rt.add(f);
      });
    if (widget.grid != null) {
      if (widget.extendedBar != null) widget.grid.insert(0, widget.extendedBar);
      rt.add(
        SliverGrid(
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: widget.gridMainAxisSpacing,
            crossAxisSpacing: widget.gridCrossAxisSpacing,
            childAspectRatio: widget.gridChildAspectRatio,
            crossAxisCount: widget.gridCrossAxisCount,
          ),
          delegate: new SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return widget.grid[index];
            },
            childCount: widget.grid.length,
          ),
        ),
      );
    }
    return rt;
  }

  @override
  Widget build(BuildContext context) {
    Widget _body = widget.body;
    if (widget.isScrollView) _body = SingleChildScrollView(child: widget.body);
    var theme = Theme.of(context);
    var scf = Scaffold(
        resizeToAvoidBottomPadding: widget.resizeToAvoidBottomPadding,
        key: widget.key,
        bottomNavigationBar: widget.bottomNavigationBar,
        drawer: widget.drawer,
        endDrawer: widget.endDrawer,
        backgroundColor: widget.backgroundColor,
        floatingActionButton: widget.floatingActionButton,
        appBar: widget.appBar,
        body: Container(
            height: double.maxFinite,
            color: theme.primaryColor,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(widget.topRadius),
                topRight: Radius.circular(widget.topRadius),
                bottomLeft: Radius.circular(widget.bottomRadius),
                bottomRight: Radius.circular(widget.bottomRadius),
              ),
              child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: NestedScrollView(
                    controller: widget.controller,
                    reverse: widget.reverse,
                    headerSliverBuilder: (context, inner) {
                      return _builder();
                    },
                    body: _createBody(_body),
                  )),
            )));

    var rt = Container(
        child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.radius), child: scf));

    if (widget.afterLoaded != null) widget.afterLoaded(scf);

    return rt;
  }

  Widget _createBody(Widget _body) {
    if (widget.extendedBar != null) {
      return ScaffoldLight(
        extendedBar: widget.extendedBar,
        bodyTop: widget.bodyTop,
        body: _body,
      );
    } else {
      return (widget.isScrollView
          ? Scaffold(
              resizeToAvoidBottomPadding: widget.resizeToAvoidBottomPadding,
              body: (widget.body == null ? Text('no data.....') : _body))
          : widget.body);
    }
  }
}

class ExtendedAppBar extends StatelessWidget {
  final Widget child;
  final double height;
  final Color color;
  final double width;
  const ExtendedAppBar(
      {Key key,
      this.height = 120,
      this.width = double.maxFinite,
      this.child,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: child,
      color: color,
    );
  }
}

class BoxContainer extends StatelessWidget {
  final Widget child;
  final Color color;
  final double topLeft;
  final double topRight;
  final double bottomLeft;
  final double bottomRight;
  final double topPositioned;
  final BoxDecoration decoration;
  final EdgeInsets padding;
  const BoxContainer(
      {Key key,
      this.child,
      this.color,
      this.decoration,
      this.topLeft = 20,
      this.topRight = 20,
      this.bottomLeft = 0,
      this.bottomRight = 0,
      this.topPositioned = 20,
      this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (padding == null)
      return _createChild(context);
    else
      return Padding(
        padding: padding,
        child: _createChild(context),
      );
  }

  Container _createChild(context) {
    return Container(
      constraints: BoxConstraints(minHeight: topPositioned + 20, minWidth: 20),
      height: double.maxFinite,
      width: double.maxFinite,
      decoration: decoration ??
          BoxDecoration(
              color: color,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(topLeft),
                  topRight: Radius.circular(topRight),
                  bottomLeft: Radius.circular(bottomLeft),
                  bottomRight: Radius.circular(bottomRight))),
      child: Stack(
        children: <Widget>[
          child,
        ],
      ),
    );
  }
}

class ScaffoldLight extends StatefulWidget {
  final Widget body;
  final ExtendedAppBar extendedBar;
  final Widget appBar;
  final double bodyTop;
  final Color backgroundColor;
  ScaffoldLight(
      {Key key,
      this.body,
      this.appBar,
      this.extendedBar,
      this.backgroundColor,
      this.bodyTop = 0})
      : super(key: key);

  _ScaffoldLightState createState() => _ScaffoldLightState();
}

class _ScaffoldLightState extends State<ScaffoldLight> {
  @override
  Widget build(BuildContext context) {
    double h = 0;
    if (widget.extendedBar!=null) h = widget.extendedBar.height ?? 0;
    return Scaffold(
        appBar: widget.appBar,
        body: Container(
          color: widget.backgroundColor ??
              Theme.of(context).scaffoldBackgroundColor,
          height: double.maxFinite,
          child: Stack(children: [
            widget.extendedBar,
            Container(
                height: double.maxFinite,
                child: Column(children: [
                  Container(height: h + widget.bodyTop),
                  Expanded(child: widget.body??Container())
                ]))
          ]),
        ));
  }
}
