//import 'package:controls_web/controls/slide_tile.dart';
//import 'package:controls_web/controls/tab_choice.dart';
import 'package:controls_web/drivers/bloc_model.dart';
//import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

/// clase de teste para Kanban
class KanbanSample extends StatefulWidget {
  KanbanSample({Key key}) : super(key: key);

  @override
  _KanbanSampleState createState() => _KanbanSampleState();
}

class _KanbanSampleState extends State<KanbanSample> {
  @override
  Widget build(BuildContext context) {
    //print('kanbnTest');
    return KanbanGrid(
        keyName: 'id', // coluna com o valor do card
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
        source: [
          {"id": 1, "ordem": 1, "nome": "teste1", "qtde": 1},
          {"id": 2, "ordem": 2, "nome": "teste2", "qtde": 2},
        ],
        onNewItem: (ctr, item) {
          var i = item ?? 1;
          if (item != null) i = item?.data['id'] ?? 1;
          ctr.add({"id": i, "ordem": 1, "nome": "teste1", "qtde": 1});
        },
        onDeleteItem: (ctr) {
          ctr.controller.delete(ctr.data);
        });
  }
}

class DefaultKanbanGrid extends InheritedWidget {
  DefaultKanbanGrid({
    Key key,
    @required this.kanbanGrid,
    Widget child,
  }) : super(key: key, child: child);
  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    throw false;
  }

  final KanbanGrid kanbanGrid;
  static DefaultKanbanGrid of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType();
}

class KanbanSlideAction {
  final Key key;
  final String label;
  final IconData icon;
  final Widget image;
  final Function(dynamic) onPressed;
  final Color color;
  final Color foregroundColor;
  final bool closeOnTap;
  KanbanSlideAction(
      {this.key,
      this.label,
      this.icon,
      this.image,
      this.onPressed,
      this.color,
      this.foregroundColor,
      this.closeOnTap})
      : assert(icon != null || image != null);
}

/// Class [KanbanGrid]
/// Fornecer [KanbanGrid.souce] contendo os dados a serem mostrados;
/// [KanbanColumn] indica os cards verticais usados no kanban
///
class KanbanGrid extends StatefulWidget {
  final List<KanbanColumn> columns;
  final bool showProcessing;
  final double minWidth;
  final double itemHeight;
  final double headerHeight;
//  final BoxDecoration decoration;

  /// [onAcceptItem] é chamado para gravar um item
  final Future<bool> Function(KanbanController, KanbanColumn, dynamic)
      onAcceptItem;

  /// [builder] é chamado para criar os itens
  final Widget Function(KanbanColumn, int, dynamic) builder;
  final Widget Function(KanbanColumn) builderHeader;
  final KanbanController controller;
  final Widget bottomNavigationBar;

  /// nome da coluna em [KanbanColumn] usado para separar os cards do kanban
  final String keyName;
  final List<dynamic> source;

  /// [onWillAccept] permite aceitar um recusar um accept
  final bool Function(DraggableKanbanItem) onWillAccept;

  /// se [DraggableKanbanItem] for null é uma nova linha se houver dados é uma copia
  final dynamic Function(KanbanController, DraggableKanbanItem) onNewItem;

  /// [onSelectedItem] é chamado quando click no card item
  //final Function(DraggableKanbanItem) onSelectedItem;
  //final Function(DraggableKanbanItem) onDoubleTap;

  /// exluir um card
  final Function(DraggableKanbanItem) onDeleteItem;
  final Widget emptyContainer;
  final List<KanbanSlideAction> slideLeading;
  final List<KanbanSlideAction> slideTrailing;
  KanbanGrid(
      {Key key,
      @required this.keyName,
      @required this.columns,
      this.showProcessing = true,
      this.minWidth = 50,
      //this.decoration,
      this.builderHeader,
      this.headerHeight = 50,
      this.onWillAccept,
      this.onAcceptItem,
      //this.onSelectedItem,
      //this.onDoubleTap,
      this.onNewItem,
      this.onDeleteItem,
      this.emptyContainer,
      @required this.builder,
      this.controller,
      this.bottomNavigationBar,
      @required this.source,
      this.itemHeight,
      this.slideLeading,
      this.slideTrailing})
      : super(key: key);

