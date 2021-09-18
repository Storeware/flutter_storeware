// @dart=2.12
import 'package:controls_web/controls/backdoor_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:controls_web/controls.dart';

class LoginBackground extends StatelessWidget {
  final Widget body;
  const LoginBackground({Key? key, required this.body}) : super(key: key);
  final top = 180.0;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;
    return BackdoorScaffold(
      preferredSize: Size.fromHeight(125),
      //appBar: AppBar(title: Text('titulo')),
      appBarChild: Stack(children: [
        //GradientBox(height: 180),
        CurvaOndaHorizontal(
          height: 180,
          color: Colors.blue,
          backgroundColor: theme.scaffoldBackgroundColor,
        ),
        Positioned(
            top: 30,
            left: 8,
            child:
                Image.asset('assets/wba.png', width: 160, color: Colors.blue)),
        Positioned(
          left: 30,
          top: 110,
          child: Container(
            height: 70,
            width: double.maxFinite,
            child: Row(
              children: [
                Icon(Icons.person, color: Colors.blue),
                //Image.asset('assets/login_person.png'),
//                Expanded(child: Container()),
              ],
            ),
            //color: Colors.transparent,
          ),
        ),
        Positioned(
          right: 50,
          top: 40,
          child: Image.asset(
            'assets/nav/dashboard.png',
            width: 60,
          ),
        )
      ]),
      children: [
        //GradientBox(
        //  height: 40,
        //),
        ClipRRect(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(40)),
          child: Container(
              //padding: EdgeInsets.only(left: 10),
              height: size.height - 180,
              width: double.maxFinite,
              child: Image.asset('assets/login_fundo.png', fit: BoxFit.fill)),
        ),
        Container(
          width: double.maxFinite,
          height: size.height - 180,
          child: body,
        ),
      ],
    );
  }
}

class CurvaOndaHorizontal extends StatelessWidget {
  CurvaOndaHorizontal(
      {Key? key,
      this.backgroundColor,
      required this.color,
      required this.height,
      this.width})
      : super(key: key);
  final double height;
  final double? width;
  final Color color;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    ResponsiveInfo resposive = ResponsiveInfo(context);
    double w = width ?? resposive.size.width;
    //width;
    double h = height;
    return Container(
      height: h,
      width: w,
      color: backgroundColor ?? Colors.white,
      //color: Colors.green,
      child: CustomPaint(painter: _WavePainter(color: color)),
    );
  }
}

class _WavePainter extends CustomPainter {
  final Color? color;
  _WavePainter({
    this.color,
  });
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color ?? Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    var path = Path();
    path.moveTo(0, size.height * .7);
    path.quadraticBezierTo(size.width * .2, size.height * .55, size.width * .35,
        3 * size.height * .23);
    path.quadraticBezierTo(
        size.width * .80, size.height * 1, size.width, size.height * .7);
    path.moveTo(0, size.height * .07);
    canvas.drawPath(path, paint);
    path.close();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
