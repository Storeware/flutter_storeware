import 'package:controls_web/controls/dialogs_widgets.dart';
import 'package:controls_web/controls/masked_field.dart';
import 'package:console/views/estoque/cadastros/estoper_page.dart';
import 'package:flutter/material.dart';
import 'package:models/models/estoper_model.dart';

class EstOperFormField extends StatefulWidget {
  final String codigo;
  final Function(String) onChanged;
  final Function(String) onSaved;
  final bool readOnly;
  final Function(String) validator;
  EstOperFormField({
    Key key,
    this.codigo,
    this.onChanged,
    this.onSaved,
    this.readOnly = false,
    this.validator,
  }) : super(key: key);

  @override
  _CodigoProdutoFormFieldState createState() => _CodigoProdutoFormFieldState();
}

class _CodigoProdutoFormFieldState extends State<EstOperFormField> {
  buscar(cd) {
    notifier.value = {};
    EstoperItemModel().buscarByCodigo(cd).then((rsp) {
      print(rsp);
      if (rsp.length > 0) notifier.value = rsp;
    });
  }

  ValueNotifier<Map<String, dynamic>> notifier;
  String nomeConta = '';
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
            width: 180,
            child: MaskedSearchFormField<String>(
              readOnly: widget.readOnly,
              autofocus: (widget.codigo ?? '').length == 0,
              labelText: 'Conta',
              controller: codigoController,
              initialValue: widget.codigo,
              onChanged: widget.onChanged,
              validator: (x) {
                if (nomeConta == '') return 'Inválido';
                return (widget.validator != null) ? widget.validator(x) : null;
              },
              onSaved: (x) {
                if (widget.onSaved != null) return widget.onSaved(x);
              },
              onFocusChange: (b, x) {
                buscar(x);
              },
              onSearch: () {
                if (widget.readOnly) return null;
                return Dialogs.showPage(context,
                    child: EstOperView(
                        canEdit: false,
                        canInsert: false,
                        onSelected: (x) async {
                          notifier.value = x;
                          //codigoController.text = x['codigo'];
                          return x['codigo'];
                        })).then((rsp) => notifier.value['codigo']);
              },
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: notifier,
              builder: (ctx, row, wg) {
                nomeConta = row['nome'] ?? '';
                return MaskedLabeled(
                  padding: EdgeInsets.only(left: 4, bottom: 2),
                  value: nomeConta,
                );
              },
            ),
          ),
        ]));
  }
}
