
import 'package:controls_web/controls/colores.dart';
import 'package:controls_web/controls/home_elements.dart';
import 'package:flutter/material.dart';

class AppsItems{
  static final _singleton = AppsItems._create();
  factory AppsItems()=>_singleton;
  AppsItems._create(){
    _init();
  }
  final List<Widget> _items = [];
  static List<Widget> builder(){
    return _singleton._items;
  }

  _init(){
    _items.clear();
    _items.add( ApplienceTile(value: '10', color: genColor(1) , title: 'yyyy',)  ) ;
    _items.add( ApplienceTile(value: '10',color: genColor(2),title: 'xxxxrr',)  ) ;
    _items.add( ApplienceTile(value: '10',color: genColor(3),title: 'xxxxrr',)  ) ;
    _items.add( ApplienceTile(value: '10',color: genColor(4),title: 'xxxxrr',)  ) ;
    _items.add( ApplienceTile(value: '10',color: genColor(5),title: 'xxxxrr',)  ) ;
    _items.add( ApplienceTile(value: '10',color: genColor(6),title: 'xxxxrr',)  ) ;
  }

}