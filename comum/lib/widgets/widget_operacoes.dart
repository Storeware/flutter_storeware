import 'package:controls_web/controls/home_elements.dart';
import 'widget_data.dart';
import 'widgets_base.dart';
import 'package:flutter/material.dart';
import 'package:controls_data/odata_client.dart';

class BoxCadastrosOperacoesCount extends WidgetBase {
  @override
  register() {
    // registrar na lista de widgets
    var item = WidgetItem(
        id: '201911272325',
        title: 'Contagem de Operações Cadastrada',
        chartTitle: 'Operações',
        active: true,
        build: (context) {
          return builder(context);
        });
    return WidgetData().headers.add(item);
  }

  @override
  Widget demo() {
    return Container(width: 120, color: Colors.amber);
  }

  @override
  Widget builder(context) {
    return ODataBuilder(
        query: ODataQuery(
          resource: 'sig01',
          select: 'count(*) conta',
          filter: "inativo eq 'N'",
        ),
        initialData: {"conta": getKey('dash_operacoes') ?? 0},
        builder: (ctx, ODataResult rst) {
          if (!rst.hasData) return Container();
          return ApplienceTile.panel(
            width: 150,
            image: Icon(Icons.bookmark, color: Colors.white),
            color: Colors.amber,
            title: 'Ctas Operação',
            value:
                setKey('dash_operacoes', rst.data.docs[0]['conta'].toString()),
          );
        });
  }
}
