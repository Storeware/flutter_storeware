import 'dart:async';

import 'package:controls_web/controls/data_viewer.dart';
import 'package:controls_web/controls/dialogs_widgets.dart';
import 'package:controls_web/controls/paginated_grid.dart';
import 'package:flutter/material.dart';

//import 'package:console/views/agenda/agenda_const.dart';

import 'cube_controller.dart';
import 'cube_dataviewer.dart';
import 'cube_dimensions.dart';
import 'cube_properties.dart';
import 'package:controls_web/controls.dart';

class CubeViewTest {
  static Widget demo() {
    return Scaffold(
        appBar: AppBar(
          title: Text('x'),
        ),
        body: CubeView(
          id: 'teste',
          sources: [
            {
              'nome': 'jose silva',
              'codigo': '10',
              'unidade': 'pc',
              'precovenda': 10.10,
              "qtde": 10,
              "filial": 1
            },
            {
              'nome': 'jose silva',
              'codigo': '10',
              'unidade': 'kg',
              'precovenda': 10.10,
              "qtde": 10,
              "filial": 2
            },
            {
              'nome': 'rob silva',
              'codigo': '12',
              'unidade': 'pc',
              'precovenda': 10.10,
              "qtde": 10,
              "filial": 1
            },
            {
              'nome': 'ellen silva',
              'codigo': '13',
              'unidade': 'pc',
              'precovenda': 10.10,
              "qtde": 10,
              "filial": 1
            },
          ],
          rows: [
            CubeDimension(
              name: 'nome',
              label: 'Nome',
              width: 180,
            ),
          ],
          columns: [
            CubeDimension(
                name: 'filial', label: 'Filial', viewType: CubeViewType.both),
          ],
          values: [
            CubeDimension(
                name: 'qtde',
                label: 'Qtde',
                viewType: CubeViewType.value,
                aggrType: CubeViewAggrType.sum,
                builder: (x) {
                  return Text(x.toString());
                }),
          ],
          dimensionOptions: [
            CubeDimension(
              name: 'codigo',
              label: 'Código',
            ),
            CubeDimension(
              name: 'unidade',
              label: 'Unidade',
            ),
            CubeDimension(
              name: 'precovenda',
              label: 'Pr.Venda',
            ),
          ],
        ));
  }
}

class CubeView extends StatefulWidget {
  final String? id;
  final List<CubeDimension>? dimensionOptions;
  final CubeController? controller;
  final List<CubeDimension>? rows;
  final List<CubeDimension>? columns;
  final List<dynamic>? sources;
  final List<CubeDimension>? values;
  final Color? totalColor;
  final Color? optionsColor;
  final Color? selectsColor;
  final bool? propEnabled;
  final bool? opened;
  final AppBar? appBar;
  final Function? onReload;
  final String? textNotFind;
  const CubeView(
      {Key? key,
      this.dimensionOptions,
      this.controller,
      this.rows,
      this.columns,
      this.sources,
      this.textNotFind,
      this.id,
      this.onReload,
      this.opened = false,
      this.values,
      this.totalColor,
      this.optionsColor,
      this.appBar,
      this.propEnabled = false,
      this.selectsColor})
      : super(key: key);

  @override
  _CubeViewState createState() => _CubeViewState();
}

class _CubeViewState extends State<CubeView> {
  CubeController? controller;
  Color? _selectsColor;
  @override
  void initState() {
    super.initState();
    _selectsColor = widget.selectsColor ?? Colors.yellow[100];

    controller = widget.controller ?? CubeController();
    controller!.rows ??= widget.rows ?? [];
    controller!.columns ??= widget.columns ?? [];
    controller!.values ??= widget.values ?? [];
    controller!.dimensionOptions ??= widget.dimensionOptions ?? [];
    controller!.sources ??= widget.sources ?? [];
  }

  @override
  void dispose() {
    if (widget.controller == null) controller!.dispose();
    super.dispose();
  }

