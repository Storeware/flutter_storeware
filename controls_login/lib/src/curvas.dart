// @dart=2.12
import 'package:flutter/material.dart';

class CurvaPoint {
  double w1, h1, w2, h2;
  CurvaPoint(this.w1, this.h1, this.w2, this.h2);
  toString() {
    return '[$w1, $h1, $w2, $h2]';
  }

  toStringPer(double w, double h) {
    return '[${100 * w1 / w}, ${100 * h1 / h}, ${100 * w2 / w}, ${100 * h2 / h}]';
  }
}

class Point {
  double x, y;
  Point(this.x, this.y);
}

class CurvePainter extends CustomPainter {
  final Point? startAt;
  final Point? endAt;
  final List<CurvaPoint>? points;
  final Color? color;
  CurvePainter({this.startAt, this.endAt, this.color, this.points});
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = color ?? Colors.lightBlue.withOpacity(0.5);
    paint.style = PaintingStyle.fill;
    var path = Path();
    path.moveTo(startAt?.x ?? 0, startAt?.y ?? 0);
    if (points != null)
      for (var p in points!) path.quadraticBezierTo(p.w1, p.h1, p.w2, p.h2);
    path.lineTo(endAt?.x ?? size.width, endAt?.y ?? size.height);
    canvas.drawPath(path, paint);
    path.close();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

/*
              
*/
class CurvaLateralEsquerda extends StatelessWidget {
  final double width;
  final double height;
  final Color? color;
  const CurvaLateralEsquerda(
      {Key? key, this.width = 200, this.height = 450, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double w = width;
    double h = height;
    return Container(
      width: w,
      height: h,
      child: CustomPaint(
          painter: CurvePainter(
              color: color,
              startAt: Point(0, 0),
              points: [
                CurvaPoint(0, 0, w, 0),
                CurvaPoint(w * .38, h * .09, w * .34, h * .43),
                CurvaPoint(w * .28, h * .73, 0, h)
              ],
              endAt: Point(0, h))),
    );
  }
}

class CurvaRodapeEsquerdo extends StatelessWidget {
  final double width;
  final double height;
  final Color? color;
  const CurvaRodapeEsquerdo(
      {Key? key, this.width = 400, this.height = 200, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var w = width;
    var h = height;
    return Container(
      width: w,
      height: h,
      child: CustomPaint(
          painter: CurvePainter(
              color: color,
              startAt: Point(0, h),
              points: [
                CurvaPoint(0, 0, 0, h * .08),
                CurvaPoint(0, h * .70, w * .34, h * .80),
              ],
              endAt: Point(w, h))),
    );
  }
}
