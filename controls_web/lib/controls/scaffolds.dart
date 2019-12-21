import 'package:controls_web/controls/rounded_button.dart';
import 'package:flutter/material.dart';

class ScaffoldSplash extends StatefulWidget {
  final Widget body;
  final Widget image;
  final String title;
  final AppBar appBar;
  final Drawer drawer;
  final Widget floatingActionButton;
  final Widget bottomNavigationBar;
  final Function onPressed;
  ScaffoldSplash({
    Key key,
    this.appBar,
    this.drawer,
    this.title,
    this.image,
    this.onPressed,
    this.body,
    this.floatingActionButton,
    this.bottomNavigationBar,
  }) : super(key: key);

  @override
  _ScaffoldSplashState createState() => _ScaffoldSplashState();
}

class _ScaffoldSplashState extends State<ScaffoldSplash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: widget.drawer,
      appBar: widget.appBar,
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
          if (widget.body != null) widget.body,
          if (widget.onPressed != null)
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
      bottomNavigationBar: widget.bottomNavigationBar,
      floatingActionButton: floatingActionButton,
    );
  }
}
