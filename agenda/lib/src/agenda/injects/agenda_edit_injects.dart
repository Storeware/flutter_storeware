// @dart=2.12

import 'package:console/config/config.dart';
import 'package:controls_web/controls/injects.dart';
import 'package:flutter/material.dart';
import 'package:models/builders.dart';
import 'package:models/models.dart';

import '../models/index.dart';
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
            onSearch: (x) {
              Map<String, dynamic>? y;
              return Dialogs.showPage(context,
                  child: CadastroClientePage(
                      title: widget.label ?? 'Parceiros',
                      //canEdit: widget.canInsert,
                      canInsert: widget.canInsert,
                      //todas: false,
                      onLoaded: (rows) {
                        addSuggestions.value = rows;
                      },
                      onSelected: (x) async {
                        y = x;
                        return x['codigo'];
                      })).then((rsp) {
                return y;
              });
            },
          );
        }));
  }
}
