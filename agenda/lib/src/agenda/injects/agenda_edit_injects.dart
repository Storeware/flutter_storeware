// @dart=2.12

import 'package:flutter/material.dart';
import 'package:flutter_storeware/index.dart';
import 'package:flutter_storeware/login.dart';
import 'package:models/builders/index.dart';
import 'package:models/models.dart';
import 'package:views/index.dart';

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
            onNew: (_, row) async {
              return ClienteController.doNovoCadastro(context, row,
                      onChanged: (row) {})
                  .then((r) {
                return r;
              });
            },
            onSearch: (x) async {
              Map<String, dynamic>? y;
              var rsp = await Dialogs.showPage(context,
                  child: CadastroClientePage(
                      title: 'Parceiros',
                      //canEdit: widget.canInsert,
                      canInsert: true,
                      //todas: false,
                      onLoaded: (rows) {
                        //addSuggestions.value = rows;
                      },
                      onSelected: (x) async {
                        y = x;
                        return x['codigo'];
                      })).then((r) => y);
              return rsp ?? {};
            },
          );
        }));
  }
}
