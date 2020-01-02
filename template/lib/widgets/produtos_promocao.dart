import 'package:comum/widgets/widget_data.dart';
import 'package:comum/widgets/widgets_base.dart';
import 'package:controls_web/controls/home_elements.dart';
import 'package:flutter/material.dart';

import 'package:controls_data/data.dart';

import '../config/config.dart';

class ProdutosPromocaoWidget extends WidgetBase {
  @override
  Widget builder(context) {
    int filial = ConfigApp().filial;
    return ODataBuilder(
        query: ODataQuery(
            resource: 'WBA_CTPROD_FILIAL_PROMOCAO',
            select: 'count(*) conta',
            filter:
                "filial eq $filial and promdtini le 'now' and promdtfim ge 'now' "),
        builder: (x, snap) {
          if (!snap.hasData) return Container();
          return ApplienceTile.panel(
            color: Colors.amber,
            width: 120,
            image: Icon(Icons.person),
            title: 'Promoções',
            value: snap.data.first['conta'].toString(),
          );
        });
  }

  @override
  void register() {
    WidgetItem item = WidgetItem(
        title: 'Promoções Produto',
        color: Colors.amber,
        build: (ctx) => ProdutosPromocaoWidget().builder(ctx));
    return WidgetData().headers.add(item);
  }
}
