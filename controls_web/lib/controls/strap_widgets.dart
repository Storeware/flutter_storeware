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
  link,
  none
}
Color strapColor(StrapButtonType type) {
  return [
    primaryColor,
    Colors.grey,
    Colors.green,
    Colors.red,
    Colors.amber,
    Colors.lightBlue,
    Colors.white,
    Colors.black,
    Colors.white,
    Colors.transparent
  ][type.index];
}

Color strapFontColor(StrapButtonType type) {
  switch (type) {
    case StrapButtonType.warning:
      return Colors.black;
    //break;
    case StrapButtonType.light:
      return Colors.black;
    // break;
    case StrapButtonType.link:
      return Colors.blue;
    // break;
    case StrapButtonType.none:
      return Colors.grey;
    //  break;
    default:
      return Colors.white;
  }
}

enum StrapButtonState { none, pressed, processing, waiting }

class StrapButton extends StatefulWidget {
  final String? text;
  final Widget? title, subtitle;
  final Function? onPressed;
  final int? maxLines;
  final Future<StrapButtonState> Function()? onPressedAsync;

  final StrapButtonType? type;
  final double? height;
  final double? width;
  final double minHeight;
  final double minWidth;
  final double? margin;
  final double? radius;
  final double? borderWidth;
  final Widget? leading;
  final Widget? trailing;
  final Widget? image;
  final bool enabled;
  final bool visible;
  final StrapButtonState Function(
      StrapButtonState, ValueNotifier<StrapButtonState>)? onStateChanged;
  final ValueNotifier<StrapButtonState>? stateNotifier;
  const StrapButton({
    Key? key,
    this.text,
    this.onPressed,
    this.margin = 1,
    this.type = StrapButtonType.primary,
    this.height = kMinInteractiveDimension,
    this.width = kMinInteractiveDimension * 3,
    this.minHeight = 30,
    this.minWidth = 60,
    this.borderWidth = 1,
    this.radius = 5,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.maxLines = 1,
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
  ValueNotifier<StrapButtonState>? _valueNotifier;

  @override
  void initState() {
    super.initState();
    _valueNotifier = widget.stateNotifier ??
        ValueNotifier<StrapButtonState>(StrapButtonState.none);
  }

  stateChanged(StrapButtonState value) {
    if (widget.onStateChanged != null) {
      _valueNotifier!.value = widget.onStateChanged!(value, _valueNotifier!);
    } else {
      _valueNotifier!.value = value;
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
            constraints: BoxConstraints(
                maxWidth: widget.width!,
                maxHeight: widget.height!,
                minHeight: widget.minHeight,
                minWidth: widget.minWidth),
            decoration: widget.type == StrapButtonType.none
                ? null
                : BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.radius!),
                    border: Border.all(
                        width: widget.borderWidth!,
                        color: Colors.grey.withOpacity(0.2)),
                    color: (widget.type == StrapButtonType.primary)
                        ? primaryColor
                        : strapColor(widget.type!),
                  ),
            child: ValueListenableBuilder<StrapButtonState>(
                valueListenable: _valueNotifier!,
                builder: (BuildContext context, StrapButtonState stateValue,
                    Widget? child) {
                  return TextButton(
                    child: Padding(
                        padding: const EdgeInsets.only(left: 1, right: 1),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (widget.leading != null)
                              Flexible(flex: 1, child: widget.leading!),
                            Expanded(
                              //flex: 4,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (widget.image != null) widget.image!,
                                  if (widget.title != null)
                                    DefaultTextStyle(
                                        style: theme.textTheme.button!,
                                        child: widget.title!),
                                  if (widget.text != null)
                                    Text(widget.text!,
                                        maxLines: widget.maxLines,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: (widget.enabled)
                                              ? strapFontColor(widget.type!)
                                              : theme.dividerColor,
                                          fontSize: 16,
                                        )),
                                  if (widget.subtitle != null)
                                    DefaultTextStyle(
                                        style: theme.textTheme.caption!,
                                        child: widget.subtitle!),
                                  if ([
                                    StrapButtonState.waiting,
                                    StrapButtonState.processing
                                  ].contains(stateValue))
                                    Container(
                                        child: Container(
                                            width: double.maxFinite,
                                            height: 2,
                                            color: strapColor(widget.type!),
                                            child: LinearProgressIndicator(
                                              backgroundColor:
                                                  Colors.transparent,
                                              valueColor:
                                                  AlwaysStoppedAnimation(
                                                      strapFontColor(
                                                          widget.type!)),
                                            ))),
                                ],
                              ),
                            ),
                            if (widget.trailing != null)
                              Flexible(flex: 1, child: widget.trailing!),
                          ],
                        )),
                    onPressed: (widget.enabled &&
                            (stateValue != StrapButtonState.waiting))
                        ? () async {
                            stateChanged(StrapButtonState.pressed);
                            if (widget.onPressedAsync != null) {
                              stateChanged(StrapButtonState.waiting);
                              if (widget.onPressedAsync != null)
                                stateChanged(await widget.onPressedAsync!());
                            } else {
                              if (widget.onPressed != null) widget.onPressed!();
                            }
                          }
                        : null,
                  );
                }));
  }
}
