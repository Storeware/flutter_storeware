// @dart=2.12

import 'package:controls_web/controls/dialogs_widgets.dart';
import 'package:controls_web/controls/masked_field.dart';
import 'package:console/views/cadastros/filiais/filial_page.dart';

import 'package:flutter/material.dart';
import 'package:models/models.dart';

class FilialFormField extends StatefulWidget {
  final double? codigo;
  final Function(double)? onChanged;
  final Function(double)? onSaved;
  final bool readOnly;
  final Function(double)? validator;
  final bool todas;
  const FilialFormField({
    Key? key,
    this.codigo,
    this.onChanged,
    this.onSaved,
    this.validator,
    this.todas = false,
    this.readOnly = false,
  }) : super(key: key);

  @override
  _CodigoProdutoFormFieldState createState() => _CodigoProdutoFormFieldState();
}

class _CodigoProdutoFormFieldState extends State<FilialFormField> {
  buscar(cd) {
    notifier.value = {};
    FilialItemModel().buscarByCodigo(cd).then((rsp) {
      //  print(rsp);
      if (rsp.isNotEmpty) notifier.value = rsp;
    });
  }

  late ValueNotifier<Map<String, dynamic>> notifier;
  String nome = '';
  @override
  void initState() {
    super.initState();
    notifier = ValueNotifier({});
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController codigoController =
        TextEditingController(text: widget.codigo!.toInt().toString());
    if ((widget.codigo ?? 0) > 0) {
      buscar(widget.codigo);
    }
    //print('filial ${widget.codigo}');
    return SizedBox(
        height: kToolbarHeight + 7,
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            width: 100,
            child: MaskedSearchFormField<int?>(
              readOnly: widget.readOnly,
              autofocus: (widget.codigo ?? 0) == 0,
              labelText: 'Filial',
              controller: codigoController,
              //initialValue: widget.codigo,
              onChanged: (x) {
                widget.onChanged!(x! + 0.0);
              },
              validator: (x) {
                if (nome == '') return 'inválido';
                return (widget.validator != null)
                    ? widget.validator!(x! + 0.0)
                    : null;
              },
              onSaved: (x) {
                if (widget.onSaved != null) return widget.onSaved!(x! + 0.0);
              },
              onFocusChange: (b, x) {
                if (x != null) if (x > 0) buscar(x);
              },
              onSearch: () async {
                if (widget.readOnly) return null;
                return await Dialogs.showPage(context,
                    child: FilialPage(
                        canEdit: false,
                        canInsert: false,
                        todas: widget.todas,
                        onSelected: (x) async {
                          notifier.value = x;
                        })).then((rsp) {
                  return notifier.value['codigo'] ~/ 1;
                });
              },
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: notifier,
              builder: (ctx, dynamic row, wg) {
                nome = row['nome'] ?? '';
                return MaskedLabeled(
                  padding: const EdgeInsets.only(left: 4, bottom: 2),
                  value: nome,
                );
              },
            ),
          ),
        ]));
  }
}
