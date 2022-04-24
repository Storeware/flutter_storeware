// @dart=2.12

import 'package:controls_web/controls/color_picker.dart';
import 'package:controls_web/controls/data_viewer.dart';
import 'package:controls_web/controls/data_viewer_helper.dart';
import 'package:flutter_storeware/login.dart';
import '../models/agenda_estado_model.dart';
import 'package:flutter/material.dart';

/// [class]
class AgendaEstadoView extends StatefulWidget {
  const AgendaEstadoView({Key? key}) : super(key: key);

  @override
  _AgendaEstadoViewState createState() => _AgendaEstadoViewState();
}

class _AgendaEstadoViewState extends State<AgendaEstadoView> {
  DataViewerController? controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text('Estados da Agenda')),
      body: DataViewer(
        canInsert: true,
        canEdit: true,
        canDelete: true,
        showPageNavigatorButtons: false,
        canSearch: false,
        onSaved: (x) {
          AgendaReloadNotifier().notify('alterado cadastro estado da agenda');
        },
        controller: controller ??= DataViewerController(
            onValidate: (x) {
              return sprint(AgendaEstadoItem.fromJson(x).toJson());
            },
            future: () => AgendaEstadoItemModel().listNoCached(),
            dataSource: AgendaEstadoItemModel(),
            keyName: 'gid'),
        columns: [
          DataViewerColumn(name: 'gid', label: 'ID', isPrimaryKey: true),
          DataViewerColumn(name: 'nome'),
          DataViewerHelper.simnaoColumn(DataViewerColumn(name: 'encerrado')),
          DataViewerHelper.simnaoColumn(DataViewerColumn(name: 'inativo')),
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
                  //  print(c.toRGB());
                  row['cor'] = c.toRGB();
                },
              );
            },
          ),
        ],
        beforeShow: (ctrl) {
          /// redefine atributos para as colunas
          /*if (ctrl is PaginatedGridController) {
            DataViewerHelper.simnaoColumn(ctrl.findColumn('encerrado'));
            DataViewerHelper.simnaoColumn(ctrl.findColumn('inativo'));
          }*/
        },
      ),
    );
  }
}

sprint(value) {
  print(value);
  return value;
}
