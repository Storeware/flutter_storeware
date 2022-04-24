// @dart=2.12

import 'package:console/config/config.dart';
import 'package:controls_web/controls/color_picker.dart';
import 'package:controls_web/controls/data_viewer.dart';
import 'package:controls_web/controls/data_viewer_helper.dart';
//import 'package:console/comum/controls.dart';
import '../models/agenda_tipo_model.dart';
import 'package:flutter/material.dart';

class CadastroAgendaTipoPage extends StatefulWidget {
  static final route = '/estados';
  CadastroAgendaTipoPage({Key? key}) : super(key: key);

  @override
  _CadastroEstadosPedidoViewState createState() =>
      _CadastroEstadosPedidoViewState();
}

class _CadastroEstadosPedidoViewState extends State<CadastroAgendaTipoPage> {
  @override
  void dispose() {
    super.dispose();
  }

  DataViewerController? controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text('Cadastro de Tipo de Agenda')),
      bottomNavigationBar: SizedBox(
        height: 50,
      ),
      body: DataViewer(
          showPageNavigatorButtons: false,
          canSearch: false,
          crossAxisAlignment: CrossAxisAlignment.center,
          onSaved: (x) {
            AgendaTipoItemModel().clearCache();
            AgendaReloadNotifier().notify('alterado cadastro tipo de agenda');
          },
          controller: controller ??= DataViewerController(
              keyName: 'gid',
              dataSource: AgendaTipoItemModel(),
              future: () => AgendaTipoItemModel().listNoCached(),
              onValidate: (row) {
                return AgendaTipoItem.fromJson(row).toJson();
              }),
          canEdit: true,
          canDelete: true,
          canInsert: true,
          columns: [
            DataViewerColumn(
              name: 'nome',
            ),
            DataViewerHelper.simnaoColumn(
                DataViewerColumn(
                  name: 'requercontato',
                  label: 'Exige Contato',
                ),
                trueValue: 'S',
                falseValue: 'N'),
            DataViewerHelper.simnaoColumn(
                DataViewerColumn(
                  name: 'inativo',
                ),
                falseValue: 'N',
                trueValue: 'S'),
            DataViewerColumn(
              name: 'cor',
              builder: (idx, Map<String, dynamic> row) {
                Color cor = ColorExtension.hexToARGB(row['cor'], Colors.blue);
                row['cor'] ??= cor.toRGB();
                return ColorPickerField(
                  color: cor,
                );
              },
              editBuilder: (a, b, item, row) {
                Color cor = ColorExtension.hexToARGB(row['cor'], Colors.blue);
                row['cor'] ??= cor.toRGB();
                return ColorPickerField(
                  color: cor,
                  onChanged: (c) {
                    row['cor'] = c.toRGB();
                  },
                );
              },
            ),
          ]),
    );
  }
}
