import 'package:comum/widgets/widget_data.dart';
import 'package:comum/widgets/widgets_base.dart';
import 'package:controls_web/controls/home_elements.dart';
import 'package:flutter/material.dart';

import 'package:controls_data/data.dart';

class ProdutosCountWidget extends WidgetBase {
  @override
  Widget builder(context) {
    return ODataBuilder(
        query: ODataQuery(
            resource: 'wba_ctprod',
            select: 'count(*) conta',
            filter: "inativo eq 'N'"),
        builder: (x, snap) {
          if (!snap.hasData) return Container();
          return ApplienceTile.panel(
            width: 120,
            color: Colors.amber,
            image: Icon(Icons.person),
            title: 'Produtos',
            value: snap.data.first['conta'].toString(),
          );
        });
  }

  @override
  void register() {
    WidgetItem item = WidgetItem(
        title: 'Produtos',
        color: Colors.amber,
        build: (ctx) => ProdutosCountWidget().builder(ctx));
    return WidgetData().items.add(item);
  }
}
