import 'package:controls_web/controls/responsive.dart';
import 'package:controls_web/drivers/bloc_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

/// clase de teste para Kanban
class KanbanSample extends StatefulWidget {
  const KanbanSample({Key? key}) : super(key: key);

  @override
  State<KanbanSample> createState() => _KanbanSampleState();
}

class _KanbanSampleState extends State<KanbanSample> {
  @override
  Widget build(BuildContext context) {
    //print('kanbnTest');
    return KanbanGrid(
        primaryKey: 'id',
        columnKeyName: 'id', // coluna com o valor do card
        builder: (column, row, data) {
          return ListTile(title: Text(data['nome']));
        },
        columns: [
          KanbanColumn(id: 1 /* valor que separa o card */, label: 'Title 1'),
          KanbanColumn(
              id: 2,
              label: 'Title 2',
              dragColor: Colors.amber,
              onNewItem: (ctr, column) {
                ctr.add(
                    {"id": column.id, "ordem": 1, "nome": "teste1", "qtde": 1});
              }),
        ],
        source: const [
          {"id": 1, "ordem": 1, "nome": "teste1", "qtde": 1},
          {"id": 2, "ordem": 2, "nome": "teste2", "qtde": 2},
        ],
        onNewItem: (ctr, item) {
          var i = item ?? 1;
          if (item != null) i = item.data['id'] ?? 1;
          ctr.add({"id": i, "ordem": 1, "nome": "teste1", "qtde": 1});
        },
        onDeleteItem: (ctr) {
          ctr.controller?.delete(ctr.data);
        });
  }
}

enum KanbanGridDragSide { left, right }

class DefaultKanbanGrid extends InheritedWidget {
  DefaultKanbanGrid({
    Key? key,
    @required this.kanbanGrid,
    Widget? child,
  }) : super(key: key, child: child!);
  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }

  final KanbanGrid? kanbanGrid;
  static DefaultKanbanGrid? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType();
}

class KanbanSlideAction {
  final Key? key;
  final String? label;
  final IconData? icon;
  final Widget? image;
  final Function(dynamic)? onPressed;
  final SlidableAction Function(dynamic)? builder;
  final Color? color;
  final Color? foregroundColor;
  final bool? closeOnTap;
  KanbanSlideAction(
      {this.key,
      this.label,
      this.icon,
      this.image,
      this.onPressed,
      this.builder,
      this.color,
      this.foregroundColor,
      this.closeOnTap}); //: assert((builder != null) && (icon != null || image != null));
}

/// Class [KanbanGrid]
/// Fornecer [KanbanGrid.souce] contendo os dados a serem mostrados;
/// [KanbanColumn] indica os cards verticais usados no kanban
///
class KanbanGrid extends StatefulWidget {
  final List<KanbanColumn>? columns;
  final bool? showProcessing;
  final double? minWidth;
  final double? itemHeight;
  final double? headerHeight;
  final Widget? columnBottom;
  final double? dropElevation;
  final IconData? dragIcon;
  final IconData? dropIcon;
  final Widget? feedback;
  final List<KanbanGridDragSide>? dragSide;

  /// [onAcceptItem] é chamado para gravar um item
  final Future<bool> Function(KanbanController, KanbanColumn, dynamic)?
      onAcceptItem;

  /// [builder] é chamado para criar os itens
  final Widget Function(KanbanColumn, int, dynamic)? builder;
  final Widget Function(KanbanColumn)? builderHeader;
  final KanbanController? controller;
  final Widget? bottomNavigationBar;

  /// nome da coluna em [KanbanColumn] usado para separar os cards do kanban
  final String? columnKeyName;
  final String? primaryKey;
  final List<dynamic>? source;

  /// [onWillAccept] permite aceitar um recusar um accept
  final bool Function(DraggableKanbanItem)? onWillAccept;

  /// se [DraggableKanbanItem] for null é uma nova linha se houver dados é uma copia
  final dynamic Function(KanbanController, DraggableKanbanItem?)? onNewItem;

