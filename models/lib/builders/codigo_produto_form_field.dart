import 'package:controls_web/controls/dialogs_widgets.dart';
import 'package:controls_web/controls/masked_field.dart';
import 'package:console/views/cadastros/produtos/produto.cadastro_page.dart';
import 'package:flutter/material.dart';
import 'package:models/models/ctprod_model.dart';

class CodigoProdutoFormField extends StatefulWidget {
  final String codigo;
  final Function(String) onChanged;
  final Function(String) onSaved;
  final Function(String) validator;
  CodigoProdutoFormField(
      {Key key, this.codigo, this.onChanged, this.onSaved, this.validator})
      : super(key: key);

  @override
  _CodigoProdutoFormFieldState createState() => _CodigoProdutoFormFieldState();
}

class _CodigoProdutoFormFieldState extends State<CodigoProdutoFormField> {
  buscarProduto(cd) {
    notifier.value = {};
    ProdutoModel().buscarByCodigo(cd).then((rsp) {
      print(rsp);
      if (rsp.length > 0) notifier.value = rsp;
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
    final TextEditingController produtoController =
        TextEditingController(text: widget.codigo);
    if ((widget.codigo ?? '').length > 0) {
      buscarProduto(widget.codigo);
    }
    return Container(
        height: kToolbarHeight + 7,
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 180,
            child: MaskedSearchFormField<String>(
              autofocus: (widget.codigo ?? '').length == 0,
              labelText: 'Código',
              controller: produtoController,
              initialValue: widget.codigo,
              onChanged: widget.onChanged,
              validator: (x) {
                if (nome == '') return 'Inválido';
                return (widget.validator != null) ? widget.validator(x) : null;
              },
              onSaved: (x) {
                if (widget.onSaved != null) return widget.onSaved(x);
              },
              onFocusChange: (b, x) {
                print('focusChange $x');
                buscarProduto(x);
              },
              onSearch: () {
                return Dialogs.showPage(context,
                    child: Scaffold(
                      appBar: AppBar(title: Text('Selecionar produto')),
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
