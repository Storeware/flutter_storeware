// @dart=2.12

import 'package:controls_web/controls/responsive.dart';
import 'agenda_const.dart';
import 'agenda_notifier.dart';

import 'package:flutter/material.dart';
import 'package:controls_extensions/extensions.dart';
import 'package:provider/provider.dart';
import 'agenda_cards.dart';
import 'agenda_controller.dart';
import 'agenda_resource.dart';
import 'agenda_timeline_dart.dart';
import 'data_slider.dart';
import 'dropdown_menu.dart';
import 'models/agenda_config.dart';
import 'models/agenda_item_model.dart';

class AgendaSemanalPage extends StatelessWidget {
  final DateTime? dataRef;
  final List<AgendaResource> resources;
  const AgendaSemanalPage({
    Key? key,
    required this.dataRef,
    required this.resources,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AgendaController controller = DefaultAgenda.of(context)!.controller!;
    DateTime primeiroDia = controller.startOfWeek;
    //DateTime ultimoDia = controller.endOfWeek;
    //int diaUm = primeiroDia.day;
    ResponsiveInfo responsive = ResponsiveInfo(context);
    final double width =
        responsive.isMobile ? kPanelWidthWeekSmall : kPanelWidthWeek;

    //DateTime hoje = DateTime.now().startOfWeek();
    var datas = [
      primeiroDia.add(const Duration(days: -21)),
      primeiroDia.add(const Duration(days: -14)),
      primeiroDia.add(const Duration(days: -7)),
      primeiroDia,
      primeiroDia.add(const Duration(days: 7)),
      primeiroDia.add(const Duration(days: 14)),
      primeiroDia.add(const Duration(days: 21)),
    ];
    //print('re-buildDefaultAgendaItemSemanal');

    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VerticalTimeline(
            title: primeiroDia.format('MMM'),
            start: AgendaConfig().nHoraInicio,
            end: AgendaConfig().nHoraFim,
            date: primeiroDia,
            onPrior: () {
              controller
                  .dataChange(controller.data!.add(const Duration(days: -7)));
            },
            onNext: () {
              controller
                  .dataChange(controller.data!.add(const Duration(days: 7)));
            },
          ),
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                /// cria os dias da semana
                for (var dia = 0; dia < 7; dia++)
                  buildColumn(width, dia, controller)
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: DataSlider(
          format: (d) => d.format('dd/MMM'),
          datas: datas,
          dataRef: primeiroDia,
          controller: controller),
    );
  }

  buildColumn(width, dia, controller) {
    var d = controller.startOfWeek.add(Duration(days: dia));
    //print([controller.data, dataRef, d, dia]);
    return DayCardColumn(
      panelWidth: width,
      color: genColor2(d.weekday),
      data: d,
    );
  }

  genColor2(int n) {
    return [
      Colors.lightBlue,
      Colors.lightBlue,
      Colors.lightBlue,
      Colors.lightBlue,
      Colors.lightBlue
    ][n % 5];
  }
}

class DayCardColumn extends StatefulWidget {
  final DateTime? data;
  final double? panelWidth;
  final Color? color;
  DayCardColumn(
      {Key? key, this.color = Colors.blue, this.data, this.panelWidth = 200})
      : super(key: key);

  @override
  _DayCardColumnState createState() => _DayCardColumnState();
}

class _DayCardColumnState extends State<DayCardColumn> {
  @override
  void initState() {
    super.initState();
    mapa = {};
  }

  String? _title;
  Color? color;
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    _title = widget.data!.format('E dd, MMM');

    final DefaultSourceList list = DefaultSourceList(sources: []);
    bool fimSemana = ([6, 7].contains(widget.data!.weekday));
    color = (fimSemana) ? theme.primaryColor : widget.color;
    ResponsiveInfo responsive = ResponsiveInfo(context);
    var _width = widget.panelWidth ??
        (responsive.isMobile ? kPanelWidthSmall : kPanelWidth);

    AgendaController controller = DefaultAgenda.of(context)!.controller!;
    list.sources!.clear();
    mapa.clear();
    controller.sources!.forEach((item) {
      if (item!.datainicio!.startOfDay() == widget.data!.startOfDay())
        list.sources!.add(item);
    });
    list.sources!.forEach((item) {
      addMapa(item!);
    });