  @override
  _KanbanGridState createState() => _KanbanGridState();
}

class _KanbanGridState extends State<KanbanGrid> {
  KanbanController controller;
  @override
  void initState() {
    controller = widget.controller ?? KanbanController();
    controller.keyName = widget.keyName;
    controller.source = widget.source ?? [];
    controller.columns = widget.columns;
    controller.widget = widget;
    controller.buildData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //print('KanbanGrid');
    return DefaultKanbanGrid(
      kanbanGrid: widget,
      child: Scaffold(
          body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder<int>(
                  initialData: -1,
                  stream: controller._reloadEvent.stream,
                  builder: (context, snap) {
                    if (!snap.hasData)
                      return (widget.showProcessing)
                          ? Align(child: CircularProgressIndicator())
                          : Container();
                    return ListView(
                      //controller: scrollCtr,
                      scrollDirection: Axis.horizontal,
                      children: [
                        for (var col in controller.columns)
                          Card(
                            color: col.color,
                            elevation: col.elevation,
                            child: Container(
                              width: controller.getCardWidth(col,
                                  col.minWidth ?? widget.minWidth, col.width),
                              constraints: BoxConstraints(
                                maxWidth: col.width,
                                minWidth: col.minWidth ?? widget.minWidth,
                                maxHeight: double.maxFinite,
                              ),
                              color: col.color,
                              child: KabanColumnCards(
                                  minWidth: widget.minWidth,
                                  controller: controller,
                                  column: col),
                            ),
                          )
                      ],
                    );
                  })),
          floatingActionButton: Container(
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
                        widget.onNewItem(controller, value);
                      },
                      onPressed: () {
                        widget.onNewItem(controller, null);
                      },
                    ),
                  ),
                if (widget.onDeleteItem != null)
                  Positioned(
                    bottom: 1,
                    right: 1,
                    child: DragTargetFloatButton<DraggableKanbanItem>(
                      onAccept: (value) {
                        widget.onDeleteItem(value);
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
  var id;
  String label;
  double width;
  double elevation;
  Color color;
  double minWidth;
  List<Widget> actions;
  int index;
  Color titleColor;
  Color dragColor;
  Color dragFocused;
  Color draggableColor;
  Color dragDottedColor;
  final dynamic Function(KanbanController, KanbanColumn) onNewItem;
  KanbanColumn({
    @required this.id,
    this.label,
    this.width = 200,
    this.minWidth,
    this.elevation = 0,
    this.titleColor = Colors.blue,
    this.dragColor = Colors.grey,
    this.draggableColor,
    this.dragDottedColor,
    this.dragFocused,
    this.onNewItem,
    this.actions,
    this.color,
  });
}

/// [KanbanController] informações de controle do Kanban
class KanbanController {
  BlocModel<int> _reloadEvent = BlocModel<int>();
  int _key = 0;
  reload() {
    print('Reload: $_updating');
    if (_updating <= 0) {
      _reloadEvent.notify(_key++);
      _updating = 0;
    }
    return this;
  }

  String keyName;
  int rowIndexOnColumn = 0;
  var widget;

  List<KanbanColumn> columns;
  List<dynamic> source = [];
  Map<dynamic, List<dynamic>> data = {};
  clear() {
    source.clear();
    if (data != null)
      (data?.keys ?? {}).forEach((k) {
        data[k].clear();
      });
    _updating = 0;
    return this;
  }

  buildData() {
    data = {};
    var i = 0;
    columns.forEach((col) {
      col.index = i++;
    });
    source.forEach((item) {
      _addData(item);
    });
    return this;
  }

  getCardWidth(col, minWidth, maxWidth) {
    return ((data[col.id]?.length ?? 0) == 0) ? minWidth : maxWidth;
  }

  isColumnMinWidth(col) {
    return (data[col.id] ?? []).length == 0;
  }

  _addData(item) {
    var value = item[keyName];
    if (data[value] == null) data[value] = [];
    data[value].add(item);
  }

  add(Map<String, dynamic> item) {
    var r = source.add(item);
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
      source.add(item);
      _addData(item);
    });
    reload();
  }

  update(item) {}

  delete(Map<String, dynamic> item) {
    var value = item[keyName];
    source.remove(item);
    data[value].remove(item);
    reload();
  }

  Future<dynamic> _insert(KanbanColumn column, int index, dynamic item) async {
    item[keyName] = column.id;
    if (widget.onAcceptItem != null) {
      this.rowIndexOnColumn = index;
      return widget.onAcceptItem(this, column, item).then((rsp) {
        if (data[column.id] == null) data[column.id] = [];
        if ((index < 0) || (data[column.id].length <= index))
          data[column.id].add(item);
        else
          data[column.id].insert(index, item);
        print('Response: $rsp');
        return (rsp is bool) ? rsp : true;
      });
    }
    data[column.id].insert(index, item);
    return true;
  }

  _remove(KanbanColumn column, item) {
    data[column.id].remove(item);
    return true;
  }

  initDataList(id) {
    if (data[id] == null) data[id] = [];
  }

  moveTo(oldItem, item, to) {
    /// tem que mandar o item original... para conseguir encontrar onde esta.
    var from = oldItem[keyName]; // pega o card
    int rowFrom = -1;
    var columnDeIndex = columnIndexOf(from);
    var cardDe = columns[columnDeIndex].id;
    if (data[cardDe] != null)
      rowFrom = data[cardDe].indexOf(oldItem); // procura posicao na lista
    if (rowFrom < 0)
      throw Exception(
          'Não encontrei o item na lista de origem, talvez ele foi alterado em um processo anterior.');
    var columnToIndex = columnIndexOf(to);
    if (columnToIndex < 0)
      throw Exception(
          "Card de destino não existe [$to], não foi possível mover.");
    return _insert(columns[columnToIndex], -1, item).then((resp) {
      if (rowFrom >= 0) {
        print('removendo $rowFrom');
        data[cardDe].removeAt(rowFrom);
      }
      reload();
      return true;
    });
  }

  int columnIndexOf(id) {
    for (int i = 0; i < columns.length; i++)
      if (columns[i].id == id) return columns[i].index;
    return -1;
  }
}

/// [KabanColumnCards] cria as linhas do kanban, uma coluna possui varias linhas
class KabanColumnCards extends StatefulWidget {
  final KanbanColumn column;
  final KanbanController controller;
  final double minWidth;
  KabanColumnCards(
      {Key key,
      @required this.column,
      @required this.controller,
      this.minWidth})
      : super(key: key);

