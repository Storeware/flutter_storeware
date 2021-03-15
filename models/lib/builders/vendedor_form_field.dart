import 'package:controls_web/controls/data_viewer.dart';
import 'package:controls_web/controls/dialogs_widgets.dart';
import 'package:controls_web/controls/masked_field.dart';
import 'package:flutter/material.dart';
import 'package:models/models/sigven_model.dart';

class VendedorFormField extends StatefulWidget {
  final String? codigo;
  final Function(String)? onChanged;
  final Function(String)? onSaved;
  final bool? readOnly;
  final bool? required;
  final Function(String)? validator;
  //final bool inPagamento;
  //final bool inRecebimento;
  //final String filter;
  VendedorFormField({
    Key? key,
    this.codigo,
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
  _VendedorFormFieldState createState() => _VendedorFormFieldState();
}

class _VendedorFormFieldState extends State<VendedorFormField> {
  buscar(cd) {
    notifier!.value = {};
    SigvenItemModel().buscarByCodigo(cd).then((rsp) {
      if (rsp.length > 0) notifier!.value = rsp;
    });
  }

  ValueNotifier<Map<String, dynamic>>? notifier;
  String nomeVendedor = '';
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
            child: MaskedSearchFormField<dynamic>(
              readOnly: widget.readOnly,
              autofocus: (widget.codigo ?? '').length == 0,
              labelText: 'Vendedor',
              controller: codigoController,
              //required: widget.required,
              initialValue: widget.codigo,
              onChanged: (x) {
                widget.onChanged!(x);
              },
              validator: (x) {
                if (!widget.required! && x == '') return null;
                if (nomeVendedor == '') return 'Inválido';
                return (widget.validator != null) ? widget.validator!(x) : null;
              },
              onSaved: (x) {
                if (widget.onSaved != null) return widget.onSaved!(x);
              },
              onFocusChange: (b, x) {
                if (x.length > 0) buscar(x);
              },
              onSearch: () async {
                if (widget.readOnly!) return null;
                return Dialogs.showPage(context,
                    child: Scaffold(
                        appBar: AppBar(title: Text('Agente de negócio')),
                        body: VendedorPage(
                            required: widget.required!,
                            onSelected: (x) async {
                              notifier!.value = x;

                              Navigator.pop(context);
                              return x['codigo'];
                            }))).then((rsp) => notifier!.value['codigo']);
              },
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<dynamic>(
              valueListenable: notifier!,
              builder: (ctx, row, wg) {
                nomeVendedor = row['nome'] ?? '';
                return MaskedLabeled(
                  padding: EdgeInsets.only(left: 4, bottom: 2),
                  value: nomeVendedor,
                );
              },
            ),
          ),
        ]));
  }
}

class VendedorPage extends StatelessWidget {
  final Function(dynamic)? onSelected;
  final bool? required;
  final bool? canEdit;
  final bool? canInsert;
  const VendedorPage(
      {Key? key,
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
        future: () => SigvenItemModel().listNoCached().then((rsp) {
          if (!required!) rsp.insert(0, {'codigo': '', "nome": 'Nenhum'});
          return rsp;
        }),
        dataSource: SigvenItemModel(),
      ),
      onSelected: onSelected,
      columns: [
        DataViewerColumn(name: 'codigo'),
        DataViewerColumn(name: 'nome', label: 'Nome do Usuário'),
      ],
    );
  }
}
