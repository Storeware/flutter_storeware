// @dart=2.12

import 'package:controls_web/controls/dialogs_widgets.dart';
import 'package:controls_web/controls/masked_field.dart';
import 'package:flutter/material.dart';

class FormFieldSearchBuilder extends StatefulWidget {
  final String? label;
  final String? value;
  final Function(String?) onChanged;
  final bool readOnly;
  final Function(String?)? validator;
  final String? filter;
  final Function(String?, Function(dynamic)) onSearch;
  final Function(String?)? onSaved;
  final Widget Function(String, Function(dynamic)) onDialogBuild;
  final Size? dialogSize;
  final String keyField;
  final String nameField;
  final bool? requiredResult;
  const FormFieldSearchBuilder({
    Key? key,
    required this.value,
    this.requiredResult,
    required this.onChanged,
    this.onSaved,
    this.dialogSize,
    this.readOnly = false,
    this.validator,
    required this.onDialogBuild,
    this.filter,
    required this.onSearch,
    required this.keyField,
    required this.nameField,
    this.label,
  }) : super(key: key);

  @override
  _FormFieldSearchBuilderState createState() => _FormFieldSearchBuilderState();
}

class _FormFieldSearchBuilderState extends State<FormFieldSearchBuilder> {
  buscar(cd) {
    widget.onSearch(cd, (rsp) {
      if (rsp != null) notifier.value = rsp;
    });
  }

  late ValueNotifier<dynamic> notifier;
  String nomeConta = '';
  @override
  void initState() {
    super.initState();
    notifier = ValueNotifier({widget.keyField: widget.value});
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController codigoController =
        TextEditingController(text: widget.value);
    if ((widget.value ?? '').isNotEmpty) {
      buscar(widget.value);
    }
    return SizedBox(
        height: kToolbarHeight + 7,
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
              width: 100,
              child: MaskedSearchFormField<dynamic>(
                  readOnly: widget.readOnly,
                  autofocus: (widget.value ?? '').isEmpty,
                  labelText: widget.label ?? '',
                  controller: codigoController,
                  initialValue: widget.value,
                  onChanged: (x) {
                    widget.onChanged(x);
                  },
                  validator: (x) {
                    if (nomeConta == '') return 'Inválido';
                    return (widget.validator != null)
                        ? widget.validator!(x)
                        : null;
                  },
                  onSaved: (x) {
                    if (widget.onSaved != null) return widget.onSaved!(x);
                  },
                  onFocusChange: (b, x) {
                    if (x.length > 0) buscar(x);
                  },
                  onSearch: () async {
                    if (widget.readOnly) return null;
                    return Dialogs.showPage(context,
                        width: (widget.dialogSize != null)
                            ? widget.dialogSize!.width
                            : null,
                        height: (widget.dialogSize != null)
                            ? widget.dialogSize!.height
                            : null,
                        child: widget.onDialogBuild(codigoController.text, (x) {
                          notifier.value = x;
                        })).then((rsp) => notifier.value[widget.keyField]);
                  })),
          Expanded(
            child: ValueListenableBuilder(
                valueListenable: notifier,
                builder: (ctx, dynamic row, wg) {
                  row ??= {};
                  nomeConta = row[widget.nameField] ?? '';
                  //codigoController.text = row[widget.keyField] ?? '';
                  //if (row[widget.keyField] != null)
                  //  widget.onChanged(row[widget.keyField]);

                  return MaskedLabeled(
                    padding: const EdgeInsets.only(left: 4, bottom: 2),
                    value: nomeConta,
                  );
                }),
          ),
        ]));
  }
}
