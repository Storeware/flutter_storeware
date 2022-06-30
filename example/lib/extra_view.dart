import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_storeware/index.dart';

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
          const Rounded(
            child: Text('Rounded'),
            color: Colors.amber,
          ).padding(padding: const EdgeInsets.all(20.0)),
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
          ),
          TextFormField(
            initialValue: '01/12/2020',
            keyboardType: TextInputType.number,
            inputFormatters: [
              DateTextInputFormatter(),
            ],
          ),
        ],
      ),
    ));
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({this.decimalRange = 0});

  final int? decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    RegExp r = RegExp('^(\\d+)?\\.?\\d{0,$decimalRange}');
    String? truncated = r.stringMatch(newValue.text) ??
        newValue.text.substring(0, newValue.text.length - 1);

    if (truncated == newValue.text) {
      return newValue;
    }

    return TextEditingValue(
      text: truncated,
      selection: TextSelection.collapsed(offset: truncated.length),
      composing: TextRange.empty,
    );
  }
}

class DateTextInputFormatter extends TextInputFormatter {
  DateTextInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    if (newValue.text.length < 10) {
      return newValue;
    }
    RegExp r = RegExp(
        r'^(?:(?:31(\/|-|\.)(?:0?[13578]|1[02]))\1|(?:(?:29|30)(\/|-|\.)(?:0?[1,3-9]|1[0-2])\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})$|^(?:29(\/|-|\.)0?2\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:0?[1-9]|1\d|2[0-8])(\/|-|\.)(?:(?:0?[1-9])|(?:1[0-2]))\4(?:(?:1[6-9]|[2-9]\d)?\d{2})$');
    String? truncated = r.stringMatch(newValue.text);
    if (truncated == null || truncated != newValue.text) {
      return oldValue;
    }
    return newValue;
  }
}
