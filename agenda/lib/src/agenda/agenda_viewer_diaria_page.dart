// @dart=2.12
//import 'package:console/views/agenda/expansion_card.dart';
import 'package:controls_web/controls/index.dart';
import 'package:controls_web/controls/responsive.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'agenda_cards.dart';
import 'agenda_const.dart';
import 'agenda_controller.dart';
import 'agenda_excluir_item.dart';
import 'agenda_notifier.dart';
import 'agenda_resource.dart';
import 'agenda_timeline_dart.dart';
import 'data_slider.dart';
import 'dropdown_menu.dart';
import 'models/agenda_config.dart';
import 'models/agenda_item_model.dart';
import 'package:controls_extensions/extensions.dart';
import 'dart:ui' as ui;

class AgendaDiariaPage extends StatelessWidget {
  const AgendaDiariaPage({
    Key? key,
    required this.dataRef,
    required this.resources,
  }) : super(key: key);

  final List<AgendaResource> resources;
  final DateTime? dataRef;
  @override
  Widget build(BuildContext context) {
    var controller = DefaultAgenda.of(context)!.controller!;
    DateFormat formated = DateFormat('dd MMM', 'pt_BR');

    ResponsiveInfo? responsive = ResponsiveInfo(context);
    double w = controller.size.width / (resources.length);
    if (w > kPanelWidth) w = kPanelWidth;
    if (w < 100) w = 100;
    //print(w);
    //print('builder-diario - OK');
    return Scaffold(
      body: Row(
        children: [
          /// monta a barra laterel com os horários
          VerticalTimeline(
              start: AgendaConfig().nHoraInicio,
              end: AgendaConfig().nHoraFim,
              date: dataRef,
              title: formated.format(dataRef!),
              onPrior: () {
                var x = DefaultAgenda.of(context)!;
                controller.dataChange(x.controller!.data!.dayBefore());
              },
              onNext: () {
                var x = DefaultAgenda.of(context)!;
                controller.dataChange(x.controller!.data!.dayAfter());
              },
              onList: () {
                //controller.listResource(resource);
              }),
          Expanded(
            child: ListView(
                scrollDirection: Axis.horizontal,
                primary: false,
                padding: EdgeInsets.zero,
                children: [
                  /// monta as coluna do recurso
                  for (var item in resources)
                    AgendaPanelWidget(
                      titleHeigth: responsive.isMobile
                          ? kTitleHeightSmall
                          : kTitleHeight,
                      title: item.label,
                      resource: item.gid,
                      color: item.color,
                      dataRef: dataRef,
                      width: w.max(responsive.isMobile ? kPanelWidthSmall : w),
                    )
                ]),
          ),
        ],
      ),
      bottomNavigationBar: DataSlider(
          dataRef: dataRef,
          controller: controller,
          format: (d) => d.format('dd/MMM'),
          datas: [
            for (var i = -3; i < 4; i++) dataRef!.add(Duration(days: i))
          ]),
    );
  }
}

class AgendaDeleteItemTarget extends StatelessWidget {
  const AgendaDeleteItemTarget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    bool accepted = false;
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: DragTarget<AgendaCardData>(
        builder: (BuildContext context, List<AgendaCardData?> candidateData,
            List<dynamic> rejectedData) {
          return CircleAvatar(
            child: Icon(
              Icons.delete,
              size: (accepted) ? 60 : 40,
            ),
            radius: (accepted) ? 50 : 30,
          );
        },
        onAccept: (data) {
          //print(data.item.toJson());
          AgendaItem item = data.item!;
          var gid = item.gid;
          AgendaController? controller = DefaultAgenda.of(context)!.controller;
          AgendaDialogs.excluirItem(context, controller, item).then((rsp) {
            //print(rsp);
            if (rsp) data.sources!.delete(gid);
          });

          accepted = false;
        },
        onWillAccept: (data) {
          accepted = true;
          return true;
        },
        onLeave: (data) {
          accepted = false;
        },
      ),
    );
  }
}

