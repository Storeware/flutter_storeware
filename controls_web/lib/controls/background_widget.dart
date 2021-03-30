// @dart=2.12
//import 'package:checkout/app/config/loja_config.dart';
import 'package:flutter/material.dart';

class BackgroundWidget extends StatelessWidget {
  final Widget? image;
  final Widget? child;
  final Widget? bottomNavigationBar;
  final Widget? topNavigationBar;
  BackgroundWidget({
    Key? key,
    this.image,
    this.child,
    this.topNavigationBar,
    this.bottomNavigationBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //return Container();
    return Stack(
      children: <Widget>[
        if (topNavigationBar != null) topNavigationBar!,
        Positioned(
          bottom: 1,
          child: (image == null)
              ? Container()
              : image ?? Container(), //?? LojaConfig.backgroundImage,
        ),
        if (bottomNavigationBar != null)
          Align(
              alignment: Alignment.bottomCenter,
              child: bottomNavigationBar ?? Container()),
        if (child != null) child!,
      ],
    );
  }
}
