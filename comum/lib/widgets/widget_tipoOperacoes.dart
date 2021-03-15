import 'package:controls_dash/controls_dash.dart';
import 'widget_data.dart';
import 'widgets_base.dart';
import 'package:flutter/material.dart';
import 'package:controls_data/odata_client.dart';

class SaidasPorTiposChart extends WidgetBase {
  final String keyOutrasContas = 'dash_conta_outras_contas';
  final String keyVariaveis = "dash_conta_despesas_variaveis";
  final String keyFornec = "dash_conta_fornec";
  final String keyFixas = "dash_conta_fixas";
  @override
  register() {
    // registrar na lista de widgets
    var item = WidgetItem(
        id: '201911270736',
        title: 'Movimento por tipo de saídas',
        chartTitle: 'Movimentação',
        active: true,
        build: (context) {
          return builder(context);
        });
    return WidgetData().add(item);
  }

  @override
  Widget demo() {
    return DashBarChart.withSampleData();
  }

  @override
  Widget builder(context) {
    return ODataBuilder(
        query: ODataQuery(
          resource: 'sigflu',
          select: "sum(case when codigo between '300' and '399' then 1 else 0 end) outras, " +
              "sum(case when codigo between '400' and '599' then 1 else 0 end) variaveis, " +
              "sum(case when codigo ge '600' then 1 else 0 end) fixas, " +
              "sum(case when codigo between '200' and '229' then 1 else 0 end) fornec " +
              "",
          filter: "data eq 'today' ",
        ),
        initialData: {
          "outras": getKey(keyOutrasContas) ?? 0,
          "variaveis": getKey(keyVariaveis) ?? 0,
          "fornec": getKey(keyFornec) ?? 0,
          "fixas": getKey(keyFixas) ?? 0,
        },
        builder: (context, snap) {
          var docs = snap.data.docs;
          var doc = docs[0];
          var outras = (docs.length > 0) ? doc['outras'] : 0;
          var variaveis = (docs.length > 0) ? doc['variaveis'] : 0;
          var fornec = (docs.length > 0) ? doc['fornec'] : 0;
          var fixas = (docs.length > 0) ? doc['fixas'] : 0;
          return Container(
              child: DashBarChart(DashPieChart.createSerie(
            data: [
              ChartPair('fornec', setKey('keyFornec', fornec)),
              ChartPair('vars', setKey(keyVariaveis, variaveis)),
              ChartPair('fixas', setKey(keyFixas, fixas)),
              ChartPair('outras', setKey(keyOutrasContas, outras)),
            ],
            id: 'Movimento',
          )));
        });
  }
}
