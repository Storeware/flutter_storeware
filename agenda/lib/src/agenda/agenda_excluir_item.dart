// @dart=2.12

import 'package:controls_web/controls/dialogs_widgets.dart';
import 'package:controls_web/controls/strap_widgets.dart';
import 'package:flutter/material.dart';

import 'agenda_controller.dart';
import 'models/agenda_item_model.dart';
import 'package:controls_extensions/extensions.dart';

class AgendaDialogs {
  static excluirItem(BuildContext context, AgendaController? controller,
      AgendaItem item) async {
    bool result = false;
    return Dialogs.showModal(context,
        title: 'Excluír o item ?',
        width: 400,
        height: 300,
        child: Center(
            child: Column(children: [
          const SizedBox(
            height: 20,
          ),
          Text(item.titulo!,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(
            height: 10,
          ),
          Text(item.texto!,
              style: const TextStyle(fontStyle: FontStyle.italic)),
          const SizedBox(
            height: 10,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
                'Início: ${item.datainicio!.format('dd, MMMM:   hh:mm', 'pt-BR')}    à    ${item.datafim!.format('hh:mm')}')
          ]),
          const SizedBox(
            height: 20,
          ),
          //Text('Excluir o item ?'),
          const SizedBox(
            height: 20,
          ),
          const Divider(),
        ])),
        bottom: Center(
          child: StrapButton(
              text: 'Sim',
              onPressed: () {
                controller!.delete(item).then((rsp) {
                  result = true;
                  Navigator.of(context).pop();
                });
              }),
        )).then((rsp) => result);
  }
}
