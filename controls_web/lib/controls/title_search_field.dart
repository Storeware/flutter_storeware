// @dart=2.12
import 'package:flutter/material.dart';
//import 'package:controls_web/controls.dart';

class TitleSearchField extends StatefulWidget {
  const TitleSearchField(
      {Key? key,
      this.expanded = false,
      this.title,
      this.label,
      this.onChanged,
      this.compactWidth = 150,
      this.expandedWidth = 300,
      this.underlineColor,
      this.controller,
      this.radius = 30,
      this.icon,
      this.child,
      this.fillColor,
      this.onResetPressed,
      this.onSearchPressed})
      : super(key: key);
  final String? label;
  final Widget? title;
  final Function(String value)? onSearchPressed;
  final Function(String value)? onChanged;
  final Function()? onResetPressed;
  final Color? underlineColor;
  final bool expanded;
  final double compactWidth;
  final TextEditingController? controller;
  final double expandedWidth;
  final double radius;
  final Widget? icon;
  final Color? fillColor;
  final Widget? child;

  @override
  _TitleSearchFieldState createState() => _TitleSearchFieldState();
}

class _TitleSearchFieldState extends State<TitleSearchField> {
  late ValueNotifier<bool> editing;
  final focusNode = FocusNode();
  get theColor =>
      widget.underlineColor ?? theme.primaryTextTheme.bodyText1!.color;
  @override
  void initState() {
    super.initState();
    editing = ValueNotifier<bool>(widget.expanded);
    _textoController = widget.controller ?? TextEditingController();
  }

  late ThemeData theme;
  late TextEditingController _textoController;
  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    //final responsive = ResponsiveInfo(context);
    return ValueListenableBuilder<bool>(
      valueListenable: editing,
      builder: (a, b, c) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (widget.title != null) Expanded(child: widget.title!),
          //Spacer(),
          if ((!b) && (widget.icon != null))
            IconButton(
                icon: widget.icon!,
                onPressed: () {
                  editing.value = !editing.value;
                }),
          if (b || (widget.icon == null))
            (widget.child != null)
                ? widget.child!
                : Container(
                    padding: EdgeInsets.all(4),
                    height: kMinInteractiveDimension,
                    width: (b) ? widget.expandedWidth : widget.compactWidth,
                    child: Focus(
                      onFocusChange: (x) {
                        editing.value = x;
                      },
                      child: TextFormField(
                        enableSuggestions: true,
                        textInputAction: TextInputAction.done,
                        controller: _textoController,
                        decoration: InputDecoration(
                            filled: b && widget.fillColor != null,
                            fillColor: widget.fillColor,
                            //focusColor: Colors.amber,
                            labelText: widget.label,
                            //labelStyle: new TextStyle(color: theme.primaryColor),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: theColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(widget.radius),
                              borderSide: new BorderSide(color: theColor),
                            ),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(color: theColor),
                            ),
                            prefixIcon: (!b)
                                ? null
                                : IconButton(
                                    icon: Icon(Icons.close),
                                    onPressed: () {
                                      _textoController.text = '';
                                      if (widget.onResetPressed != null)
                                        widget.onResetPressed!();
                                      if (widget.icon != null)
                                        editing.value = !editing.value;
                                    },
                                  ),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.search),
                              onPressed: () {
                                if ((editing.value) &&
                                    _textoController.text.isNotEmpty &&
                                    (widget.onSearchPressed != null))
                                  widget
                                      .onSearchPressed!(_textoController.text);
                                if (_textoController.text.isEmpty)
                                  editing.value = !editing.value;
                              },
                            )),
                        autofocus: editing.value,
                        //focusNode: focusNode,
                        onChanged: (x) {
                          if (widget.onChanged != null) widget.onChanged!(x);
                        },
                        onFieldSubmitted:(x){
                          if (widget.onSearchPressed != null)
                            widget.onSearchPressed!(x);
                        },
                        onSaved: (x) {
                          if (widget.onSearchPressed != null)
                            widget.onSearchPressed!(x!);
                        },
                      ),
                    )),
        ],
      ),
    );
  }
}
