import 'package:controls_web/controls/sidebar.dart';
import 'package:controls_web/drivers/bloc_model.dart';
//import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class DualListViewerController {
  Widget? widget;
  List<dynamic>? options;
  List<dynamic>? items;
  SidebarController? sidebarController;
  DualListViewerController({
    this.options,
    this.items,
  }) {
    sidebarController = SidebarController();
    options = options ?? [];
    items = items ?? [];
  }
  loadBy(String keyName, dynamic value) {
    var it;
    try {
      it = options!.firstWhere((item) {
        return item[keyName] == value;
      });
    } catch (e) {
      //
    }
    if (it != null) {
      load(it);
    }
  }

  moveTo(index, item) {
    print('moveTo');
    if (!_loading && (onInsert != null))
      onInsert!(item).then((rsp) {
        begin();
        options!.remove(item);
        items!.insert(index, item);
        end();
      });
    else {
      begin();
      options!.remove(item);
      items!.insert(index, item);
      end();
    }
  }

  bool _loading = false;
  load(item) {
    _loading = true;
    moveTo(items!.length, item);
    _loading = false;
  }

  moveFrom(index, item) {
    print('moveFrom');
    if (!_loading && (onDelete != null))
      onDelete!(item).then((rsp) {
        begin();
        items!.remove(item);
        options!.insert(index, item);
        end();
      });
    else {
      begin();
      items!.remove(item);
      options!.insert(index, item);
      end();
    }
  }

  int _enabled = 0;
  begin([bool b = true]) {
    _enabled += (b) ? 1 : -1;
  }

  end() {
    _enabled--;
    changed();
  }

  int _count = 0;
  changed() {
    if ((!_loading) && (_enabled <= 0)) subscription.notify(_count++);
  }

  BlocModel<int> subscription = BlocModel<int>();
  Future<dynamic> Function(dynamic)? onInsert;
  Future<dynamic> Function(dynamic)? onDelete;
}

class DualListViewer extends StatefulWidget {
  final DualListViewerController? controller;
  final Widget Function(DualListItemData, dynamic)? builderOption;
  final Widget Function(DualListItemData, dynamic)? builder;
  final Widget? header;
  final Widget? body;
  final Widget? bottom;
  final bool? canDrag;
  final List<dynamic>? options;
  final List<dynamic>? items;
  //final String keyName;
  final Future<dynamic> Function(dynamic)? onInsert;
  final Future<dynamic> Function(dynamic)? onDelete;
  final bool Function(dynamic)? accept;
  final double? leftWidth;
  final Widget? optionsTitle;
  final Widget? itemsTitle;
  const DualListViewer({
    Key? key,
    this.controller,
    @required this.builder,
    this.header,
    this.body,
    this.bottom,
    this.options,
    this.items,
    this.leftWidth = 200,
    this.canDrag = true,
    //@required this.keyName,
    this.onInsert,
    this.onDelete,
    this.accept,
    this.builderOption,
    this.optionsTitle,
    this.itemsTitle,
  }) : super(key: key);

  @override
  _DualListViewerState createState() => _DualListViewerState();
}

class _DualListViewerState extends State<DualListViewer> {
  DualListViewerController? controller;
  @override
  void initState() {
    controller = widget.controller ?? DualListViewerController();
    controller!.options = widget.options ?? controller!.options ?? [];
    controller!.items = widget.items ?? controller!.items ?? [];
    controller!.widget = widget;
    controller!.onDelete = widget.onDelete;
    controller!.onInsert = widget.onInsert;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    controller!.sidebarController!.width =
        widget.leftWidth ?? controller!.sidebarController!.width;
    return Scaffold(
      body: StreamBuilder<int>(
          stream: controller!.subscription.stream,
          builder: (context, snapshot) {
            return Column(
              children: [
                if (widget.header != null) widget.header!,
                Expanded(
                  child: SidebarScaffold(
                    controller: controller!.sidebarController,
                    sidebar: SidebarContainer(
                      width: widget.leftWidth,
                      controller: controller!.sidebarController,
                      child: ListView(
                        children: [
                          if (widget.optionsTitle != null)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: widget.optionsTitle,
                            ),
                          DragTargetDualListItem(
                            index: -1,
                            controller: controller!,
                            side: DragTargetDualListSide.left,
                            canDrag: widget.canDrag!,
                          ),
                          for (var i = 0; i < controller!.options!.length; i++)
                            Padding(
                              padding: EdgeInsets.only(
                                  right: (widget.canDrag! ? 40 : 8)),
                              child: DualListItemCard(
                                  canDrag: widget.canDrag!,
                                  side: DragTargetDualListSide.left,
                                  builder: (a, b) =>
                                      (widget.builderOption != null)
                                          ? widget.builderOption!(a, b)
                                          : widget.builder!(a, b),
                                  data: DualListItemData(
                                    item: controller!.options![i],
                                    index: i,
                                    controller: controller!,
                                  )),
                            )
                        ],
                      ),
                    ),
                    body: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: ListView(children: [
                        if (widget.itemsTitle != null)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: widget.itemsTitle,
                          ),
                        DragTargetDualListItem(
                          canDrag: widget.canDrag!,
                          index: -1,
                          controller: controller!,
                          side: DragTargetDualListSide.right,
                        ),
                        for (var i = 0; i < controller!.items!.length; i++)
                          Padding(
                            padding: EdgeInsets.only(
                                right: (widget.canDrag!) ? 40.0 : 8),
                            child: DualListItemCard(
                              canDrag: widget.canDrag!,
                              side: DragTargetDualListSide.right,
                              builder: widget.builder!,
                              data: DualListItemData(
                                item: controller!.items![i],
                                index: i,
                                controller: controller!,
                              ),
                            ),
                          ),
                      ]),
                    ),
                  ),
                ),
                if (widget.bottom != null) widget.bottom!
              ],
            );
          }),
    );
  }
}

