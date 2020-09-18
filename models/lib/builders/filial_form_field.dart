import 'package:controls_web/controls/dialogs_widgets.dart';
import 'package:controls_web/controls/masked_field.dart';
import 'package:console/models/filial_model.dart';
import 'package:console/views/cadastros/filial_page.dart';

import 'package:flutter/material.dart';

class FilialFormField extends StatefulWidget {
  final double codigo;
  final Function(double) onChanged;
  final Function(double) onSaved;
  final bool readOnly;
  final Function(double) validator;
  FilialFormField({
    Key key,
    this.codigo,
    this.onChanged,
    this.onSaved,
    this.validator,
    this.readOnly = false,
  }) : super(key: key);

  @override
  _CodigoProdutoFormFieldState createState() => _CodigoProdutoFormFieldState();
}

class _CodigoProdutoFormFieldState extends State<FilialFormField> {
  buscar(cd) {
    notifier.value = {};
    FilialItemModel().buscarByCodigo(cd).then((rsp) {
      print(rsp);
      if (rsp.length > 0) notifier.value = rsp[0];
    });
  }

  ValueNotifier<Map<String, dynamic>> notifier;
  String nome = '';
  @override
  void initState() {
    super.initState();
    notifier = ValueNotifier({});
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController codigoController =
        TextEditingController(text: widget.codigo.toInt().toString());
    if ((widget.codigo ?? 0) > 0) {
      buscar(widget.codigo);
    }
    print('filial ${widget.codigo}');
    return Container(
        height: kToolbarHeight + 7,
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 100,
            child: MaskedSearchFormField<double>(
              readOnly: widget.readOnly,
              autofocus: (widget.codigo ?? 0) == 0,
              labelText: 'Filial',
              controller: codigoController,
              //initialValue: widget.codigo,
              onChanged: widget.onChanged,
              validator: (x) {
                if (nome == '') return 'inválido';
                return (widget.validator != null) ? widget.validator(x) : null;
              },
              onSaved: (x) {
                if (widget.onSaved != null) return widget.onSaved(x);
              },
              onFocusChange: (b, x) {
                if (x > 0) buscar(x);
              },
              onSearch: () {
                if (widget.readOnly) return null;
                return Dialogs.showPage(context,
                    child: FilialPage(
                        canEdit: false,
                        canInsert: false,
                        onSelected: (x) async {
                          notifier.value = x;
                          codigoController.text = x['codigo'].toString();
                          return x['codigo'];
                        }));
              },
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: notifier,
              builder: (ctx, row, wg) {
                nome = row['nome'] ?? '';
                return MaskedLabeled(
                  padding: EdgeInsets.only(left: 4, bottom: 2),
                  value: nome,
                );
              },
            ),
          ),
        ]));
  }
}
