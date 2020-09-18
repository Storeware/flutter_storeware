import 'package:controls_web/controls/dialogs_widgets.dart';
import 'package:controls_web/controls/masked_field.dart';
import 'package:controls_web/controls/responsive.dart';
import 'package:console/models/sigcad_model.dart';
import 'package:console/views/cadastros/cadastro_clientes.dart';
//import 'package:console/views/financas/cadastros/cadastro_contas_operacao_page.dart';
import 'package:flutter/material.dart';
//import 'package:controls_data/odata_client.dart';

class SigcadFormField extends StatefulWidget {
  final double codigo;
  final Function(double) onChanged;
  final Function(double) onSaved;
  final bool readOnly;
  final String label;
  final Function(int) validator;
  SigcadFormField({
    Key key,
    this.codigo = 0.0,
    this.onChanged,
    this.onSaved,
    this.readOnly = false,
    this.label,
    this.validator,
  }) : super(key: key);

  @override
  _CodigoProdutoFormFieldState createState() => _CodigoProdutoFormFieldState();
}

class _CodigoProdutoFormFieldState extends State<SigcadFormField> {
  buscar(double cd) {
    notifier.value = {};
    print(['buscando:', cd]);
    if ((cd ?? 0.0) == 0) {
      notifier.value = {"codigo": 0.0, "nome": ''};
      return;
    }
    SigcadItemModel().buscarByCodigo(cd).then((rsp) {
      print(rsp);
      if (rsp.length > 0) notifier.value = rsp[0];
    });
  }

  ValueNotifier<Map<String, dynamic>> notifier;
  String nomeContato = '';
  @override
  void initState() {
    super.initState();
    notifier = ValueNotifier({});
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveInfo responsive = ResponsiveInfo(context);
    final TextEditingController codigoController = TextEditingController(
        text: '${(widget.codigo ?? 0.0).toStringAsFixed(0)}');
    if ((widget.codigo ?? 0) > 0) {
      buscar(widget.codigo);
    }
    return Container(
        height: kToolbarHeight + 7,
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 140,
            child: MaskedSearchFormField<int>(
              readOnly: widget.readOnly,
              autofocus: (widget.codigo ?? 0) == 0,
              labelText: widget.label ?? 'Parceiro',
              controller: codigoController,
              initialValue: widget?.codigo?.toInt() ?? 0,
              onChanged: (x) => widget.onChanged(x + 0.0),
              validator: (v) {
                if (((v ?? 0) > 0) && (nomeContato == '')) return 'Inválido';
                return (widget.validator != null) ? widget.validator(v) : null;
              },
              onSaved: (x) {
                print(['saved', x]);
                if (widget.onSaved != null) return widget.onSaved(x + 0.0);
              },
              onFocusChange: (b, x) {
                print('onFocusChange $x');
                buscar(x + 0.0);
              },
              onSearch: () {
                if (widget.readOnly) return null;
                return Dialogs.showPage(context,
                    child: Scaffold(
                        appBar: AppBar(title: Text('Contatos')),
                        body: CadastroClienteWidget(
                            canChange: true,
                            canInsert: true,
                            top: 10,
                            height: responsive.size.height * 0.90,
                            //title: 'Contatos',
                            onChange: (x) {
                              codigoController.text = x.toInt().toString();
                              if (widget.onChanged != null) widget.onChanged(x);
                              buscar(x);
                            }))).then((rsp) => true);
              },
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: notifier,
              builder: (ctx, row, wg) {
                nomeContato = row['nome'] ?? '';
                return MaskedLabeled(
                  padding: EdgeInsets.only(left: 4, bottom: 2),
                  value: nomeContato,
                );
              },
            ),
          ),
        ]));
  }
}
