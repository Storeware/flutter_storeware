import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'input.field.dart';

// ignore: must_be_immutable
class Label extends StatelessWidget {
  String text;
  final double fontSize;
  final int max;
  final int min;
  final int count;
  Label(this.text,
      {this.min, this.fontSize = 13.0, this.max = 0, this.count = 0});
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w300,
        ),
      ),
      (this.max > 0
          ? Text(
              count.toString() +
                  '/' +
                  (min != null ? min.toString() + '-' : '') +
                  max.toString(),
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w300))
          : Text(''))
    ]);
  }
}

class TextInputTile extends StatelessWidget { // ignore: must_be_immutable
  var validateFunction;
  var onSaved;
  final Key key;
  var onChange;
  var onEnter;
  Widget subtitle;
  final String labelText;

  TextInputType textInputType = TextInputType.text;
  Color textFieldColor, iconColor;
  bool obscureText = false;
  TextStyle textStyle, hintStyle;
  String initialValue;
  final bool autocorrect;
  final bool autofocus;
  final Widget trailing;
  final Widget leading;
  final bool dense;
  final int maxLines;
  final int maxLength;

  TextInputTile({this.subtitle,this.trailing,
    this.leading, this.dense,
    this.maxLength,
    this.labelText, this.maxLines=1,
    this.textStyle,this.initialValue,
    this.textInputType,this.autocorrect=true,
    this.autofocus = true, this.validateFunction,
    this.onChange,this.key,this.onEnter,
    this.onSaved,this.hintStyle,this.obscureText,this.iconColor,this.textFieldColor
    });


  @override
  Widget build(BuildContext context) {
    return ListTile(
       trailing: trailing,
       leading: leading,
       dense: dense,
       title: TextInput(
         key:key,
         maxLines: maxLines,
         labelText: labelText,
         maxLength: maxLength,
         validateFunction:validateFunction,
         onSaved: onSaved,
         onChange: onChange,
         onEnter: onEnter,
         textStyle: textStyle,
         initialValue: initialValue,
         textInputType: textInputType,
         autocorrect: autocorrect,
         autofocus: autofocus,
         //hintText: hintText,
         hintStyle: hintStyle,
         obscureText: obscureText,
         iconColor: iconColor,
         textFieldColor: textFieldColor,
       ),
         subtitle: subtitle,
    );
  }
}


enum TextInputLabelPosition { top, bottom }

// ignore: must_be_immutable
class TextInput extends StatefulWidget {
  final String labelText;
  final TextInputLabelPosition labelPosition;
  //final String text;
  IconData icon;
  String hintText = '';
  TextInputType textInputType = TextInputType.text;
  Color textFieldColor, iconColor;
  bool obscureText = false;
  double decorateBottomMargin = 5.0;
  TextStyle textStyle, hintStyle;
  String initialValue;
  final bool autocorrect;
  final bool autofocus;
  var validateFunction;
  var onSaved;
  Key key;
  var onChange;
  var onEnter;
  double labelFontSize;
  double margimBottom;
  TextEditingController controller;
  FocusNode focusNode;
  final double margimLeft;
  final double margimRight;
  final double margimTop;
  final EdgeInsets contentPadding;
  final int maxLines;
  final int maxLength;
  final Widget labelAction;
  final TextInputAction textInputAction;
  List<TextInputFormatter> inputFormatters;

  TextInput(
      {this.hintText,
      this.initialValue,
      this.key,
      this.controller,
      this.autocorrect = false,
      this.focusNode,
      this.labelText='',
      this.labelPosition = TextInputLabelPosition.bottom,
      this.labelAction,
      this.maxLines = 1,
      this.maxLength,
      this.margimTop = 0.0,
      this.margimLeft = 10.0,
      this.margimRight = 10.0,
      this.labelFontSize = 13.0,
      this.margimBottom = 5.0,
      this.contentPadding,
      this.autofocus = false,
      this.onEnter,
      this.onChange,
      this.obscureText,
      this.textInputType,
      this.textFieldColor,
      this.icon,
      this.iconColor,
      this.decorateBottomMargin,
      this.textStyle,
      this.validateFunction,
      this.onSaved,
      this.hintStyle,
      this.textInputAction,
      this.inputFormatters});

  @override
  _TextInputState createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  Widget _wg(context) {
    List<Widget> rt = [];
    rt.add(new InputField(
        textInputAction: widget.textInputAction,
        maxLines: widget.maxLines,
        maxLength: widget.maxLength,
        onEnter: widget.onEnter,
        autocorrect: widget.autocorrect,
        hintText: widget.hintText,
        initialValue: widget.initialValue,
        key: widget.key,
        autofocus: widget.autofocus,
        controller: widget.controller,
        focusNode: widget.focusNode,
        obscureText: widget.obscureText,
        onChange: widget.onChange,
        contentPadding: widget.contentPadding,
        textInputType: widget.textInputType,
        icon: widget.icon,
        iconColor: widget.iconColor,
        decorateBottomMargin: widget.decorateBottomMargin,
        textStyle: widget.textStyle,
        validateFunction: widget.validateFunction,
        onSaved: widget.onSaved,
        inputFormatters: widget.inputFormatters,
        //labelText: widget.labelText,
        labelText: (widget.labelPosition == TextInputLabelPosition.top
            ? (widget.labelText != null ? widget.labelText : widget.hintText)
            : ''),
        hintStyle: widget.hintStyle));
    if (this.widget.labelText != '' &&
        widget.labelPosition == TextInputLabelPosition.bottom)
      rt.add(Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Expanded(
            child: Text(
          widget.labelText,
          style: TextStyle(
            fontSize: widget.labelFontSize,
            fontWeight: FontWeight.w300,
          ),
        )),
        (widget.labelAction != null ? widget.labelAction : Text('')),
      ]));

    return Container(
      margin: EdgeInsets.only(
          top: widget.margimTop,
          left: widget.margimLeft,
          right: widget.margimRight,
          bottom: widget.margimBottom),
      child: new Column(
        children: rt,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _wg(context);
  }
}
