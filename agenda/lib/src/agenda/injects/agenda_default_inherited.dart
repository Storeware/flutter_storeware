// @dart=2.12

import 'package:console/views/agenda/models/agenda_item_model.dart';
import 'package:flutter/widgets.dart';

class DefaultAgendaEdit extends InheritedWidget {
  final AgendaItem? item;
  final dynamic widget;
  final DateTime? dataRef;
  final dynamic data = {};
  DefaultAgendaEdit({
    Key? key,
    required Widget child,
    this.dataRef,
    this.item,
    this.widget,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(DefaultAgendaEdit oldWidget) {
    return false;
  }

  static of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<DefaultAgendaEdit>();
}