  /// exluir um card
  final Function(DraggableKanbanItem)? onDeleteItem;
  final Widget Function(KanbanColumn)? emptyContainer;
  final List<KanbanSlideAction>? slideLeading;
  final List<KanbanSlideAction>? slideTrailing;
  final Widget? bottom;
  const KanbanGrid(
      {Key? key,
      @required this.columnKeyName,
      @required this.columns,
      @required this.primaryKey,
      this.showProcessing = true,
      this.minWidth = kMinInteractiveDimension,
      this.builderHeader,
      this.headerHeight,
      this.onWillAccept,
      this.onAcceptItem,
      this.onNewItem,
      this.onDeleteItem,
      this.emptyContainer,
      @required this.builder,
      this.controller,
      this.bottomNavigationBar,
      @required this.source,
      this.dragSide = const [KanbanGridDragSide.right],
      this.itemHeight,
      this.slideLeading,
      this.columnBottom,
      this.bottom,
      this.dragIcon,
      this.dropIcon,
      this.feedback,
      this.dropElevation = 15,
      this.slideTrailing})
      : super(key: key);

  @override
  State<KanbanGrid> createState() => _KanbanGridState();
}

class _KanbanGridState extends State<KanbanGrid> {
  KanbanController? controller;
  double? headerHeight;
  @override
  void initState() {
    controller = widget.controller ?? KanbanController();
    controller!.columnKeyName = widget.columnKeyName!;
    controller!.source = widget.source ?? [];
    controller!.columns = widget.columns!;
    controller!.widget = widget;
    controller!.buildData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveInfo resposive = ResponsiveInfo(context);
    headerHeight ??= widget.headerHeight ?? resposive.isSmall
        ? 30
        : kMinInteractiveDimension;

    return DefaultKanbanGrid(
      kanbanGrid: widget,
      child: Scaffold(
          bottomSheet: widget.bottom,
          body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder<int>(
                  initialData: -1,
                  stream: controller!._reloadEvent.stream,
                  builder: (context, snap) {
                    if (!snap.hasData)
                      return (widget.showProcessing!)
                          ? const Align(child: CircularProgressIndicator())
                          : Container();
                    return ListView(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      children: [
                        for (var col in controller!.columns!)
                          Builder(builder: (_) {
                            double minW =
                                col.minWidth ?? widget.minWidth ?? 120.0;
                            double maxW = col.width!;
                            if (minW > maxW) minW = maxW;
                            return Card(
                              color: col.color ?? Colors.transparent,
                              elevation: col.elevation,
                              child: Container(
                                width:
                                    controller!.getCardWidth(col, minW, maxW),
                                constraints: BoxConstraints(
                                  maxWidth: maxW,
                                  minWidth: minW,
                                  maxHeight: double.maxFinite,
                                ),
                                color: col.color,
                                child: Column(children: [
                                  Expanded(
                                      child: KabanColumnCards(
                                          minWidth: minW,
                                          controller: controller!,
                                          column: col)),
                                  if (widget.columnBottom != null)
                                    widget.columnBottom!,
                                ]),
                              ),
                            );
                          }),
                      ],
                    );
                  })),
          floatingActionButton: SizedBox(
            height: 160,
            child: Stack(
              children: [
                if (widget.onNewItem != null)
                  Positioned(
                    bottom: 70,
                    right: 1,
                    child: DragTargetFloatButton<DraggableKanbanItem>(
                      icon: Icons.add,
                      onAccept: (value) {
                        widget.onNewItem!(controller!, value);
                      },
                      onPressed: () {
                        widget.onNewItem!(controller!, null);
                      },
                    ),
                  ),
                if (widget.onDeleteItem != null)
                  Positioned(
                    bottom: 1,
                    right: 1,
                    child: DragTargetFloatButton<DraggableKanbanItem>(
                      onAccept: (value) {
                        widget.onDeleteItem!(value);
                      },
                      icon: Icons.delete,
                    ),
                  ),
              ],
            ),
          ),
          bottomNavigationBar: widget.bottomNavigationBar),
    );
  }
}

