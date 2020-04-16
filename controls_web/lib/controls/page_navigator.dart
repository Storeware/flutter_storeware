import 'dart:async';

import 'package:controls_web/drivers/bloc_model.dart';
import 'package:flutter/material.dart';

class PageNavigatorController {
  var notifiler = BlocModel<int>();
  goTo(pg) {
    notifiler.notify(pg);
  }

  set pagina(x) {
    goTo(x);
  }
}

class PageNavigator extends StatefulWidget {
  final int pagina;
  final int count;
  final Color color;
  final Function(int) onChange;
  final double width;
  final double height;
  final PageNavigatorController controller;
  const PageNavigator(
      {Key key,
      this.pagina = 1,
      this.onChange,
      this.count = 5,
      this.width,
      this.height = 40,
      this.controller,
      this.color})
      : super(key: key);

  @override
  _PageNavigatorState createState() => _PageNavigatorState();
}

class _PageNavigatorState extends State<PageNavigator> {
  int _pagina;

  StreamSubscription navStream;
  @override
  void initState() {
    _pagina = widget.pagina;
    if (widget.controller != null)
      navStream = widget.controller.notifiler.stream.listen((p) {
        goTo(p);
      });

    super.initState();
  }

  @override
  void dispose() {
    if (navStream != null) navStream.cancel();
    super.dispose();
  }

  goTo(pag) {
    setState(() {
      _pagina = pag;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? double.maxFinite,
      height: widget.height,
      color: widget.color ?? Colors.amber,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () {
            _pagina -= widget.count;
            widget.onChange(_pagina);
          },
        ),
        InkWell(
          child: Text('0'),
          onTap: () {
            _pagina = 1;
            widget.onChange(_pagina);
          },
        ),
        for (var i = _pagina; i < _pagina + widget.count; i++)
          InkWell(
            child: Text(i.toString()),
            onTap: () {
              _pagina = i;
              widget.onChange(_pagina);
            },
          ),
        IconButton(
          icon: Icon(Icons.chevron_right),
          onPressed: () {
            _pagina += widget.count;
            widget.onChange(_pagina);
          },
        )
      ]),
    );
  }
}