  Color get optionsColor =>
      widget.optionsColor ?? theme!.primaryColor.withAlpha(50);
  Color? get selectsColor => _selectsColor;
  ThemeData? theme;
  DataViewerController? dvController;
  @override
  Widget build(BuildContext context) {
    if (controller!.sources!.length == 0)
      return Center(
        child: Container(
            child: Text(widget.textNotFind ??
                'A seleção indicada não contém dados para mostrar')),
      );

    theme = Theme.of(context);
    controller!.id = widget.id;
    ValueNotifier<bool> opened = ValueNotifier<bool>(widget.opened!);

    dvController = DataViewerController(
      keyName: 'id',
      future: () async {
        return controller!.dataView;
      },
    );
    // inicializa;
    controller!.revisar();
    controller!.calculate();
    Timer.run(() {
      controller!.notifyChange();
    });

    return DefaultCube(
        controller: controller,
        child: StatefulBuilder(
          builder: (context, _) => Scaffold(
              appBar: widget.appBar,
              body: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: controller!.stream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Align(child: Container());
                    if (snapshot.hasData) {
                      createColumns(snapshot.data!);
                    }
                    return Column(children: [
                      ValueListenableBuilder<bool>(
                        valueListenable: opened,
                        builder: (a, b, w) => (!b)
                            ? Container()
                            : Container(
                                height: kToolbarHeight +
                                    (kMinInteractiveDimension * 2),
                                child: Column(
                                  children: [
                                    Container(
                                        height: kToolbarHeight,
                                        color: optionsColor,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Stack(
                                                children: [
                                                  CubeListDragTarget(
                                                      items: controller!
                                                          .dimensionOptions,
                                                      acceptTypes: [
                                                        CubeViewType.both,
                                                        CubeViewType.value,
                                                        CubeViewType.all
                                                      ],
                                                      onAccept: (item) {
                                                        controller!
                                                            .optionsAdd(item);
                                                      },
                                                      containerType:
                                                          CubeViewType.none),
                                                  Positioned(
                                                      right: 0,
                                                      child: Text('opções',
                                                          style: TextStyle(
                                                              color: theme!
                                                                  .dividerColor))),
                                                ],
                                              ),
                                            ),
                                            ...buildActions(context),
                                          ],
                                        )),
                                    Container(
                                      height: kMinInteractiveDimension * 2,
                                      child: Row(children: [
                                        Container(
                                            width: controller!.rowsWidth,
                                            child: Column(
                                              children: [
                                                Flexible(
                                                  flex: 1,
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                        color: selectsColor!
                                                            .withAlpha(150),
                                                        child:
                                                            CubeValuesDragtaget(),
                                                      ),
                                                      Positioned(
                                                          right: 0,
                                                          child: Text('valores',
                                                              style: TextStyle(
                                                                  color: theme!
                                                                      .dividerColor))),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  height: 1,
                                                  color: theme!.dividerColor,
                                                ),
                                                Flexible(
                                                    flex: 1,
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                            color: selectsColor,
                                                            child:
                                                                CubeRowDragtaget()),
                                                        Positioned(
                                                            right: 0,
                                                            child: Text(
                                                                'descritivos',
                                                                style: TextStyle(
                                                                    color: theme!
                                                                        .dividerColor))),
                                                      ],
                                                    )),
                                              ],
                                            )),
                                        SizedBox(
                                            width: 2,
                                            child: Container(
                                                color: theme!.dividerColor)),
                                        Expanded(
                                            child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Flexible(
                                                flex: 1,
                                                //color: Colors.yellow,
                                                child: Container(
                                                    color: selectsColor,
                                                    child: Stack(
                                                      children: [
                                                        CubeColumnDragtarget(),
                                                        Positioned(
                                                            right: 0,
                                                            child: Text(
                                                                'totalizadores',
                                                                style: TextStyle(
                                                                    color: theme!
                                                                        .dividerColor))),
                                                      ],
                                                    ))),
                                            //Flexible(flex: 1, child: Container()),
                                          ],
                                        )),
                                      ]),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                      Expanded(
                        child: Container(
                          child: (!snapshot.hasData)
                              ? null
                              : Column(
                                  children: [
                                    Container(
                                        alignment: Alignment.topLeft,
                                        width: double.maxFinite,
                                        child: ValueListenableBuilder<bool>(
                                            valueListenable: opened,
                                            builder: (a, b, w) {
                                              return IconButton(
                                                icon: Icon((b)
                                                    ? Icons.keyboard_arrow_up
                                                    : Icons
                                                        .keyboard_arrow_down),
                                                onPressed: () {
                                                  opened.value = !b;
                                                },
                                              );
                                            })),
                                    Expanded(
                                        child: CubeDataViewer(
                                            controller: dvController!))
                                  ],
                                ),
                        ),
                      ),
                    ]);
                  })),
        ));
  }

  List<Widget> buildActions(context) {
    return [
      if (widget.propEnabled!)
        IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Dialogs.showPage(context,
                  child: CubePropertiesPage(title: Text('Propriedades')));
            }),
      if (widget.onReload != null)
        IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              widget.onReload!();
              //controller.calculate();
            })
    ];
  }

  get totalBackgroudColor => widget.totalColor ?? Colors.blueGrey[100];
  get subtotalBackgrouColor => totalBackgroudColor.withAlpha(100);

  createColumns(List<Map<String, dynamic>> source) {
    //dvController.columns = [];
    dvController!.paginatedController.columns = [];
    if ((controller!.rows!.length + controller!.columns!.length) <= 2)
      dvController!.paginatedController.columns!.add(DataViewerColumn(
        name: 'icon',
        label: '',
        sort: false,
        readOnly: true,
        visible: true,
        isVirtual: true,
        builder: (i, x) => Text('.'),
      ));
    List<CubeDimension> cols = [
      ...controller!.rows!,
      if (controller!.aggrs.length == 0) ...controller!.columns!
    ];
    for (var item in cols) {
      dvController!.paginatedController.columns!.add(DataViewerColumn(
        name: item.name!,
        label: item.label!,
        width: item.width ?? 120,
        sort: false,
        builder: (i, v) {
          if (item.builder != null) return item.builder!(v);

          var k = v.keys.toList()[0];
          var x = (v[item.name] ?? '').toString();
          String? s;
          String s0;
          s0 = '${v[k] ?? ''}';

          if (!s0.contains('Total')) {
            if (item.onGetValue != null)
              s = item.onGetValue!(v[item.name!]);
            else
              s = (v[item.name] ?? '').toString();
            return Text(s ?? '');
          } else
            return SizedBox.expand(
                child: Container(
                    alignment: Alignment.centerLeft,
                    color: (s0.contains('Sub'))
                        ? subtotalBackgrouColor
                        : totalBackgroudColor,
                    child: Text(x,
                        style: TextStyle(fontWeight: FontWeight.bold))));
        },
      ));
    }

    for (var item in controller!.aggrs) {
      var option = controller!.findByName(item.aggrName!);
      var c = DataViewerColumn(
          name: item.name!,
          label: item.label!,
          numeric: true,
          sort: false,
          onGetValue: (x) {
            return (item.onGetValue != null) ? item.onGetValue!(x) : x;
          },
          builder: (i, v) {
            String? s, s0;
            var k = v.keys.toList()[0];
            s0 = '${v[k] ?? ''}';

            //print(s);
            var vl = double.tryParse(v[item.name].toString());
            if (!s0.contains('Total')) {
              if (item.onGetValue != null)
                s = item.onGetValue!(v[item.name]);
              else
                s = (v[item.name] ?? '').toString();
              if ((vl != null) && (vl == 0))
                return Text('');
              else
                return Text((s).toString());
            } else
              return SizedBox.expand(
                  child: Container(
                alignment: Alignment.centerRight,
                color: (s0.contains('Sub'))
                    ? subtotalBackgrouColor
                    : totalBackgroudColor,
                child: (vl == 0)
                    ? Text('')
                    : Text((v[item.name] ?? '').toString(),
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
              ));
          },
          width: option?.width ?? 120);
      dvController!.paginatedController.columns!.add(c);
    }

    if (dvController!.paginatedController.columns!.length == 0)
      dvController!.paginatedController.columns!
          .add(PaginatedGridColumn(name: 'none'));
  }
}