  @override
  _KabanColumnCardsState createState() => _KabanColumnCardsState();
}

class _KabanColumnCardsState extends State<KabanColumnCards> {
  bool get isSlidable =>
      (kanban.slideTrailing != null || kanban.slideLeading != null);
  Widget getItem(index, data, item) {
    return Padding(
        padding: const EdgeInsets.only(top: 2, left: 6, right: 6),
        child: DragTargetKanbanCard(
          //key: ValueKey(index),
          itemIndex: index,
          data: data,
          column: widget.column,
          controller: widget.controller,
          child: isSlidable
              ? Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  secondaryActions: kanban.slideTrailing == null
                      ? null
                      : [
                          for (final it in kanban.slideTrailing)
                            IconSlideAction(
                              caption: it.label,
                              icon: it.icon,
                              iconWidget: it.image,
                              onTap: () => it.onPressed(item),
                            )
                        ],
                  actions: kanban.slideLeading == null
                      ? null
                      : [
                          for (final it in kanban.slideLeading)
                            IconSlideAction(
                              key: it.key,
                              caption: it.label,
                              icon: it.icon,
                              iconWidget: it.image,
                              onTap: () => it.onPressed(item),
                              color: it.color,
                              foregroundColor: it.foregroundColor,
                              closeOnTap: it.closeOnTap,
                            )
                        ],
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
        column: widget.column,
        controller: widget.controller,
        item: item,
        child: widget.controller.widget.builder(widget.column, index, item));
  }

  Widget buildSlidable(index, item) {
    var draggable = DraggableKanbanItem(
        column: widget.column, controller: widget.controller, data: item);
    return Stack(children: [
      widget.controller.widget.builder(widget.column, index, item),
      Positioned(
          right: 0,
          bottom: 0,
          child: Draggable<DraggableKanbanItem>(
              data: draggable,
              feedback: Icon(Icons.more),
              child: Icon(Icons.swap_horiz))),
    ]);
  }

  KanbanGrid kanban;
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    var data = widget.controller.data[widget.column.id] ?? [];
    var accepted = false;
    kanban = DefaultKanbanGrid.of(context).kanbanGrid;

    return Column(children: [
      /// header
      if (kanban.headerHeight > 0)
        DragTargetKanbanCard(
          controller: widget.controller,
          data: data,
          column: widget.column,
          child: Container(
              height: kanban.headerHeight,
              color: widget.column.titleColor,
              //padding: EdgeInsets.all(8),
              alignment: Alignment.center,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: (widget.controller.widget.builderHeader != null)
                          ? widget.controller.widget
                              .builderHeader(widget.column)
                          : Text(widget.column.label ?? '',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              )),
                    ),
                  ),
                  if (!widget.controller.isColumnMinWidth(widget.column))
                    if (widget.column.actions != null) ...widget.column.actions,
                ],
              )),
        ),
      Expanded(
          child: ListView(children: [
        /// itens
        for (var i = 0; i < data.length; i++) getItem(i, data, data[i]),
        Padding(
          padding: const EdgeInsets.only(top: 2, left: 6.0, right: 6.0),
          child: DragTarget<DraggableKanbanItem>(
            onWillAccept: (v) {
              accepted = true;
              return true;
            },
            onAccept: (value) {
              value.controller._remove(value.column, value.data);
              widget.controller
                  ._insert(widget.column, -1, value.data)
                  .then((b) {
                value.controller.reload();
              });
            },
            onLeave: (v) {
              accepted = false;
            },
            builder: (a, items, c) => Material(
              elevation: (accepted) ? 8 : 0,
              child: kanban.emptyContainer ??
                  Container(
                      height: 40,
                      color: theme.primaryColor.withOpacity(0.1),
                      child: (accepted && items.length > 0)
                          ? kanban.builder(items[0].column, 0, items[0].data)
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
  KanbanController controller;
  KanbanColumn column;
  dynamic data;
  DraggableKanbanItem(
      {@required this.column, @required this.controller, @required this.data});
}

/// objeto que pode ser arrastado para outro estado
class DraggableKanbanCard extends StatefulWidget {
  final dynamic item;
  final KanbanController controller;
  final KanbanColumn column;
  final Widget child;
  final int itemIndex;
  DraggableKanbanCard(
      {Key key,
      @required this.column,
      this.item,
      this.controller,
      this.child,
      this.itemIndex})
      : super(key: key);

  @override
  _DraggableKanbanCardState createState() => _DraggableKanbanCardState();
}

class _DraggableKanbanCardState extends State<DraggableKanbanCard> {
  @override
  Widget build(BuildContext context) {
    KanbanGrid kanban = DefaultKanbanGrid.of(context).kanbanGrid;

    var draggable = DraggableKanbanItem(
        column: widget.column,
        controller: widget.controller,
        data: widget.item);
    return Draggable<DraggableKanbanItem>(
      data: draggable,
      // rootOverlay: true,

      feedback: Container(
        constraints: BoxConstraints(maxWidth: widget.column.width),
        child: Align(
          child: Icon(Icons.more),
        ),
      ),
      child:
          /*((widget.controller.widget.onSelectedItem != null) ||
              (widget.controller.widget.onDoubleTap != null))
          ? InkWell(

              /// estava com BUG do InkWell dentro do dragable - observar
              child: widget.child,
              onDoubleTap: () {
                if (widget.controller.widget.onDoubleTap != null)
                  widget.controller.widget.onDoubleTap(draggable);
              },
              hoverColor: Colors.grey.withOpacity(0.5),
              onTap: () {
                if (widget.controller.widget.onSelectedItem != null)
                  widget.controller.widget.onSelectedItem(draggable);
              })
          :*/
          widget.child,
      childWhenDragging: Material(
        color: Colors.grey.withOpacity(0.2),
        child: Container(height: 0),
      ),
    );
  }
}

/// Target que recebe o item arrastado / solto dentro do estado
class DragTargetKanbanCard extends StatefulWidget {
  final Widget child;
  final KanbanController controller;
  final int itemIndex;
  final List data;
  final KanbanColumn column;

  DragTargetKanbanCard({
    Key key,
    this.child,
    this.controller,
    this.itemIndex,
    @required this.data,
    @required this.column,
  }) : super(key: key);

  @override
  _DragTargetKanbanCardState createState() => _DragTargetKanbanCardState();
}

class _DragTargetKanbanCardState extends State<DragTargetKanbanCard>
    with SingleTickerProviderStateMixin {
  bool accepted = false;
  //bool processing = false;
  bool inDetails = false;
  int itemAccept = -1;

  bool canAccept(DraggableKanbanItem item) {
    /// faz validação se o  estado pode aceitar o item;
    /// aqui vai regras de validação de movimentação dos itens
    if (widget.controller.widget.onWillAccept != null)
      return widget.controller.widget.onWillAccept(item);
    return true;
  }

  get index => widget.itemIndex ?? -1;
  @override
  Widget build(BuildContext context) {
    KanbanGrid kanban = DefaultKanbanGrid.of(context).kanbanGrid;
    return Column(
      children: [
        DragTarget<DraggableKanbanItem>(
          onWillAccept: (value) {
            itemAccept = widget.itemIndex;
            return accepted = canAccept(value);
          },
          onAccept: (value) {
            value.controller._remove(value.column, value.data);
            widget.controller
                ._insert(
                    widget.column, (widget.itemIndex ?? 0) /*+ 1*/, value.data)
                .then((b) {
              value.controller.reload();
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
              List<DraggableKanbanItem> candidateData,
              List<dynamic> rejectedData) {
            return Material(
                //elevation: accepted ? 8 : 0,
                child: Column(
              children: [
                if (accepted)
                  TweenAnimationBuilder(
                      duration: Duration(milliseconds: 100),
                      tween: Tween(begin: 1.0, end: 0.90),
                      builder: (context, value, child) => Container(
                            width: (candidateData[0].column.width ??
                                    kanban.minWidth) *
                                value,
                            child: Material(
                                elevation: accepted ? 8 : 0,
                                child: Container(
                                    height: kanban.itemHeight,
                                    child: kanban.builder(
                                        candidateData[0].column,
                                        0,
                                        candidateData[0].data))),
                          )),
                widget.child,
              ],
            ));
          },
          onAcceptWithDetails: (value) {
            setState(() {
              inDetails = true;
              //itemAccept = widget.itemIndex;
            });
          },
        ),
      ],
    );
  }
}

/// botão para descarregar um item
class DragTargetFloatButton<T> extends StatefulWidget {
  final Function onPressed;
  final Function(dynamic) onAccept;
  final double sizeOnFocus;
  final double size;
  final IconData icon;
  final IconData iconFocus;
  final Color backgroundColor;
  final bool Function(dynamic) onWillAccept;
  DragTargetFloatButton({
    Key key,
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
  _DragTargetFloatButtonState createState() => _DragTargetFloatButtonState<T>();
}

class _DragTargetFloatButtonState<T> extends State<DragTargetFloatButton> {
  bool acceptDelete = false;
  @override
  Widget build(BuildContext context) {
    return DragTarget<T>(
      onWillAccept: (value) {
        setState(() {
          acceptDelete =
              (widget.onWillAccept != null) ? widget.onWillAccept(value) : true;
        });
        return true;
      },
      onLeave: (value) {
        setState(() {
          acceptDelete = false;
        });
      },
      onAccept: (value) {
        widget.onAccept(value);
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
                onPressed: widget.onPressed);
      },
    );
  }
}
