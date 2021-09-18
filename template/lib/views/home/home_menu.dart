// @dart=2.12

import 'package:flutter/material.dart';
import 'package:controls_web/controls.dart';

//import '../pedidos/pedidos_view.dart';

class HomeMenu {
  static List<TabChoice> generate() {
    return [
      TabChoice(
          image: Image.asset('assets/nav/vendas.png'),
          label: 'Vendas',
          color: Color(0xFF00CEC9),
          builder: () {
            return Container();
            //VendasGetstorView();
            //return PainelView();
            //return DashMaisCurtidos()
          }),
      TabChoice(
          image: Image.asset('assets/nav/estatisticas.png'),
          label: 'Estatísticas',
          color: Color(0xFF5AB083),
          builder: () {
            return Container();
            //EstatisticasGestaoView();
            //return dv.DashboardView(
            //  tarefas: false,
            //  showDrawer: false,
            //);
          }),
      TabChoice(
          image: Image.asset('assets/nav/estocagem.png'),
          label: 'Estocagem',
          color: Color(0xff747EEE),
          primary: true,
          builder: () {
            return Container(); // EstocagemGestorView();
          }),
      TabChoice(
          image: Image.asset('assets/nav/clientes.png'),
          label: 'Clientes',
          primary: true,
          color: Color(0xFFFFC97E),
          builder: () {
            return Container(); //ClientesGestaoView();
          }),
    ];
  }
}
