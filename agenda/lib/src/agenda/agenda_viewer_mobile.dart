// @dart=2.12

import 'package:agenda/agenda.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:controls_extensions/extensions.dart';
import 'agenda_controller.dart';
import 'agenda_notifier.dart';
import 'agenda_resource.dart';
import 'data_slider.dart';
import 'models/agenda_item_model.dart';

class AgendaMobile extends StatelessWidget {
  final DateTime? dataRef;
  final List<AgendaResource>? resources;
  const AgendaMobile({Key? key, this.dataRef, this.resources})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    AgendaController? controller = DefaultAgenda.of(context)!.controller;
    //print('re-buildDefaultAgendaItemMobile');

    return Scaffold(
      body: CustomScrollView(primary: false, slivers: [
        SliverGrid.count(
            crossAxisSpacing: 1,
            mainAxisSpacing: 1,
            crossAxisCount: 2,
            children: <Widget>[
              for (var r in resources!)
                ResourceCard(dataRef: dataRef, resource: r)
            ])
      ]),
      bottomNavigationBar: DataSlider(
          dataRef: dataRef,
          controller: controller,
          format: (d) => d.format('Edd'),
          datas: [
            for (var i = -3; i < 4; i++) dataRef!.add(Duration(days: i))
          ]),
    );
  }
}

/// [ResourceCard] monta os cards para agenda diaria no mobile
class ResourceCard extends StatelessWidget {
  final AgendaResource? resource;
  final DateTime? dataRef;
  ResourceCard({Key? key, this.resource, this.dataRef}) : super(key: key);

  final DefaultSourceList list = DefaultSourceList(sources: []);

  buildSources(List<AgendaItem?> srcBase) {
    //list.clear();
    srcBase.forEach((item) {
      if (item!.recursoGid == resource!.gid) if (item.datainicio!
              .toDate()
              .compareTo(dataRef!.toDate()) ==
          0) {
        list.add(item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //ThemeData theme = Theme.of(context);
    AgendaController controller = DefaultAgenda.of(context)!.controller!;

    buildSources(controller.sources!);

    return ChangeNotifierProvider<DefaultSourceList>.value(
      value: list,
      builder: (a, b) => Card(
        color: resource!.color!.lighten(90),
        child: Stack(children: [
          AgendaPanelTitle(
              title: resource!.label,
              style: TextStyle(fontSize: 12),
              height: 20,
              color: resource!.color,
              count: list.sources!.length,
              onList: () {
                controller.listResource(list, resource!.gid);
              },
              actions: []),
          Positioned(
              top: 30,
              bottom: 5,
              left: 5,
              right: 5,
              child: novoItem(list, controller,
                  child: createItems(list, controller))),
        ]),
      ),
    );
  }

  novoItem(DefaultSourceList list, controller, {Widget? child}) {
    return InkWell(
      child: child ?? CircleAvatar(radius: 15, child: Icon(Icons.add)),
      onTap: () {
        controller.onInsert(AgendaData(
            controller: controller,
            hour: controller.startHour,
            interval: controller.defaultDuracaoAgenda,
            date: dataRef,
            resource: resource!.gid,
            sources: list));
      },
    );
  }

  drag(DefaultSourceList list, controller, child) {
    bool accepted = false;
    return DragTarget<AgendaCardData>(
        onWillAccept: (d) {
          accepted = true;
          return accepted;
        },
        onLeave: (d) {
          accepted = false;
        },
        onAccept: (data) {
          var gid = data.item!.gid;
          var novo = controller.moveTo(
              data.item, data.item!.datainicio, this.resource!.gid);
          try {
            data.sources!.begin();
            list.begin();
            data.sources!.delete(gid);
            list.sources!.add(novo);
          } finally {
            data.sources!.end();
            list.end();
          }
          accepted = false;
        },
        builder: (c, items, a) => //(accepted)
            //? Icon(Icons.camera, color: Colors.grey, size: 30)
            //:
            child);
  }

  createItems(DefaultSourceList list, controller) {
    return Consumer<DefaultSourceList>(
        builder: (a, b, c) => drag(
            list,
            controller,
            Wrap(children: [
              for (AgendaItem? itemRef in list.sources!)
                Tooltip(
                  message: '${itemRef!.titulo}',
                  child: Draggable<AgendaCardData>(
                    data: AgendaCardData(item: itemRef, sources: list),
                    feedback:
                        CircleAvatar(child: Icon(Icons.my_location, size: 30)),
                    child: Card(
                      //radius: 20,
                      //backgroundColor: Colors.red,
                      child: Container(
                        width: 70,
                        height: 30,
                        child: Row(
                          children: [
                            Container(
                              color: (itemRef.domicilio == 'S')
                                  ? Colors.red
                                  : Colors.amber,
                              width: 5,
                            ), //),
                            Expanded(
                              flex: 9,
                              child: InkWell(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Text(
                                      '${itemRef.datainicio!.format('H:mm')}',
                                      style: TextStyle(fontSize: 14)),
                                ),
                                onTap: () {
                                  controller.onEdit(AgendaData(
                                    controller: controller,
                                    hour: itemRef.start!.hours,
                                    item: itemRef,
                                    date: itemRef.datainicio,
                                    sources: list,
                                    resource: itemRef.recursoGid,
                                    //sources: sources,
                                  ));
                                },
                              ),
                            ),
                            if (itemRef.completada == 1)
                              Icon(Icons.check, size: 10)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ])));
  }
}
