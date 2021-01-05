import 'package:controls_web/controls/data_viewer.dart';
import 'package:controls_web/controls/dialogs_widgets.dart';
import 'package:controls_web/controls/masked_field.dart';
import 'package:flutter/material.dart';
import 'package:models/models/usuarios_model.dart';

class UsuarioFormField extends StatefulWidget {
  final String codigo;
  final String label;
  final void Function(String) onChanged;
  final void Function(String) onSaved;
  final bool readOnly;
  final bool required;
  final String Function(String) validator;
  //final bool inPagamento;
  //final bool inRecebimento;
  //final String filter;
  UsuarioFormField({
    Key key,
    this.codigo,
    this.label,
    this.onChanged,
    this.onSaved,
    this.required = true,
    //this.inPagamento = false,
    //this.inRecebimento = false,
    this.readOnly = false,
    this.validator,
    //this.filter,
  }) : super(key: key);

  @override
  _UsuarioFormFieldState createState() => _UsuarioFormFieldState();
}

class _UsuarioFormFieldState extends State<UsuarioFormField> {
  buscar(cd) {
    notifier.value = {};
    UsuarioItemModel().buscarByCodigo(cd).then((rsp) {
      if (rsp.length > 0) notifier.value = rsp;
    });
  }

  ValueNotifier<Map<String, dynamic>> notifier;
  String nomeUsuario = '';
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
            width: 150,
            child: MaskedSearchFormField<dynamic>(
              readOnly: widget.readOnly,
              autofocus: (widget.codigo ?? '').length == 0,
              labelText: widget.label ?? 'Pessoa',
              controller: codigoController,
              //required: widget.required,
              initialValue: widget.codigo,
              onChanged: (x) {
                widget.onChanged(x);
              },
              validator: (x) {
                if (!widget.required && x == '') return null;
                if (nomeUsuario == '') return 'Inválido';
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
                        appBar: AppBar(title: Text('Usuários')),
                        body: UsuarioPage(
                            required: widget.required,
                            onSelected: (x) async {
                              notifier.value = x;
                              Navigator.pop(context);
                              //if (widget.onChanged != null)
                              //  widget.onChanged(x['codigo']);
                              return x['codigo'];
                            }))).then((rsp) => notifier.value['codigo']);
              },
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: notifier,
              builder: (ctx, row, wg) {
                nomeUsuario = row['nome'] ?? '';
                //codigoController.text = row['codigo'];

                //if (row['codigo'] != null) widget.onChanged(row['codigo']);

                return MaskedLabeled(
                  padding: EdgeInsets.only(left: 4, bottom: 2),
                  value: nomeUsuario,
                );
              },
            ),
          ),
        ]));
  }
}

class UsuarioPage extends StatelessWidget {
  final Function(dynamic) onSelected;
  final bool required;
  final bool canEdit;
  final bool canInsert;
  const UsuarioPage(
      {Key key,
      this.onSelected,
      this.canEdit = false,
      this.canInsert = false,
      this.required = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DataViewer(
      canEdit: canEdit,
      canInsert: canInsert,
      canDelete: false,
      controller: DataViewerController(
        keyName: 'codigo',
        future: () => UsuarioItemModel().listNoCached().then((rsp) {
          if (!required) rsp.insert(0, {'codigo': '', "nome": 'Nenhum'});
          return rsp;
        }),
        dataSource: UsuarioItemModel(),
      ),
      onSelected: onSelected,
      columns: [
        DataViewerColumn(name: 'codigo'),
        DataViewerColumn(name: 'nome', label: 'Nome do Usuário'),
      ],
    );
  }
}
