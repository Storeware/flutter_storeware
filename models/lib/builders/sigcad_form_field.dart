// @dart=2.12

import 'package:controls_web/controls/dialogs_widgets.dart';
import 'package:controls_web/controls/masked_field.dart';
import 'package:controls_web/controls/responsive.dart';
import 'package:console/views/cadastros/clientes/cadastro_clientes.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class SigcadFormField extends StatefulWidget {
  final double? codigo;
  final Function(double)? onChanged;
  final Function(double)? onSaved;
  final bool readOnly;
  final String? label;
  final Function(int?)? validator;
  final Function(double)? onFocusChanged;
  final Function(dynamic)? onItemChanged;
  const SigcadFormField({
    Key? key,
    this.codigo = 0.0,
    this.onChanged,
    this.onSaved,
    this.readOnly = false,
    this.label,
    this.validator,
    this.onItemChanged,
    this.onFocusChanged,
  }) : super(key: key);

  @override
  _CodigoProdutoFormFieldState createState() => _CodigoProdutoFormFieldState();
}

class _CodigoProdutoFormFieldState extends State<SigcadFormField> {
  buscar(double? cd) async {
    notifier.value = {};
    if ((cd ?? 0.0) == 0) {
      notifier.value = {"codigo": 0.0, "nome": ''};
      return;
    }
    return SigcadItemModel().buscarByCodigo(cd!).then((rsp) {
      if (rsp.isNotEmpty) notifier.value = rsp;
    });
  }

  late ValueNotifier<Map<String, dynamic>> notifier;
  String nomeContato = '';
  @override
  void initState() {
    super.initState();
    notifier = ValueNotifier({});
  }

  doItemChanged(double? codigo, String nome) {
    if (widget.onItemChanged != null) {
      widget.onItemChanged!({'codigo': codigo, 'nome': nome});
    }
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveInfo responsive = ResponsiveInfo(context);
    final TextEditingController codigoController =
        TextEditingController(text: (widget.codigo ?? 0.0).toStringAsFixed(0));
    if ((widget.codigo ?? 0) > 0) {
      buscar(widget.codigo);
    }
    return Container(
        height: kToolbarHeight + 7,
        alignment: Alignment.bottomLeft,
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            width: 140,
            child: MaskedSearchFormField<int?>(
              readOnly: widget.readOnly,
              autofocus: (widget.codigo ?? 0) == 0,
              labelText: widget.label ?? 'Parceiro',
              controller: codigoController,
              initialValue: widget.codigo?.toInt() ?? 0,
              onChanged: (x) => widget.onChanged!(x! + 0.0),
              validator: (v) {
                if (((v ?? 0) > 0) && (nomeContato == '')) return 'Inválido';
                return (widget.validator != null) ? widget.validator!(v) : null;
              },
              onSaved: (x) {
                // print(['saved', x]);
                if (widget.onSaved != null) return widget.onSaved!(x! + 0.0);
              },
              onFocusChange: (b, x) {
                // print('onFocusChange $x');
                buscar(x! + 0.0).then((rsp) {});
                if (widget.onFocusChanged != null) {
                  widget.onFocusChanged!(x + 0.0);
                }
              },
              onSearch: () async {
                if (widget.readOnly) return null;
                //var rt = await
                return Dialogs.showPage(context,
                        child: Scaffold(
                            appBar: AppBar(title: const Text('Contatos')),
                            body: CadastroClientePage(
                                canEdit: true,
                                canInsert: true,
                                top: 10,
                                height: responsive.size.height * 0.90,
                                onChange: (x) {
                                  codigoController.text =
                                      (x ?? 0).toInt().toString();
                                  buscar(x).then((rsp) {
                                    //if (widget.onChanged != null)
                                    //  widget.onChanged(x);
                                  });
                                })))
                    .then((rsp) => int.tryParse(codigoController.text));
              },
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: notifier,
              builder: (ctx, dynamic row, wg) {
                nomeContato = row['nome'] ?? '';
                doItemChanged(
                    double.tryParse(codigoController.text), nomeContato);
                return MaskedLabeled(
                  padding: const EdgeInsets.only(left: 4, bottom: 11),
                  value: nomeContato,
                );
              },
            ),
          ),
        ]));
  }
}
