
import 'package:controls_web/controls/colores.dart';
import 'package:controls_web/controls/home_elements.dart';
import 'package:flutter/material.dart';

class AppsItems{
  static final _singleton = AppsItems._create();
  factory AppsItems()=>_singleton;
  AppsItems._create(){
    
  }
  final List<Widget> _items = [];
 
 
  static List<Widget> builder(context){
    return _singleton._init(context);  
  }

  _init(context){
    _items.clear();
    _items.add( ApplienceTile(
      dividerHeight:1,
      value: '10', color: genColor(1) , title: 'yyyy',)  ) ;
    _items.add( ApplienceTile(image: Icon(Icons.ac_unit),value: '10',color: genColor(2),title: 'xxxxrr',)  ) ;
    _items.add( ApplienceTile(value: '10',color: genColor(3),title: 'xxxxrr',)  ) ;
    _items.add( ApplienceTile(value: '10',color: genColor(4),title: 'xxxxrr',)  ) ;
    _items.add( ApplienceTile(value: '10',color: genColor(5),title: 'xxxxrr',)  ) ;
    _items.add( ApplienceTile(value: '10',color: genColor(6),title: 'xxxxrr',)  ) ;
 
 
    return _items;
  }

  static List<Widget> topBars(){
    List<Widget> r = [];
    r.add(ApplienceTile(
        value:'11',
        valueFontSize: 24,
        title:'Títulos',
        titleFontSize: 16,
        elevation:1.0
    ));
    return r;
  }
  

}