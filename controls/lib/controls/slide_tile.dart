import 'package:flutter/material.dart';

class SlideTile extends StatefulWidget {
  final String button;
  final Function onTap;
  final Function onPressed;
  final Function onRatingPressed;
  final String img;
  final String title;
  final String subTitle;
  final String rating;
  final Color ratingBG;
  final double elevation;
  final Color color;
  final Color textColor;
  final Widget trailing;
  SlideTile(
      {Key key,
      this.button,
      this.color,
      this.onTap,
      this.onPressed,
      this.textColor = Colors.black,
      this.onRatingPressed,
      this.trailing,
      @required this.img,
      @required this.title,
      @required this.subTitle,
      @required this.rating,
      this.elevation = 3.0,
      this.ratingBG = Colors.blue})
      : super(key: key);

  @override
  _SlideTileState createState() => _SlideTileState();
}

class _SlideTileState extends State<SlideTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: Container(
        height: MediaQuery.of(context).size.height / 2.5, //2.9,
        width: MediaQuery.of(context).size.width / 1.2,
        child: Card(
          color: widget.color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          elevation: widget.elevation,
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height / 3.7,
                    width: MediaQuery.of(context).size.width,
                    child: InkWell(
                      onTap: widget.onTap,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        child: Image.asset(
                          "${widget.img}",
                          fit: BoxFit.fitHeight,
                          //height: imgHeigth,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 6.0,
                    right: 6.0,
                    child: widget.rating != null
                        ? SlideButton(
                            color: widget.color,
                            leading: Icon(
                              Icons.star,
                              color: widget.ratingBG,
                              size: 10,
                            ),
                            text: " ${widget.rating} ",
                            textColor: widget.textColor,
                            onPressed: widget.onRatingPressed,
                          )
                        : Container(),
                  ),
                  Positioned(
                    top: 6.0,
                    left: 6.0,
                    child: widget.button != null
                        ? SlideButton(
                            color: widget.color,
                            text: widget.button,
                            textColor: widget.textColor,
                            onPressed: widget.onPressed)
                        : Container(),
                  ),
                ],
              ),
              SizedBox(height: 7.0),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "${widget.title}",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: widget.textColor,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              SizedBox(height: 7.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Container(
                      //width: MediaQuery.of(context).size.width,
                      child: Text(
                        "${widget.subTitle}",
                        style: TextStyle(
                          fontSize: 12,
                          color: widget.textColor,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ),
                  widget.trailing ?? Container()
                ],
              ),
              SizedBox(height: 10.0),
            ],
          ),
        ),
      ),
    );
  }
}

class SlideButton extends StatelessWidget {
  const SlideButton(
      {this.text,
      this.textStyle,
      this.color,
      Key key,
      this.elevation = 1.0,
      this.textColor,
      this.onPressed,
      this.child,
      this.width,
      this.height,
      this.leading,
      this.trailing})
      : super(key: key);

  final String text;
  final Color textColor;
  final Function onPressed;
  final Widget leading;
  final Widget trailing;
  final double elevation;
  final TextStyle textStyle;
  final Color color;
  final Widget child;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
       width: width,
       height: height,
        child: Card(
      color: color,
      elevation: elevation,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: <Widget>[
            leading ?? Container(),
            InkWell(
              onTap: onPressed,
              child: Text(
                text ?? '',
                style: textStyle ??
                    TextStyle(
                      fontSize: 10,
                      color: textColor ?? Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            child ?? Container(),
            trailing ?? Container()
          ],
        ),
      ),
    ));
  }
}
