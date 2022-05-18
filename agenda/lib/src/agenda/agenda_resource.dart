// @dart=2.12

import 'package:flutter/widgets.dart';

class AgendaResource {
  String? label;
  String? gid;
  Color? color;
  double intervalo;

  AgendaResource({this.gid, this.label, this.color, required this.intervalo});
}

class AgendaResources {
  List<AgendaResource> resources = [];
  operator [](index) => resources[index];
  add(AgendaResource item) {
    //print(item);
    resources.add(item);
    return this;
  }

  int indexOf(String? gid) {
    for (var i = 0; i < resources.length; i++)
      if (resources[i].gid == gid) return i;
    return -1;
  }

  find(String? gid) {
    var i = indexOf(gid);
    return (i < 0) ? null : resources[i];
  }

  addAll(items) {
    resources.addAll(items);
    return this;
  }

  clear() {
    resources.clear();
  }

  get length => resources.length;
}
