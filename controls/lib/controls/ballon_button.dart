import 'dart:math';
import 'package:flutter/material.dart';



List<List<Color>> _colores=[
  [Colors.amber,Colors.greenAccent,Colors.black12,Colors.blue,Colors.deepOrangeAccent],
  [Colors.deepOrange[50],Colors.deepOrange[50],Colors.lime[50],Colors.lightGreen[100],Colors.greenAccent[100]],
  [Colors.amber,Colors.greenAccent,Colors.black12,Colors.blue,Colors.deepOrangeAccent],
  [Colors.green[100],Colors.lightBlue[100],Colors.orangeAccent[100],Colors.deepOrangeAccent[100],Colors.brown[100]],
  [Colors.lightBlue,Colors.black12,Colors.orangeAccent,Colors.deepOrangeAccent,Colors.amberAccent],
];

Color genColores( int index, [bool isRandom=false] ){
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

Color randomColores(){
  return genColores(-1,true);
}


// ignore: must_be_immutable
class BallonButton extends StatelessWidget {
  final String text;
  EdgeInsetsGeometry padding;
  final double radius;
  Color borderColor;
  final double borderWidth;
  Color color;
  final double leftRight;
  final double topBottom;
  //final VoidCallback onTap;

  BallonButton(
      {
    this.text,
    this.color,
    this.padding,
    this.radius=30.0,
    this.borderWidth=1.0,
    this.borderColor,
    this.leftRight=15.0,
    this.topBottom:5.0
  }){
    if (this.padding==null)
       this.padding = EdgeInsets.only(left:leftRight,right:leftRight,top:topBottom,bottom:topBottom);
    if (this.borderColor==null)
      borderColor = const Color.fromRGBO(221, 221, 221, 1.0);
    if (this.color==null)
       color = randomColores();
  }

  @override
  Widget build(BuildContext context) {
    return  new Container(
        padding: padding,
        decoration: new BoxDecoration(
            color: color,
            borderRadius: new BorderRadius.all(Radius.circular(this.radius)),
            border: new Border.all(
                color: borderColor,
                width: borderWidth)),
        child: new Text(text ));

  }
}
