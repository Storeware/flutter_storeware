import 'package:controls_web/controls/home_elements.dart';
import 'widget_data.dart';
import 'widgets_base.dart';
import 'package:flutter/material.dart';
import 'package:controls_data/odata_client.dart';

class BoxCadastrosClientesCount extends WidgetBase {
  @override
  register() {
    // registrar na lista de widgets
    var item = WidgetItem(
        id: '201911272325',
        title: 'Conta Cadastro de pessoas',
        chartTitle: 'Clientes',
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
          resource: 'sigcad',
          select: 'count(*) conta',
          filter: "tipo eq 'CLIENTE' ",
        ),
        initialData: {"conta": getKey('dash_clientes') ?? 0},
        builder: (ctx, ODataResult rst) {
          if (!rst.hasData) return Container();
          String d = rst.data.docs[0]['conta'].toString();
          return ApplienceTile.panel(
            width: 150,
            image: Icon(Icons.recent_actors, color: Colors.white),
            color: Colors.amber,
            title: 'Clientes',
            value: setKey('dash_clientes', d),
          );
        });
  }
}