class AgendsaPanelWidgetData {
  Color? _color;
  ThemeData? theme;
  late Size size;
  Map<int, List<AgendaItem>> mapa = {};
}

/// [AgendaPanelWidget] Monta o painel do recurso onde ira receber os horários da agenda
class AgendaPanelWidget extends StatelessWidget {
  final String? title;
  final double width;
  final Color? color;
  final double titleHeigth;
  final String? resource;
  final DateTime? dataRef;
  final double elevation;
  AgendaPanelWidget({
    Key? key,
    this.width = 120,
    this.title,
    this.color,
    this.titleHeigth = kTitleHeight,
    this.resource,
    this.dataRef,
    this.elevation = 1,
  }) : super(key: key);

  final AgendsaPanelWidgetData dados = AgendsaPanelWidgetData();
  Map<int, List<AgendaItem>> get mapa => dados.mapa;
  get theme => dados.theme;
  //get widget => this;

  addMapa(AgendaItem item) {
    //print('addMap( $item )');
    int hora = item.datainicio!.hour;
    if (dados.mapa[hora] == null) dados.mapa[hora] = [];
    dados.mapa[hora]!.add(item);
  }

  Point mapaCount(AgendaItem item) {
    int i = 0;
    int p = 0;
    dados.mapa.keys.forEach((k) {
      dados.mapa[k]!.forEach((v) {
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

  /* int mapaIndexOf(AgendaItem item) {
    int hora = item.datainicio.hour;
    return dados.mapa[hora].indexOf(item);
  }
*/
  Point panelPoint(AgendaItem item, double width) {
    //var idx = mapaIndexOf(item);
    //if (idx < 0) return Point(x: width, y: 0);
    Point p = mapaCount(item); //.datainicio.hour);
    double len = ((p.x! > 0) ? (width ~/ p.x!) : width) + 0.0;
    double y = p.y!;
    // print([p.toJson(), len, y, y * len]);
    return Point(x: len, y: y * len);
  }

  @override
  Widget build(BuildContext context) {
    //print(width);
    dados.size = MediaQuery.of(context).size;
    dados.theme = Theme.of(context);
    dados._color = color ?? theme.primaryColor;
    bool accepted = false;
    ResponsiveInfo responsive = ResponsiveInfo(context);

    AgendaController controller = DefaultAgenda.of(context)!.controller!;
    DefaultSourceList list = DefaultSourceList(sources: []);
    list.sources!.clear();
    list.sources!.addAll(controller.sourceWhere(resource, dataRef));

    /// monta a lista de itens por horario - concentração
    return ChangeNotifierProvider<DefaultSourceList>.value(
        value: list,
        builder: (a, b) {
          return Consumer<DefaultSourceList>(builder: (a, list, w) {
            dados.mapa = {};
            list.sources!
                .sort((a, b) => a!.datainicio!.compareTo(b!.datainicio!));

            list.sources!.forEach((item) {
              addMapa(item!);
            });
            DefaultAgenda.setContext(context);

            return Card(
              margin: EdgeInsets.all(responsive.isMobile ? 1.0 : 4.0),
              elevation: responsive.isMobile ? 0.0 : elevation,
              child: DragTarget<AgendaCardData>(
                onAccept: (data) {
                  try {
                    //if (data == null) return;
                    accepted = true;
                    var item = data.item!;
                    controller.moveTo(item, item.start, resource);
                  } catch (e) {
                    //
                  }
                  accepted = false;
                },
                onWillAccept: (item) {
                  accepted = true;
                  return accepted;
                },
                onLeave: (item) {
                  accepted = false;
                },
                builder: (context, list1, list2) {
                  //print('Builder Resources $title');

                  return Container(
                    width: width,
                    height: dados.size.height,
                    color: dados._color!.withAlpha(50),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          child: AgendaPanelTitle(
                            // titulo da coluna
                            width: width,
                            title: title,
                            color: dados._color,
                            count: list.sources!.length,
                            onList: () {
                              controller.listResource(list, resource);
                            },
                          ),
                        ),

                        /// cria as divisorias por horario
                        for (var i = controller.iStart;
                            i < controller.iEnd;
                            i++)
                          Positioned(
                            top: controller.calcTop(i + 0.0),
                            child: Container(
                              // area do grid de de recruso
                              height: controller.cardHeigth,
                              width: width,
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 1,
                                          color: Colors.grey.withAlpha(50)))),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  BackgroudContainer(
                                      // drag esquerdo
                                      width: 40,
                                      date: dataRef,
                                      hour: i + 0.0,
                                      interval:
                                          (controller.defaultDuracaoAgenda *
                                                  2) ~/
                                              1,
                                      resource: resource,
                                      sources: list),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Expanded(
                                            // drag centro superior
                                            flex: 1,
                                            child: BackgroudContainer(
                                                date: dataRef,
                                                hour: i + 0.0,
                                                resource: resource,
                                                sources: list)),
                                        Expanded(
                                            // drag centro inferior
                                            flex: 1,
                                            child: BackgroudContainer(
                                                date: dataRef,
                                                hour: i + 0.5,
                                                divider: false,
                                                resource: resource,
                                                sources: list)),
                                      ],
                                    ),
                                  ),
                                  BackgroudContainer(
                                      // drag direito
                                      width: 40,
                                      date: dataRef,
                                      hour: i + 0.5,
                                      interval:
                                          (controller.defaultDuracaoAgenda *
                                                  2) ~/
                                              1,
                                      resource: resource,
                                      sources: list),
                                ],
                              ),
                            ),
                          ),

                        /// mostra os cards da agenda
                        ...buildItem(context, list, controller)
                      ],
                    ),
                  );
                },
              ),
            );
          });
        });
  }

  List<Widget> buildItem(BuildContext context, list, controller) {
    List<Widget> lst = [];
    if (mapa.length == 0) return [];
    // inverter a ordem para o drop ficar por cima do item inferior
    for (int x = mapa.length - 1; x > -1; x--) {
      int hora = mapa.keys.elementAt(x);
      //   for (var idx in mapa.keys) {
      List<AgendaItem>? items = mapa[hora];
      items!.sort((a, b) => a.datainicio!.compareTo(b.datainicio!));
      if (horaItemCount(items[0]) > 1)
        lst.add(buildMultiAgendaItem(
            context, hora, items, list, controller, width));
      else
        for (var card in items)
          lst.add(buildDefaultAgendaItem(context, card, list, controller));
    }
    return lst;
  }

  int horaItemCount(AgendaItem item) {
    return mapa[item.datainicio!.hour]!.length;
  }

  Widget buildMultiAgendaItem(
      BuildContext context,
      int itemIndex,
      List<AgendaItem> items,
      DefaultSourceList sources,
      AgendaController controller,
      double width) {
    Point point = panelPoint(items[0], width);

    return Positioned(
        top: controller.calcTop((items[0].start!.hours ~/ 1) + 0.0),
        left: point.y,
        child: Container(
          //alignment: Alignment.center,
          //height: kMinInteractiveDimension,
          color: Colors.amber,
          width: width,
          child: DragTagetMultItem(
              list: sources,
              item: items[0],
              herdarResourseGid: true,
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
                                item: litems[idx],
                                mostrarResource: true,
                                width: width,
                                herdarResourceGid: true,
                                showHours: true,
                                sources: sources);
                          })));
                },
                title: Text('${items.length} agendas'),
              )),
        ));
  }

  /// criar os Cards da agenda - itens da agenda
  Widget buildDefaultAgendaItem(BuildContext context, AgendaItem item,
      DefaultSourceList sources, AgendaController controller) {
    Point point = panelPoint(item, width);
    var _startHours = item.start!.hours;

    /// DONE: se um item vem do dia anterior, precisa ajustar a hora de inicio no visual
    if (controller.data!.startOfDay().isAfter(item.start!))
      _startHours = controller.startHour!;
    return Positioned(
      top: controller.calcTop(_startHours + 0.0),
      left: point.y,
      child: ChangeNotifierProvider.value(
          value: AgendaItemNotifier(value: item),
          child: Consumer<AgendaItemNotifier>(
            builder: (_, itemRef, __) {
              return DefaultAgendaItem(
                item: itemRef.value,
                sources: sources,
                child: AgendaCardItem(
                  controller: controller,
                  item: itemRef.value,
                  width: point.x! - 10,
                  herdarResourceGid: true,
                  sources: sources,
                ),
              );
            },
          )),
    );
  }
}

