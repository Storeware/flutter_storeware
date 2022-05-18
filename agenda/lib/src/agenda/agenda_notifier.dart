// @dart=2.12

import 'package:flutter/widgets.dart';

import 'models/agenda_item_model.dart';

class DefaultSourceList extends ChangeNotifier {
  final List<AgendaItem?>? sources;
  DefaultSourceList({this.sources});
  int _in = 0;
  begin() {
    _in++;
  }

  end() {
    _in--;
    changed();
  }

  delete(String? gid) {
    var i = indexOf(gid);
    //print('Delete $gid');
    if (i >= 0) {
      sources!.removeAt(i);
      changed();
    }
  }

  indexOf(String? gid) {
    if (gid == null) return -1;
    for (var i = 0; i < sources!.length; i++)
      if (sources![i]!.gid == gid) return i;
    return -1;
  }

  update(AgendaItem item) {
    var i = indexOf(item.gid);
    if (i >= 0) {
      sources![i]!.fromMap(item.toJson());
      changed();
    }
  }

  add(AgendaItem? item) {
    if (item != null) {
      sources!.add(item);
      changed();
      // print('add ${item.gid}');
    }
  }

  addAll(List<AgendaItem> its) {
    its.forEach((item) => add(item));
    changed();
  }

  changed() {
    if (_in <= 0) {
      notifyListeners();
      //print('notifier');
    }
  }
}

class DefaultAgendaItem extends InheritedWidget {
  final AgendaItem? item;
  final DefaultSourceList? sources;
  DefaultAgendaItem({Key? key, required Widget child, this.sources, this.item})
      : super(key: key, child: child);
  @override
  bool updateShouldNotify(DefaultAgendaItem oldWidget) {
    return oldWidget.item!.resource != item!.resource;
  }

  static DefaultAgendaItem? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DefaultAgendaItem>();
  }
}
