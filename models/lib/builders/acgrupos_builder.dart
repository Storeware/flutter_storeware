import 'package:flutter/material.dart';

import 'dropdown_builder.dart';

class AcgruposDropdownBuilder extends StatelessWidget {
  final String? value;
  final Function(String)? onChanged;
  const AcgruposDropdownBuilder({Key? key, this.value, this.onChanged})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return DropdownDataBuilder.createDropDownFormField(context,
        value: value,
        collection: 'acgrupos',
        fields: 'id,nome',
        keyField: 'nome',
        nameField: 'nome',
        label: 'Grupo',
        onChanged: onChanged);
  }
}