/// [KanbanColumn] são as colunas do Kanban, ou estados
class KanbanColumn {
  dynamic id;
  String? label;
  double? width;
  double? elevation;
  Color? color;
  double? minWidth;
  List<Widget>? actions;
  Widget? leading;
  int? index;
  Color? titleColor;
  Color? dragColor;
  //Color dragFocused;
  //Color draggableColor;
  //Color dragDottedColor;
  final dynamic Function(KanbanController, KanbanColumn)? onNewItem;
  KanbanColumn({
    @required this.id,
    this.label,
    this.width = 200,
    this.minWidth,
    this.leading,
    this.elevation = 0,
    this.titleColor,
    this.dragColor = Colors.grey,
    this.onNewItem,
    this.actions,
    this.color,
  });
}

/// [KanbanController] informações de controle do Kanban
class KanbanController {
  final BlocModel<int> _reloadEvent = BlocModel<int>();
  ValueNotifier<String> processingIndex = ValueNotifier<String>('');

  int _key = 0;
  reload() {
    //print('Reload: $_updating');
    if (_updating <= 0) {
      _reloadEvent.notify(_key++);
      _updating = 0;
    }
    return this;
  }

  String? columnKeyName;
  int rowIndexOnColumn = 0;
  dynamic widget;

  List<KanbanColumn>? columns;
  List<dynamic>? source = [];
  Map<dynamic, List<dynamic>>? data = {};
  clear() {
    source!.clear();
    if (data != null)
      for (var k in (data?.keys ?? {})) {
        data![k]!.clear();
      }
    _updating = 0;
    return this;
  }

  buildData() {
    data = {};
    var i = 0;
    for (var col in (columns ?? [])) {
      col.index = i++;
    }

    for (var item in (source ?? [])) {
      _addData(item);
    }
    return this;
  }

  getCardWidth(col, minWidth, maxWidth) {
    return ((data![col.id]?.length ?? 0) == 0) ? minWidth : maxWidth;
  }

  isColumnMinWidth(col) {
    return (data![col.id] ?? []).isEmpty;
  }

  _addData(item) {
    var value = item[columnKeyName];
    if (value == null) return;
    if (data![value] == null) data![value] = [];
    data![value!]!.add(item);
  }

  add(Map<String, dynamic> item) {
    var r = source!.add(item);
    _addData(item);
    reload();
    return r;
  }

  int _updating = 0;
  begin([value = true]) {
    _updating += (value ? 1 : -1);
    return this;
  }

  end() {
    _updating--;
    reload();
    return this;
  }

  refresh() {
    reload();
    return this;
  }

  addAll(rsp) {
    rsp.forEach((item) {
      source!.add(item);
      _addData(item);
    });
    reload();
  }

  update(item) {}

  delete(Map<String, dynamic> item) {
    var value = item[columnKeyName];
    source!.remove(item);
    data![value!]!.remove(item);
    reload();
  }

  Future<dynamic> _insert(KanbanColumn column, int index, dynamic item) async {
    item[columnKeyName] = column.id;
    if (widget.onAcceptItem != null) {
      rowIndexOnColumn = index;
      return widget.onAcceptItem(this, column, item).then((rsp) {
        if (data![column.id] == null) data![column.id] = [];
        if ((index < 0) || (data![column.id!]!.length <= index))
          data![column.id!]!.add(item);
        else
          data![column.id!]!.insert(index, item);
        //  print('Response: $rsp');
        return (rsp is bool) ? rsp : true;
      });
    }
    data![column.id!]!.insert(index, item);
    return true;
  }

  _remove(KanbanColumn column, item) {
    data![column.id!]!.remove(item);
    return true;
  }

