import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef String InputFieldControllerCallback(
    /*TextEditingController controller,*/ String text);

@immutable
// ignore: must_be_immutable
class InputField extends StatefulWidget {
  IconData icon;
  String hintText;
  String labelText;
  EdgeInsets contentPadding;
  TextInputType textInputType = TextInputType.text;
  Color textFieldColor, iconColor;
  bool obscureText = false;
  double decorateBottomMargin = 5.0;
  TextStyle textStyle, hintStyle;
  var validateFunction;
  var onSaved;
  var onEnter;
  final InputFieldControllerCallback onChange;
  Key key;
  final bool autofocus;
  String initialValue;
  TextEditingController controller;
  final autocorrect;
  final maxLength;
  FocusNode focusNode;
  final int maxLines;
  final Widget preffix;
  final Widget preffixIcon;
  final Widget suffix;
  final Widget suffixIcon;
  final TextInputAction textInputAction;

  InputField({
    this.initialValue,
    this.key,
    this.controller,
    this.focusNode,
    this.hintText = '',
    this.labelText,
    this.maxLines,
    this.maxLength,
    this.contentPadding,
    this.autofocus = false,
    this.autocorrect = false,
    this.obscureText,
    this.onChange,
    this.textInputType,
    this.textFieldColor,
    this.icon,
    this.iconColor,
    this.decorateBottomMargin,
    this.textStyle,
    this.validateFunction,
    this.onEnter,
    this.onSaved,
    this.hintStyle,
    this.preffix,
    this.preffixIcon,
    this.suffix,
    this.suffixIcon,
    this.createController = true,
    this.textInputAction,
    this.inputFormatters,
  }) {
    if (textInputType == null) this.textInputType = TextInputType.text;
    if (obscureText == null) this.obscureText = false;
    if (decorateBottomMargin == null) this.decorateBottomMargin = 0.0;
    if (contentPadding == null) this.contentPadding = EdgeInsets.all(3.0);
  }

  final bool createController;

  List<TextInputFormatter> inputFormatters;

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  TextEditingController _controller;
  FocusNode _textFocus;

  @override
  void initState() {
    if (widget.controller == null &&
        widget.onChange != null &&
        widget.createController) {
      _textFocus = new FocusNode();
      _textFocus.addListener(_onFocusEnter);
      _controller = new TextEditingController();
      _controller.addListener(_onChange);
      _controller.text = _getInitial(widget.initialValue);
    }
    super.initState();
  }

  _onFocusEnter() {
    if (widget.onEnter != null) {
      widget.onEnter(_controller);
    }
  }

  _onChange() {
    bool hasFocus = _textFocus.hasFocus;
    String newText = _controller.text;
    if (widget.onChange != null && _controller != null) {
      var s = widget.onChange(/*_controller,*/ newText);
      if (s != null && newText != s) {
        _controller.text = s;
        _controller.selection = new TextSelection(
            baseOffset: newText.length, extentOffset: newText.length);
      }
    } else {
      //print ('!onChange');
      _controller.text = newText;
    }

    if (!hasFocus) {
      //print('!hasFocus');
      _controller.selection = new TextSelection(
          baseOffset: _controller.text.length,
          extentOffset: _controller.text.length);
    }
    setState(() {});
  }

  @override
  void dispose() {
    if (_controller != null) _controller.removeListener(_onChange);
    if (_textFocus != null) _textFocus.removeListener(_onFocusEnter);
    super.dispose();
  }

  _getDecoration() {
    if (widget.icon != null) {
      return new InputDecoration(
        contentPadding: widget.contentPadding,
        hintText: widget.hintText,
        // hintStyle: widget.hintStyle,
        labelText: widget.labelText,
        icon: new Icon(
          widget.icon,
          color: widget.iconColor,
        ),
        suffixIcon: widget.suffixIcon,
        suffix: widget.suffix,
        prefix: widget.preffix,
        prefixIcon: widget.preffixIcon,
      );
    }
    return new InputDecoration(
      contentPadding: widget.contentPadding,
      hintText: widget.hintText,
      labelText: widget.labelText,
      // hintStyle: widget.hintStyle,
    );
  }

  _getInitial(initial) {
    if (_controller != null &&
        initial != null /*&& _controller.text != initial*/) {
      _controller.text = initial.toString();
    }
    return initial;
  }

  Widget _listWrapped() {
    /*if (widget.initialValue!=null && (widget.controller!=null || _controller!=null )) {
      //print(widget.initialValue);
      if (widget.controller!=null)
         widget.controller.text = widget.initialValue;
      if (_controller!=null)
        _controller.text = widget.initialValue;
    }*/
    // if (_controller!=null)
    //   _controller.text = _getInitial( widget.initialValue);

//    print ([widget.labelText,'controller',(widget.controller!=null?widget.controller:_controller),widget.initialValue]);
    return new TextFormField(
      maxLength: widget.maxLength,
      textCapitalization: TextCapitalization.sentences,
      autocorrect: widget.autocorrect,
      textInputAction: widget.textInputAction,
      style: widget.textStyle,
      maxLines: widget.maxLines,
      key: widget.key,
      controller: (widget.controller != null ? widget.controller : _controller),
      focusNode: (widget.focusNode != null ? widget.focusNode : _textFocus),
      autofocus: widget.autofocus,
      obscureText: widget.obscureText,
      keyboardType: widget.textInputType,
      validator: widget.validateFunction,
      onSaved: widget.onSaved,
      decoration: _getDecoration(),
      inputFormatters: widget.inputFormatters,
      initialValue: (_controller == null && widget.controller == null
          ? widget.initialValue
          : null),
    );
  }

  @override
  Widget build(BuildContext context) {
    return (new Container(
      margin: new EdgeInsets.only(bottom: widget.decorateBottomMargin),
      child: new DecoratedBox(
        decoration: new BoxDecoration(
            borderRadius: new BorderRadius.all(new Radius.circular(30.0)),
            color: widget.textFieldColor),
        child: _listWrapped(),
      ),
    ));
  }

  //ListTile
}