class BackgroudContainer extends StatelessWidget {
  final DateTime? date;
  final double? hour;
  final DefaultSourceList? sources;
  final bool divider;
  final String? resource;
  final double? width;
  final Color? color;
  final int alpha;
  final int? interval;
  const BackgroudContainer(
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
                    ? Border(bottom: BorderSide(width: 1, color: Colors.grey))
                    : null),
            child: (accepted && (interval != null))
                ? Text('$interval min', style: TextStyle(fontSize: 12))
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
        //print('onAccepted');
        try {
          AgendaController controller = DefaultAgenda.of(context)!.controller!;
          DateTime dt = toDate(date)
              .add(Duration(hours: toHour(hour!), minutes: toMinutes(hour!)));
          var item =
              controller.moveTo(data.item!, dt, resource, interval: interval);
          data.sources!.begin();
          sources!.begin();
          try {
            data.sources!.delete(data.item!.gid);
            sources!.add(item);
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

/// Custom MenuButton to display a menu button following Material Design example
class MenuButton<T> extends StatefulWidget {
  const MenuButton(
      {required final this.child,
      required final this.items,
      required final this.itemBuilder,
      final this.toggledChild,
      final this.divider = const Divider(
        height: 1,
        color: Colors.grey,
      ),
      final this.topDivider = true,
      final this.onItemSelected,
      final this.decoration,
      final this.onMenuButtonToggle,
      final this.scrollPhysics = const NeverScrollableScrollPhysics(),
      final this.popupHeight,
      final this.crossTheEdge = false,
      final this.edgeMargin = 0.0,
      final this.showSelectedItemOnList = true,
      final this.selectedItem,
      final this.label,
      final this.labelDecoration,
      final this.itemBackgroundColor = Colors.white,
      final this.menuButtonBackgroundColor = Colors.white})
      : assert(showSelectedItemOnList || selectedItem != null);

  /// Widget to display the default button to trigger the menu button
  final Widget child;

  /// Same as child but when the menu button is opened
  final Widget? toggledChild;

  /// A widget to design each item of the menu button
  final MenuItemBuilder<T> itemBuilder;

  /// Divider widget [default = true]
  final Widget divider;

  /// Top Divider visibility [default = Divider(height: 1, color: Colors.grey)]
  final bool topDivider;

  /// List of all items available on the menu
  final List<T> items;

  /// Action to do when an item is selected
  final MenuItemSelected<T>? onItemSelected;

  /// A custom decoration for menu button
  final BoxDecoration? decoration;

  /// Function triggered when menu button is triggered
  final MenuButtonToggleCallback? onMenuButtonToggle;

  /// Determines the scroll physics [default = NeverScrollableScrollPhysics()]
  final ScrollPhysics scrollPhysics;

  /// Force a define height for the popup view
  final double? popupHeight;

  /// Set it to true if you want the button to expand
  final bool crossTheEdge;

  /// Prevent the button to not touch the edge
  final double edgeMargin;

  /// Display or not the selected item on the list [default = true]
  final bool showSelectedItemOnList;

  /// Define the selected item
  final T? selectedItem;

  /// Add a label on top of the menu button as Material design
  final Text? label;

  /// Custom LabelDecoration if you use a label
  final LabelDecoration? labelDecoration;

  /// Background color of items [default = Colors.white]
  final Color itemBackgroundColor;

  /// Background color of menu button [default = Colors.white]
  final Color menuButtonBackgroundColor;

  @override
  State<StatefulWidget> createState() => _MenuButtonState<T>();
}

class _MenuButtonState<T> extends State<MenuButton<T>> {
  /// Keep an instance of old selected item if necessary
  T? oldItem;

  /// The current selected item
  late T selectedItem;

  /// Custom LabelDecoration if you use a label
  late LabelDecoration labelDecoration;

  /// Automatically calculated depending on the label [Text] widget
  late Size labelTextSize;

  /// Value containing the current state of the menu
  bool toggledMenu = false;

  /// The button used as [child]
  late Widget button;

  /// With of the button which is automatically calculated
  late double buttonWidth;

  /// A custom decoration for menu button
  late BoxDecoration decoration;

  void _updateLabelTextSize() {
    if (widget.label != null) {
      setState(
        () => labelTextSize = MenuButtonUtils.getTextSize(
          widget.label!.data,
          widget.label!.style,
        ),
      );
    }
  }

  /// Update the button and make it clickable
  void _updateButton() {
    setState(
      () => button = Container(
        decoration: decoration,
        child: Material(
          color: widget.menuButtonBackgroundColor,
          child: InkWell(
            borderRadius: decoration.borderRadius != null
                ? decoration.borderRadius as BorderRadius
                : null,
            child: Container(
              child: widget.child,
            ),
            onTap: togglePopup,
          ),
        ),
      ),
    );
  }

  /// Define the label decoration if label is used
  /// Default label decoration of parameter is not used or your custom label decoration
  void _updateLabelDecoration() {
    setState(
      () {
        if (widget.label == null && widget.labelDecoration == null) {
          labelDecoration = const LabelDecoration(
              leftPosition: 0,
              verticalMenuPadding: 0,
              background: Colors.transparent);
        } else if (widget.label != null && widget.labelDecoration == null) {
          labelDecoration = const LabelDecoration();
        } else if (widget.label != null) {
          labelDecoration = widget.labelDecoration!;
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    setState(
      () {
        decoration = widget.decoration ??
            BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: const BorderRadius.all(
                Radius.circular(3.0),
              ),
            );
        button = Container(
          decoration: decoration,
          child: Material(
            color: widget.menuButtonBackgroundColor,
            child: InkWell(
              child: Container(
                child: widget.child,
              ),
              onTap: togglePopup,
            ),
          ),
        );
      },
    );
    _updateLabelDecoration();
    _updateLabelTextSize();
  }

  @override
  void didUpdateWidget(MenuButton<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateLabelTextSize();
    _updateLabelDecoration();
    _updateButton();
  }

  @override
  Widget build(BuildContext context) {
    return widget.label == null
        ? button
        : Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: labelDecoration.verticalMenuPadding,
                ),
                child: button,
              ),
              Positioned(
                top: labelDecoration.verticalMenuPadding,
                left: labelDecoration.leftPosition,
                child: Container(
                  width: labelTextSize.width + labelDecoration.leftPosition,
                  height: decoration.border?.top.width ?? 0,
                  color: Theme.of(context).backgroundColor,
                ),
              ),
              Positioned(
                top: labelDecoration.verticalMenuPadding / 2,
                left: labelDecoration.leftPosition,
                child: Container(
                  color: labelDecoration.background,
                  width: labelTextSize.width + labelDecoration.leftPosition,
                  height: labelTextSize.height / 2,
                ),
              ),
              Positioned(
                top: labelDecoration.verticalMenuPadding,
                left: labelDecoration.leftPosition,
                child: Container(
                  color: labelDecoration.background,
                  width: labelTextSize.width + labelDecoration.leftPosition,
                  height: labelTextSize.height / 2,
                ),
              ),
              Positioned(
                top: (0 - labelTextSize.height / 2) +
                    labelDecoration.verticalMenuPadding,
                left: labelDecoration.leftPosition +
                    labelDecoration.leftPosition / 2,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  opacity: toggledMenu ? 0 : 1,
                  child: widget.label,
                ),
              ),
            ],
          );
  }

