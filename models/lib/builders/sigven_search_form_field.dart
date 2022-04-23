// @dart=2.12

import 'dart:async';

import 'package:console/builders/search_form_field.dart';
import 'package:console/views/os/cadastros/sigven_view.dart';
import 'package:controls_web/controls/dialogs_widgets.dart';
import 'package:controls_web/controls/ink_button.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class SigvenSearchFormField extends StatefulWidget {
  final Function(String?)? onChanged;
  final String? codigo;
  final bool canEdit;
  final bool canInsert;
  final bool canDelete;
  final String Function(String)? validator;
  final String? label;
  const SigvenSearchFormField({
    Key? key,
    this.onChanged,
    this.codigo,
    this.label,
    this.validator,
    this.canEdit = false,
    this.canInsert = false,
    this.canDelete = false,
  }) : super(key: key);

  @override
  _SigbcoSearchFormFieldState createState() => _SigbcoSearchFormFieldState();
}

class _SigbcoSearchFormFieldState extends State<SigvenSearchFormField> {
  final ValueNotifier<dynamic> notifier = ValueNotifier({});

  buscar(cd) {
    notifier.value = {};
    SigvenItemModel().buscarByCodigo('$cd').then((rsp) {
      if (rsp.isEmpty) {
        notifier.value = {};
      } else {
        notifier.value = rsp;
      }
      vendedorController.text = notifier.value['nome'] ?? '';
      _dados = notifier.value;
      return notifier.value;
    });
  }

  @override
  void initState() {
    super.initState();
    _dados = {"codigo": widget.codigo};
    stateController = SearchFormFieldController();
  }

  late dynamic _dados;
  dynamic stateController;
  get codigo => _dados['codigo'];
  get nome => _dados['nome'];
  set codigo(x) => _dados['codigo'] = x;
  set nome(x) => _dados['nome'] = x;

  ValueNotifier<List> addSuggestions = ValueNotifier<List>([]);
  final TextEditingController vendedorController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    if ((widget.codigo ?? '').isNotEmpty) buscar(widget.codigo);
    return /*ValueListenableBuilder(
      valueListenable: notifier,
      builder: (a, b, c) =>*/
        SearchFormField(
      minChars: 2,
      controller: vendedorController,
      keyStorage: 'sigven_searchfield',
      nameField: 'nome',
      keyField: 'codigo',
      label: widget.label ?? 'Vendedor',
      //initialValue: notifier.value['nome'] ?? '',
      suggestionsNotifier: addSuggestions,
      stateController: stateController,
      onFocusChanged: (b, texto) {
        if (!b &&
            (codigo ?? '').isEmpty &&
            texto.isNotEmpty &&
            texto.length <= 10) {
          SigvenItemModel().buscarByCodigo(texto).then((rsp) {
            if (rsp.isNotEmpty) {
              codigo = rsp['codigo'];
              nome = rsp['nome'];
              widget.onChanged!(codigo);
              Timer(const Duration(milliseconds: 500), () {
                stateController.closeOverlay(nome);
              });
            } else {
              stateController.closeOverlay('');
            }
          });
        }
      },

      sufixIcon: InkButton(
          child: const Icon(Icons.clear),
          onTap: () {
            vendedorController.text = '';
          }),
      onChanged: (v) {
        widget.onChanged!(v['codigo']);
        notifier.value = v;
        vendedorController.text = v['nome'] ?? '';
      },
      validator: (x) {
        if (widget.validator != null) return widget.validator!(x);
        if (vendedorController.text.isEmpty) return 'Informar o vendedor';
        return null;
      },
      onSearch: (a) {
        late dynamic y;
        return Dialogs.showPage(context,
            child: SigvenView(
                //title: 'Classificação da Operação',
                //inPagamento: widget.inPagamento,
                //inRecebimento: widget.inRecebimento,
                //filter: widget.filter,
                canEdit: widget.canEdit,
                canInsert: widget.canInsert,
                canDelete: widget.canDelete,
                //mostrarSinteticos: widget.sinteticos,
                //inativos: false,
                onLoaded: (rows) {
                  addSuggestions.value = rows;
                },
                onSelected: (x) async {
                  y = x;
                  return x['codigo'];
                })).then((rsp) {
          return y;
        });
      },
      future: (x) {
        var u = x.toUpperCase();
        String f = '';
        return SigvenItemModel()
            .listCached(
                select: 'codigo,nome',
                filter: "(upper(nome) like '%25$u%25' or codigo = '$x') $f ")
            .then((r) {
          return r;
        });
      }, //),
    );
  }
}
