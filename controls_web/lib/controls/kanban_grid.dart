import 'package:controls_web/drivers/bloc_model.dart';
//import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

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

/// Class [KanbanGrid]
/// Fornecer [KanbanGrid.souce] contendo os dados a serem mostrados;
/// [KanbanColumn] indica os cards verticais usados no kanban
///
class KanbanGrid extends StatefulWidget {
  final List<KanbanColumn> columns;
  final bool showProcessing;
  final double minWidth;

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
  final Function(DraggableKanbanItem) onSelectedItem;
  final Function(DraggableKanbanItem) onDoubleTap;

  /// exluir um card
  final Function(DraggableKanbanItem) onDeleteItem;
  KanbanGrid({
    Key key,
    @required this.keyName,
    @required this.columns,
    this.showProcessing = true,
    this.minWidth = 50,
    this.builderHeader,
    this.onWillAccept,
    this.onAcceptItem,
    this.onSelectedItem,
    this.onDoubleTap,
    this.onNewItem,
    this.onDeleteItem,
    @required this.builder,
    this.controller,
    this.bottomNavigationBar,
    @required this.source,
  }) : super(key: key);

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
    return Scaffold(
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
        bottomNavigationBar: widget.bottomNavigationBar);
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
    this.width = 250,
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
  Widget getItem(index, data, item) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: DragTargetKanbanCard(
          itemIndex: index,
          data: data,
          column: widget.column,
          controller: widget.controller,
          child: DraggableKanbanCard(
              column: widget.column,
              controller: widget.controller,
              item: item,
              child: widget.controller.widget
                  .builder(widget.column, index, item))),
    );
  }

  @override
  Widget build(BuildContext context) {
    var data = widget.controller.data[widget.column.id] ?? [];

    return ListView(children: [
      DragTargetKanbanCard(
        controller: widget.controller,
        data: data,
        column: widget.column,
        child: Container(
            height: 50,
            color: widget.column.titleColor,
            //padding: EdgeInsets.all(8),
            alignment: Alignment.center,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: (widget.controller.widget.builderHeader != null)
                        ? widget.controller.widget.builderHeader(widget.column)
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
                /*if (widget.column.onNewItem != null) // passou para botao separado.
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      widget.column.onNewItem(widget.controller, widget.column);
                    },
                  )*/
              ],
            )),
      ),
      for (var i = 0; i < data.length; i++) getItem(i, data, data[i])
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
  DraggableKanbanCard(
      {Key key, @required this.column, this.item, this.controller, this.child})
      : super(key: key);

  @override
  _DraggableKanbanCardState createState() => _DraggableKanbanCardState();
}

class _DraggableKanbanCardState extends State<DraggableKanbanCard> {
  @override
  Widget build(BuildContext context) {
    var draggable = DraggableKanbanItem(
        column: widget.column,
        controller: widget.controller,
        data: widget.item);
    return Draggable<DraggableKanbanItem>(
      data: draggable,
      feedback: Container(
          width: widget.column.width / 3,
          height: 50,
          color: widget.column.dragColor),
      child: ((widget.controller.widget.onSelectedItem != null) ||
              (widget.controller.widget.onDoubleTap != null))
          ? InkWell(
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
          : widget.child,
      childWhenDragging: Container(color: Colors.amber),
      onDragCompleted: () {
        //widget.controller.remove(widget.item);
        // alterado para o target para controller sucesso sincronizado
      },
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

class _DragTargetKanbanCardState extends State<DragTargetKanbanCard> {
  bool accepted = false;
  bool processing = false;

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
    //print('Index: $index');
    return Column(
      children: [
        widget.child,
        if (processing) Align(child: CircularProgressIndicator()),
        DragTarget<DraggableKanbanItem>(
          onWillAccept: (value) {
            return accepted = canAccept(value);
          },
          onAccept: (value) {
            setState(() {
              processing = true;
            });
            // insere no destino
            widget.controller
                ._insert(widget.column, (widget.itemIndex ?? 0) + 1, value.data)
                .then((b) {
              bool refresh = true;
              if (b is bool) refresh = b;
              print('Refresh: $refresh');
              if (refresh) {
                // sucesso no registro, remove a origem
                value.controller._remove(value.column, value.data);
                value.controller.reload();
              }
            });
            setState(() {
              processing = false;
            });
            accepted = false;
          },
          onLeave: (value) {
            accepted = false;
            processing = false;
          },
          builder: (BuildContext context,
              List<DraggableKanbanItem> candidateData,
              List<dynamic> rejectedData) {
            return (accepted)
                ? Container(
                    height: 50,
                    color: widget.column.dragFocused ??
                        Colors.grey.withOpacity(0.9),
                  )
                : Container(
                    color: widget.column.dragDottedColor ??
                        Colors.grey.withOpacity(0.2),
                    child: Container(
                      height: (((index + 1) == (widget.data.length))) ? 50 : 5,
                      color: widget.column.draggableColor ??
                          Colors.grey.withOpacity(0.1),
                    ),
                  );
          },
        ),
      ],
    );
  }
}

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
