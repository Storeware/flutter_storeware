// @dart=2.12

import 'dart:async';

//import 'package:controls_data/odata_client.dart' show ODataDocument;
import 'package:controls_web/controls/data_viewer.dart';
import 'package:console/views/agenda/models/agenda_item_model.dart';
import 'package:console/views/agenda/models/agenda_model.dart';
import 'package:flutter/material.dart';
//import 'package:controls_data/odata_client.dart';
import 'package:controls_extensions/extensions.dart';

import '../agenda_controller.dart';
import '../agenda_notifier.dart';
import '../agenda_resource.dart';

class ListarAgendaDataRosource extends StatefulWidget {
  final DateTime? de;
  final DateTime? ate;
  final String? resource;
  final String? title;
  final bool? canEdit;
  final bool? canInsert;
  final AgendaController? agendaController;
  final DefaultSourceList list;

  ListarAgendaDataRosource(
      {Key? key,
      this.de,
      this.ate,
      this.resource,
      this.title,
      required this.agendaController,
      this.canEdit = true,
      this.canInsert = false,
      required this.list})
      : super(key: key);

  @override
  _ListarAgendaHoraState createState() => _ListarAgendaHoraState();
}

class _ListarAgendaHoraState extends State<ListarAgendaDataRosource> {
  DataViewerController? controller;

  late StreamSubscription rowsChanged;
  String? editingGid;
  @override
  void initState() {
    super.initState();

    /// recebe evento da agenda indicando que mudou o registro;
    rowsChanged = AgendaItemChangedNotifier().listen((item) {
      AgendaResource? resource =
          widget.agendaController!.resourceFind(item.item!.recursoGid);
      var row = item.item!.toJson();
      row['nome'] = resource?.label ?? '';

      /// altrea somente no grid, não na tabela.
      /// a alteração na tabela é feito pelo controller da agenda;
      switch (item.event) {
        case AgendaPostEvent.delete:
          controller!.paginatedController.removeByKey('gid', row);
          controller!.paginatedController.changed(true);
          break;
        case AgendaPostEvent.insert:
          controller!.paginatedController.add(row);
          controller!.paginatedController.changed(true);
          break;
        case AgendaPostEvent.update:
          controller!.paginatedController.changeTo('gid', row['gid'], row);
          controller!.paginatedController.changed(true);
          break;
        default:
      }
    });
    String filter = (widget.resource != null)
        ? "a.recurso_gid eq '${widget.resource}' and"
        : '';
    controller = DataViewerController(
      keyName: 'gid',
      future: () => AgendaItemModel().listNoCached(
        resource: 'agenda a',
        join: 'join agenda_recurso b on (b.gid=a.recurso_gid)',
        select: 'a.gid, a.datainicio,a.datafim,a.titulo,a.texto,b.nome',
        filter:
            "$filter  a.datainicio le '${widget.ate!.toDateTimeSql()}' and a.datafim ge '${widget.de!.toDateTimeSql()}' ",
      ),
    );
  }

  @override
  void dispose() {
    rowsChanged.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String maskDe = (widget.de!.hours > 0) ? 'dd/MMMM H:mm' : 'dd/MMMM';
    String maskAte = 'dd/MMMM H:mm';

    return Scaffold(
      appBar: AppBar(
          title: Text(
              '${widget.title ?? 'Período'} ${widget.de!.format(maskDe)} até  ${widget.ate!.format(maskAte)}')),
      floatingActionButton: widget.canInsert!
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                DateTime d = DateTime.now();
                widget.agendaController!.onInsert!(AgendaData(
                  controller: widget.agendaController,
                  date: d,
                  hour: d.hours,
                  sources: widget.list,
                  //sources: widget.agendaController.sources,
                ));
              },
            )
          : null,
      body: DataViewer(
          controller: controller,
          rowsPerPage: 10,
          canSearch: false,
          showPageNavigatorButtons: false,
          canEdit: widget.canEdit!,
          canInsert: widget.canInsert!,
          onEditItem: (ctrl) {
            // print('onEditItem');
            var gid = ctrl.data!['gid'];
            return AgendaItemModel()
                .getOne(filter: "gid eq '$gid' ")
                .then((rsp) {
              AgendaItem item = AgendaItem.fromJson(rsp!, zone: -3);
              return widget.agendaController!.onEdit!(AgendaData(
                item: item,
                date: item.datainicio,
                controller: widget.agendaController,
                resource: item.recursoGid,
                hour: item.datainicio!.hours,
                sources: widget.list,
                parentContext: context,
              ));
            });
          },
          columns: [
            DataViewerColumn(name: 'nome'),
            DataViewerColumn(
                name: 'datainicio',
                label: 'Início',
                onGetValue: (x) {
                  DateTime d = toDateTime(x);
                  return d.format('dd/MM/y k:mm').toString();
                }),
            DataViewerColumn(
                name: 'datafim',
                label: 'Término',
                onGetValue: (x) {
                  DateTime d = toDateTime(x);
                  return d.format('dd/MM/y k:mm').toString();
                }),
            DataViewerColumn(
              name: 'titulo',
              label: 'Título',
              maxLines: 2,
            ),
            DataViewerColumn(
              name: 'texto',
              maxLines: 3,
            ),
          ]),
    );
  }
}
