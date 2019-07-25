import 'package:flutter/material.dart';

typedef WidgetListBuilderContext(BuildContext context, int index);

bool navigateTo(context, onToPageFunc,
    {String key, Function(String) permission}) {
  if (permission != null) if (!permission(key)) {
    return false;
  }
  Navigator.of(context).push(MaterialPageRoute(builder: (x) => onToPageFunc()));
  return true;
}

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
  final EdgeInsets padding;
  final SliverAppBar sliverAppBar;
  final List<Widget> slivers;
  final List<Widget> grid;
  final Widget body;
  final Widget beforeBody;
  final Widget afterBody;
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
  final double gridMainAxisSpacing;
  final double gridCrossAxisSpacing;
  final double gridChildAspectRatio;
  final int gridCrossAxisCount;
  final ExtendedAppBar extendedBar;
  final double bodyTop;
  final List<Widget> bottomSlivers;
  final int itemCount;
  final Function(BuildContext, int) builder;
  SliverScaffold(
      {Key key,
      this.appBar,
      this.sliverAppBar,
      this.slivers,
      this.bottomSlivers,
      this.grid,
      this.gridMainAxisSpacing = 1.0,
      this.gridCrossAxisSpacing = 1.0,
      this.gridChildAspectRatio = 8.0,
      this.gridCrossAxisCount = 1,
      this.resizeToAvoidBottomPadding = false,
      this.body,
      this.beforeBody,
      this.afterBody,
      this.padding,
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
      this.topRadius = 0,
      this.bottomRadius = 0,
      this.extendedBar,
      this.itemCount,
      this.builder,
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
    //if (widget.sliverAppBar != null) rt.add(widget.sliverAppBar);
    //if (widget.extendedBar != null) rt.add(widget.extendedBar);
    if (widget.slivers != null)
      widget.slivers.forEach((f) {
        rt.add(f);
      });
    return rt;
  }

  _sliverGrid() {
    var _grid = widget.grid ?? [];
    return SliverGrid(
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: widget.gridMainAxisSpacing,
        crossAxisSpacing: widget.gridCrossAxisSpacing,
        childAspectRatio: widget.gridChildAspectRatio,
        crossAxisCount: widget.gridCrossAxisCount,
      ),
      delegate: new SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return _grid[index];
        },
        childCount: _grid.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double gapBody =
        (widget.extendedBar != null ? widget.extendedBar.height : 0) +
            widget.bodyTop;
    if (gapBody < 0) gapBody = 0;
    Widget _body = widget.body;
    if (widget.isScrollView) _body = SingleChildScrollView(child: widget.body);
    var theme = Theme.of(context);
    var _backgroundColor = widget.backgroundColor ?? theme.primaryColor;
    var scf = Scaffold(
        resizeToAvoidBottomPadding: widget.resizeToAvoidBottomPadding,
        key: widget.key,
        bottomNavigationBar: widget.bottomNavigationBar,
        drawer: widget.drawer,
        endDrawer: widget.endDrawer,
        backgroundColor: widget.backgroundColor,
        floatingActionButton: widget.floatingActionButton,
        appBar: widget.appBar,
        body: _clipRBody(
            Stack(
              children: <Widget>[
                widget.extendedBar ?? Container(),
                Column(children: [
                  Container(
                    height: gapBody,
                  ),
                  Expanded(
                      child: Container(
                    child: CustomScrollView(
                      slivers: _scroolSlivers(_body),
                    ),
                  )),
                ]),
              ],
            ),
            theme,
            _backgroundColor));

    var rt;
    if (widget.radius > 0)
      rt = Container(
          color: _backgroundColor,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(widget.radius), child: scf));
    else
      rt = scf;

    if (widget.afterLoaded != null) widget.afterLoaded(scf);

    return rt;
  }

  List<Widget> _scroolSlivers(Widget _body) {
    List<Widget> rt = [];
    if (widget.sliverAppBar != null) rt.add(widget.sliverAppBar);
    rt.add(SliverList(
      delegate: SliverChildListDelegate(_builder()),
    ));

    if (widget.grid != null) rt.add(_sliverGrid());

    rt.add(
        SliverList(delegate: SliverChildListDelegate([widget.beforeBody??Container(), _body ?? Container(), widget.afterBody??Container()])));

    if (widget.builder != null && widget.itemCount != null) {
      List<Widget> r = [];
      for (var i = 0; i < widget.itemCount; i++) {
        r.add(widget.builder(context, i));
      }
      if (r.length > 0)
        rt.add(SliverList(delegate: SliverChildListDelegate(r)));
    }

    if (widget.bottomSlivers != null)
      rt.add(
          SliverList(delegate: SliverChildListDelegate(widget.bottomSlivers)));

    return rt;
  }

  Widget _clipRBody(Widget _body, ThemeData theme, _backgroundColor) {
    Widget r = Container(
        color: _backgroundColor,
        child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(widget.topRadius),
              topRight: Radius.circular(widget.topRadius),
              bottomLeft: Radius.circular(widget.bottomRadius),
              bottomRight: Radius.circular(widget.bottomRadius),
            ),
            child:
                Container(color: theme.scaffoldBackgroundColor, child: _body)));

    if (widget.padding != null)
      return Container(
          color: _backgroundColor,
          child: Padding(padding: widget.padding, child: r));
    return r;
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
      child: child != null ? Wrap(children: [child]) : null,
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
          child ?? Container(),
        ],
      ),
    );
  }
}

var bgColor = (Colors.blue[900]);

AppBar appBarLight(context,
    {Widget title, List<Widget> actions, Widget menu, backgroundColor}) {
  //var bg = (backgroundColor ??= bgColor);
  return AppBar(
    //iconTheme: IconThemeData(color: Colors.white),
    //backgroundColor: bg,
    leading: menu ??
        IconButton(
          icon: Image.asset('assets/voltar.png'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
    title: title,
    actions: actions,
    elevation: 0.0,
    //brightness: Brightness.light,
  );
}

class ScaffoldLight extends StatefulWidget {
  final Widget body;
  final AppBar appBar;
  final Widget drawer;
  final Widget bottomNavigationBar;
  final Widget panelImage;
  final double extendedPanelHeigh;
  final Color backgroudColor;
  final String title;
  final Key scaffoldKey;
  ScaffoldLight(
      {Key key,
      this.scaffoldKey,
      this.body,
      this.appBar,
      this.drawer,
      this.bottomNavigationBar,
      this.panelImage,
      this.backgroudColor,
      this.title,
      this.extendedPanelHeigh = 150})
      : super(key: key);

  _ScaffoldLightState createState() => _ScaffoldLightState();
}

class _ScaffoldLightState extends State<ScaffoldLight> {
  appBar() {
    return widget.appBar;
  }

  @override
  Widget build(BuildContext context) {
    var bg = bgColor;
    return Scaffold(
        key: widget.scaffoldKey,
        backgroundColor: widget.backgroudColor,
        appBar: appBar(),
        drawer: widget.drawer,
        body: Stack(children: <Widget>[
          Container(
              width: double.infinity,
              height: widget.extendedPanelHeigh,
              child: Container(
                  color: bg,
                  child: Center(
                    child: widget.title != null
                        ? Text(widget.title,
                            style: TextStyle(color: Colors.white, fontSize: 18))
                        : widget.panelImage,
                  ))),
          widget.body,
        ]),
        bottomNavigationBar: widget.bottomNavigationBar);
  }
}
