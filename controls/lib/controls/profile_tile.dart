import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const _baseSize = Size(411, 830);

double responsiveWidth(context, width) {
  return MediaQuery.of(context).size.width * width / _baseSize.width;
}

double responsiveHeight(context, height) {
  return MediaQuery.of(context).size.height * height / _baseSize.height;
}

class ProfileView extends StatefulWidget {
  final List<Widget> children;
  final Key sliversKey;
  ProfileView({Key key, this.children, this.sliversKey}) : super(key: key);

  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
          key: widget.sliversKey,
          delegate: SliverChildListDelegate(widget.children),
        )
      ],
    );
  }
}

class ProfileList extends StatelessWidget {
  final Widget title;
  final double height;
  final List<Widget> children;
  final Axis scrollDirection;
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;
  const ProfileList(
      {Key key,
      this.title,
      this.children,
      this.backgroundColor,
      this.height,
      this.padding,
      this.scrollDirection = Axis.horizontal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            width: double.infinity,
            color: backgroundColor,
            child: title ?? Container()),
        Container(
          height: height,
          color: backgroundColor,
          child: ListView(
            padding: padding,
            scrollDirection: scrollDirection,
            children: children,
          ),
        ),
      ],
    );
  }
}

class ProfileTile extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final Widget child;
  final Function onTap;
  final double radius;
  final Widget topBar;
  final Widget bottomBar;
  final Widget title;
  final double height;
  final double width;
  final double elevation;
  final Color color;
  const ProfileTile(
      {Key key,
      this.onTap,
      this.padding,
      this.radius = 10,
      this.color,
      this.height,
      this.width, //= double.maxFinite,
      this.topBar,
      this.child,
      this.title,
      this.bottomBar,
      this.elevation = 10})
      : super(key: key);

  n(v) {
    return v ?? Container();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: InkWell(
          onTap: onTap,
          child: Card(
            color: color,
            elevation: elevation,
            child: Padding(
              padding: padding ?? const EdgeInsets.all(0.0),
              child: Column(
                children: <Widget>[n(topBar), n(child), n(title), n(bottomBar)],
              ),
            ),
          )),
    );
  }
}

class ProfileValue extends StatefulWidget {
  final String value;
  final String label;
  final double height;
  final double width;
  final backgroundColor;
  final borderColor;
  final double elevation;
  final String unit;
  final Function onTap;
  final EdgeInsetsGeometry padding;
  final Axis direction;
  ProfileValue(
      {Key key,
      this.elevation = 0,
      this.direction = Axis.horizontal,
      this.value = '',
      this.label = '',
      this.height = 60,
      this.width = 110,
      this.backgroundColor,
      this.borderColor,
      this.unit,
      this.onTap,
      this.padding})
      : super(key: key);
  _ProfileValueState createState() => _ProfileValueState();
}

class _ProfileValueState extends State<ProfileValue> {
  @override
  Widget build(BuildContext context) {
    return ProfileButton(
        height: widget.height,
        width: widget.width,
        radius: 8,
        onPressed: widget.onTap,
        padding: widget.padding ?? EdgeInsets.all(0),
        color: widget.borderColor ?? widget.backgroundColor,
        child: Card(
          elevation: widget.elevation,
          color: widget.backgroundColor,
          child: Wrap(
            direction: widget.direction,
            children: <Widget>[
              Text(widget.label, style: TextStyle(fontSize: 16)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    widget.value,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text((widget.unit != null ? '/' + widget.unit : ''))
                ],
              ),
            ],
          ),
        ));
  }
}

class ProfileContainer extends StatelessWidget {
  final double height;
  final double width;
  final Color color;
  final Widget child;
  const ProfileContainer(
      {Key key, this.child, this.height = 10, this.width = 10, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child:
          Container(height: height, width: width, color: color, child: child),
    );
  }
}

class ProfileButton extends StatefulWidget {
  final Widget child;
  final Function onPressed;
  final double radius;
  final EdgeInsetsGeometry padding;
  final double height;
  final double width;
  final BoxBorder border;
  final BoxShape shape;
  final Color color;
  const ProfileButton(
      {Key key,
      this.child,
      this.color,
      this.height = 60,
      this.width,
      this.onPressed,
      this.padding,
      this.border,
      this.shape,
      this.radius = 5})
      : super(key: key);

  @override
  _ProfileButtonState createState() => _ProfileButtonState();
}

class _ProfileButtonState extends State<ProfileButton> {
  bool _tapInProgress;

  @override
  void initState() {
    _tapInProgress = false;
    super.initState();
  }

  void _tapDown(TapDownDetails details) {
    setState(() {
      _tapInProgress = true;
    });
  }

  void _tapUp(TapUpDetails details) {
    setState(() {
      _tapInProgress = false;
    });
  }

  void _tapCancel() {
    setState(() {
      _tapInProgress = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        child: Container(
          height: widget.height,
          width: widget.width,
          padding: this.widget.padding ?? EdgeInsets.all(1.0),
          decoration: BoxDecoration(
            border: widget.border,
            //shape: widget.shape,
            color: (widget.color ?? Theme.of(context).buttonColor)
                .withAlpha(_tapInProgress ? 100 : 255),
            borderRadius: BorderRadius.circular(widget.radius),
          ),
          child: Center(child: widget.child),
        ),
        onTap: this.widget.onPressed,
        onTapDown: _tapDown,
        onTapUp: _tapUp,
        onTapCancel: _tapCancel,
      ),
    );
  }
}
