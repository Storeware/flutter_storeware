import 'package:flutter/material.dart';

import 'masked_field.dart';

extension MaskedTextFieldBr on MaskedTextField {
  static cpf(
          {Key key,
          String label = 'CPF',
          String initialValue,
          onSave,
          String mask = '000.000.000-00',
          String match, // = r"^\+?\d{2,3}\((\d{2})\)\s?(\d{4,5}\-?\d{4})",
          Function(String) validator,
          TextStyle style}) =>
      MaskedTextField(
          key: key,
          label: label,
          mask: mask,
          initialValue: initialValue ?? '',
          onSave: onSave,
          validator: validator,
          sample: '000.000.000-00',
          match: match,
          keyboardType: TextInputType.phone,
          style: style);
  static cep(
          {Key key,
          String label = 'CEP',
          String initialValue,
          onSave,
          String mask = '00000-000',
          String match, // = r"^\+?\d{2,3}\((\d{2})\)\s?(\d{4,5}\-?\d{4})",
          Function(String) validator,
          TextStyle style}) =>
      MaskedTextField(
          key: key,
          label: label,
          mask: mask,
          initialValue: initialValue ?? '',
          onSave: onSave,
          validator: validator,
          sample: '99999-999',
          match: match,
          keyboardType: TextInputType.phone,
          style: style);
}

class MaskedEndereco extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;
  final Map<String, dynamic> initialValues;
  final double width;
  final String Function(Map<String, dynamic>) validator;
  MaskedEndereco({
    Key key,
    this.initialValues,
    this.onSave,
    this.width,
    this.validator,
  }) : super(key: key);

  @override
  _MaskedEnderecoState createState() => _MaskedEnderecoState();
}

class _MaskedEnderecoState extends State<MaskedEndereco> {
  Map<String, dynamic> values;
  @override
  Widget build(BuildContext context) {
    values = widget.initialValues;
    return Container(
      width: widget.width,
      child: Flex(direction: Axis.horizontal, children: [
        Container(
            constraints: BoxConstraints(
              minWidth: 80,
              maxWidth: 100,
            ),
            child: MaskedTextFieldBr.cep(
                label: 'CEP',
                initialValue: values['cep'] ?? '',
                onSave: (x) {
                  values['cep'] = x;
                  doSave();
                })),
        SizedBox(
          width: 5,
        ),
        Container(
            constraints: BoxConstraints(
              minWidth: 80,
              maxWidth: 100,
            ),
            child: MaskedTextField.text(
                label: 'num casa',
                initialValue: values['numero'] ?? '',
                onSave: (x) {
                  values['numero'] = x;
                  doSave();
                })),
        SizedBox(
          width: 5,
        ),
        Expanded(
          child: Container(
              child: MaskedTextField.text(
                  label: 'complemento',
                  validator: (x) {
                    values['compl'] = x;
                    doValidator();
                  },
                  initialValue: values['compl'] ?? '',
                  onSave: (x) {
                    values['compl'] = x;
                    doSave();
                  })),
        ),
      ]),
    );
  }

  doSave() {
    if (widget.onSave != null) widget.onSave(values);
  }

  doValidator() {
    if (widget.validator != null) {
      return widget.validator(values);
    } else
      return null;
  }
}