class DualListItemData {
  int? index;
  final DualListViewerController? controller;
  final dynamic? item;
  DualListItemData({
    this.item,
    @required this.index,
    @required this.controller,
  });
}

class DraggableDualListItem extends StatelessWidget {
  final DualListItemData? data;
  final DragTargetDualListSide? side;
  final bool? canDrag;
  final Widget Function(DualListItemData, dynamic)? builder;
  const DraggableDualListItem({
    Key? key,
    this.canDrag = true,
    @required this.data,
    @required this.builder,
    @required this.side,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (!canDrag!)
        ? InkWell(
            child: builder!(data!, data!.item),
            onTap: () {
              if (side == DragTargetDualListSide.left)
                data!.controller!
                    .moveTo(data!.controller!.items!.length, data!.item);
              else if (side == DragTargetDualListSide.right)
                data!.controller!
                    .moveFrom(data!.controller!.options!.length, data!.item);
            },
          )
        : Draggable<DualListItemData>(
            data: data,
            feedback: Container(width: 100, height: 50, color: Colors.grey),
            child: InkWell(
              child: builder!(data!, data!.item),
              onTap: () {
                if (side == DragTargetDualListSide.left)
                  data!.controller!
                      .moveTo(data!.controller!.items!.length, data!.item);
                else if (side == DragTargetDualListSide.right)
                  data!.controller!
                      .moveFrom(data!.controller!.options!.length, data!.item);
              },
            ),
            childWhenDragging: Container(color: Colors.amber),
            onDragCompleted: () {
              //widget.controller.remove(widget.item);
              // alterado para o target para controller sucesso sincronizado
            },
          );
  }
}

class DualListItemCard extends StatelessWidget {
  final DragTargetDualListSide? side;
  final Widget Function(DualListItemData, dynamic)? builder;
  final DualListItemData? data;
  final bool? canDrag;
  const DualListItemCard({
    Key? key,
    @required this.data,
    @required this.builder,
    @required this.side,
    @required this.canDrag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DraggableDualListItem(
          key: UniqueKey(),
          side: side,
          builder: builder,
          data: data,
          canDrag: canDrag,
        ),
        DragTargetDualListItem(
          key: UniqueKey(),
          controller: data!.controller!,
          index: data!.index!,
          side: side!,
          canDrag: canDrag!,
        ),
      ],
    );
  }
}

enum DragTargetDualListSide { left, right }

class DragTargetDualListItem extends StatefulWidget {
  final DragTargetDualListSide? side;
  final int? index;
  final DualListViewerController? controller;
  final bool? canDrag;

  const DragTargetDualListItem({
    Key? key,
    @required this.side,
    this.index,
    @required this.canDrag,
    @required this.controller,
  }) : super(key: key);

  @override
  _DragTargetDualListItemState createState() => _DragTargetDualListItemState();
}

class _DragTargetDualListItemState extends State<DragTargetDualListItem> {
  bool accepted = false;

  expanded() {
    bool r = false;
    if (widget.side == DragTargetDualListSide.left)
      r = (widget.controller!.options!.length == 0) ||
          ((widget.index! + 1) == widget.controller!.options!.length);
    if (widget.side == DragTargetDualListSide.right)
      r = (widget.controller!.items!.length == 0) ||
          ((widget.index! + 1) == widget.controller!.items!.length);
    return r;
  }

  @override
  Widget build(BuildContext context) {
    return (!widget.canDrag!)
        ? Container()
        : DragTarget<DualListItemData>(
            onWillAccept: (value) {
              return accepted = true;
            },
            onLeave: (value) {
              accepted = false;
              return;
            },
            onAccept: (value) {
              if (widget.side == DragTargetDualListSide.left)
                widget.controller!.moveFrom(widget.index! + 1, value.item);
              else if (widget.side == DragTargetDualListSide.right)
                widget.controller!.moveTo(widget.index! + 1, value.item);
              setState(() {
                accepted = false;
              });
              return;
            },
            builder: (BuildContext context, List<dynamic> candidateData,
                List<dynamic> rejectedData) {
              return (accepted)
                  ? Container(
                      height: 50,
                      color: Colors.grey.withOpacity(0.9),
                    )
                  : //Container(
                  //  color: Colors.grey.withOpacity(0.2),
                  //child:
                  Container(
                      height: expanded() ? 50 : 5,
                      //color: expanded() ? Colors.grey.withOpacity(0.1) : null,
                      //),
                    );
            },
          );
  }
}