  /// The method to toggle the popup when button is pressed
  void togglePopup() {
    setState(() => toggledMenu = !toggledMenu);
    if (widget.onMenuButtonToggle != null) {
      widget.onMenuButtonToggle!(toggledMenu);
    }
    if (!widget.showSelectedItemOnList) {
      setState(() => selectedItem = widget.selectedItem!);
      MenuButtonUtils.showSelectedItemOnList(
          oldItem, selectedItem, widget.items);
    }

    final List<Widget> items = widget.items
        .map((T value) => _MenuItem<T>(
              value: value,
              child: widget.itemBuilder(value),
              itemBackgroundColor: widget.itemBackgroundColor,
            ))
        .toList();
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context)!.context.findRenderObject() as RenderBox;
    buttonWidth = button.size.width;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset(0, labelDecoration.verticalMenuPadding),
            ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    if (items.isNotEmpty) {
      _togglePopup(
        context: context,
        position: position,
        items: items,
        toggledChild: widget.toggledChild,
        divider: widget.divider,
        topDivider: widget.topDivider,
        decoration: decoration,
        scrollPhysics: widget.scrollPhysics,
        popupHeight: widget.popupHeight,
        edgeMargin: widget.edgeMargin,
        crossTheEdge: widget.crossTheEdge,
        itemBackgroundColor: widget.itemBackgroundColor,
      ).then<void>((T? newValue) {
        setState(() => toggledMenu = !toggledMenu);
        if (widget.onMenuButtonToggle != null) {
          widget.onMenuButtonToggle!(toggledMenu);
        }
        if (!widget.showSelectedItemOnList && newValue != null) {
          setState(() => oldItem = selectedItem);
          setState(() => selectedItem = newValue);
        }
        if (mounted && newValue != null && widget.onItemSelected != null) {
          widget.onItemSelected!(newValue);
        }
      });
    }
  }

  Future<T?> _togglePopup({
    required BuildContext context,
    required RelativeRect position,
    required List<Widget> items,
    required BoxDecoration decoration,
    required bool topDivider,
    required bool crossTheEdge,
    required double edgeMargin,
    required Color itemBackgroundColor,
    required ScrollPhysics scrollPhysics,
    required Widget divider,
    double? popupHeight,
    Widget? toggledChild,
  }) =>
      Navigator.push(
        context,
        _MenuRoute<T>(
            position: position,
            items: items,
            toggledChild: toggledChild,
            divider: divider,
            topDivider: topDivider,
            decoration: decoration,
            scrollPhysics: scrollPhysics,
            popupHeight: popupHeight,
            crossTheEdge: crossTheEdge,
            edgeMargin: edgeMargin,
            buttonWidth: buttonWidth,
            itemBackgroundColor: itemBackgroundColor),
      );
}

