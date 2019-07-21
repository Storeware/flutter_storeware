import 'package:flutter/material.dart';
import 'dart:math' as math;

/*

          TimelineFabView(),

          TimelineProfile( image: AssetImage('assets/foto.png'),
              title: Text('Pereira',style: TextStyle(fontSize: 28.0),),
              subTitle: Text('Gerente'),
              trailling: Text('24h'),
            ),
          Expanded(
            child: TimelineView.builder(itemCount:20, itemBuilder:(index){
              return TimelineTile(
                title: Text('Teste1'),
                subTitle: Text(index.toString()),
                trailling: Text(index.toString()),
                left: 16.0,
                icon: (index.isEven? Icon(Icons.add):Icon(Icons.memory)),
                dotSize: 22.0,
                dotColor: (index.isOdd? Colors.red: Colors.blue),
              );
            })
                      )


*/

typedef Widget TimelineViewCallback(int index);

//package:app/package:app/package:app/package:app/package:app/package:app/package:app///
/// Main TimelineView
//package:app/package:app/package:app/package:app/package:app/package:app/package:app///
// ignore: must_be_immutable
class TimelineView extends StatelessWidget {
  List<Widget> children = [];
  double top;
  double bottom;
  double left;
  double right;
  double leftLine;
  double topLine;

  TimelineView(
      {this.children,
      this.top = 0.0,
      this.bottom = 0.0,
      this.left = 16.0,
      this.right = 16.0,
      this.topLine = 0.0,
      this.leftLine = 32.0});

  static builder(
      {int itemCount = 0,
      TimelineViewCallback itemBuilder,
      top = 10.0,
      bottom = 10.0,
      left = 16.0,
      right = 16.0,
      leftLine = 32.0}) {
    List<Widget> rt = [];
    for (var idx = 0; idx < itemCount; idx++) {
      rt.add(itemBuilder(idx));
    }
    TimelineView vw = new TimelineView(
      children: rt,
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      leftLine: leftLine,
    );
    return vw;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      TimelineVerticalLine(
        left: leftLine,
        top: topLine,
        width: 1.0,
      ),
      Positioned(
          top: top,
          bottom: bottom,
          left: left,
          right: right,
          child: ListView(
            children: children,
          ))
    ]);
  }
}

// ignore: must_be_immutable
class TimelineTile extends StatelessWidget {
  //TimelineTask task;
  final Widget title;
  final Widget subTitle;
  final Widget leading;
  final Widget trailing;
  final double dotSize;
  Color dotColor;
  final double dotLeft;
  final double left;
  final double height;
  final Icon icon;
  final double gap;
  final GestureTapCallback onTap;
  final GestureLongPressCallback onLongPress;
  final bool enabled;

  //final Animation<double> animation;

  TimelineTile(
      {Key key,
      this.onTap,
      this.enabled = true,
      this.title,
      this.subTitle,
      this.leading,
      this.trailing,
      this.icon,
      this.height = 60.0,
      this.left = 16.0,
      this.gap = 2.0,
      this.dotLeft = 16.0,
      this.dotColor,
      this.dotSize = 10.0,
        this.onLongPress/*, this.animation*/})
      : super(key: key);

  List<Widget> _list = [];
  _createList() {
    _list = [];
    if (title != null) _list.add(title);
    if (subTitle != null) _list.add(subTitle);
  }

  Widget _createGap(){
    return new Padding(padding: new EdgeInsets.symmetric(horizontal: gap),);
  }

  List<Widget> _createRow() {
    List<Widget> rt = [];
    // dot
    rt.add(new Padding(
      padding: new EdgeInsets.symmetric(horizontal: dotLeft - dotSize / 2),
      child: new Container(
        height: dotSize,
        width: dotSize,
        child: icon,
        decoration: new BoxDecoration(shape: BoxShape.circle, color: dotColor),
      ),
    ));

    if (gap>0)
      rt.add( _createGap()  );


    if (leading!=null)
      rt.add(leading);

    if (gap>0)
      rt.add( _createGap()  );


    // tasks
    rt.add(new Expanded(
      child: new Padding(
          padding: EdgeInsets.symmetric(horizontal: left),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _list,
          )),
    ));

    if (gap>0)
      rt.add( _createGap()  );
    // trailing
    rt.add(
      new Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: trailing,
      ),
    );

    return rt;
  }



  @override
  Widget build(BuildContext context) {
    _createList();
    if (dotColor == null) dotColor = Colors.blue;
    return new InkWell(
       onTap: (enabled? onTap:null),
      onLongPress: (enabled?onLongPress:null),
      child: Container(
      height: height,
      child: Row( children: _createRow()),
    ));
  }
}

// ignore: must_be_immutable
class TimelineVerticalLine extends StatelessWidget {
  double top;
  double bottom;
  double left;
  double width;
  Color color;

  TimelineVerticalLine(
      {this.top = 0.0,
      this.bottom = 0.0,
      this.left = 32.0,
      this.width = 1.0,
      this.color}) {
    if (this.color == null) this.color = Colors.grey[300];
  }

