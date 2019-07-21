import 'dart:math';
import 'package:flutter/material.dart';


List<List<Color>> _colores=[
  [Colors.amber,Colors.greenAccent,Colors.black12,Colors.blue,Colors.deepOrangeAccent],
  [Colors.deepOrange[50],Colors.deepOrange[50],Colors.lime[50],Colors.lightGreen[100],Colors.greenAccent[100]],
  [Colors.amber,Colors.greenAccent,Colors.black12,Colors.blue,Colors.deepOrangeAccent],
  [Colors.green[100],Colors.lightBlue[100],Colors.orangeAccent[100],Colors.deepOrangeAccent[100],Colors.brown[100]],
  [Colors.lightBlue,Colors.black12,Colors.orangeAccent,Colors.deepOrangeAccent,Colors.amberAccent],
];

Color genColor( int index, [bool isRandom=false] ){
  if (index<0 || isRandom)
    index = new Random().nextInt(1000);
  var y = (index~/5) % 5;
  var x = (index%5).toInt() ;
  if (y<0) y = 0;
  if (y>4) y = 4;
  if (x<0) x = 0;
  if (x>4) x = 4;
  //print([y,x]);
  return _colores[x][y];
}

Color randomColor(){
  return genColor(-1,true);
}