  initDataList(id) {
    if (data![id] == null) data![id] = [];
  }

  moveTo(oldItem, item, to) {
    /// tem que mandar o item original... para conseguir encontrar onde esta.
    var from = oldItem[columnKeyName]; // pega o card
    int rowFrom = -1;
    var columnDeIndex = columnIndexOf(from);
    var cardDe = columns![columnDeIndex].id;
    if (data![cardDe] != null)
      rowFrom = data![cardDe!]!.indexOf(oldItem); // procura posicao na lista
    if (rowFrom < 0)
      throw Exception(
          'Não encontrei o item na lista de origem, talvez ele foi alterado em um processo anterior.');
    var columnToIndex = columnIndexOf(to);
    if (columnToIndex < 0)
      throw Exception(
          "Card de destino não existe [$to], não foi possível mover.");
    return _insert(columns![columnToIndex], -1, item).then((resp) {
      if (rowFrom >= 0) {
        //print('removendo $rowFrom');
        data![cardDe]!.removeAt(rowFrom);
      }
      reload();
      return true;
    });
  }

  int columnIndexOf(id) {
    for (int i = 0; i < columns!.length; i++)
      if (columns![i].id == id) return columns![i].index ?? -1;
    return -1;
  }
}

/// [KabanColumnCards] cria as linhas do kanban, uma coluna possui varias linhas
class KabanColumnCards extends StatefulWidget {
  final KanbanColumn? column;
  final KanbanController? controller;
  final double? minWidth;
  const KabanColumnCards(
      {Key? key,
      @required this.column,
      @required this.controller,
      this.minWidth})
      : super(key: key);

  @override
  State<KabanColumnCards> createState() => _KabanColumnCardsState();
}

class _KabanColumnCardsState extends State<KabanColumnCards> {
  bool get isSlidable =>
      (kanban!.slideTrailing != null || kanban!.slideLeading != null);
  Widget getItem(index, data, item) {
    return Padding(
        padding: const EdgeInsets.only(top: 2, left: 6, right: 6),
        child: DragTargetKanbanCard(
          //key: ValueKey(index),
          itemIndex: index,
          data: data,
          column: widget.column!,
          controller: widget.controller!,
          child: isSlidable
              ? Slidable(
                  startActionPane: kanban!.slideLeading == null
                      ? null
                      : ActionPane(
                          motion: const DrawerMotion(),
                          extentRatio: 0.25,
                          children: [
                            for (final it in kanban!.slideLeading!)
                              if (it.builder != null)
                                it.builder!(item)
                              else
                                SlidableAction(
                                  key: it.key,
                                  label: it.label,
                                  icon: it.icon,
                                  // iconWidget: it.image,
                                  onPressed: (context) => it.onPressed!(item),
                                  backgroundColor: it.color!,
                                  foregroundColor: it.foregroundColor,
                                  //closeOnTap: it.closeOnTap ?? false,
                                )
                          ],
                        ),
                  endActionPane: kanban!.slideTrailing == null
                      ? null
                      : ActionPane(
                          motion: const DrawerMotion(),
                          extentRatio: 0.25,
                          children: [
                            for (final it in kanban!.slideTrailing!)
                              if (it.builder != null)
                                it.builder!(item)
                              else
                                SlidableAction(
                                    label: it.label,
                                    icon: it.icon,
                                    //iconWidget: it.image,
                                    onPressed: (context) => it.onPressed!(item))
                          ],
                        ),
                  key: ObjectKey(item),
                  child: buildSlidable(index, item),
                )
              : buildDraggable(index, item),
        ));
  }

  Widget buildDraggable(index, item) {
    return DraggableKanbanCard(
        key: ObjectKey(item),
        itemIndex: index,
        column: widget.column!,
        controller: widget.controller!,
        item: item,
        child: widget.controller!.widget.builder(widget.column, index, item));
  }

