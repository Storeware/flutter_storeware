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
    _items.add(ApplienceTile.status(
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
    _items.add(ApplienceStatus(
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
    _items.add(ApplienceTile.status(
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
      onPressed: () {},
      value: '99',
      icon: Icons.access_time,
    ));
    r.add(ApplienceStatus(
      padding: EdgeInsets.all(4),
      width: 150,
      icon: Icons.sim_card,
      title: 'Cards',
      bottom: ApplienceCards(children: [Text('x'), Text('y')]),
    ));
    r.add(ApplienceStatus(
        width: 150,
        title: 'Detalhes',
        color: Colors.amber,
        icon: Icons.adjust,
        valueFontSize: 18,
        bottom: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            ApplienceStatus.transparent(
              title: 'Itens',
              value: '1',
            ),
            ApplienceStatus.transparent(
              title: 'Total',
              value: '2',
            )
          ],
        )));
    for (int i in intRange(0, 5)) {
      r.add(ApplienceTicket(
        color: genColor(i),
        value: ((i + 1) * 10).toString(),
        subTitle: 'Títulos-$i',
      ));
    }
    return r;
  }

  static List<Widget> body(context) {
    List<Widget> r = [];
    r.add(Container(
        color: Colors.lightBlue,
        child: ApplienceCards(elevation: 0, children: [
          for (var i in intRange(20, 25))
            Chip(backgroundColor: genColor(i), label: Text('body $i')),
        ])));
    r.add(Container(
      height: 200,
      child: ApplienceCarrousel(
        enabled: true,
        children: <Widget>[
          Container(
            color: Colors.greenAccent,
            height: 80,
            width: MediaQuery.of(context).size.width * 2 / 3,
          ),
          Container(
            color: Colors.red,
            height: 120,
            width: 120,
          ),
          for (var i in intRange(1, 10))
            Containcer c(
              color: genColor(i),
              height: 120,
              width: 120,
            )
        ],
      ),
    ));

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
