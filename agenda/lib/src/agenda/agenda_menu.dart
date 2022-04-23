// @dart=2.12

import 'package:console/config/config.dart';
import 'package:controls_web/controls/menu_dialogs.dart';
import 'package:flutter/material.dart';

import 'cadastros/cadastro_agenda_estado_page.dart';
import 'cadastros/cadastro_agenda_tipo_page.dart';
import 'cadastros/cadastro_resources_page.dart';
import 'package:models/models.dart';

class AgendaMenu {
  static show(context) {
    final choices = [
      MenuChoice(
        index: 0,
        width: 450,
        height: 550,
        enabled: Acessos.habilitado(acesso_Agenda_Recurso),
        title: 'Cadastro de Recursos',
        icon: Icons.group,
        builder: (cxt) => CadastroAgendaRecursosPage(),
      ),
      MenuChoice(
        index: 1,
        width: 450,
        height: 550,
        enabled: Acessos.habilitado(acesso_Agenda_Tipo),
        title: 'Cadastro de Tipos de Agenda',
        icon: Icons.settings,
        builder: (cxt) => CadastroAgendaTipoPage(),
      ),
      MenuChoice(
        index: 2,
        width: 450,
        height: 550,
        title: 'Cadastro de Estados da Agenda',
        enabled: Acessos.habilitado(acesso_Agenda_Estado),
        icon: Icons.chevron_right,
        builder: (ctx) => const AgendaEstadoView(),
      )
    ];
    return MenuDialog.show(context,
        title: 'Menu',
        width: 350,
        height: kToolbarHeight * (choices.length + 1),
        choices: choices);
  }
}
