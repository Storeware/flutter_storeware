// @dart=2.12
import 'package:flutter/material.dart';

class StaggeredAnimation extends StatefulWidget {
  final Widget child;
  final int itemIndex;
  final int initialDelay;
  const StaggeredAnimation({
    Key? key,
    required this.itemIndex,
    required this.child,
    this.initialDelay = 500,
  }) : super(key: key);

  @override
  _StaggeredAnimationState createState() => _StaggeredAnimationState();
}

class _StaggeredAnimationState extends State<StaggeredAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _staggeredController;
  late Duration _initialDelayTime;
  static const _itemSlideTime = Duration(milliseconds: 250);
  static const _staggerTime = Duration(milliseconds: 50);
  static const _buttonDelayTime = Duration(milliseconds: 150);
  static const _buttonTime = Duration(milliseconds: 500);
  late var _animationDuration;
  late Interval _itemSlideIntervals;
  //late Interval _buttonInterval;

  @override
  void initState() {
    super.initState();
    _initialDelayTime = Duration(milliseconds: widget.initialDelay);
    _animationDuration = _initialDelayTime +
        (_staggerTime * (length)) +
        _buttonDelayTime +
        _buttonTime;
    _createAnimationIntervals();
    _staggeredController = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );
    _staggeredController.forward();
  }

  int get length => widget.itemIndex;
  void _createAnimationIntervals() {
    final startTime = _initialDelayTime + (_staggerTime * widget.itemIndex);
    final endTime = startTime + _itemSlideTime;
    _itemSlideIntervals = Interval(
      startTime.inMilliseconds / _animationDuration.inMilliseconds,
      endTime.inMilliseconds / _animationDuration.inMilliseconds,
    );

    //final buttonStartTime =
    //    Duration(milliseconds: (length * 50)) + _buttonDelayTime;
    //final buttonEndTime = buttonStartTime + _buttonTime;
    /* _buttonInterval = Interval(
      buttonStartTime.inMilliseconds / _animationDuration.inMilliseconds,
      buttonEndTime.inMilliseconds / _animationDuration.inMilliseconds,
    );*/
  }

  @override
  void dispose() {
    _staggeredController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _staggeredController,
        builder: (context, child) {
          final animationPercent = Curves.easeOut.transform(
            _itemSlideIntervals.transform(_staggeredController.value),
          );
          final opacity = animationPercent;
          final slideDistance = (1.0 - animationPercent) * 150;

          return Opacity(
            opacity: opacity,
            child: Transform.translate(
              offset: Offset(slideDistance, 0),
              child: child,
            ),
          );
        },
        child: widget.child);
  }
}
