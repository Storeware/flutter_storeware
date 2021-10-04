import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PanelGradient extends StatefulWidget {
  final Color? color;
  final titleColor;
  final double? radius;
  final onPressed;
  final double? height;
  final Widget? image;
  //final String title;
  //final String subTitle;
  //final Color subTitleColor;
  final Widget? child;
  final double? width;
  final double? opacity;
  PanelGradient(
      {Key? key,
      this.color,
      this.titleColor = Colors.white,
      this.onPressed,
      this.image,
      this.child,
      //  this.title = '',
      //  this.subTitle,
      //  this.subTitleColor = Colors.white,
      this.opacity = 1,
      this.width,
      this.height, //= 120.0,
      this.radius = 15.0})
      : super(key: key);

  _PanelGradientState createState() => _PanelGradientState();
}

//Opacity(opacity: widget.opacity, child: widget.image),
class _PanelGradientState extends State<PanelGradient> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
        padding:
            const EdgeInsets.only(bottom: 0, right: 6.0, left: 6.0, top: 0.0),
        child: GestureDetector(
          onTap: () {
            widget.onPressed();
          },
          child: SizedBox(
            child: Stack(
              children: <Widget>[
                Column(children: [
                  SizedBox(
                    height: 30.0,
                  ),
                  ClipRRect(
                    borderRadius: new BorderRadius.circular(widget.radius!),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.1, 0.5, 0.7, 0.9],
                          colors: [
                            Colors.blue[500]!, //widget.color.withOpacity(0.4),
                            Colors.blue[600]!, //widget.color.withOpacity(0.8),
                            Colors.blue[800]!, //widget.color.withOpacity(0.95),
                            Colors.blue[800]!, //widget.color.withOpacity(1),
                          ],
                        ),
                      ),
                      width: double.maxFinite,
                      //color: widget.color,
                      height: widget.height,
                    ),
                  ),
                ]),
                Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 0,
                        ),
                        Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                              color: widget.titleColor,
                            ),
                            width: size.width / 5,
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: widget.image,
                              ),
                            )),
                        if (widget.child != null)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: widget.child,
                          ),
                      ],
                    )),
              ],
            ),
          ),
        ));
  }
}
