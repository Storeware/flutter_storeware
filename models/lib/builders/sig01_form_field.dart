// @dart=2.12

import 'package:controls_web/controls/dialogs_widgets.dart';
import 'package:controls_web/controls/masked_field.dart';
//import 'package:controls_web/controls/masked_field.dart';

import 'package:console/views/financas/cadastros/sig01_page.dart';
import 'package:controls_web/controls/responsive.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class Sig01FormField extends StatefulWidget {
  final String? codigo;
  final Function(String?)? onChanged;
  final Function(String?)? onSaved;
  final bool readOnly;
  final Function(String?)? validator;
  final bool inPagamento;
  final bool inRecebimento;
  final String? filter;
  final String? label;
  const Sig01FormField({
    Key? key,
    this.codigo,
    this.label,
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
      if (rsp.isNotEmpty) notifier.value = rsp;
    });
  }

  late ValueNotifier<Map<String, dynamic>> notifier;
  String nomeConta = '';
  @override
  void initState() {
    super.initState();
    notifier = ValueNotifier({});
  }

  minX(double a, double b) => (a < b) ? a : b;
  @override
  Widget build(BuildContext context) {
    var responsive = ResponsiveInfo(context);
    final TextEditingController codigoController =
        TextEditingController(text: widget.codigo);
    if ((widget.codigo ?? '').isNotEmpty) {
      buscar(widget.codigo);
    }
    return SizedBox(
        height: kToolbarHeight + 7,
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            width: 100,
            child: MaskedSearchFormField<String?>(
              readOnly: widget.readOnly,
              autofocus: (widget.codigo ?? '').isEmpty,
              labelText: widget.label ?? 'Tipo',
              controller: codigoController,
              initialValue: widget.codigo,
              onChanged: (x) {
                widget.onChanged!(x);
              },
              validator: (x) {
                if (nomeConta == '') return 'Inválido';
                return (widget.validator != null) ? widget.validator!(x) : null;
              },
              onSaved: (x) {
                if (widget.onSaved != null) return widget.onSaved!(x);
              },
              onFocusChange: (b, x) {
                if (x!.isNotEmpty) buscar(x);
              },
              onSearch: () async {
                if (widget.readOnly) return null;
                return Dialogs.showPage(context,
                    width: minX(responsive.size.width, 400),
                    child: Scaffold(
                        appBar: AppBar(
                            title:
                                const Text('Classificar o tipo de movimento')),
                        body: Sig01Page(
                            canEdit: false,
                            canInsert: false,
                            filter: widget.filter,
                            inPagamento: widget.inPagamento,
                            inRecebimento: widget.inRecebimento,
                            onSelected: (x) async {
                              notifier.value = x;
                              return x['codigo'];
                            }))).then((rsp) => notifier.value['codigo']);
              },
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: notifier,
              builder: (ctx, dynamic row, wg) {
                nomeConta = row['nome'] ?? '';
                //codigoController.text = row['codigo'];
                //widget.onChanged(row['codigo']);

                return MaskedLabeled(
                  padding: const EdgeInsets.only(left: 4, bottom: 2),
                  value: nomeConta,
                );
              },
            ),
          ),
        ]));
  }
}
