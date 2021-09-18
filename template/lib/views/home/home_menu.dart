// @dart=2.12

//import 'package:controls_web/controls/tab_choice.dart';
import 'package:console/views/cadastros/clientes/cadastro_clientes.dart';
//import 'package:console/views/dashboard/dashboard_view.dart' as dv;
//import 'package:console/views/estoque/estoque_view.dart';
import 'package:flutter/material.dart';
import 'package:controls_web/controls.dart';
import 'package:gestor/views/clientes/clientes_gestao_view.dart';
import 'package:gestor/views/estatisticas/estatisticas_gestao_view.dart';
import 'package:gestor/views/estocagem/estocagem_gestor_view.dart';
import 'package:gestor/views/pedidos/pedidos_gestor_view.dart';
import 'package:gestor/views/vendas/vendas_gestor_view.dart';
import 'package:gestor/views/financeiro/financeiro_gestor_view.dart';

//import '../pedidos/pedidos_view.dart';

class HomeMenu {
  static List<TabChoice> generate() {
    return [
      TabChoice(
          image: Image.asset('assets/nav/vendas.png'),
          label: 'Vendas',
          color: Color(0xFF00CEC9),
          builder: () {
            return VendasGetstorView();
            //return PainelView();
            //return DashMaisCurtidos()
          }),
      TabChoice(
          image: Image.asset('assets/nav/estatisticas.png'),
          label: 'Estatísticas',
          color: Color(0xFF5AB083),
          builder: () {
            return EstatisticasGestaoView();
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
            return EstocagemGestorView();
          }),
      TabChoice(
          image: Image.asset('assets/nav/clientes.png'),
          label: 'Clientes',
          primary: true,
          color: Color(0xFFFFC97E),
          builder: () {
            return ClientesGestaoView();
          }),
      TabChoice(
          image: Image.asset('assets/nav/financeiro.png'),
          label: 'Financeiro',
          primary: true,
          color: Color(0xFFFA6E5A),
          builder: () {
            return FinanceiroGestorView(); // FinancasView();
          }),
      TabChoice(
          image: Image.asset('assets/nav/pedidos.png'),
          label: 'Pedidos',
          color: Color(0xffF25386),
          builder: () {
            return PedidosGestorView();
          }),
    ];
  }
}
