import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageButton extends StatefulWidget {
  final Color color;
  final titleColor;
  final double radius;
  final onPressed;
  final double height;
  final Widget image;
  final String title;
  final String subTitle;
  final Color subTitleColor;
  final double width;
  final double opacity;
  final Widget leading;
  ImageButton(
      {Key key,
      this.color,
      this.titleColor = Colors.white,
      this.onPressed,
      this.image,
      this.leading,
      this.title = '',
      this.subTitle,
      this.subTitleColor = Colors.white,
      this.opacity = 1,
      this.width,
      this.height = 120.0,
      this.radius = 15.0})
      : super(key: key) {}

  _ImageButtonState createState() => _ImageButtonState();
}

//Opacity(opacity: widget.opacity, child: widget.image),
class _ImageButtonState extends State<ImageButton> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    //var theme = Theme.of(context);
    //var primaryColor = widget.color?? theme.primaryColor;
    return Padding(
        padding:
            const EdgeInsets.only(bottom: 0, right: 6.0, left: 6.0, top: 0.0),
        child: GestureDetector(
          onTap: () {
            widget.onPressed();
          },
          child: Container(
            child: Stack(
              children: <Widget>[
                Column(children: [
                  Container(
                    height: 30.0,
                  ),
                  ClipRRect(
                    borderRadius: new BorderRadius.circular(widget.radius),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.1, 0.5, 0.7, 0.9],
                          colors: [
                            Colors.blue[500], //widget.color.withOpacity(0.4),
                            Colors.blue[600], //widget.color.withOpacity(0.8),
                            Colors.blue[800], //widget.color.withOpacity(0.95),
                            Colors.blue[800], //widget.color.withOpacity(1),
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
                        Container(
                          height: widget.height / 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Text(
                            widget.title.toUpperCase(),
                            style: TextStyle(color: widget.titleColor),
                            maxLines: 3,
                            softWrap: true,
                          ),
                        ),
                        widget.subTitle != null
                            ? Divider(
                                height: 10.0,
                                color: Colors.white,
                              )
                            : Container(),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Text(
                            widget.subTitle ?? '',
                            softWrap: true,
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: 10, color: widget.subTitleColor),
                          ),
                        )
                      ],
                    )),
                if (widget.leading != null)
                  Positioned(top: 40, left: 5, child: widget.leading),
              ],
            ),
          ),
        ));
  }
}
