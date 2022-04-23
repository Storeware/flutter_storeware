// @dart=2.12
import 'package:console/views/agenda/models/agenda_estado_model.dart';
import 'package:controls_web/controls/color_picker.dart';
import 'package:controls_web/controls/colores.dart';
import 'package:controls_web/controls/responsive.dart';
import 'package:flutter/material.dart';

import 'agenda_controller.dart';
import 'agenda_notifier.dart';
import 'models/agenda_item_model.dart';
import 'models/agenda_tipo_model.dart';
import 'package:controls_extensions/extensions.dart';

class Point {
  double? x;
  double? y;
  Point({this.x, this.y});
  toJson() {
    return {"x": x, "y": y};
  }

  Point.fromJson(Map<String, double> json) {
    x = json['x'];
    y = json['y'];
  }
}

class AgendaCardData {
  final AgendaItem? item;
  final DefaultSourceList? sources;
  AgendaCardData({this.item, this.sources});
}

class AgendaCardItem extends StatelessWidget {
  final AgendaItem? item;
  final DateTime? date;
  final double? height;
  final double elevation;
  final double? width;
  final Color color;
  final Color? tagColor;
  final bool showHours;
  final BuildContext? masterContext;
  final DefaultSourceList? sources;
  final bool mostrarResource;
  final bool herdarResourceGid;

  final AgendaController controller;
  const AgendaCardItem({
    Key? key,
    this.item,
    this.masterContext,
    required this.controller,
    this.height,
    this.elevation = 10,
    this.mostrarResource = false,
    required this.herdarResourceGid,
    this.width,
    this.date,
    this.showHours = false,
    this.sources,
    this.color = Colors.amber,
    this.tagColor,
    //this.left
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    dynamic dtipo;
    controller.tipos.forEach((it) {
      if (it['gid'] == (item!.tipoGid ?? '')) dtipo = it;
    });
    AgendaTipoItem tipo = AgendaTipoItem.fromJson(dtipo ?? {});
    var data = AgendaCardData(
        item: item, sources: (sources ?? []) as DefaultSourceList?);
    ResponsiveInfo responsive = ResponsiveInfo(masterContext ?? context);
    List<Widget> _actions = [];
    var linhas = item!.end!.difference(item!.start!).inMinutes ~/ 60;
    var fullBox = (linhas == 1);
    if (linhas < 1) linhas = 1;
    return Draggable<AgendaCardData>(
      key: UniqueKey(),
      data: data,
      feedback: Container(
          width: 100,
          height: controller.calcHeigth(
                  date, item!.start!, item!.start!.addHours(1)) /
              2,
          color: Colors.grey),
      child: Card(
        elevation: elevation,
        color: Colors.transparent,
        child: Container(
          width: width,
          height: height ??
              (controller.calcHeigth(date, item!.start!, item!.end!) -
                  ((fullBox) ? 10 : 0)),
          color: tipo.color ?? (color).withAlpha(100),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Tooltip(
                  height: 60,
                  message: '${tipo.nome ?? ''} - ${item!.texto} ${item!.local}',
                  child: buildTagContainer()),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: DragTagetMultItem(
                    list: sources,
                    item: item,
                    herdarResourseGid: herdarResourceGid,
                    child: Wrap(
                      children: [
                        if (_actions.isNotEmpty) ..._actions,
                        Text(
                            getTitulo(item!, tipo, showHours: showHours) ?? '?',
                            overflow: TextOverflow.ellipsis,
                            maxLines: linhas,
                            style: TextStyle(fontWeight: FontWeight.w500)),
                        if ((!responsive.isMobile) &&
                            (controller.viewerNotifier.viewer ==
                                AgendaViewerType.horario))
                          Text('${item!.texto}',
                              maxLines: linhas,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 13)),
                      ],
                    ),
                  ),
                ),
              ),
              Wrap(
                direction: Axis.vertical,
                children: [
                  if ((item!.completada ?? 0) == 1) Icon(Icons.check),
                  ...sinalizarVencidos(item!),
                  btnEditar(),
                ],
              ),
            ],
          ),
        ),
      ),
      childWhenDragging: Container(color: Colors.amber),
    );
  }

  InkWell btnEditar() {
    return InkWell(
      child: Icon(Icons.edit, size: 20),
      onTap: () {
        if (controller.onEdit != null)
          controller.onEdit!(AgendaData(
            controller: controller,
            hour: item!.start!.hours,
            item: item,
            date: date,
            resource: item!.recursoGid,
            mostrarResource: mostrarResource,
            sources: sources,
          ));
      },
    );
  }

  buildTagContainer() {
    return FutureBuilder<AgendaEstadoItem?>(
        future: AgendaEstadoItemModel().procurar(item!.estadoGid),
        builder: (x, snap) {
          if (!snap.hasData) return Container();
          AgendaEstadoItem estado = snap.data!;
          Color cor = ColorExtension.hexToARGB(
              estado.cor!,
              genColorSeeds(estado.internoOrdem,
                  (estado.encerrado == 'N') ? coldColors : warmColors));
          return Container(
            color: cor,
            width: 8,
          );
        });
  }

  String? getTitulo(AgendaItem item, AgendaTipoItem tipo,
      {bool showHours = false}) {
    String tx = item.texto ?? '';
    String h = '';
    if (showHours) h = item.datainicio!.format('H:mm') + '-';
    if (tx != '') tx = ' - ';
    if ((item.nomeCliente ?? '').isNotEmpty) {
      var p = item.nomeCliente!.split(' ');
      return "$h${p[0]}, ${item.titulo ?? ''} $tx";
    }
    if ((item.titulo ?? '').isEmpty) return tipo.nome;
    return '$h${item.titulo} $tx';
  }

  List<Widget> sinalizarVencidos(AgendaItem item) {
    List<Widget> r = [];
    if (item.domicilio == 'S') r.add(Icon(Icons.home, size: 18));
    try {
      if (item.datainicio != null) if (item.datainicio!.between(
          DateTime.now().addMinutes(-(item.minutoslembrete ?? 15)),
          DateTime.now().addMinutes(item.minutoslembrete ?? 15)))
        r.add(Icon(Icons.timer, size: 18));
    } catch (e) {
      //debugPrint('sinalizarVencidos: $e');
    }
    return r;
  }
}

