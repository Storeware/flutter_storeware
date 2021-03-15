import 'package:controls_dash/controls_dash.dart';
import 'widget_data.dart';
import 'widgets_base.dart';
import 'package:flutter/material.dart';
import 'package:controls_data/odata_client.dart';

class TitulosDoDiaChart extends WidgetBase {
  @override
  register() {
    // registrar na lista de widgets
    var item = WidgetItem(
        id: '201911270735',
        title: 'A Titulos do dia',
        chartTitle: 'Títulos',
        active: true,
        build: (context) {
          return builder(context);
        });
    return WidgetData().add(item);
  }

  @override
  Widget demo() {
    /// dados estaticos
    return DashDanutChart(DashDanutChart.createSerie(
      // showValues: true,
      data: [
        ChartPair('Entradas', 20),
        ChartPair('Saídas', 2),
      ],
      id: '1',
    ));
  }

  final String keyEntrada = 'dash_conta_entrada';
  final String keySaida = 'dash_conta_entrada';
  @override
  Widget builder(context) {
    //var size = MediaQuery.of(context).size;
    return ODataBuilder(
        query: ODataQuery(
          resource: 'sigflu',
          select: "sum(case when codigo lt '200' then 1 else 0 end) entrada, " +
              "sum(case when codigo ge '200' then 1 else 0 end) saida",
          filter: "data eq 'today' ",
          //groupby: 'codigo',
        ),
        initialData: {
          "entrada": getKey(keyEntrada) ?? 0,
          "saida": getKey(keySaida) ?? 0
        },
        builder: (context, ODataResult snapshot) {
          var entrada = 0.0;
          var saida = 0.0;
          if (snapshot.hasData) {
            // print(['hasData', snapshot.data.docs[0].data()]);

            var dados = snapshot.data.docs[0].data();
            entrada = (dados['entrada'] ?? 0);
            saida = (dados['saida'] ?? 0);
          }
          return DashHorizontalBarChart(
            DashHorizontalBarChart.createSerie(
              data: [
                ChartPair('Entradas', setKey(keyEntrada, entrada)),
                ChartPair('Saídas', setKey(keySaida, saida)),
              ],
              id: '',
            ),
            showValues: false,
          );
        });
  }
}
