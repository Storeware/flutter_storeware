import 'dart:math';
import 'package:flutter/material.dart';

Color genColor(num index, [bool isRandom = false]) {
  if (index < 0 || isRandom) index = new Random().nextInt(1000);
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
  Color(0xffabdee6),
  Color(0xffcbaacb),
  Color(0xffffffb5),
  Color(0xffffccb6),
  Color(0xfff3b0c3),
  Color(0xffc6dbda),
  Color(0xfffee1e8),
  Color(0xfffed7c3),
  Color(0xfff6eac2),
  Color(0xffecd5e3),
  Color(0xffff968a),
  Color(0xffffaea5),
  Color(0xffffc5bf),
  Color(0xffffd8be),
  Color(0xffffc8a2),
  Color(0xffd4f0f0),
  Color(0xff8fcaca),
  Color(0xffcce2cb),
  Color(0xffb6cfb6),
  Color(0xff97c1a9),
  Color(0xfffcb9aa),
  Color(0xffffdbcc),
  Color(0xffeceae4),
  Color(0xffa2e1db),
  Color(0xff55cbcd)
];

List<List<Color>> _colores = [
  [
    pastelColors[0],
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
