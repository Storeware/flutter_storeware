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

////////////////////////////////////////////
/// Main TimelineView
////////////////////////////////////////////
// ignore: must_be_immutable
class TimelineView extends StatelessWidget {
  List<Widget> children = [];
  double top;
  double bottom;
  double left;
  double right;
  double leftLine;
  double topLine;
  double bottomLine;

  TimelineView(
      {this.children,
      this.top = 0.0,
      this.bottom = 0.0,
      this.left = 16.0,
      this.right = 16.0,
      this.topLine = 0.0,
      this.leftLine = 32.0,
      this.bottomLine = 0.0});

  static builder(
      {int itemCount = 0,
      TimelineViewCallback itemBuilder,
      top = 10.0,
      bottom = 10.0,
      left = 16.0,
      right = 16.0,
      leftLine = 32.0,
      bottomLine = 0.0}) {
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
      bottomLine: bottomLine,
    );
    return vw;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      TimelineVerticalLine(
        left: leftLine,
        top: topLine,
        bottom: bottomLine,
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

@immutable
class TimelineTile extends StatelessWidget {
  final Widget title;
  final Widget subTitle;
  final Widget leading;
  final Widget trailing;
  final double dotSize;
  final Color dotColor;
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
      this.dotColor = Colors.blue,
      this.dotSize = 10.0,
      this.onLongPress /*, this.animation*/})
      : super(key: key);

  List<Widget> _list = [];
  _createList() {
    _list = [];
    if (title != null) _list.add(title);
    if (subTitle != null) _list.add(subTitle);
  }

  Widget _createGap() {
    return new Padding(
      padding: new EdgeInsets.symmetric(horizontal: gap),
    );
  }

  List<Widget> _createRow() {
    List<Widget> rt = [];
    // dot
    if (icon == null)
      rt.add(new Padding(
        padding: new EdgeInsets.symmetric(horizontal: dotLeft - dotSize / 2),
        child: new Container(
          height: dotSize,
          width: dotSize,
          decoration:
              new BoxDecoration(shape: BoxShape.circle, color: dotColor),
        ),
      ));

    if (icon != null)
      rt.add(new Padding(
        padding: new EdgeInsets.symmetric(horizontal: (dotLeft - dotSize) / 2),
        child: icon,
      ));

    if (gap > 0) rt.add(_createGap());

    if (leading != null) rt.add(leading);

    if (gap > 0) rt.add(_createGap());

    // tasks
    rt.add(new Expanded(
      child: new Padding(
          padding: EdgeInsets.symmetric(horizontal: left),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: _list,
          )),
    ));

    if (gap > 0) rt.add(_createGap());
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
    return new InkWell(
        onTap: (enabled ? onTap : null),
        onLongPress: (enabled ? onLongPress : null),
        child: Container(
          height: height,
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: _createRow()),
        ));
  }
}

@immutable
class TimelineVerticalLine extends StatelessWidget {
  final double top;
  final double bottom;
  final double left;
  final double width;
  final Color color;

  TimelineVerticalLine(
      {this.top = 0.0,
      this.bottom = 0.0,
      this.left = 32.0,
      this.width = 1.0,
      this.color = Colors.grey}) {
    //if (this.color == null) this.color = Colors.grey[300];
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

@immutable
class TimelineProfile extends StatelessWidget {
  final double minRadius;
  final double maxRadius;
  final ImageProvider<dynamic> image;
  final Widget icon;
  final double imageHeight;
  final double paddingLeft;
  final double paddingRight;
  final Widget title;
  final Widget subTitle;
  final double height;
  final Widget trailling;
  final Color color;
  final Decoration foregroundDecoration;
  final Decoration decoration;
  final EdgeInsets margin;

  TimelineProfile(
      {this.minRadius = 28.0,
      this.maxRadius = 28.0,
      this.image,
      this.icon,
      this.imageHeight = 28.0,
      this.paddingRight = 10.0,
      this.paddingLeft = 16.0,
      this.title,
      this.subTitle,
      this.trailling,
      this.height = 80.0,
      this.margin ,
      this.color = Colors.black12,
      this.decoration,
      this.foregroundDecoration});

  List<Widget> _list = [];
  _createList() {
    _list = [];
    if (title != null) _list.add(title);
    if (subTitle != null) _list.add(subTitle);
  }

  @override
  Widget build(BuildContext context) {
    _createList();
    return new Container(
      height: height,
      margin: (margin==null?EdgeInsets.all(0.0):margin),
      padding: new EdgeInsets.only(left: paddingLeft, top: imageHeight / 2.5),
      color: color,
      foregroundDecoration: foregroundDecoration,
      decoration: decoration,
      child: new Row(
        children: <Widget>[
          new CircleAvatar(
            minRadius: minRadius,
            maxRadius: maxRadius,
            backgroundImage: image,
            child: icon,
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

@immutable
class TimelineFabView extends StatefulWidget {
  final double top;
  final double left;
  final onClick;
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

@immutable
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