class CubeColumnDragtarget extends StatelessWidget {
  const CubeColumnDragtarget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CubeController? controller = DefaultCube.of(context)!.controller;
    var columns = controller!.columns;

    return CubeListDragTarget(
        items: columns,
        acceptTypes: [CubeViewType.column, CubeViewType.all, CubeViewType.both],
        onAccept: (item) {
          controller.columnAdd(item);
        },
        containerType: CubeViewType.column);
  }
}

class CubeRowDragtaget extends StatelessWidget {
  const CubeRowDragtaget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CubeController? controller = DefaultCube.of(context)!.controller;
    var rows = controller!.rows;

    return CubeListDragTarget(
      items: rows,
      acceptTypes: [CubeViewType.row, CubeViewType.all, CubeViewType.both],
      onAccept: (item) {
        controller.rowAdd(item);
      },
      containerType: CubeViewType.row,
    );
  }
}

class CubeValuesDragtaget extends StatelessWidget {
  const CubeValuesDragtaget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CubeController? controller = DefaultCube.of(context)!.controller;
    var rows = controller!.values;

    return CubeListDragTarget(
      items: rows,
      acceptTypes: [CubeViewType.value, CubeViewType.all],
      onAccept: (item) {
        controller.valueAdd(item);
      },
      containerType: CubeViewType.value,
    );
  }
}