  @override
  Widget build(BuildContext context) {
    return new Positioned(
      top: top,
      bottom: bottom,
      left: left,
      child: new Container(
        width: width,
        color: Colors.red[300],
      ),
    );
  }
}

// ignore: must_be_immutable
class TimelineProfile extends StatelessWidget {
  double minRadius;
  double maxRadius;
  ImageProvider<dynamic> image;
  double imageHeight;
  double paddingLeft;
  double paddingRight;
  Widget title;
  Widget subTitle;
  Widget trailling;

  TimelineProfile(
      {this.minRadius = 28.0,
      this.maxRadius = 28.0,
      this.image,
      this.imageHeight = 28.0,
      this.paddingRight = 10.0,
      this.paddingLeft = 16.0,
      this.title,
      this.subTitle,
      this.trailling});

  List<Widget> _list = [];
  _createList() {
    _list = [];
    if (title != null) _list.add(title);
    if (subTitle != null) _list.add(subTitle);
  }

  @override
  Widget build(BuildContext context) {
    _createList();
    return new Padding(
      padding: new EdgeInsets.only(left: paddingLeft, top: imageHeight / 2.5),
      child: new Row(
        children: <Widget>[
          new CircleAvatar(
            minRadius: minRadius,
            maxRadius: maxRadius,
            backgroundImage: image,
          ),
          new Expanded(
              child: new Padding(
            padding: EdgeInsets.only(left: paddingLeft),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: _list,
            ),
          )),
          new Padding(
            padding: EdgeInsets.only(right: paddingRight),
            child: trailling,
          )
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class TimelineFabView extends StatefulWidget {
  double top;
  double left;
  var onClick;
  TimelineFabView({this.top, this.left, this.onClick});
  @override
  _AnimatedFabViewState createState() => _AnimatedFabViewState();
}

class _AnimatedFabViewState extends State<TimelineFabView> {
  @override
  Widget build(BuildContext context) {
    return new Positioned(
        top: widget.top,
        left: widget.left,
        right: -40.0,
        child: new TimelineAnimatedFab(
          onClick: widget.onClick,
        ));
  }
}

class TimelineAnimatedFab extends StatefulWidget {
  final VoidCallback onClick;

  const TimelineAnimatedFab({Key key, this.onClick}) : super(key: key);

  @override
  _AnimatedFabState createState() => new _AnimatedFabState();
}

class _AnimatedFabState extends State<TimelineAnimatedFab>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<Color> _colorAnimation;

  final double expandedSize = 180.0;
  final double hiddenSize = 20.0;

  @override
  void initState() {
    super.initState();
    _animationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 200));
    _colorAnimation = new ColorTween(begin: Colors.pink, end: Colors.pink[800])
        .animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new SizedBox(
      width: expandedSize,
      height: expandedSize,
      child: new AnimatedBuilder(
        animation: _animationController,
        builder: (BuildContext context, Widget child) {
          return new Stack(
            alignment: Alignment.center,
            children: <Widget>[
              _buildExpandedBackground(),
              _buildOption(Icons.check_circle, 0.0),
              _buildOption(Icons.flash_on, -math.pi / 3),
              _buildOption(Icons.access_time, -2 * math.pi / 3),
              _buildOption(Icons.error_outline, math.pi),
              _buildFabCore(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOption(IconData icon, double angle) {
    double iconSize = 0.0;
    if (_animationController.value > 0.8) {
      iconSize = 26.0 * (_animationController.value - 0.8) * 5;
    }
    return new Transform.rotate(
      angle: angle,
      child: new Align(
        alignment: Alignment.topCenter,
        child: new Padding(
          padding: new EdgeInsets.only(top: 8.0),
          child: new IconButton(
            onPressed: _onIconClick,
            icon: new Transform.rotate(
              angle: -angle,
              child: new Icon(
                icon,
                color: Colors.white,
              ),
            ),
            iconSize: iconSize,
            alignment: Alignment.center,
            padding: new EdgeInsets.all(0.0),
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedBackground() {
    double size =
        hiddenSize + (expandedSize - hiddenSize) * _animationController.value;
    return new Container(
      height: size,
      width: size,
      decoration: new BoxDecoration(shape: BoxShape.circle, color: Colors.pink),
    );
  }

  Widget _buildFabCore() {
    double scaleFactor = 2 * (_animationController.value - 0.5).abs();
    return new FloatingActionButton(
      onPressed: _onFabTap,
      child: new Transform(
        alignment: Alignment.center,
        transform: new Matrix4.identity()..scale(1.0, scaleFactor),
        child: new Icon(
          _animationController.value > 0.5 ? Icons.close : Icons.filter_list,
          color: Colors.white,
          size: 26.0,
        ),
      ),
      backgroundColor: _colorAnimation.value,
    );
  }

  open() {
    if (_animationController.isDismissed) {
      _animationController.forward();
    }
  }

  close() {
    if (_animationController.isCompleted) {
      _animationController.reverse();
    }
  }

  _onFabTap() {
    if (_animationController.isDismissed) {
      open();
    } else {
      close();
    }
  }

  _onIconClick() {
    widget.onClick();
    close();
  }
}
