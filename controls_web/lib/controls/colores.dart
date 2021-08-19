import 'dart:math';
import 'package:flutter/material.dart';

Color genColor(num index, [bool? isRandom = false]) {
  if (index < 0 || isRandom!) index = new Random().nextInt(1000);
  var y = (index ~/ 5) % 5;
  var x = (index % 5).toInt();
  if (y < 0) y = 0;
  if (y > 4) y = 4;
  if (x < 0) x = 0;
  if (x > 4) x = 4;
  //print([y,x]);
  return _colores[x][y];
}

Color randomColor() {
  return genColor(-1, true);
}

Color genColorSeeds(int index, List<Color> seeds) {
  int pos = (index % seeds.length);
  return seeds[pos];
}

const coldColors = [
  Colors.transparent,
  Colors.green,
  Colors.blue,
  Colors.lightGreen,
  Colors.lime,
  Colors.green
];
const warmColors = [
  Colors.transparent,
  Colors.amber,
  Colors.orange,
  Colors.red,
  Colors.yellow,
  Color(0xFFffaea5)
];

const amethistColors = [
  Color(0xffefeeee),
  Color(0xffe9ccb1),
  Color(0xffd3c4be),
  Color(0xffe4dac2),
  Color(0xfff4eee1),
  Color(0xffc4bdac),
  Color(0xffebcfc4),
  Color(0xffe8e6d9),
  Color(0xff999999),
  Color(0xfff3ecac),
];

const pastelColors = [
  Color(0xffabdee6), //0
  Color(0xffcbaacb), //1
  Color(0xffffffb5), //2
  Color(0xffffccb6), //3
  Color(0xfff3b0c3), //4
  Color(0xffc6dbda), //5
  Color(0xfffee1e8), //6
  Color(0xfffed7c3), //7
  Color(0xfff6eac2), //8
  Color(0xffecd5e3), //9
  Color(0xffff968a), //10
  Color(0xffffaea5), //11
  Color(0xffffc5bf), //12
  Color(0xffffd8be), //3
  Color(0xffffc8a2), //4
  Color(0xffd4f0f0), //5
  Color(0xff8fcaca), //6
  Color(0xffcce2cb), //7
  Color(0xffb6cfb6), //8
  Color(0xff97c1a9), //9
  Color(0xfffcb9aa), //20
  Color(0xffffdbcc), //1
  Color(0xffeceae4), //2
  Color(0xffa2e1db), //3
  Color(0xff55cbcd) //4
];

List<List<Color>> _colores = [
  [
    pastelColors[19],
    pastelColors[1],
    pastelColors[2],
    pastelColors[3],
    pastelColors[4]
  ],
  [
    pastelColors[5],
    pastelColors[6],
    pastelColors[6],
    pastelColors[7],
    pastelColors[8]
  ],
  [
    pastelColors[9],
    pastelColors[10],
    pastelColors[11],
    pastelColors[12],
    pastelColors[13]
  ],
  [
    pastelColors[14],
    pastelColors[15],
    pastelColors[16],
    pastelColors[17],
    pastelColors[18]
  ],
  [
    amethistColors[0],
    amethistColors[1],
    amethistColors[2],
    amethistColors[3],
    amethistColors[4]
  ],
];