/*
class DragTargetItem extends StatelessWidget {
  final Widget? child;
  final AgendaItem? item;
  final DefaultSourceList? list;
  const DragTargetItem({Key? key, this.child, this.item, required this.list})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var accepted = false;
    AgendaController? controller = DefaultAgenda.of(context)!.controller;
    return DragTarget<AgendaCardData>(
      builder: (BuildContext context, List<AgendaCardData?> candidateData,
          List<dynamic> rejectedData) {
        return (!accepted)
            ? child!
            : Icon(Icons.camera, color: Colors.grey, size: 60);
      },
      onAccept: (AgendaCardData data) {
        var gid = data.item!.gid;
        var novo =
            controller!.moveTo(data.item!, item!.datainicio, item!.recursoGid);
        try {
          data.sources!.begin();
          list!.begin();
          data.sources!.delete(gid);
          list!.add(novo);
        } finally {
          data.sources!.end();
          list!.end();
        }
        accepted = false;
      },
      onLeave: (d) {
        accepted = false;
      },
      onWillAccept: (data) {
        accepted = true;
        return accepted;
      },
    );
  }
}
*/
class DragTagetMultItem extends StatelessWidget {
  final Widget? child;
  final AgendaItem? item;
  final DefaultSourceList? list;
  final bool herdarResourseGid;

  const DragTagetMultItem(
      {Key? key,
      this.herdarResourseGid = true,
      this.child,
      this.item,
      this.list})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var accepted = false;
    AgendaController? controller = DefaultAgenda.of(context)!.controller;
    return DragTarget<AgendaCardData>(
      builder: (BuildContext context, List<AgendaCardData?> candidateData,
          List<dynamic> rejectedData) {
        return (!accepted)
            ? child!
            : Icon(Icons.camera, color: Colors.grey, size: 60);
      },
      onAccept: (AgendaCardData data) {
        var gid = data.item!.gid;
        var novo = controller!.moveTo(data.item!, item!.datainicio,
            (herdarResourseGid) ? item!.recursoGid : data.item!.recursoGid);
        try {
          data.sources!.begin();
          list!.begin();
          data.sources!.delete(gid);
          list!.add(novo);
        } finally {
          data.sources!.end();
          list!.end();
        }
        accepted = false;
      },
      onLeave: (d) {
        accepted = false;
      },
      onWillAccept: (data) {
        accepted = true;
        return accepted;
      },
    );
  }
}
