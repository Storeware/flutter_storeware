import 'package:flutter/material.dart';

class BackgroundImage extends StatelessWidget {
  final String imageFile;
  final Widget child;
  const BackgroundImage(this.imageFile, {Key key, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      //width: size.width,
      //height: size.height,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            //width: size.width,
            //height: size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: Image.asset(
                  this.imageFile,
                ).image,
                fit: BoxFit.cover,
              ),
            ),
            //child:child
          ),
          Positioned(top: 1, bottom: 1, left: 1, right: 1, child: child)
        ],
      ),
    );
  }
}