/// A custom [PopupRoute] which is pushed on [Navigator] when menu button is toggled
class _MenuRoute<T> extends PopupRoute<T> {
  _MenuRoute(
      {required final this.position,
      required final this.items,
      required final this.topDivider,
      required final this.decoration,
      required final this.crossTheEdge,
      required final this.edgeMargin,
      required final this.buttonWidth,
      required final this.itemBackgroundColor,
      required final this.scrollPhysics,
      required final this.divider,
      final this.popupHeight,
      final this.toggledChild});

  /// Position of the popup
  final RelativeRect position;

  /// List of all items available on the menu
  final List<Widget> items;

  /// Divider widget
  final Widget divider;

  /// Top Divider visibility
  final bool topDivider;

  /// A custom decoration for menu button
  final BoxDecoration decoration;

  /// Determines the scroll physics
  final ScrollPhysics scrollPhysics;

  /// Expand the button width or not
  final bool crossTheEdge;

  /// Prevent the button to not touch the edge
  final double edgeMargin;

  /// With of the button which is automatically calculated
  final double buttonWidth;

  /// Background color of items
  final Color itemBackgroundColor;
  final Widget? toggledChild;

  /// Force a define height for the popup view
  final double? popupHeight;

  @override
  Color? get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => null;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  Animation<double> createAnimation() => CurvedAnimation(
        parent: super.createAnimation(),
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) =>
      MediaQuery.removePadding(
        context: context,
        removeTop: true,
        removeBottom: true,
        removeLeft: true,
        removeRight: true,
        child: Builder(
          builder: (BuildContext context) {
            return CustomSingleChildLayout(
              delegate: _MenuRouteLayout(
                position,
              ),
              child: _Menu<T>(
                route: this,
                scrollPhysics: scrollPhysics,
                popupHeight: popupHeight,
                crossTheEdge: crossTheEdge,
                edgeMargin: edgeMargin,
                buttonWidth: buttonWidth,
                itemBackgroundColor: itemBackgroundColor,
              ),
            );
          },
        ),
      );
}

