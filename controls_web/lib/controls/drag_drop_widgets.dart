import 'package:flutter/material.dart';

class DraggableData<T> {
  final T? data;
  final Function(T)? onCompleted;
  DraggableData({
    this.data,
    this.onCompleted,
  });
}

class DraggableItem<T> extends StatelessWidget {
  final T? data;
  final Widget? child;
  final Widget? feedback;
  final Function(T)? onCompleted;
  final Function()? onStarted;
  final Function(DraggableDetails)? onEnd;
  final IconData? icon;
  const DraggableItem({
    Key? key,
    @required this.child,
    this.feedback,
    this.onCompleted,
    this.onStarted,
    this.onEnd,
    this.icon,
    @required this.data,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Draggable<DraggableData<T>>(
      data: DraggableData<T>(
          data: data,
          onCompleted: (data) {
            if (onCompleted != null) onCompleted!(data);
          }),
      feedback:
          feedback ?? CircleAvatar(child: Icon(icon ?? Icons.my_location)),
      child: child!,
      //onDragCompleted: onCompleted,
      onDragStarted: onStarted,
      onDragEnd: onEnd,
    );
  }
}

class DragTargetItem<T> extends StatelessWidget {
  final Widget? child;
  final T? item;
  final Future<bool> Function(T)? onAccept;
  final Function(T)? afterAccept;
  final IconData? icon;
  final double? iconSize;
  final Color? color;
  final Function(T)? onWillAccept;

  const DragTargetItem({
    Key? key,
    @required this.child,
    @required this.item,
    @required this.onAccept,
    this.afterAccept,
    this.iconSize = 55,
    this.icon,
    this.color,
    this.onWillAccept,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool accepted = false;
    return DragTarget<DraggableData<T>>(
      builder: (BuildContext context, List<DraggableData<T>?> candidateData,
          List<dynamic> rejectedData) {
        return (!accepted)
            ? child!
            : Icon(icon ?? Icons.camera,
                color: color ?? Colors.grey, size: iconSize);
      },
      onAccept: (data) {
        onAccept!(data.data!).then((rsp) {
          if (afterAccept != null) afterAccept!(data.data!);
          if (data.onCompleted != null) data.onCompleted!(data.data!);
        });
        accepted = false;
      },
      onLeave: (d) {
        accepted = false;
      },
      onWillAccept: (data) {
        accepted = (onWillAccept != null) ? onWillAccept!(data!.data!) : true;
        return accepted;
      },
    );
  }
}
