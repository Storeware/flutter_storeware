// @dart=2.12
import 'package:controls_data/data.dart';
//import 'package:controls_data/local_storage.dart';
import 'package:controls_web/controls/color_picker.dart';
import 'package:controls_web/controls/dialogs_widgets.dart';
import 'package:controls_web/controls/injects.dart';
import 'package:controls_web/controls/responsive.dart';
import 'package:flutter_storeware/login.dart';
import 'agenda_resource.dart';
import 'models/agenda_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'agenda_controller.dart';
import 'agenda_edit.dart';
import 'agenda_notifier.dart';
import 'agenda_page.dart';
import 'models/agenda_config.dart';
import 'models/agenda_item_model.dart';
import 'models/agenda_recurso_model.dart';
import 'package:controls_extensions/extensions.dart' as ext;

import 'models/agenda_tipo_model.dart';
import 'relatorios/listar_agenda_data_resource.dart';

class AgendaView extends StatefulWidget {
  static get route => '/agenda';

  /// data base da agenda
  final String? title;
  final DateTime? date;
  final DateTime? dateEnd;
  final String? resourceId;
  final String? estadoId;
  final bool automaticallyImplyLeading;
  final AgendaViewerType? viewerType;

  /// permite inserir novos widget para edição dos dados;
  /// exemplo: identificação de animal;
  final Widget? editExtended;

  /// inserir header na edição dos dados;
  final Widget? editHeader;

  /// inserir bottom na edição de dados
  final Widget? editBottom;
  final String? agendaGid;
  const AgendaView(
      {Key? key,
      this.title,
      this.agendaGid,
      this.date,
      this.dateEnd,
      this.viewerType,
      this.automaticallyImplyLeading = true,
      this.estadoId,
      this.editExtended,
      this.editHeader,
      this.editBottom,
      this.resourceId})
      : super(key: key);

  @override
  _AgendaViewState createState() => _AgendaViewState();

  static edit(String? gid) {
    return AgendaView(
      agendaGid: gid,
    );
  }
}