/// Positioning of the menu on the screen.
class _MenuRouteLayout extends SingleChildLayoutDelegate {
  _MenuRouteLayout(this.position);

  /// Rectangle of underlying button, relative to the overlay's dimensions.
  final RelativeRect position;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints.loose(constraints.biggest);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) =>
      Offset(position.left, position.top);

  @override
  bool shouldRelayout(_MenuRouteLayout oldDelegate) =>
      position != oldDelegate.position;
}

class _Menu<T> extends StatefulWidget {
  const _Menu({
    Key? key,
    required final this.route,
    required this.edgeMargin,
    required final this.crossTheEdge,
    required this.buttonWidth,
    required final this.itemBackgroundColor,
    required final this.scrollPhysics,
    final this.popupHeight,
  }) : super(key: key);

  final _MenuRoute<T> route;

  /// Determines the scroll physics
  final ScrollPhysics scrollPhysics;

  /// Expand the button width or not
  final bool crossTheEdge;

  /// Prevent the button to not touch the edge
  final double edgeMargin;

  /// With of the button which is automatically calculated
  final double buttonWidth;

  /// Background color of items
  final Color itemBackgroundColor;

  /// Force a define height for the popup view
  final double? popupHeight;

  @override
  __MenuState<T> createState() => __MenuState<T>();
}