  bool canAccept(DraggableKanbanItem item) {
    /// faz validação se o  estado pode aceitar o item;
    /// aqui vai regras de validação de movimentação dos itens
    if (widget.controller!.widget.onWillAccept != null)
      return widget.controller!.widget.onWillAccept(item);
    return true;
  }

  Widget buildSlidable(index, item) {
    var draggable = DraggableKanbanItem(
        itemIndex: index,
        column: widget.column!,
        controller: widget.controller!,
        data: item);
    return Stack(children: [
      widget.controller!.widget.builder(widget.column, index, item),
      if (kanban!.dragSide!.contains(KanbanGridDragSide.right))
        Positioned(
            right: 0,
            bottom: 0,
            child: Draggable<DraggableKanbanItem>(
                data: draggable,
                feedback:
                    kanban!.feedback ?? Icon(kanban!.dropIcon ?? Icons.more),
                child: Icon(kanban!.dragIcon ?? Icons.swap_horiz))),
      if (kanban!.dragSide!.contains(KanbanGridDragSide.left))
        Positioned(
            left: 0,
            bottom: 0,
            child: Draggable<DraggableKanbanItem>(
                data: draggable,
                feedback:
                    kanban!.feedback ?? Icon(kanban!.dropIcon ?? Icons.more),
                child: Icon(kanban!.dragIcon ?? Icons.swap_horiz))),
    ]);
  }

  KanbanGrid? kanban;
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    var data = widget.controller!.data![widget.column!.id] ?? [];
    var accepted = false;
    kanban = DefaultKanbanGrid.of(context)!.kanbanGrid;

    return Column(children: [
      /// header
      if ((kanban!.headerHeight ?? 40) > 0)
        DragTargetKanbanCard(
          itemIndex: 0, // DONE: parece ser dinamico
          controller: widget.controller!,
          data: data,
          column: widget.column!,
          child: AppBar(
              primary: false,
              backgroundColor: widget.column!.titleColor ??
                  theme.appBarTheme.backgroundColor,
              toolbarHeight: kanban!.headerHeight,
              elevation: 0,
              automaticallyImplyLeading: false,
              title: Padding(
                padding: const EdgeInsets.all(8),
                child: (widget.controller!.widget.builderHeader != null)
                    ? widget.controller!.widget.builderHeader(widget.column)
                    : Text(widget.column!.label ?? '',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        )),
              ),
              leading: widget.column!.leading,
              actions: widget.column!.actions),
        ),
      Expanded(
          child: ListView(children: [
        /// itens
        for (var i = 0; i < data.length; i++) getItem(i, data, data[i]),
        Padding(
          padding: const EdgeInsets.only(top: 2, left: 6.0, right: 6.0),
          child: DragTarget<DraggableKanbanItem>(
            onWillAccept: (value) {
              accepted = canAccept(value!);
              return accepted;
            },
            onAccept: (DraggableKanbanItem value) {
              try {
                widget.controller!.processingIndex.value =
                    '${value.data[kanban!.primaryKey]}';
                value.controller!._remove(value.column!, value.data);
                widget.controller!
                    ._insert(widget.column!, -1, value.data)
                    .then((b) {
                  widget.controller!.processingIndex.value = '';
                  value.controller!.reload();
                });
              } finally {}
            },
            onLeave: (v) {
              accepted = false;
            },
            onAcceptWithDetails: (value) {
              final data = value.data.data;
              kanban!.controller!.processingIndex.value =
                  (data != null) ? '${data[kanban!.primaryKey]}' : '';
            },
            builder: (a, items, c) => Material(
              elevation: (accepted) ? kanban!.dropElevation! : 0.0,
              child: (kanban!.emptyContainer != null)
                  ? kanban!.emptyContainer!(widget.column!)
                  : Container(
                      height: 40,
                      color: theme.primaryColor.withOpacity(0.1),
                      child: (accepted && items.isNotEmpty)
                          ? kanban!.builder!(
                              items[0]!.column!, 0, items[0]!.data)
                          : null),
            ),
          ),
        ),
      ]))
    ]);
  }
}

