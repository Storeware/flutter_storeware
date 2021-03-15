import 'package:controls_web/controls/data_viewer.dart';
import 'package:flutter/material.dart';

import 'cube_controller.dart';

class CubeDataViewer extends StatelessWidget {
  final DataViewerController? controller;
  const CubeDataViewer({
    Key? key,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DefaultCube? cube = DefaultCube.of(context);
    print(
        [for (var item in controller!.paginatedController.columns!) item.name]);
    print([
      for (var item in controller!.paginatedController.columns!) item.width
    ]);
    // print([cube.controller.dataView]);
    if (cube!.controller!.dataView.length == 0)
      return Container(child: Text('Não há dados para mostrar'));
    //PaginatedDataTable();
    return SizedBox.expand(
        child: DataViewer(
      canEdit: false,
      canInsert: false,
      canDelete: false,
      canSort: false,
      controller: controller!,
      columns: controller!.paginatedController.columns,
      source: cube.controller!.dataView,
      showPageNavigatorButtons: false,
      header: Container(),
      headerHeight: 0,
      dataRowHeight: 30,
    ));
  }
}
