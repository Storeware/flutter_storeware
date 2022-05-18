// @dart=2.12

import 'package:controls_web/controls/masked_field.dart';
import 'package:flutter/material.dart';

class DateFormField extends StatelessWidget {
  final DateTime? initialValue;
  final Function(DateTime d)? onSaved;
  final String? label;
  const DateFormField({Key? key, this.label, this.initialValue, this.onSaved})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        //padding: EdgeInsets.only(top: 6),
        width: 200,
        child: MaskedDatePicker(
          labelText: label,
          initialValue: initialValue,
          onSaved: onSaved,
        ));
  }
}
