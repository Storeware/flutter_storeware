// @dart=2.12

import 'package:controls_web/controls/masked_field.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

import 'form_callback.dart';

class CodigoProdutoFormField extends StatefulWidget {
  final String? codigo;
  final Function(String)? onChanged;
  final Function(String)? onSaved;
  final Function(String)? validator;
  final FormSearchCallback onSearch;
  const CodigoProdutoFormField(
      {Key? key,
      this.codigo,
      this.onChanged,
      this.onSaved,
      this.validator,
      required this.onSearch})
      : super(key: key);

  @override
  _CodigoProdutoFormFieldState createState() => _CodigoProdutoFormFieldState();
}

class _CodigoProdutoFormFieldState extends State<CodigoProdutoFormField> {
  buscarProduto(cd) {
    notifier.value = {};
    ProdutoModel().buscarByCodigo(cd).then((rsp) {
      //print(rsp);
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
    final TextEditingController produtoController =
        TextEditingController(text: widget.codigo);
    if ((widget.codigo ?? '').isNotEmpty) {
      buscarProduto(widget.codigo);
    }
    return SizedBox(
        height: kToolbarHeight + 7,
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            width: 180,
            child: MaskedSearchFormField<String>(
                autofocus: (widget.codigo ?? '').isEmpty,
                labelText: 'Código',
                controller: produtoController,
                initialValue: widget.codigo,
                onChanged: widget.onChanged,
                validator: (x) {
                  if (nome == '') return 'Inválido';
                  return (widget.validator != null)
                      ? widget.validator!(x)
                      : null;
                },
                onSaved: (x) {
                  if (widget.onSaved != null) return widget.onSaved!(x);
                },
                onFocusChange: (b, x) {
                  // print('focusChange $x');
                  buscarProduto(x);
                },
                onSearch: () {
                  return widget.onSearch(context).then((r) {
                    notifier.value = r;
                    return r['codigo'];
                  });
                } /*() {
                return Dialogs.showPage(context,
                    child: Scaffold(
                      appBar: AppBar(title: const Text('Selecionar produto')),
                      body: CadastroProdutoPage(
                          canEdit: false,
                          canInsert: false,
                          onSelected: (x) async {
                            notifier.value = x;
                            //produtoController.text = x['codigo'];
                            return x['codigo'];
                          }),
                    )).then((rsp) {
                  return notifier.value['codigo'];
                });
              },*/
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
