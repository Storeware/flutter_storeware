import 'package:controls_web/controls/colores.dart';
import 'package:controls_web/controls/home_elements.dart';
import 'package:controls_web/system.utils.dart';
import 'package:flutter/material.dart';

class AppsItems {
  static final _singleton = AppsItems._create();
  factory AppsItems() => _singleton;
  AppsItems._create();
  static List<Widget> builder(context) {
    return _singleton._init(context);
  }

  _init(context) {
    List<Widget> _items = [];
    _items.add(ApplienceTile(
      dividerHeight: 1,
      value: '10',
      color: genColor(1),
      title: 'yyyy',
    ));
    _items.add(ApplienceTile.panel(
      image: Icon(Icons.ac_unit),
      value: '10',
      color: genColor(2),
      title: 'xxxxrr',
    ));
    _items.add(ApplienceTile(
      value: '10',
      color: genColor(3),
      title: 'xxxxrr',
    ));
    _items.add(ApplienceTile(
      value: '10',
      color: genColor(4),
      title: 'xxxxrr',
    ));
    _items.add(ApplienceTile(
      value: '10',
      color: genColor(5),
      title: 'xxxxrr',
    ));
    _items.add(ApplienceTile(
      value: '10',
      color: genColor(6),
      title: 'xxxxrr',
    ));

    for (var i in intRange(10, 40)) {
      _items.add(ApplienceTile(
          value: i.toString(), title: 'YYYY $i', color: genColor(i)));
    }

    return _items;
  }
  
  static List<Widget> topBars() {
    List<Widget> r = [];
    r.add(ApplienceTicket(
      title: 'Detalhes',
      color: Colors.amber,
      subTitle: 'novo item',
      onPressed: (){},
      value: '99',
      icon: Icons.access_time,
    ));
    for (int i in intRange(0, 5)) {
      r.add(ApplienceTile.status(
        color: genColor(i),
        value: ((i + 1) * 10).toString(),
        title: 'Títulos-$i',
        width: 150,
      ));
    }
    return r;
  }

  static List<Widget> body() {
    List<Widget> r = [];
    for (var i in intRange(10, 15)) {
      r.add(ListTile(title: Text('body $i')));
    }

    return r;
  }

  static List<Widget> bottom() {
    List<Widget> r = [];
    for (var i in intRange(10, 15)) {
      r.add(ListTile(title: Text('Bottom $i')));
    }
    return r;
  }
}
