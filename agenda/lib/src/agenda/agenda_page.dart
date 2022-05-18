// @dart=2.12
import 'dart:async';

import 'package:controls_web/controls/ink_button.dart';
import 'package:controls_data/local_storage.dart';
import 'package:controls_web/controls/responsive.dart';
import 'const_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'agenda_const.dart';
import 'agenda_controller.dart';
import 'agenda_menu.dart';
import 'agenda_resource.dart';
import 'agenda_viewer_diaria_page.dart';
import 'agenda_viewer_mensal_page.dart';
import 'agenda_viewer_mobile.dart';
import 'agenda_viewer_semanal_page.dart';
import 'models/agenda_item_model.dart';
import 'package:comum/socketio/index.dart';

class AgendaPage extends StatefulWidget {
  final AgendaController? controller;
  final DateTime? data;
  final String? title;
  final bool automaticallyImplyLeading;

  const AgendaPage({
    Key? key,
    this.controller,
    this.automaticallyImplyLeading = true,
    this.data,
    this.title = '', //'Agenda de Serviços',
  }) : super(key: key);

  @override
  _AgendaViewState createState() => _AgendaViewState();

  static test() {
    var data = DateTime.now();
    var dia = data.day;
    var mes = data.month;
    var ano = data.year;
    return AgendaPage(
      controller: AgendaController(
        future: null,
        resources: [
          for (var i = 0; i < 10; i++)
            AgendaResource(intervalo: 0, gid: '$i', label: 'X $i'),
        ],
        sources: [
          for (var i = 0; i < 10; i++)
            AgendaItem(
              gid: '$i',
              recursoGid: '$i',
              datainicio: DateTime(ano, mes, dia, 8 + i, 0),
              datafim:
                  DateTime(ano, mes, dia, 8 + i, i + 30 + (i.isEven ? 30 : 0))
                      .add(const Duration(minutes: 30)),
              titulo: 'Reunião com .... $i',
            ),
        ],
      ),
    );
  }
}

class _AgendaViewState extends State<AgendaPage> {
  AgendaController? get controller => widget.controller;
  List<AgendaResource> get resources => controller!.resources.resources;
  late List<bool> _toggleSelects;
  late SocketIOClient socketEvents;
  bool canReload = true;
  int? count;
  @override
  void initState() {
    super.initState();
    _toggleSelects = [true, false, false];
    socketEvents = SocketIOClient(config: V3SocketIOConfig());
    socketEvents.ensureInited(() {
      initSocket();
    });
  }

  initSocket() {
    controller!.onSaving = (i) {
      count ??= 0;
      count = count! + i;
    };

    /// as mensagem são empilhadas para pegar posterior
    socketEvents.subscribeEvent('AGENDA/CHANGED', onData: (x) {
      // verifica o contador  do evento para evitar recarregar sem necessidade
      // print(['evento', count, x]);
      if ((count == null) || (x.count! <= count!)) {
        // primeira vez ou o sever resetou.
        count = x.count;
        return;
      }
      count = x.count;

      /// poe na fila
      socketEvents.push(x.payload);

      /// controla mesnagens repetidas.
      Timer.periodic(const Duration(milliseconds: 10000), (timerLocal) {
        if (canReload && (socketEvents.length > 0)) {
          controller!.dataNotifier.notify(controller!.data);
          socketEvents.removeAll();
        }
        if (socketEvents.length <= 0) timerLocal.cancel();
      });
    });
  }

  Timer? timer;

  @override
  void dispose() {
    socketEvents.dispose();
    if (timer != null) {
      try {
        timer!.cancel();
      } catch (e) {}
    }
    super.dispose();
  }