/// notificador de edição de um item
/// enviado quando o usuario seleciona um item para editar os dados.
class KanbanEditNotifier extends BlocModel<DraggableKanbanItem> {
  static final _singleton = KanbanEditNotifier._create();
  KanbanEditNotifier._create();
  factory KanbanEditNotifier() => _singleton;
}

/// [DraggableKanbanItem]  controller do item draggable
class DraggableKanbanItem {
  final int? itemIndex;
  KanbanController? controller;
  KanbanColumn? column;
  dynamic data;
  DraggableKanbanItem(
      {@required this.column,
      @required this.itemIndex,
      @required this.controller,
      @required this.data});
}

/// objeto que pode ser arrastado para outro estado
class DraggableKanbanCard extends StatefulWidget {
  final dynamic item;
  final KanbanController? controller;
  final KanbanColumn? column;
  final Widget? child;
  final int? itemIndex;
  const DraggableKanbanCard(
      {Key? key,
      @required this.column,
      this.item,
      this.controller,
      this.child,
      this.itemIndex})
      : super(key: key);

  @override
  State<DraggableKanbanCard> createState() => _DraggableKanbanCardState();
}

class _DraggableKanbanCardState extends State<DraggableKanbanCard> {
  @override
  Widget build(BuildContext context) {
    // KanbanGrid? kanban = DefaultKanbanGrid.of(context)!.kanbanGrid;

    var draggable = DraggableKanbanItem(
      itemIndex: widget.itemIndex,
      column: widget.column,
      controller: widget.controller,
      data: widget.item,
    );
    return Draggable<DraggableKanbanItem>(
      data: draggable,
      //dragAnchor: DragAnchor.pointer,
      feedback: const Icon(Icons.room_preferences),
      childWhenDragging: Material(
        color: Colors.grey.withOpacity(0.2),
        child: Container(height: 0),
      ), //??
      //kanban.feedback ??
      //Icon(kanban.dropIcon ?? Icons.more),
      child: widget.child!,
    );
  }
}

/// Target que recebe o item arrastado / solto dentro do estado
class DragTargetKanbanCard extends StatefulWidget {
  final Widget? child;
  final KanbanController? controller;
  final int? itemIndex;
  final List? data;
  final KanbanColumn? column;

  const DragTargetKanbanCard({
    Key? key,
    this.child,
    this.controller,
    @required this.itemIndex,
    @required this.data,
    @required this.column,
  }) : super(key: key);

  @override
  State<DragTargetKanbanCard> createState() => _DragTargetKanbanCardState();
}

