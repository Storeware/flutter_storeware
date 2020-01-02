import 'package:comum/widgets/widget_data.dart';
import 'package:comum/widgets/widgets_base.dart';
import 'package:controls_web/controls/home_elements.dart';
import 'package:flutter/material.dart';

import 'package:controls_data/data.dart';

class GruposProdutosWidget extends WidgetBase {
  @override
  Widget builder(context) {
    print('builder->GruposProdutos');
    return ODataBuilder(
        query: ODataQuery(
          resource: 'wba_ctgrupo',
          select: 'count(*) conta',
          filter: "issintetico eq 'N'",
        ),
        builder: (x, ODataResult snap) {
          ODataDocuments d = snap.data;
          print(['dados', snap.hasData, d.length]);
          if (!snap.hasData) return Container();
          return ApplienceTile.panel(
            width: 180,
            color: Colors.blue.withAlpha(100),
            image: Icon(Icons.person),
            title: 'Grupos',
            value: d.first['conta'].toString(),
          );
        });
  }

  @override
  void register() {
    WidgetItem item = WidgetItem(
        title: 'Grupos',
        color: Colors.blue,
        active: true,
        build: (ctx) => GruposProdutosWidget().builder(ctx));
    return WidgetData().headers.add(item);
  }
}
