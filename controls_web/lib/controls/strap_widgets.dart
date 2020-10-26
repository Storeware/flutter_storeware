import 'package:flutter/material.dart';

Color primaryColor = Colors.blue;

enum StrapButtonType {
  primary,
  secondary,
  success,
  danger,
  warning,
  info,
  light,
  dark,
  link
}
strapColor(StrapButtonType type) {
  return [
    primaryColor,
    Colors.grey,
    Colors.green,
    Colors.red,
    Colors.amber,
    Colors.lightBlue,
    Colors.white,
    Colors.black,
    Colors.white
  ][type.index];
}

strapFontColor(StrapButtonType type) {
  switch (type) {
    case StrapButtonType.warning:
      return Colors.black;
      break;
    case StrapButtonType.light:
      return Colors.black;
      break;
    case StrapButtonType.link:
      return Colors.blue;
      break;

    default:
      return Colors.white;
  }
}

enum StrapButtonState { none, pressed, processing }

class StrapButton extends StatefulWidget {
  final String text;
  final Widget title, subtitle;
  final Function onPressed;
  final Future<StrapButtonState> Function() onPressedAsync;

  final StrapButtonType type;
  final double height;
  final double width;
  final double margin;
  final double radius;
  final double borderWidth;
  final Widget leading;
  final Widget trailing;
  final Widget image;
  final bool enabled;
  final bool visible;
  final StrapButtonState Function(
      StrapButtonState, ValueNotifier<StrapButtonState>) onStateChanged;
  final ValueNotifier<StrapButtonState> stateNotifier;
  const StrapButton({
    Key key,
    this.text,
    this.onPressed,
    this.margin = 1,
    this.type = StrapButtonType.primary,
    this.height = kMinInteractiveDimension,
    this.width = kMinInteractiveDimension * 3,
    this.borderWidth = 1,
    this.radius = 5,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.image,
    this.enabled = true,
    this.visible = true,
    this.onStateChanged,
    this.stateNotifier,
    this.onPressedAsync,
  }) : super(key: key);

  @override
  _StrapButtonState createState() => _StrapButtonState();
}

class _StrapButtonState extends State<StrapButton> {
  ValueNotifier<StrapButtonState> _valueNotifier;

  @override
  void initState() {
    super.initState();
    _valueNotifier = widget.stateNotifier ??
        ValueNotifier<StrapButtonState>(StrapButtonState.none);
  }

  stateChanged(StrapButtonState value) {
    if (widget.onStateChanged != null) {
      _valueNotifier.value = widget.onStateChanged(value, _valueNotifier);
    } else {
      _valueNotifier.value = value;
    }
  }

  @override
  Widget build(BuildContext context) {
    stateChanged(StrapButtonState.none);
    var theme = Theme.of(context);
    primaryColor = theme.primaryColor;
    return (!widget.visible)
        ? Container()
        : Container(
            height: widget.height,
            width: widget.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.radius),
              border: Border.all(
                  width: widget.borderWidth,
                  color: Colors.grey.withOpacity(0.2)),
              color: (widget.type == StrapButtonType.primary)
                  ? primaryColor
                  : strapColor(widget.type),
            ),
            child: ValueListenableBuilder<StrapButtonState>(
                valueListenable: _valueNotifier,
                builder: (BuildContext context, StrapButtonState stateValue,
                    Widget child) {
                  return FlatButton(
                    child: Padding(
                        padding: const EdgeInsets.all(1),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (widget.leading != null)
                              Flexible(flex: 1, child: widget.leading),
                            Expanded(
                              //flex: 4,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (widget.image != null) widget.image,
                                  if (widget.title != null)
                                    DefaultTextStyle(
                                        style: theme.textTheme.button,
                                        child: widget.title),
                                  if (widget.text != null)
                                    Text(widget.text,
                                        style: TextStyle(
                                          color: (widget.enabled)
                                              ? strapFontColor(widget.type)
                                              : theme.dividerColor,
                                          fontSize: 16,
                                        )),
                                  if (widget.subtitle != null)
                                    DefaultTextStyle(
                                        style: theme.textTheme.caption,
                                        child: widget.subtitle),
                                ],
                              ),
                            ),
                            if (widget.trailing != null)
                              Flexible(flex: 1, child: widget.trailing),
                            if (stateValue == StrapButtonState.processing)
                              Container(
                                  child: Container(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        backgroundColor:
                                            strapFontColor(widget.type),
                                      ))),
                          ],
                        )),
                    onPressed: (widget.enabled &&
                            (stateValue != StrapButtonState.processing))
                        ? () async {
                            stateChanged(StrapButtonState.pressed);
                            if (widget.onPressedAsync != null) {
                              stateChanged(StrapButtonState.processing);
                              stateChanged(await widget.onPressedAsync() ??
                                  StrapButtonState.none);
                            } else {
                              widget.onPressed();
                            }
                          }
                        : null,
                  );
                }));
  }
}