class __MenuState<T> extends State<_Menu<T>> {
  final GlobalKey key = GlobalKey();

  /// The calculated width if [crossTheEdge] is set to true
  double? width;

  @override
  void initState() {
    super.initState();
    if (widget.crossTheEdge == true) {
      WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
        final RenderBox renderBox =
            key.currentContext!.findRenderObject() as RenderBox;
        final Offset offset = renderBox.globalToLocal(Offset.zero);
        final double x = offset.dx.abs();
        final double screenWidth = MediaQuery.of(context).size.width;

        setState(() => width = screenWidth - x - widget.edgeMargin);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];

    if (widget.route.topDivider) {
      children.add(widget.route.divider);
    }

    for (int i = 0; i < widget.route.items.length; i += 1) {
      children.add(widget.route.items[i]);

      if (i < widget.route.items.length - 1) {
        children.add(widget.route.divider);
      }
    }

    final CurveTween opacity =
        CurveTween(curve: const Interval(0.0, 1.0 / 8.0));
    final CurveTween height = CurveTween(curve: const Interval(0.0, .9));
    final CurveTween shadow = CurveTween(curve: const Interval(0.0, 1.0 / 4.0));

    return Material(
      color: Colors.transparent,
      child: AnimatedBuilder(
        animation: widget.route.animation!,
        builder: (BuildContext context, Widget? child) => Opacity(
          opacity: opacity.evaluate(widget.route.animation!),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            key: key,
            width: width ?? widget.buttonWidth,
            height: widget.popupHeight,
            decoration: BoxDecoration(
              color: widget.route.decoration.color ??
                  widget.route.itemBackgroundColor,
              border: widget.route.decoration.border,
              borderRadius: widget.route.decoration.borderRadius != null
                  ? widget.route.decoration.borderRadius
                  : null,
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Color.fromARGB(
                        (20 * shadow.evaluate(widget.route.animation!)).toInt(),
                        0,
                        0,
                        0),
                    offset: Offset(
                        0.0, 3.0 * shadow.evaluate(widget.route.animation!)),
                    blurRadius: 5.0 * shadow.evaluate(widget.route.animation!))
              ],
            ),
            child: ClipRRect(
              borderRadius: widget.route.decoration.borderRadius != null
                  ? widget.route.decoration.borderRadius as BorderRadius
                  : BorderRadius.zero,
              child: IntrinsicWidth(
                child: SingleChildScrollView(
                  physics: widget.scrollPhysics,
                  child: ListBody(children: <Widget>[
                    _MenuButtonToggledChild(
                      child: widget.route.toggledChild ?? Container(),
                      itemBackgroundColor: widget.itemBackgroundColor,
                    ),
                    Align(
                      alignment: AlignmentDirectional.topStart,
                      widthFactor: 1.0,
                      heightFactor: height.evaluate(widget.route.animation!),
                      child: SingleChildScrollView(
                        child: ListBody(
                          children: children,
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Class to build the menu button toggled child (button display when menu button is toggled)
class _MenuButtonToggledChild extends StatelessWidget {
  const _MenuButtonToggledChild(
      {required final this.child, required this.itemBackgroundColor});

  /// Child [Widget] used for the menu button when toggled
  final Widget child;

  /// Background color of items
  final Color itemBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: itemBackgroundColor,
      child: InkWell(
        onTap: () => Navigator.of(context).pop(),
        child: child,
      ),
    );
  }
}

/// Class to build each menu item and make it clickable
class _MenuItem<T> extends StatelessWidget {
  const _MenuItem(
      {required this.value,
      required final this.child,
      required this.itemBackgroundColor});

  /// The value of the item
  final T value;

  /// The child [Widget] of the item
  final Widget child;

  /// The background color of the item
  final Color itemBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: itemBackgroundColor,
      child: InkWell(
          onTap: () => Navigator.of(context).pop<T>(value), child: child),
    );
  }
}

/// Class to define a custom decoration for a label
class LabelDecoration {
  const LabelDecoration({
    this.verticalMenuPadding = 12,
    this.leftPosition = 6,
    this.background = Colors.white,
  });

  /// Vertical padding of the label [default = 12]
  final double verticalMenuPadding;

  /// Padding on the left side of the label [default = 6]
  final double leftPosition;

  /// Background color of the label [default = Colors.white]
  final Color background;
}

/// Utils class with useful method
/// [getTextSize] - Calculate text size from a [Text] widget
/// [showSelectedItemOnList] - Create a new map without the selected item
class MenuButtonUtils {
  static Size getTextSize(String? text, TextStyle? style) {
    //TextDirection? td = TextDirection.LTR;
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: ui.TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  static Map<String, dynamic> showSelectedItemOnList(
      dynamic oldSelected, dynamic selectedItem, List<Object?> items) {
    if (oldSelected != selectedItem) {
      final Map<String, Object?> res = <String, Object?>{
        'oldSelected': oldSelected,
        'selectedItem': selectedItem,
        'items': items,
      };

      if (oldSelected == null) {
        items.removeWhere((dynamic element) => element == selectedItem);
        return res;
      }

      bool isOldSelectedAlready = false;
      items.forEach((dynamic element) {
        if (element == oldSelected) {
          isOldSelectedAlready = true;
        }
      });

      items.removeWhere((Object? element) => element == selectedItem);
      if (!isOldSelectedAlready) {
        items.add(oldSelected);
      }

      return res;
    }

    return <String, Object>{};
  }
}

typedef MenuButtonToggleCallback = void Function(bool isToggle);

typedef MenuItemBuilder<T> = Widget Function(T value);

typedef MenuItemSelected<T> = void Function(T value);