class _AgendaViewState extends State<AgendaView> {
  AgendaController? controller;
  DateTime? data;
  late ResponsiveInfo responsive;
  double height = 650;

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    /// lembra a ultima agenda visualizada;
    String agendaAtiva = LocalStorage().getString('ultima_agenda_ativa') ??
        AgendaViewerType.horario.toString();
    AgendaViewerType? viewType = AgendaViewerType.horario;
    for (var item in AgendaViewerType.values) {
      if (agendaAtiva == item.toString()) {
        viewType = item;
      }
    }
    AgendaConfig().fromMap(configInstance!.configDados);
    // print([AgendaConfig().toJson(), configInstance!.configDados]);
    controller = AgendaController(
        viewer: widget.viewerType ?? viewType ?? AgendaViewerType.horario,
        future: () {
          //print([controller.de, controller.ate]);
          String filter = '';
          if (widget.resourceId != null) {
            filter += " and a.recurso_gid = '${widget.resourceId}' ";
          }
          if (widget.estadoId != null) {
            filter += " and a.estado_gid = '${widget.estadoId}' ";
          }
          return AgendaItemModel()
              .listAgenda(
            filter: "("
                "(a.datainicio between '${controller!.de}' and '${controller!.ate}') or "
                "a.datainicio le '${controller!.ate}' and a.datafim ge '${controller!.de}') $filter ",
            //top: 250
          )
              .then((item) {
            return item;
          });
        },
        onInsert: (AgendaData data) {
          data.item = AgendaItem.fromJson({})
            ..gid = const Uuid().v4()
            ..estadoGid = '1'
            ..recursoGid = data.resource
            ..completada = 0
            ..datainicio = data.date;
          //print(data.item.toJson());
          Dialogs.showPage(
            context,
            width: 500,
            height: height,
            child: AgendaEdit(
              controller: controller,
              interval: data.interval,
              event: AgendaPostEvent.insert,
              title: 'Nova agenda',
              header: widget.editHeader,
              bottom: widget.editBottom,
              extendBuilder: widget.editExtended,
              data: data, //.copyWith(parentContext: context),
              item: data.item,
            ),
          );
        },
        onEdit: (AgendaData data) {
          Dialogs.showPage(
            context,
            width: 500,
            height: height,
            child: AgendaEdit(
              controller: controller,
              item: data.item,
              event: AgendaPostEvent.update,
              canDelete: false,
              title: 'Alteração',
              header: widget.editHeader,
              bottom: widget.editBottom,
              extendBuilder: widget.editExtended,
              data: data.copyWith(parentContext: context),
            ),
          );
        },
        onPostItem: (item, event) async {
          try {
            var mp = item!.toJson();
            if (event == AgendaPostEvent.insert) {
              return AgendaItemModel().post(mp).then((rsp) => mp);
            }
            if (event == AgendaPostEvent.update) {
              return AgendaItemModel().put(mp).then((rsp) => mp);
            }
            if (event == AgendaPostEvent.delete) {
              var rsp = InjectBuilder.builderAsync(
                      context, 'DeleteObjetoDoServico', item) ??
                  Future.value({});
              return rsp.then((rsp) {
                return AgendaItemModel()
                    .delete(item.toJson())
                    .then((rsp) => mp);
              });
            }
          } finally {
            // AgendaItemModel().webHookSend(); // despacha itens na fila;
          }
          return null;
        },
        onListHour: (DefaultSourceList? list, DateTime? dt, int hr) {
          DateTime de = dt!.startOfHour(hr);
          DateTime ate = dt.endOfHour(hr);
          Dialogs.showPage(context,
              child: ListarAgendaDataRosource(
                  agendaController: controller,
                  title: 'Horário ',
                  canInsert: responsive.isMobile,
                  canEdit: responsive.isMobile,
                  de: de,
                  list: list!,
                  ate: ate));
        },
        onListDates: (DefaultSourceList list, de, ate) {
          Dialogs.showPage(context,
              child: ListarAgendaDataRosource(
                  agendaController: controller,
                  title: 'Período ',
                  canInsert: responsive.isMobile,
                  canEdit: responsive.isMobile,
                  de: de,
                  list: list,
                  ate: ate));
        },
        onListResource: (DefaultSourceList list, de, ate, resource) {
          Dialogs.showPage(context,
              child: ListarAgendaDataRosource(
                  agendaController: controller,
                  canInsert: responsive.isMobile,
                  canEdit: responsive.isMobile,
                  de: de,
                  list: list,
                  ate: ate,
                  resource: resource));
        });
    data = widget.date ?? DateTime.now();
    controller!.data = data;
    controller!.de = data;
    controller!.ate = widget.dateEnd;
    AgendaTipoItemModel().list().then((tipos) {
      controller!.tipos.clear();
      controller!.tipos.addAll(tipos);
    });
    super.initState();
  }

  edit(gid) {
    return FutureBuilder<dynamic>(
        future: AgendaItemModel().getOne(filter: "gid eq '$gid'"),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();
          controller!.sources = [AgendaItem.fromJson(snapshot.data)];
          AgendaItem item = AgendaItem.fromJson(snapshot.data);
          AgendaData data = AgendaData(
            controller: controller,
            sources: DefaultSourceList(sources: controller!.sources),
            item: item,
            date: item.datainicio,
            resource: item.recursoGid,
            interval: item.difMinutes,
            hour: item.datainicio!.hour + (item.datainicio!.minute / 60),
          );
          return AgendaEdit(
            controller: controller,
            item: data.item,
            event: AgendaPostEvent.update,
            canDelete: false,
            title: 'Alteração',
            header: widget.editHeader,
            bottom: widget.editBottom,
            extendBuilder: widget.editExtended,
            data: data,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    responsive = ResponsiveInfo(context);
    if (responsive.size.height > height) height = responsive.size.height * 0.9;
    if (responsive.size.height < height) height = responsive.size.height * 0.99;

    Size size = MediaQuery.of(context).size;
    controller!.size.withSize(size);
    controller!.size.widthExpand((responsive.isSmall
            ? 50.0
            : responsive.isMobile
                ? 150.0
                : 280.0) *
        -1);

    return (widget.agendaGid != null)
        ? edit(widget.agendaGid)
        : Scaffold(
            appBar: (widget.title != null)
                ? AppBar(
                    automaticallyImplyLeading: widget.automaticallyImplyLeading,
                    title: Text(widget.title!))
                : null,
            body: ResponsiveBuilder(
              //context: context,
              builder: (a, b) => StreamBuilder<dynamic>(
                stream: AgendaResourceNotifyChanged().stream,
                builder: (context, snapshot) {
                  return FutureBuilder<dynamic>(
                      future: AgendaRecursoItemModel().listNoCached(
                          filter: "inativo eq 'N'", orderBy: 'ordem'),
                      builder: (context, resources) {
                        if (!resources.hasData) {
                          return const Align(
                              child: CircularProgressIndicator());
                        }
                        controller!.resources.clear();
                        for (var i = 0; i < resources.data.length; i++) {
                          controller!.resources.add(AgendaResource(
                              intervalo:
                                  toDouble(resources.data[i]['intervalo']),
                              gid: resources.data[i]['gid'],
                              color: ColorExtension.intRGBToColor(
                                  resources.data[i]['cor']),
                              label: resources.data[i]['nome']));
                        }
                        controller!.data = data;
                        /*return ChangeNotifierProvider.value(
                    value: controller.sourceNotifier,
                    child:*/
                        return ChangeNotifierProvider.value(
                          value: controller!.dataNotifier,
                          child: AgendaPage(
                              automaticallyImplyLeading:
                                  widget.automaticallyImplyLeading,
                              title: widget.title,
                              data: controller!.data,
                              controller: controller),
                        );
                        //);
                      });
                },
              ),
            ),
          );
  }
}
