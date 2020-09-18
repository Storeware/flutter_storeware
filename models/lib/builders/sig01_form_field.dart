import 'package:controls_web/controls/dialogs_widgets.dart';
import 'package:controls_web/controls/masked_field.dart';
//import 'package:controls_web/controls/masked_field.dart';

import 'package:console/models/sig01_model.dart';
import 'package:console/views/financas/cadastros/sig01_page.dart';
import 'package:flutter/material.dart';

class Sig01FormField extends StatefulWidget {
  final String codigo;
  final Function(String) onChanged;
  final Function(String) onSaved;
  final bool readOnly;
  final Function(String) validator;
  final bool inPagamento;
  final bool inRecebimento;
  final String filter;
  Sig01FormField({
    Key key,
    this.codigo,
    this.onChanged,
    this.onSaved,
    this.inPagamento = false,
    this.inRecebimento = false,
    this.readOnly = false,
    this.validator,
    this.filter,
  }) : super(key: key);

  @override
  _CodigoProdutoFormFieldState createState() => _CodigoProdutoFormFieldState();
}

class _CodigoProdutoFormFieldState extends State<Sig01FormField> {
  buscar(cd) {
    notifier.value = {};
    Sig01ItemModel().buscarByCodigo(cd).then((rsp) {
      print(rsp);
      if (rsp.length > 0) notifier.value = rsp[0];
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
            width: 100,
            child: MaskedSearchFormField<String>(
              readOnly: widget.readOnly,
              autofocus: (widget.codigo ?? '').length == 0,
              labelText: 'Tipo',
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
                if (x.length > 0) buscar(x);
              },
              onSearch: () async {
                if (widget.readOnly) return null;
                return Dialogs.showPage(context,
                    child: Scaffold(
                        appBar: AppBar(
                            title: Text('Classificar o tipo de movimento')),
                        body: Sig01Page(
                            canEdit: false,
                            canInsert: false,
                            filter: widget.filter,
                            inPagamento: widget.inPagamento,
                            inRecebimento: widget.inRecebimento,
                            onSelected: (x) async {
                              notifier.value = x;
                              codigoController.text = x['codigo'];
                              return x['codigo'];
                            }))).then((rsp) => codigoController.text);
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
