import 'package:controls_web/controls/masked_field.dart';
import 'package:flutter/material.dart';

extension MaskedTextFieldBr on MaskedTextField {
  static cnpj(
          {Key? key,
          String label = 'CNPJ',
          String? initialValue,
          onChanged,
          onSave,
          String mask = '00.000.000/0000-00',
          String? match, // = r"^\+?\d{2,3}\((\d{2})\)\s?(\d{4,5}\-?\d{4})",
          Function(String)? validator,
          TextStyle? style}) =>
      MaskedTextField(
          key: key,
          label: label,
          mask: mask,
          initialValue: initialValue ?? '',
          onSaved: onSave,
          validator: validator,
          sample: '00.000.000/0000-00',
          match: match,
          onChanged: onChanged,
          keyboardType: TextInputType.phone,
          style: style);

  static cpf(
          {Key? key,
          String label = 'CPF',
          String? initialValue,
          onChanged,
          onSave,
          String mask = '000.000.000-00',
          String? match, // = r"^\+?\d{2,3}\((\d{2})\)\s?(\d{4,5}\-?\d{4})",
          Function(String)? validator,
          TextStyle? style}) =>
      MaskedTextField(
          key: key,
          label: label,
          mask: mask,
          initialValue: initialValue ?? '',
          onSaved: onSave,
          validator: validator,
          sample: '000.000.000-00',
          match: match,
          onChanged: onChanged,
          keyboardType: TextInputType.phone,
          style: style);
  static cep(
          {Key? key,
          String label = 'CEP',
          String? initialValue,
          onChanged,
          onSave,
          String mask = '00000-000',
          String? match, // = r"^\+?\d{2,3}\((\d{2})\)\s?(\d{4,5}\-?\d{4})",
          Function(String)? validator,
          TextStyle? style}) =>
      MaskedTextField(
          key: key,
          label: label,
          mask: mask,
          initialValue: initialValue ?? '',
          onChanged: onChanged,
          onSaved: onSave,
          validator: validator,
          sample: '99999-999',
          match: match,
          keyboardType: TextInputType.phone,
          style: style);
}

class MaskedEndereco extends StatefulWidget {
  final Function(Map<String, dynamic>)? onSave;
  final Map<String, dynamic>? initialValues;
  final double? width;
  final Function(String)? onChanged;
  final String Function(Map<String, dynamic>)? validator;
  const MaskedEndereco({
    Key? key,
    this.initialValues,
    this.onSave,
    this.width,
    this.validator,
    this.onChanged,
  }) : super(key: key);

  @override
  State<MaskedEndereco> createState() => _MaskedEnderecoState();
}

class _MaskedEnderecoState extends State<MaskedEndereco> {
  Map<String, dynamic>? values;

  //final TextEditingController _cepController = TextEditingController();

  @override
  void initState() {
    //_cepController.text = values['cep'] ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    values = widget.initialValues;
    return SizedBox(
      width: widget.width,
      child: Flex(direction: Axis.horizontal, children: [
        Container(
            constraints: const BoxConstraints(
              minWidth: 80,
              maxWidth: 100,
            ),
            child: MaskedTextFieldBr.cep(
                label: 'CEP',
                initialValue: values!['cep'] ?? '',
                onChanged: widget.onChanged,
                onSave: (x) {
                  values!['cep'] = x;
                  doSave();
                })),
        const SizedBox(
          width: 5,
        ),
        Container(
            constraints: const BoxConstraints(
              minWidth: 80,
              maxWidth: 100,
            ),
            child: MaskedTextField.text(
                label: 'num casa',
                maxLength: 10,
                initialValue: values!['numero'] ?? '',
                onSaved: (x) {
                  values!['numero'] = x;
                  doSave();
                })),
        const SizedBox(
          width: 5,
        ),
        Expanded(
          child: Container(
              child: MaskedTextField.text(
                  label: 'complemento',
                  maxLength: 60,
                  validator: (x) {
                    values!['compl'] = x;
                    doValidator();
                  },
                  initialValue: values!['compl'] ?? '',
                  onSaved: (x) {
                    values!['compl'] = x;
                    doSave();
                  })),
        ),
      ]),
    );
  }

  doSave() {
    if (widget.onSave != null) widget.onSave!(values!);
  }

  doValidator() {
    if (widget.validator != null) {
      return widget.validator!(values!);
    } else
      return null;
  }
}