class CubeListDragTarget extends StatelessWidget {
  final List<CubeDimension>? items;
  final Function(CubeDimension)? onAccept;
  final List<CubeViewType>? acceptTypes;
  final CubeViewType? containerType;
  const CubeListDragTarget({
    Key? key,
    this.items,
    this.onAccept,
    this.acceptTypes,
    @required this.containerType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool accepted = false;
    List<CubeViewType> _types = acceptTypes ?? [CubeViewType.both];
    return DragTarget<CubeDimension>(
      builder: (a, b, c) => SizedBox.expand(
        child: Wrap(children: [
          for (var index = 0; index < items!.length; index++)
            Container(
              width: 100,
              child: _BuildDragSpace(
                  index: index,
                  item: items![index],
                  type: containerType!,
                  child:
                      CubeOptionsDraggable(item: items![index], index: index)),
            ),
          if (accepted) Icon(Icons.flip_to_front, size: 32),
        ]),
      ),
      onAccept: (item) {
        onAccept!(item);
        accepted = false;
      },
      onLeave: (item) => accepted = false,
      onWillAccept: (item) {
        return accepted = _types.contains(item!.viewType);
      },
      onAcceptWithDetails: (item) {},
    );
  }
}

class CubeOptionsDraggable extends StatelessWidget {
  const CubeOptionsDraggable({
    Key? key,
    @required this.item,
    this.index,
  }) : super(key: key);

  final CubeDimension? item;
  final int? index;

  @override
  Widget build(BuildContext context) {
    item!.tag = index;
    return Draggable<CubeDimension>(
      data: item,
      feedback: Container(
          width: 70,
          color: Colors.transparent,
          child: Rounded(
            width: 100,
            height: 60,
            child: Text(
              item!.label!,
              style: TextStyle(fontSize: 14),
            ),
          )
          //FlatButton(child: Text(item.label), onPressed: () {}),
          ),
      child: CubeOptionButton(item: item!),
      //childWhenDragging: Rounded(
      //color: Colors.grey,
      //onPressed: () {},
      //  child: Text(item.label),
      //),
    );
  }
}

class _BuildDragSpace extends StatelessWidget {
  final CubeDimension? item;
  final CubeViewType? type;
  final int? index;
  final Widget? child;
  const _BuildDragSpace({
    Key? key,
    @required this.item,
    @required this.type,
    @required this.index,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool accepted = false;
    var cube = DefaultCube.of(context);
    return DragTarget<CubeDimension>(
      builder: (a, b, c) {
        return Row(
          children: [
            if (accepted) Container(child: Icon(Icons.flip_to_front)),
            Expanded(child: child!),
          ],
        );
      },
      onAccept: (x) {
        switch (type) {
          case CubeViewType.column:
            cube!.controller!.columnAdd(x, index: index);
            break;
          case CubeViewType.row:
            cube!.controller!.rowAdd(x, index: index);
            break;
          case CubeViewType.value:
            cube!.controller!.valueAdd(x, index: index);
            break;
          case CubeViewType.none:
            cube!.controller!.optionsAdd(x, index: index);
            break;
          default:
        }
      },
      onLeave: (x) {
        accepted = false;
      },
      onWillAccept: (x) {
        switch (type) {
          case CubeViewType.column:
            return accepted = [
              CubeViewType.both,
              CubeViewType.column,
              CubeViewType.all
            ].contains(item!.viewType);

          case CubeViewType.row:
            return accepted = [
              CubeViewType.both,
              CubeViewType.row,
              CubeViewType.all
            ].contains(item!.viewType);

          case CubeViewType.value:
            return accepted = [
              CubeViewType.all,
              CubeViewType.value,
            ].contains(item!.viewType);
          case CubeViewType.none:
            return accepted = true;

          default:
        }
        return accepted = false;
      },
    );
  }
}

class CubeOptionButton extends StatelessWidget {
  const CubeOptionButton({
    Key? key,
    @required this.item,
  }) : super(key: key);

  final CubeDimension? item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child:
          Rounded(height: 30, color: Colors.white, child: Text(item!.label!)),
    );
  }
}
