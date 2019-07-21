// ignore: must_be_immutable
import 'package:flutter/material.dart';

class SlideDouble extends StatefulWidget {
  // ignore: must_be_immutable
  final double value;
  final bool autoFocus;
  final FormFieldSetter<double> onChange;
  final Color color;
  final double width;
  final double minValue;
  final double maxValue;
  final String labelText;
  SlideDouble(
      {this.labelText = 'qtde',
      this.value,
      this.minValue = 0,
      this.maxValue,
      this.onChange,
      this.color,
      this.width = 150,
      this.autoFocus = false});
  @override
  _SlideDoubleState createState() => _SlideDoubleState(value, onChange);
}

class _SlideDoubleState extends State<SlideDouble> {
  final GlobalKey _key = GlobalKey(debugLabel: 'SlideDouble');

  final FormFieldSetter<double> onChange;

  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //myController.addListener(_valueChanged);
  }

  @override
  void dispose() {
    //myController.removeListener(_valueChanged);
    myController.dispose();
    super.dispose();
  }

  _SlideDoubleState(double value, this.onChange) {
    String _value = _toDoubleString(value);
    myController.text = _value;
  }

  _toDoubleString(double v) {
    if (double.parse(v.toStringAsFixed(0)) == v) {
      return v.toStringAsFixed(0);
    }
    return v.toString();
  }

  doChange(String val) {
    val = val.replaceAll(',', '.');
    double v = double.parse(val);
    String _value = _toDoubleString(v);
    myController.text = _value;
    myController.selection = new TextSelection(
        baseOffset: myController.text.length,
        extentOffset: myController.text.length);

    if (onChange != null) onChange(v);
  }

  @override
  Widget build(BuildContext context) {
    return new Flexible(
      child: Container(
        width: widget.width,
        color: widget.color,
        child: Row(children: <Widget>[
          IconButton(
              icon: Icon(Icons.remove_circle_outline),
              onPressed: () {
                double v = (double.parse(myController.text) - 1);
                if (v < widget.minValue) v = widget.minValue;
                doChange(v.toString());
              }),
          new Flexible(
              child: TextField(
            key: _key,
            keyboardType:
                TextInputType.numberWithOptions(decimal: true, signed: false),
            controller: myController,

            decoration: new InputDecoration(
              hintText: '',
              labelText: widget.labelText,
            ),
            //initialValue: _value,
            onChanged: (x) {
              //print(x);
              doChange(x);
            },
            autofocus: widget.autoFocus,
            //textAlign: TextAlign.justify,
            //autovalidate: true,
          )),
          IconButton(
              icon: Icon(Icons.add_circle_outline),
              onPressed: () {
                double v = (double.parse(myController.text) + 1);
                //print(v);
                if (widget.maxValue != null && v > widget.maxValue)
                  v = widget.maxValue;
                doChange(v.toString());
              }),
        ]),
      ),
    );
  }
}