  _selectDate(BuildContext context) async {
    DateTime? d = await showDatePicker(
        context: context,
        initialDate: controller!.data!,
        lastDate: DateTime(controller!.data!.year + 1, 12),
        firstDate: DateTime(controller!.data!.year - 1, 1));
    return d;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ResponsiveInfo responsive = ResponsiveInfo(context);
    //print('AgendaPage-builder');
    return ChangeNotifierProvider.value(
      value: controller!.viewerNotifier,
      child: Builder(
        builder: (x) {
          return DefaultAgenda(
            data: widget.data,
            controller: controller,
            child: Scaffold(
              floatingActionButton: const AgendaDeleteItemTarget(),
              appBar: PreferredSize(
                  preferredSize: Size.fromHeight(responsive.isMobile
                      ? kToolBarHeightSmall
                      : kToolBarHeight), // here the desired height
                  child: AppBar(
                    automaticallyImplyLeading: widget.automaticallyImplyLeading,
                    iconTheme: theme.iconTheme.copyWith(color: Colors.black),
                    backgroundColor: scaffoldBackgroundColor,
                    //backgroundColor: theme.primaryColor.withAlpha(100),
                    title: Text(widget.title ?? '',
                        style: const TextStyle(color: Colors.black)),
                    elevation: responsive.isMobile ? 0 : 0,
                    actions: [
                      ToggleButtons(
                        isSelected: const [false, false],
                        //highlightColor: Colors.indigo,
                        //color: theme.textTheme.button.color,
                        //selectedColor: theme.iconTheme.color,
                        children: const [
                          Tooltip(
                              message: 'Calendário',
                              child: Icon(Icons.calendar_today)),
                          Tooltip(message: 'Hoje', child: Icon(Icons.today)),
                        ],
                        onPressed: (idx) {
                          // print('$idx');
                          if (idx == 0) {
                            _selectDate(context).then((d) {
                              // print(d);
                              controller!.dataChange(d);
                            });
                          }
                          if (idx == 1) controller!.dataChange(DateTime.now());
                        },
                      ),
                      Consumer<AgendaViewerRefNotifier>(builder: (c, mdl, w) {
                        // print('viewer: ${mdl.viewer}');
                        // if (mdl != null)
                        for (var i = 0; i < _toggleSelects.length; i++) {
                          _toggleSelects[i] = mdl.viewer!.index == i;
                        }

                        return ToggleButtons(
                          //highlightColor: Colors.indigo,
                          //color: theme.primaryIconTheme.color,
                          //selectedColor: theme.iconTheme.color,
                          isSelected: _toggleSelects,
                          children: const [
                            // Tooltip(
                            //     message: 'mobile', child: Icon(Icons.view_compact)),
                            Tooltip(
                                message: 'diário',
                                child: Icon(Icons.view_week)),
                            Tooltip(
                                message: 'semanal',
                                child: Icon(Icons.view_agenda)),
                            Tooltip(
                                message: 'mensal',
                                child: Icon(Icons.view_comfy)),
                          ],
                          onPressed: (int index) {
                            for (var item in AgendaViewerType.values) {
                              if (item.index == index) {
                                _toggleSelects[item.index] =
                                    item.index == index;
                                controller!.viewerChange(item);
                                LocalStorage().setString(
                                    'ultima_agenda_ativa', item.toString());
                              }
                            }
                          },
                        );
                      }),
                      InkButton(
                        child: Icon(Icons.more_vert,
                            color: theme.textTheme.button!.color),
                        onTap: () {
                          AgendaMenu.show(context);
                        },
                      )
                    ],
                  )),
              body: Consumer<AgendaDataRefNofifier>(
                builder: (a, AgendaDataRefNofifier dataRef, c) {
                  return FutureBuilder<dynamic>(
                      future: controller!.future!(),
                      builder: (context, snapshot) {
                        canReload = false;
                        if (!snapshot.hasData) {
                          const Align(child: CircularProgressIndicator());
                        }
                        controller!.begin(true);
                        if (snapshot.data != null) {
                          controller!.sources!.clear();
                          snapshot.data.forEach((item) {
                            try {
                              controller!.sources!
                                  .add(AgendaItem.fromJson(item, zone: -3));
                            } finally {}
                          });
                        }
                        controller!.beginEndReset();
                        try {
                          switch (controller!.viewerNotifier.viewer) {
                            case AgendaViewerType.periodo:
                              return AgendaMensalPage(
                                  dataRef: controller!.data,
                                  resources: resources);

                            case AgendaViewerType.mensal:
                              return AgendaMensalPage(
                                  dataRef: controller!.data,
                                  resources: resources);

                            case AgendaViewerType.semanal:
                              //print('AgendasSemanal');

                              return AgendaSemanalPage(
                                  dataRef: controller!.data,
                                  resources: resources);

                            default:
                              //print('AgendasDiario');

                              return (!responsive.isSmall)
                                  ? AgendaDiariaPage(
                                      dataRef: controller!.data,
                                      resources: resources)
                                  : AgendaMobile(
                                      dataRef: controller!.data,
                                      resources: resources);
                          }
                        } finally {
                          canReload = true;
                          socketEvents.removeAll();
                        }
                      });
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