    return ChangeNotifierProvider<DefaultSourceList>.value(
        value: list,
        builder: (a, x) {
          return Consumer<DefaultSourceList>(builder: (a, list, w) {
            mapa = {};
            list.sources!
                .sort((a, b) => a!.datainicio!.compareTo(b!.datainicio!));
            list.sources!.forEach((item) {
              addMapa(item!);
            });

            DefaultAgenda.setContext(context);

            return Card(
                color: genWeekDayColor(widget.data!)!.lighten(30),
                margin: EdgeInsets.all(responsive.isMobile ? 1 : 4),
                elevation: responsive.isMobile ? 0 : null,
                child: Consumer<DefaultSourceList>(
                  builder: (a, list, c) => Container(
                    width: _width,
                    child: Stack(children: [
                      AgendaPanelTitle(
                        width: _width,
                        title: _title,
                        style: const TextStyle(color: Colors.black),
                        color: genWeekDayColor(widget.data!),
                        count: list.sources!.length,
                        onList: () {
                          controller.onListDates!(
                              list,
                              widget.data!.startOfDay(),
                              widget.data!.endOfDay());
                        },
                      ),
                      for (var i = controller.iStart; i < controller.iEnd; i++)
                        Positioned(
                          top: controller.calcTop(i + 0.0),
                          child: Container(
                            height: controller.cardHeigth,
                            width: kPanelWidthWeek, //widget.width,
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1,
                                        color: Colors.grey.withAlpha(50)))),
                            child: Row(
                              children: [
                                SemanalBackgroudContainer(
                                    width: 40,
                                    date: widget.data,
                                    hour: i + 0.0,
                                    interval:
                                        (controller.defaultDuracaoAgenda * 2) ~/
                                            1,
                                    sources: list),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Expanded(
                                          flex: 1,
                                          child: SemanalBackgroudContainer(
                                              date: widget.data,
                                              hour: i + 0.0,
                                              sources: list)),
                                      Expanded(
                                          flex: 1,
                                          child: SemanalBackgroudContainer(
                                              date: widget.data,
                                              hour: i + 0.5,
                                              divider: false,
                                              sources: list)),
                                    ],
                                  ),
                                ),
                                SemanalBackgroudContainer(
                                    width: 40,
                                    date: widget.data, //widget.date,
                                    hour: i + 0.5,
                                    interval:
                                        (controller.defaultDuracaoAgenda * 2) ~/
                                            1,
                                    sources: list),
                              ],
                            ),
                          ),
                        ),
                      //for (var item in list.sources!)
                      //  buildDefaultAgendaItem(item!, list, controller, _width)
                      /// mostra os cards da agenda
                      ...buildItem(list, controller, _width)
                    ]),
                  ),
                ));
          });
        });
  }

  List<Widget> buildItem(list, controller, double width) {
    List<Widget> lst = [];
    if (mapa.length == 0) return [];
    // inverter a ordem para o drop ficar por cima do item inferior
    for (int x = mapa.length - 1; x > -1; x--) {
      int hora = mapa.keys.elementAt(x);
      //for (var idx in mapa.keys) {
      List<AgendaItem>? items = mapa[hora];
      items!.sort((a, b) => a.datainicio!.compareTo(b.datainicio!));
      if (horaItemCount(items[0]) > 1)
        lst.add(buildMultiAgendaItem(hora, items, list, controller, width));
      else
        for (var card in items)
          lst.add(buildDefaultAgendaItem(card, list, controller, width));
    }
    return lst;
  }

  int horaItemCount(AgendaItem item) {
    return mapa[item.datainicio!.hour]!.length;
  }

  Widget buildMultiAgendaItem(int itemIndex, List<AgendaItem> items,
      DefaultSourceList sources, AgendaController controller, double width) {
    Point point = panelPoint(items[0], width);

    var top = controller.calcTop((items[0].start!.hours ~/ 1) + 0.0);
    return Positioned(
        top: top,
        left: point.y,
        child: Container(
          color: Colors.amber,
          width: width,
          child: DragTagetMultItem(
              list: sources,
              item: items[0],
              herdarResourseGid: false,
              child: DropdownMenu(
                itemCount: items.length,
                builder: (ctx, idx) {
                  List<AgendaItem> litems = mapa[itemIndex]!;
                  return Container(
                    height: kMinInteractiveDimension,
                    child: ChangeNotifierProvider.value(
                      value: AgendaItemNotifier(value: litems[idx]),
                      child: Consumer<AgendaItemNotifier>(
                          builder: (_, itemRef, __) {
                        return AgendaCardItem(
                            height: 40,
                            controller: controller,
                            mostrarResource: true,
                            herdarResourceGid: false,
                            item: litems[idx],
                            width: width,
                            showHours: true,
                            sources: sources);
                      }),
                    ),
                  );
                },
                title: Text('${items.length} agendas'),
              )),
        ));
  }

  Positioned buildDefaultAgendaItem(AgendaItem item, DefaultSourceList list,
      AgendaController controller, _width) {
    Point point = panelPoint(item, _width);
    return Positioned(
        top: controller.calcTop(item.start!.hours + 0.0),
        left: point.y,
        child: ChangeNotifierProvider.value(
            value: AgendaItemNotifier(value: item),
            child: Consumer<AgendaItemNotifier>(builder: (_, itemRef, __) {
              return DefaultAgendaItem(
                item: itemRef.value,
                sources: list,
                child: AgendaCardItem(
                  sources: list,
                  controller: controller,
                  item: itemRef.value,
                  width: point.x! - 10,
                  herdarResourceGid: false,
                ),
              );
            })));
  }

  Size? size;

  late Map<int, List<AgendaItem>> mapa;

  addMapa(AgendaItem item) {
    int hora = item.datainicio!.hour;
    if (mapa[hora] == null) mapa[hora] = [];
    if (mapa[hora]!.indexOf(item) < 0) mapa[hora]!.add(item);
  }

  //int mapaCount(int hora) => (mapa[hora] == null) ? 0 : mapa[hora].length;
  Point mapaCount(AgendaItem item) {
    int i = 0;
    int p = 0;
    mapa.keys.forEach((k) {
      mapa[k]!.forEach((v) {
        // item é longo;
        if (v.gid == item.gid) p = i;
        //    else {
        if ((v.datainicio!.hour == item.datainicio!.hour) ||
            (v.datainicio!.isAfter(item.datainicio!) &&
                v.datafim!.isBefore(item.datafim!)))
          i++;
        else
        // v esta dentro de um longo
        if ((v.datainicio!.hour == item.datainicio!.hour) ||
            (v.datainicio!.isBefore(item.datainicio!) &&
                v.datafim!.isAfter(item.datafim!))) i++;
        //  }
      });
    });
    return Point(x: i + 0.0, y: p + 0.0);
  }

