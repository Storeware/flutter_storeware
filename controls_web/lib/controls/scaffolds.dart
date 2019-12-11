import 'package:controls_web/controls/rounded_button.dart';
import 'package:flutter/material.dart';

class ScaffoldSplash extends StatefulWidget {
  final Widget body;
  final Widget image;
  final String title;
  final Function onPressed;
  ScaffoldSplash({Key key, this.title, this.image, this.onPressed, this.body})
      : super(key: key);

  @override
  _ScaffoldSplashState createState() => _ScaffoldSplashState();
}

class _ScaffoldSplashState extends State<ScaffoldSplash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(children: [
          SizedBox(
            height: 70,
          ),
          Container(child: Center(child: widget.image)),
          SizedBox(
            height: 40,
          ),
          Text(widget.title),
          SizedBox(
            height: 30,
          ),
          RoundedButton(
            height: 40,
            width: 180,
            buttonName: 'Entrar',
            onTap: () {
              if (widget.onPressed != null) widget.onPressed();
            },
          )
        ]),
      ),
    );
  }
}
