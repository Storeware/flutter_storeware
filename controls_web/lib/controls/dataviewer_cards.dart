// @dart=2.12
import 'package:flutter/material.dart';
import 'package:controls_web/controls.dart';
import 'package:controls_web/controls/data_viewer.dart';
import 'dart:async';

class DataViewerCards extends StatefulWidget {
  final double itemWidth;
  final Widget Function(BuildContext context, Map<String, dynamic> data)
      itemBuilder;
  final DataViewerController controller;
  final Widget? header;
  final Widget? footer;
  final double padding;
  final int? rowsPerPage;
  final Widget Function()? noDataBuilder;
  final Widget? placeHolder;
  final bool canHideNavigator;
  final bool lazyLoader;
  DataViewerCards({
    Key? key,
    this.itemWidth = 200,
    required this.itemBuilder,
    required this.controller,
    this.header,
    this.footer,
    this.rowsPerPage,
    this.lazyLoader = false,
    this.canHideNavigator = false,
    this.noDataBuilder,
    this.placeHolder,
    this.padding = 2.0,
  }) : super(key: key);
  @override
  _cards createState() => _cards();
}

class _cards extends State<DataViewerCards> {
  ScrollController _scrollController = ScrollController();
  late ValueNotifier<bool> _loading;
  late int conta;
  @override
  void initState() {
    super.initState();
    _loading = ValueNotifier<bool>(true);
    conta = 1;
    _scrollController..addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (widget.lazyLoader) if (conta >
        0) if (_scrollController.position.extentAfter == 0) {
      if (!_loading.value) {
        print(_scrollController.position.extentAfter);
        _loading.value = true;
        Timer.run(() {
          widget.controller.openNext().then((r) {
            //    loadMoreStatus = LoadingStatus.STABLE;
            conta = r;
            _loading.value = false;
          });
        });
      }
    }
  }

  int nKey = 0;
  @override
  Widget build(BuildContext context) {
    ResponsiveInfo responsive = ResponsiveInfo(context);
    int nCols = responsive.size.width ~/ widget.itemWidth;
    if (nCols < 1) nCols = 1;
    int _rowsPerPage = widget.rowsPerPage ?? widget.controller.top ?? 0;

    widget.controller.open(page: 1).then((r) {
      conta = r;
      _loading.value = false;
    });

    return StreamBuilder<int>(
        initialData: 0,
        stream: widget.controller.subscribeChanges.stream,
        builder: (a, b) => Padding(
              padding: EdgeInsets.all(widget.padding),
              child: StreamBuilder<List>(
                  stream: widget.controller.stream,
                  builder: (context, snapshot) {
                    return (!snapshot.hasData)
                        ? Center(
                            child: widget.placeHolder ??
                                CircularProgressIndicator())
                        : Container(
                            child: ListView(
                            controller: _scrollController,
                            children: [
                              Wrap(children: [
                                if (widget.header != null) widget.header!,
                                if (snapshot.hasData &&
                                    snapshot.data!.length == 0)
                                  (widget.noDataBuilder == null)
                                      ? Align(
                                          child: Text('Sem dados para mostrar'))
                                      : widget.noDataBuilder!(),
                                for (var item in snapshot.data ?? [])
                                  Container(
                                      key: ValueKey(
                                          '${item[widget.controller.keyName] ?? nKey++}'),
                                      child: widget.itemBuilder(context, item)),
                                paginarWidget(
                                    context,
                                    (!widget.canHideNavigator) ||
                                        ((widget.controller.page > 1) ||
                                            (snapshot.data!.length >=
                                                _rowsPerPage))),
                              ]),
                              ValueListenableBuilder<bool>(
                                valueListenable: _loading,
                                builder: (BuildContext context, dynamic value,
                                    Widget? child) {
                                  return (value)
                                      ? SizedBox(
                                          height: 40,
                                          child: Align(
                                              child:
                                                  CircularProgressIndicator()))
                                      : SizedBox();
                                },
                              ),
                              if (widget.footer != null) widget.footer!,
                            ],
                          ));
                  }),
            ));
  }

  paginarWidget(context, show) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          child: (show) ? createPageNavigator(context) : null,
        ),
        SizedBox(height: 10),
      ],
    );
  }

  createPageNavigator(BuildContext context) {
    int n = 0;
    return Padding(
      padding: const EdgeInsets.only(left: 14, right: 14, bottom: 40),
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            createNavButton(1),
            for (var i = widget.controller.page - 1;
                i < widget.controller.page + 4;
                i++)
              if (i > 1)
                if ((n++) < 4) createNavButton(i),
          ],
        ),
      ),
    );
  }

  Widget createNavButton(int i) {
    return (widget.controller.page == i)
        ? CircleAvatar(
            radius: 15,
            backgroundColor: Colors.grey.withOpacity(0.3),
            child: Text('$i'),
          )
        : IconButton(
            icon: Text('$i'),
            onPressed: () {
              _loading.value = true;
              widget.controller.open(page: i).then((r) {
                conta = r;
                _loading.value = false;
              });
            },
          );
  }
}
