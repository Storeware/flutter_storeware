// @dart=2.12

import 'dart:async';

import 'form_callback.dart';
import 'search_form_field.dart';
//import 'package:console/views/financas/cadastros/sig01_page.dart';
import 'package:controls_web/controls/dialogs_widgets.dart';
import 'package:controls_web/controls/ink_button.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class Sig01SearchFormField extends StatefulWidget {
  final Function(String?)? onChanged;
  final String? codigo;
  final bool inPagamento;
  final bool inRecebimento;
  final String? filter;
  final bool canEdit;
  final bool canInsert;
  final bool? canDelete;
  final bool sinteticos;
  final String? Function(String)? validator;
  final FormSearchCallback onSearch;

  const Sig01SearchFormField({
    Key? key,
    this.onChanged,
    this.codigo,
    this.inPagamento = true,
    this.inRecebimento = true,
    this.filter,
    this.validator,
    this.sinteticos = false,
    this.canEdit = false,
    this.canInsert = false,
    this.canDelete = false,
    required this.onSearch,
  }) : super(key: key);

  @override
  _SigbcoSearchFormFieldState createState() => _SigbcoSearchFormFieldState();
}

class _SigbcoSearchFormFieldState extends State<Sig01SearchFormField> {
  final ValueNotifier<dynamic> notifier = ValueNotifier({});

  buscar(cd) {
    notifier.value = {};
    Sig01ItemModel().buscarByCodigo('$cd').then((rsp) {
      if (rsp.isEmpty) {
        notifier.value = {};
      } else {
        notifier.value = rsp;
      }
      operacaoController.text = notifier.value['nome'] ?? '';
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

  ValueNotifier<List> addSuggestions = ValueNotifier<List>([]);
  final TextEditingController operacaoController = TextEditingController();

  late dynamic _dados;
  dynamic stateController;
  get codigo => _dados['codigo'];
  get nome => _dados['nome'];
  set codigo(x) => _dados['codigo'] = x;
  set nome(x) => _dados['nome'] = x;

  @override
  Widget build(BuildContext context) {
    if ((widget.codigo ?? '').isNotEmpty) buscar(widget.codigo);
    return /*ValueListenableBuilder(
      valueListenable: notifier,
      builder: (a, b, c) =>*/
        SearchFormField(
      minChars: 2,
      controller: operacaoController,
      keyStorage: 'sig01_searchfield',
      nameField: 'nome',
      keyField: 'codigo',
      label: 'Classificação da Operação',
      //initialValue: notifier.value['nome'] ?? '',
      suggestionsNotifier: addSuggestions,
      stateController: stateController,
      onFocusChanged: (b, texto) {
        if (!b &&
            (codigo ?? '').isEmpty &&
            texto.isNotEmpty &&
            texto.length <= 10) {
          Sig01ItemModel().buscarByCodigo(texto).then((rsp) {
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
            operacaoController.text = '';
          }),
      onChanged: (v) {
        widget.onChanged!(v['codigo']);
        notifier.value = v;
        operacaoController.text = v['nome'] ?? '';
      },
      validator: (x) {
        if (widget.validator != null) return widget.validator!(x);
        if (operacaoController.text.isEmpty) return 'Informar a operação';
        return null;
      },
      onSearch: (c) => widget.onSearch(context).then((r) {
        addSuggestions.value = [r];
        return r['codigo'];
      }),
      /* (a) {
        late dynamic y;
        return Dialogs.showPage(context,
            child: Sig01Page(
                title: 'Classificação da Operação',
                inPagamento: widget.inPagamento,
                inRecebimento: widget.inRecebimento,
                filter: widget.filter,
                canEdit: widget.canEdit,
                canInsert: widget.canInsert,
                canDelete: widget.canDelete,
                mostrarSinteticos: widget.sinteticos,
                inativos: false,
                onLoaded: (rows) {
                  addSuggestions.value = rows;
                },
                onSelected: (x) async {
                  y = x;
                  return x['codigo'];
                })).then((rsp) {
          return y;
        });
      },*/
      future: (x) {
        var u = x.toUpperCase();
        String f = '';
        if (widget.inPagamento && widget.inRecebimento) {
          // quando ambos estao habilitados então não tem filtro.
        } else {
          if (widget.inPagamento) f = " and codigo ge '200' ";
          if (widget.inRecebimento) f = " and codigo lt '200' ";
        }
        return Sig01ItemModel()
            .listCached(
                select: 'codigo,nome',
                filter:
                    "sintetico = '${widget.sinteticos ? 'S' : 'N'}' and  (upper(nome) like '%25$u%25' or codigo = '$x') $f ")
            .then((r) {
          return r;
        });
      }, //),
    );
  }
}
