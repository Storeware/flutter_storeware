import 'package:flutter/material.dart';
import 'package:controls_web/drivers/bloc_model.dart';

class LeftMenuVisibleNotifier extends BlocModel<bool> {
  static final _singleton = LeftMenuVisibleNotifier._create();
  LeftMenuVisibleNotifier._create();
  factory LeftMenuVisibleNotifier() => _singleton;
}

class LeftMenuItem {
  Widget icon;
  String title;
  Function onPressed;
  LeftMenuItem({this.title, this.icon, this.onPressed});
}

class LeftMenuContainer extends StatefulWidget {
  final Function(bool) onChange;
  final bool expanded;
  final double expandedWidth;
  final double colapsedWidth;
  final bool visible;
  final List<LeftMenuItem> children;
  const LeftMenuContainer(
      {Key key,
      this.visible = true,
      this.children,
      this.expandedWidth = 200,
      this.colapsedWidth = 50,
      this.expanded = true,
      this.onChange})
      : super(key: key);

  @override
  _LeftMenuContainerState createState() => _LeftMenuContainerState();
}

class _LeftMenuContainerState extends State<LeftMenuContainer> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: LeftMenuVisibleNotifier().stream,
        initialData: widget.visible,
        builder: (x, y) {
          _visible = y.data;
          if (!_visible) return Container();
          var p = Theme.of(context).primaryColor;
          return Container(
            width:
                (widget.expanded ? widget.expandedWidth : widget.colapsedWidth),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: ListView(
                children: <Widget>[
                  Container(
                    height: 25,
                    color: p.withAlpha(100),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                          //iconSize: 20,
                          //padding: EdgeInsets.all(0),
                          child: Icon((widget.expanded
                              ? Icons.arrow_left
                              : Icons.arrow_right)),
                          onTap: () {
                            if (widget.onChange != null)
                              widget.onChange(!widget.expanded);
                          },
                          splashColor: Colors.indigo,
                        ),
                        Text(
                          widget.expanded ? 'Menu' : '..',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  ..._createItems(context),
                ],
              ),
            ),
          );
        });
  }

  _createItems(context) {
    return [
      for (var i = 0; i < (widget.children ?? []).length; i++)
        _createItem(widget.children[i])
    ];
  }

  _createItem(LeftMenuItem item) {
    if (widget.expanded)
      return ListTile(
        leading: item.icon,
        dense: false,
        contentPadding: EdgeInsets.only(left: 8),
        title: Text(item.title),
        onTap: () {
          if (item.onPressed != null) item.onPressed();
        },
      );
    return InkWell(
      child: item.icon,
      splashColor: Colors.indigo,
      onTap: () {
        if (item.onPressed != null) item.onPressed();
      },
    );
  }
}
