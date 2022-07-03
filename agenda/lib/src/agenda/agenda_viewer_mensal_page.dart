// @dart=2.12

import 'package:controls_web/controls/responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'agenda_cards.dart';
import 'agenda_controller.dart';
import 'agenda_notifier.dart';
import 'agenda_resource.dart';
import 'package:controls_extensions/extensions.dart';

import 'agenda_timeline_dart.dart';
import 'data_slider.dart';
import 'models/agenda_item_model.dart';

class AgendaMensalPage extends StatefulWidget {
  final DateTime? dataRef;
  final List<AgendaResource> resources;
  const AgendaMensalPage({
    Key? key,
    required this.dataRef,
    required this.resources,
  }) : super(key: key);

  @override
  _AgendaSemanalPageState createState() => _AgendaSemanalPageState();
}

class _AgendaSemanalPageState extends State<AgendaMensalPage> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    DateTime primeiroDia =
        (widget.dataRef ?? DateTime.now()).startOfMonth().startOfWeek();

    DateTime ultimoDia = (widget.dataRef ?? DateTime.now()).endOfMonth();

    int dias = ultimoDia.difference(primeiroDia).inDays + 1;
//    AgendaController controller = DefaultAgenda.of(context).controller;

    AgendaController? controller = DefaultAgenda.of(context)!.controller;
    //print('re-buildDefaultAgendaItemMensal');

    return Scaffold(
      bottomNavigationBar: DataSlider(
          dataRef: primeiroDia,
          controller: controller,
          format: (d) => d.format('MMM'),
          activated: (DateTime d) {
            // print([d, primeiroDia, d.endOfWeek().month, ultimoDia.month]);
            return d.endOfWeek().month == ultimoDia.month;
          },
          datas: [for (var i = -3; i < 4; i++) widget.dataRef!.addMonths(i)]),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomScrollView(
                primary: false,
                slivers: <Widget>[
                  SliverToBoxAdapter(
                      child: Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Container(
                      height: 30,
                      color: theme.primaryColor.withAlpha(30),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            for (var i = 0; i < 7; i++)
                              Text([
                                'Seg',
                                'Ter',
                                'Qua',
                                'Qui',
                                'Sex',
                                'Sab',
                                'Dom'
                              ][i])
                          ]),
                    ),
                  )),
                  SliverPadding(
                    padding: const EdgeInsets.all(0),
                    sliver: SliverGrid.count(
                      crossAxisSpacing: 3,
                      mainAxisSpacing: 3,
                      crossAxisCount: 7,
                      children: <Widget>[
                        for (var i = 0; i < dias; i++)
                          AgendasMensalContainer(
                            index: i,
                            data: primeiroDia.addDays(i),
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AgendasMensalContainer extends StatelessWidget {
  final int? index;
  final DateTime? data;
  const AgendasMensalContainer({
    Key? key,
    this.index,
    this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DefaultAgenda agenda = DefaultAgenda.of(context)!;
    AgendaController controller = agenda.controller!;

    final DefaultSourceList list = DefaultSourceList(sources: []);

    DateTime _data = data!.toDate();
    for (var item in controller.sources!) {
      DateTime d = item!.datainicio!.toDate();
      if (d.compareTo(_data) == 0) {
        list.sources!.add(item);
      }
    }
    if (controller.data!.month != _data.month) return Container();

    return ChangeNotifierProvider.value(
        value: list,
        builder: (a, b) => InkWell(
            key: UniqueKey(),
            child: Container(
              color: genWeekDayColor(_data)!.withAlpha(50),
              child: Stack(children: [
                InkWell(
                  child: Text(
                    _data.format('dd'),
                    style: const TextStyle(fontSize: 12),
                  ),
                  onTap: () {
                    // vai para visao diaria;
                    controller.dataChange(_data,
                        viewer: AgendaViewerType.horario);
                  },
                ),
                Positioned(
                    top: 14,
                    left: 1,
                    right: 1,
                    bottom: 1,
                    child: Consumer<DefaultSourceList>(builder: (a, b, c) {
                      //print('consumir item');
                      return AgendaMensalTarget(
                          list: b,
                          controller: controller,
                          data: data,
                          child: Wrap(children: [
                            for (var item in list.sources!)
                              AgendaMensalCard(item: item, sources: list)
                          ]));
                    }))
              ]),
            ),
            onTap: () {
              controller.onInsert!(AgendaData(
                controller: controller,
                hour: controller.startHour,
                interval: controller.defaultDuracaoAgenda,
                date: data,
                //resource: resource,
                sources: list,
              ));
            }));
  }
}

class AgendaMensalTarget extends StatelessWidget {
  final Widget? child;
  final AgendaController? controller;
  final DefaultSourceList list;
  final DateTime? data;
  const AgendaMensalTarget(
      {Key? key, this.child, this.controller, this.data, required this.list})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool accepted = false;
    return DragTarget<AgendaCardData>(
      builder: (BuildContext context, List<AgendaCardData?> candidateData,
          List<dynamic> rejectedData) {
        return (!accepted)
            ? child!
            : const Icon(Icons.camera, color: Colors.grey, size: 30);
      },
      onWillAccept: (data) {
        accepted = true;
        return true;
      },
      onAccept: (data) {
        var gid = data.item!.gid;
        DateTime dt = this.data!.add(Duration(
            hours: data.item!.datainicio!.hour,
            minutes: data.item!.datainicio!.minute));
        var novo = controller!.moveTo(data.item!, dt, data.item!.resource);
        try {
          data.sources!.begin();
          list.begin();
          data.sources!.delete(gid);
          list.add(novo);
        } finally {
          data.sources!.end();
          list.end();
        }
        accepted = false;
      },
      onLeave: (obj) {
        accepted = false;
      },
    );
  }
}

class AgendaMensalCard extends StatelessWidget {
  final AgendaItem? item;
  final DefaultSourceList sources;
  const AgendaMensalCard({Key? key, this.item, required this.sources})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    AgendaController controller = DefaultAgenda.of(context)!.controller!;
    AgendaResource? resource = controller.resourceFind(item!.recursoGid);
    ResponsiveInfo responsive = ResponsiveInfo(context);
    return (responsive.isDesktop)
        ? AgendaCardItem(
            controller: controller,
            item: item,
            date: controller.data,
            sources: sources,
            herdarResourceGid: false,
          )
        : Padding(
            padding: const EdgeInsets.all(1.0),
            child: Tooltip(
                message: '${resource?.label ?? '?'} - ${item!.titulo}',
                child: InkWell(
                  child: Draggable<AgendaCardData>(
                    data: AgendaCardData(
                      item: item,
                      sources: sources,
                    ),
                    feedback: const CircleAvatar(
                        child: Icon(Icons.my_location, size: 30)),
                    child: CircleAvatar(
                        radius: responsive.isSmall ? 8 : 10,
                        backgroundColor: resource?.color ?? Colors.brown,
                        child: Stack(children: [
                          (item!.completada == 1)
                              ? Align(
                                  alignment: (responsive.isMobile)
                                      ? Alignment.center
                                      : Alignment.centerRight,
                                  child: const Icon(Icons.check,
                                      color: Colors.white, size: 18))
                              : Container(),
                          if (responsive.isTablet)
                            Center(
                              child: Text(
                                (resource?.label ?? ' ').substring(0, 1),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            )
                        ])),
                  ),
                  onTap: () {
                    controller.onEdit!(AgendaData(
                      controller: controller,
                      hour: item!.start!.hours,
                      item: item,
                      date: item!.datainicio,
                      resource: item!.recursoGid,
                      sources: sources,
                      //sources: sources,
                    ));
                  },
                )),
          );
  }
}
