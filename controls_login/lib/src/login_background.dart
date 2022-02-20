// @dart=2.12
import 'package:flutter/material.dart';
import 'package:controls_web/controls.dart';

class LoginBackground extends StatelessWidget {
  final Widget body;
  final String? appLogoImage;
  final String? logoImage;
  final String? backgroundImage;
  final Widget? topBackground;
  final Widget? title;
  final Widget? appBarChild;
  final List<Widget>? children;

  const LoginBackground({
    Key? key,
    this.logoImage,
    this.topBackground,
    this.appLogoImage,
    this.backgroundImage,
    this.title,
    this.appBarChild,
    this.children,
    this.top = 180.0,
    required this.body,
  }) : super(key: key);
  final double top;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;
    return BackdoorScaffold(
      preferredSize: const Size.fromHeight(125),
      //appBar: AppBar(title: Text('titulo')),
      appBarChild: appBarChild ??
          Stack(children: [
            topBackground ??
                CurvaOndaHorizontal(
                  height: top,
                  color: Colors.blue,
                  backgroundColor: theme.scaffoldBackgroundColor,
                ),
            Positioned(
                top: 30,
                left: 8,
                child: Image.asset(logoImage ?? 'assets/wba.png',
                    width: 160, color: Colors.blue)),
            if (title != null)
              Positioned(
                  top: 10,
                  right: 8,
                  child: DefaultTextStyle(
                      child: title!,
                      style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 20,
                          fontWeight: FontWeight.bold))),
            Positioned(
              left: 30,
              top: top - 70,
              child: SizedBox(
                height: 70,
                width: double.maxFinite,
                child: Row(
                  children: const [
                    Icon(Icons.person, color: Colors.blue),
                    //Image.asset('assets/login_person.png'),
//                Expanded(child: Container()),
                  ],
                ),
                //color: Colors.transparent,
              ),
            ),
            if (appLogoImage != null)
              Positioned(
                right: 50,
                top: 40,
                child: Image.asset(
                  appLogoImage!,
                  width: 60,
                ),
              )
          ]),
      children: [
        if (backgroundImage != null)
          ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(40)),
            child: SizedBox(
                //padding: EdgeInsets.only(left: 10),
                height: size.height - top,
                width: double.maxFinite,
                child: Image.asset(backgroundImage ?? 'assets/login_fundo.png',
                    fit: BoxFit.fill)),
          ),
        SizedBox(
          width: double.maxFinite,
          height: size.height - top,
          child: body,
        ),
        if (children != null) ...children!
      ],
    );
  }
}

class CurvaOndaHorizontal extends StatelessWidget {
  const CurvaOndaHorizontal(
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