/*
  int mapaIndexOf(AgendaItem item) {
    int hora = item.datainicio.hour;
    return mapa[hora]?.indexOf(item) ?? -1;
  }


  Point panelPoint(AgendaItem item, _width) {
    var idx = mapaIndexOf(item);
    if (idx < 0) return Point(x: _width, y: 0);
    int conta = mapaCount(item.datainicio.hour);
    //print('conta: $conta');
    double len = ((_width ~/ conta)) + 0.0;
    return Point(x: len, y: idx * len);
  }
*/
  Point panelPoint(AgendaItem item, _width) {
    //var idx = mapaIndexOf(item);
    //if (idx < 0) return Point(x: width, y: 0);
    Point p = mapaCount(item); //.datainicio.hour);
    double len = ((p.x! > 0) ? (_width ~/ (p.x)) : _width) + 0.0;
    double y = p.y!;
    //print([p.toJson(), len, y, y * len]);
    return Point(x: len, y: y * len);
  }
}

class SemanalBackgroudContainer extends StatelessWidget {
  final DateTime? date;
  final double? hour;
  final DefaultSourceList? sources;
  final bool divider;
  final String? resource;
  final double? width;
  final Color? color;
  final int alpha;
  final int? interval;
  SemanalBackgroudContainer(
      {Key? key,
      this.hour,
      this.date,
      this.sources,
      this.resource,
      this.width,
      this.alpha = 150,
      this.color,
      this.divider = false,
      this.interval})
      : super(key: key);

  DateTime toDate(d) {
    return DateTime(d.year, d.month, d.day);
  }

  int toHour(double h) {
    return h ~/ 1;
  }

  int toMinutes(double h) => (((h - (h ~/ 1)) * 60)) ~/ 1;

  @override
  Widget build(BuildContext context) {
    AgendaController? controller = DefaultAgenda.of(context)!.controller;
    bool accepted = false;
    return DragTarget<AgendaCardData>(
      builder: (BuildContext context, List<AgendaCardData?> candidateData,
          List<dynamic> rejectedData) {
        return InkWell(
          child: Container(
            alignment: Alignment.center,
            width: width,
            decoration: BoxDecoration(
                color: (accepted) ? Colors.grey.withAlpha(alpha) : color,
                border: (divider)
                    ? const Border(
                        bottom: BorderSide(width: 1, color: Colors.grey))
                    : null),
            child: (accepted && (interval != null))
                ? Text('$interval min', style: const TextStyle(fontSize: 12))
                : null,
          ),
          onTap: () {
            if (controller!.onInsert != null) {
              controller.onInsert!(
                AgendaData(
                    controller: controller,
                    hour: hour,
                    interval: interval,
                    date: date,
                    resource: resource,
                    sources: sources),
              );
            }
          },
        );
      },
      //child: child,
      onAccept: (data) {
        try {
          AgendaController controller = DefaultAgenda.of(context)!.controller!;
          DateTime dt = toDate(date)
              .add(Duration(hours: toHour(hour!), minutes: toMinutes(hour!)));
          // print([dt, resource]);
          var gid = data.item!.gid;
          var novo =
              controller.moveTo(data.item!, dt, resource, interval: interval);
          try {
            data.sources!.begin();
            sources!.begin();
            data.sources!.delete(gid);
            sources!.add(novo);
          } finally {
            data.sources!.end();
            sources!.end();
          }
        } catch (e) {
          print('Accept: $e');
        }
        accepted = false;
      },
      onWillAccept: (data) {
        accepted = true;
        return true;
      },
      onLeave: (data) {
        accepted = false;
      },
      onAcceptWithDetails: (data) {},
    );
  }
}