class _DragTargetKanbanCardState extends State<DragTargetKanbanCard>
    with SingleTickerProviderStateMixin {
  bool accepted = false;
  bool inDetails = false;
  int itemAccept = -1;

  bool canAccept(DraggableKanbanItem item) {
    /// faz validação se o  estado pode aceitar o item;
    /// aqui vai regras de validação de movimentação dos itens
    if (widget.controller!.widget.onWillAccept != null)
      return widget.controller!.widget.onWillAccept(item);
    return true;
  }

  get index => widget.itemIndex ?? -1;
  dynamic item;
  @override
  Widget build(BuildContext context) {
    if (widget.itemIndex != null &&
        widget.data != null &&
        widget.data!.isNotEmpty) item = widget.data![widget.itemIndex!];
    KanbanGrid kanban = DefaultKanbanGrid.of(context)!.kanbanGrid!;
    return Column(
      children: [
        DragTarget<DraggableKanbanItem>(
          onWillAccept: (value) {
            itemAccept = widget.itemIndex!;
            accepted = canAccept(value!);
            return accepted;
          },
          onAccept: (value) {
            if (!accepted) return;
            value.controller!._remove(value.column!, value.data);
            widget.controller!
                ._insert(
                    widget.column!, (widget.itemIndex ?? 0) /*+ 1*/, value.data)
                .then((b) {
              kanban.controller!.processingIndex.value = '';
              value.controller!.reload();
            });
            setState(() {
              accepted = false;
              inDetails = false;
              itemAccept = -1;
            });
          },
          onLeave: (value) {
            accepted = false;
            inDetails = false;
            itemAccept = -1;
          },
          builder: (BuildContext context,
              List<DraggableKanbanItem?> candidateData,
              List<dynamic> rejectedData) {
            return Material(
                //elevation: accepted ? 8 : 0,
                child: Column(
              children: [
                if (accepted)
                  TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 100),
                      tween: Tween(begin: 1.0, end: 0.90),
                      builder: (context, value, child) => SizedBox(
                            width: ((candidateData[0]!.column!.width ??
                                    kanban.minWidth!) *
                                value),
                            child: Material(
                                elevation: accepted ? kanban.dropElevation! : 0,
                                child: SizedBox(
                                    height: kanban.itemHeight,
                                    child: kanban.builder!(
                                        candidateData[0]!.column!,
                                        0,
                                        candidateData[0]!.data))),
                          )),
                widget.child!,
              ],
            ));
          },
          onAcceptWithDetails: (value) {
            final data = value.data.data;
            kanban.controller!.processingIndex.value =
                (data != null) ? '${data[kanban.primaryKey]}' : '';
            inDetails = true;
          },
        ),
        ValueListenableBuilder<String>(
          valueListenable: kanban.controller!.processingIndex,
          builder: (BuildContext context, String value, Widget? child) {
            final data = itemData;
            return SizedBox(
                height: 2,
                child:
                    ((data != null) && (value == data['${kanban.primaryKey}']))
                        ? const LinearProgressIndicator()
                        : null);
          },
        ),
      ],
    );
  }

  get itemData {
    if (item != null) return item;
    if (widget.itemIndex == null) return null;
    return ((widget.itemIndex! >= 0) &&
            (widget.itemIndex! < widget.data!.length))
        ? widget.data![widget.itemIndex!]
        : null;
  }
}

/// botão para descarregar um item
class DragTargetFloatButton<T> extends StatefulWidget {
  final Function? onPressed;
  final Function(dynamic)? onAccept;
  final double? sizeOnFocus;
  final double? size;
  final IconData? icon;
  final IconData? iconFocus;
  final Color? backgroundColor;
  final bool Function(dynamic)? onWillAccept;
  const DragTargetFloatButton({
    Key? key,
    this.size = 25,
    this.sizeOnFocus = 45,
    this.onPressed,
    @required this.icon,
    this.iconFocus,
    this.backgroundColor,
    @required this.onAccept,
    this.onWillAccept,
  }) : super(key: key);

  @override
  State<DragTargetFloatButton> createState() =>
      _DragTargetFloatButtonState<T>();
}

class _DragTargetFloatButtonState<T> extends State<DragTargetFloatButton> {
  bool acceptDelete = false;
  @override
  Widget build(BuildContext context) {
    return DragTarget(
      onWillAccept: (value) {
        setState(() {
          acceptDelete = (widget.onWillAccept != null)
              ? widget.onWillAccept!(value)
              : true;
        });
        return true;
      },
      onLeave: (value) {
        setState(() {
          acceptDelete = false;
        });
      },
      onAccept: (value) {
        widget.onAccept!(value);
        setState(() {
          acceptDelete = false;
        });
      },
      builder: (ctx, accept, reject) {
        return (acceptDelete)
            ? CircleAvatar(
                backgroundColor: widget.backgroundColor,
                radius: widget.sizeOnFocus,
                child: Icon(widget.iconFocus ?? widget.icon,
                    size: widget.sizeOnFocus),
              )
            : FloatingActionButton(
                backgroundColor: widget.backgroundColor,
                child: Icon(widget.icon, size: widget.size),
                onPressed: () => widget.onPressed!());
      },
    );
  }
}
