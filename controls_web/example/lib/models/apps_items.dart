
import 'package:controls_web/controls/colores.dart';
import 'package:controls_web/controls/home_elements.dart';
import 'package:flutter/material.dart';

class AppsItems{
  static final _singleton = AppsItems._create();
  factory AppsItems()=>_singleton;
  AppsItems._create();
  static List<Widget> builder(context){
    return _singleton._init(context);  
  }
  _init(context){
    List<Widget> _items=[];
    _items.add( ApplienceTile(
      dividerHeight:1,
      value: '10', color: genColor(1) , title: 'yyyy',)  ) ;
    _items.add( ApplienceTile.panel(image: Icon(Icons.ac_unit),value: '10',color: genColor(2),title: 'xxxxrr',)  ) ;
    _items.add( ApplienceTile(value: '10',color: genColor(3),title: 'xxxxrr',)  ) ;
    _items.add( ApplienceTile(value: '10',color: genColor(4),title: 'xxxxrr',)  ) ;
    _items.add( ApplienceTile(value: '10',color: genColor(5),title: 'xxxxrr',)  ) ;
    _items.add( ApplienceTile(value: '10',color: genColor(6),title: 'xxxxrr',)  ) ;
 
 
    return _items;
  }

  static List<Widget> topBars(){
    List<Widget> r = [];
    r.add(ApplienceTile.status(
        color: genColor(1),
        value:'11',
        title:'Títulos',
        width: 150,
    ));
    return r;
  }
  

}