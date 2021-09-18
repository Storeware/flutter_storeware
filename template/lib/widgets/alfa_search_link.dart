// @dart=2.12
import 'package:flutter/material.dart';

class AlfaFilterLink extends StatefulWidget {
  AlfaFilterLink({
    Key? key,
    required this.onChanged,
    this.width = 40,
    this.padding,
    this.initialValue,
    this.valueNotifier,
    this.values,
  }) : super(key: key);
  final Function(String) onChanged;
  final double width;
  final EdgeInsets? padding;
  final String? values;
  final String? initialValue;
  final ValueNotifier<String>? valueNotifier;

  @override
  _AlfaFilterLinkState createState() => _AlfaFilterLinkState();
}

class _AlfaFilterLinkState extends State<AlfaFilterLink> {
  @override
  void initState() {
    super.initState();
    _valueInicial =
        widget.valueNotifier ?? ValueNotifier(widget.initialValue ?? '+');
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
        valueListenable: _valueInicial,
        builder: (BuildContext context, dynamic value, Widget? child) {
          return Container(
              width: widget.width,
              padding: widget.padding ?? EdgeInsets.only(top: 40, bottom: 40),
              child: ListView(
                //mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  for (var l in (widget.values ?? '+ABCDEFGHIJKLMNOPQRSTUVWXYZ')
                      .toList())
                    buildLetra(l, value),
                ],
              ));
        });
  }

  late ValueNotifier<String> _valueInicial;

  buildLetra(String value, String selected) {
    return CircleAvatar(
        backgroundColor:
            (value == selected) ? Colors.amber : Colors.transparent,
        child: TextButton(
          child: Text(value),
          onPressed: () {
            _valueInicial.value = value;
            widget.onChanged(value);
          },
        ));
  }
}

extension _StringList on String {
  toList() {
    return [for (var i = 0; i < this.length; i++) this[i]];
  }
}
