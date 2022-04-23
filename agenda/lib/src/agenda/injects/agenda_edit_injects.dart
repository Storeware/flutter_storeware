// @dart=2.12

import 'package:console/builders/sigcad_search_form_field.dart';
import 'package:console/config/config.dart';
import 'package:console/views/agenda/models/agenda_item_model.dart';
import 'package:controls_web/controls/injects.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

import 'constantes.dart';

class InjectsAgendaContato {
  static register(BuildContext context) {
    var injects = InjectBuilder.of(context)!;
    injects.register(InjectItem(
        name: 'AgendaEditHeader', // nao mudar o nome
        builder: (x, dados) {
          return SigcadSearchFormField(
            label: labelContatoAgenda,
            codigo: dados.sigcadCodigo,
            canClear: true,
            onChanged: (codigo) {
              dados.sigcadCodigo = codigo;
              SigcadItemModel().buscarByCodigo(codigo!).then((rsp) {
                if (dados is AgendaItem) {
                  dados.nomeCliente = rsp['nome'] ?? '';
                  HistoricoItemModel.registerLGPD(
                    codigoPessoa: codigo,
                    titulo: 'Acesso para agendamento',
                    info: 'Visualização dos dados para agenda(${dados.titulo})',
                    origem: 'Agenda',
                    usuario: configInstance!.usuario,
                    origemGid: dados.gid,
                  );
                }
              });
            },
          );
        }));
  }
}
