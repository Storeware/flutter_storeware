import 'package:flutter/material.dart';

@immutable
class SliverScaffold extends StatefulWidget {
  final AppBar appBar;
  final SliverAppBar sliverAppBar;
  final List<Widget> slivers;
  final Widget body;
  final Widget drawer;
  final Widget endDrawer;
  final double radius;
  final Color backgroundColor;
  final Widget floatingActionButton;
  final Widget bottomNavigationBar;
  final afterLoaded;
  final ScrollController controller;

  final bool reverse;

  SliverScaffold(
      {Key key,
      this.appBar,
      this.sliverAppBar,
      this.slivers,
      this.body,
      this.controller,
      this.reverse = false,
      this.drawer,
      this.endDrawer,
      this.floatingActionButton,
      this.backgroundColor,
      this.bottomNavigationBar,
      this.afterLoaded,
      this.radius = 0.0})
      : super(key: key);

  static nested(
      {AppBar appBar,
      SliverAppBar sliverAppBar,
      @required Widget body,
      double radius = 0.0}) {
    return SliverScaffold(
      appBar: appBar,
      sliverAppBar: sliverAppBar,
      body: body,
      radius: radius,
    );
  }

  @override
  _SliverScaffoldState createState() => _SliverScaffoldState();
}

class _SliverScaffoldState extends State<SliverScaffold> {

  List<Widget> _builder() {
    List<Widget> rt = [];
    if (widget.sliverAppBar != null) rt.add(widget.sliverAppBar);
    if (widget.slivers != null)
      widget.slivers.forEach((f) {
        rt.add(f);
      });
    return rt;
  }

  @override
  Widget build(BuildContext context) {
    var scf = Scaffold(
        key: widget.key,
        bottomNavigationBar: widget.bottomNavigationBar,
        drawer: widget.drawer,
        endDrawer: widget.endDrawer,
        backgroundColor: widget.backgroundColor,
        floatingActionButton: widget.floatingActionButton,
        appBar: widget.appBar,
        body: NestedScrollView(
          controller: widget.controller,
          reverse: widget.reverse,
          headerSliverBuilder: (context, inner) {
            return _builder();
          },
          body: (widget.body == null ? Text('body.....') : widget.body),
        ));

    var rt = Container(
        child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.radius), child: scf));
    if (widget.afterLoaded != null) widget.afterLoaded(scf);

    return rt;
  }
}
