import 'package:flutter/material.dart';
//import 'package:flutter_storeware/index.dart';
import 'package:controls_web/controls/widget_extensions.dart';

class RoundedCard extends StatelessWidget {
  final Widget child;
  final double elevation;
  final Color? color;
  final double borderRadius;
  const RoundedCard(
      {Key? key,
      this.borderRadius = 8,
      this.color,
      this.elevation = 5,
      required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: child,
    );
  }
}

class ExtraView extends StatelessWidget {
  const ExtraView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          RoundedCard(
            color: Colors.amber[50],
            child: const ExpansionTile(
              title: Text("RoundedCard with ExpansionTile"),
              children: [Text("Expanded content")],
            ),
          ),
          TextFormField(
            initialValue: '0.00',
            keyboardType: TextInputType.number,
            inputFormatters: [
              MaskedInputTextFormatter.number(3),
            ],
          ).rounded(),
          TextFormField(
            initialValue: '01/12/2020',
            keyboardType: TextInputType.number,
            inputFormatters: [
              MaskedInputTextFormatter.date(),
            ],
          ).dottedLine(),
        ],
      ),
    ));
  }
}
