import 'package:controls_web/controls/dialogs_widgets.dart';
import 'package:console/views/financas/cadastros/sigbco_page.dart';
import 'package:controls_web/controls/masked_field.dart';

import 'package:flutter/material.dart';
import 'package:models/models/sigbco_model.dart';

class SigbcoFormField extends StatefulWidget {
  final String codigo;
  final Function(String) onChanged;
  final Function(String) onSaved;
  final bool readOnly;
  final Function(String) validator;
  SigbcoFormField({
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

class _CodigoProdutoFormFieldState extends State<SigbcoFormField> {
  buscar(cd) {
    notifier.value = {};
    SigbcoItemModel().buscarByCodigo('$cd').then((rsp) {
      if (rsp.length > 0) return notifier.value = rsp;
      notifier.value = {};
    });
  }

  ValueNotifier<Map<String, dynamic>> notifier;
  String nomeBanco = '';
  @override
  void initState() {
    super.initState();
    notifier = ValueNotifier({});
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController codigoController =
        TextEditingController(text: widget.codigo);
    if ((widget.codigo ?? '').length > 0) {
      buscar(widget.codigo);
    }
    return Container(
        height: kToolbarHeight + 7,
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 100,
            child: MaskedSearchFormField<String>(
              readOnly: widget.readOnly,
              autofocus: ('${widget.codigo ?? ''}').length == 0,
              labelText: 'Cx/Bc',
              controller: codigoController,
              initialValue: widget.codigo,
              onChanged: (x) {
                print(x);
                widget.onChanged(x);
              },
              validator: (x) {
                if (nomeBanco == '') return 'inválido';
                return (widget.validator != null) ? widget.validator(x) : null;
              },
              onSaved: (x) {
                if (widget.onSaved != null) return widget.onSaved(x);
              },
              onFocusChange: (b, x) {
                if ('$x'.length > 0) buscar('$x');
              },
              onSearch: () {
                if (widget.readOnly) return null;
                return Dialogs.showPage(context,
                    child: SigbcoPage(
                        canEdit: false,
                        canInsert: false,
                        onSelected: (x) async {
                          notifier.value = x;
                          return x['codigo'];
                        })).then((rsp) => notifier.value['codigo']);
              },
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: notifier,
              builder: (ctx, row, wg) {
                nomeBanco = '${notifier.value['nome'] ?? ''}';
                widget.onChanged(row['codigo']);

                return MaskedLabeled(
                  padding: EdgeInsets.only(left: 4, bottom: 2),
                  value: nomeBanco,
                );
              },
            ),
          ),
        ]));
  }
}
