// @dart=2.12
import 'package:flutter/material.dart';
import 'package:controls_web/controls.dart';
import 'package:controls_web/controls/data_viewer.dart';

class DataViewerCards extends StatelessWidget {
  final double itemWidth;
  final Widget Function(BuildContext context, Map<String, dynamic> data)
      itemBuilder;
  final DataViewerController controller;
  final Widget? header;
  final Widget? footer;
  final double padding;
  final int? rowsPerPage;
  final Widget Function()? noDataBuilder;
  DataViewerCards({
    Key? key,
    this.itemWidth = 200,
    required this.itemBuilder,
    required this.controller,
    this.header,
    this.footer,
    this.rowsPerPage,
    this.noDataBuilder,
    this.padding = 2.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ResponsiveInfo responsive = ResponsiveInfo(context);
    int nCols = responsive.size.width ~/ itemWidth;
    if (nCols < 1) nCols = 1;
    int _rowsPerPage = rowsPerPage ?? controller.top ?? 0;

    return Padding(
      padding: EdgeInsets.all(padding),
      child: FutureBuilder<List>(
          future: controller.future!(),
          builder: (context, snapshot) {
            return (!snapshot.hasData)
                ? Center(child: CircularProgressIndicator())
                : Container(
                    child: ListView(
                    children: [
                      Wrap(children: [
                        if (header != null) header!,
                        if (snapshot.hasData && snapshot.data!.length == 0)
                          (noDataBuilder == null)
                              ? Align(child: Text('Sem dados para mostrar'))
                              : noDataBuilder!(),
                        for (var item in snapshot.data ?? [])
                          itemBuilder(context, item),
                        paginarWidget(
                            context,
                            ((controller.page > 1) ||
                                (snapshot.data!.length >= _rowsPerPage))),
                      ]),
                      if (footer != null) footer!,
                    ],
                  ));
          }),
    );
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
            for (var i = controller.page - 1; i < controller.page + 4; i++)
              if (i > 1)
                if ((n++) < 4) createNavButton(i),
          ],
        ),
      ),
    );
  }

  Widget createNavButton(int i) {
    return (controller.page == i)
        ? CircleAvatar(
            radius: 15,
            backgroundColor: Colors.grey.withOpacity(0.3),
            child: Text('$i'),
          )
        : IconButton(
            icon: Text('$i'),
            onPressed: () {
              //widget.onPageSelected!(i);
              controller.goPage(i);
            },
          );
  }
}
