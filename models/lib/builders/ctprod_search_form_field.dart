// @dart=2.12

import 'dart:async';

import 'form_callback.dart';
import 'search_form_field.dart';
import 'package:controls_web/controls/ink_button.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class CtprodSearchFormField extends StatefulWidget {
  final Function(String?)? onChanged;
  final String? codigo;
  final String? filter;
  final bool canEdit;
  final bool canInsert;
  final bool canDelete;
  final bool autofocus;
  final bool readOnly;
  final bool canClear;
  final bool obrigatorio;
  final String? Function(String)? validator;
  final FormSearchCallback onSearch;
  final SuggestionController? suggestionController;

  const CtprodSearchFormField({
    Key? key,
    this.onChanged,
    this.codigo,
    this.filter,
    this.validator,
    this.canClear = true,
    this.obrigatorio = true,
    this.autofocus = false,
    this.readOnly = false,
    this.canEdit = false,
    this.canInsert = false,
    this.canDelete = false,
    required this.onSearch,
    this.suggestionController,
  }) : super(key: key);

  @override
  _SigbcoSearchFormFieldState createState() => _SigbcoSearchFormFieldState();
}

class _SigbcoSearchFormFieldState extends State<CtprodSearchFormField> {
  final ValueNotifier<dynamic> notifierItem = ValueNotifier({});

  @override
  void initState() {
    super.initState();
    stateController = SearchFormFieldController();
    suggestionsAmount = amount;
    _dados = {"codigo": widget.codigo};
  }

  buscar(cd) {
    //notifier.value = {};
    ProdutoModel().buscarByCodigo('$cd').then((rsp) {
      if (rsp.isNotEmpty) {
        notify(rsp);
      } else {
        notify({});
      }
      textController.text = nome ?? '';
      return rsp;
    });
  }

  late dynamic _dados;
  notify(dynamic values) {
    _dados = values;
    notifierItem.value = values;
  }

  final TextEditingController textController = TextEditingController();
  ValueNotifier<List> addSuggestions = ValueNotifier<List>([]);

  String? get codigo => _dados['codigo'];
  set codigo(String? tx) => _dados['codigo'] = tx;
  String? get nome => _dados['nome'];
  set nome(String? tx) => _dados['nome'] = tx;
  get amount => 8;
  SearchFormFieldController? stateController;
  int? suggestionsAmount;
  @override
  Widget build(BuildContext context) {
    if ((widget.codigo ?? '').isNotEmpty) buscar(widget.codigo);
    return /*ValueListenableBuilder(
      valueListenable: notifier,
      builder: (a, b, c) =>*/
        SearchFormField(
            minChars: 2,
            controller: textController,
            readOnly: widget.readOnly,
            autofocus: widget.autofocus,
            keyStorage: 'ctprod_searchfield',
            nameField: 'nome',
            keyField: 'codigo',
            label: 'Produto/Serviço',
            initialValue: nome ?? '',
            suggestionsAmount: suggestionsAmount,
            suggestionsNotifier: addSuggestions,
            stateController: stateController,
            suggestionController: widget.suggestionController,
            onFocusChanged: (b, texto) {
              if (!b &&
                  (codigo ?? '').isEmpty &&
                  texto.isNotEmpty &&
                  texto.length <= 18) {
                ProdutoModel().buscarByCodigo(texto).then((rsp) {
                  if (rsp.isNotEmpty) {
                    codigo = rsp['codigo'];
                    nome = rsp['nome'];
                    widget.onChanged!(codigo);
                    Timer(const Duration(milliseconds: 500), () {
                      stateController!.closeOverlay(nome ?? '');
                    });
                  } else {
                    stateController!.closeOverlay('');
                  }
                });
              }
            },
            sufixIcon: (widget.canClear)
                ? InkButton(
                    child: const Icon(Icons.clear),
                    onTap: () {
                      codigo = '';
                      nome = '';
                      suggestionsAmount = amount;
                      textController.text = '';
                    })
                : null,
            onChanged: (v) {
              suggestionsAmount = 8;
              _dados = v;
              widget.onChanged!(codigo);

              textController.text = nome ?? '';
            },
            validator: (x) {
              if (widget.validator != null) return widget.validator!(x);
              if ((x.isEmpty || (codigo ?? '').isEmpty) && widget.obrigatorio) {
                return 'Identificar o produto/serviço';
              }

              return ((nome ?? '').isEmpty || (codigo ?? '').isEmpty)
                  ? 'Indentificar o produto/serviço'
                  : null;
            },
            onSearch: (x) => widget.onSearch(context).then((r) => r['codigo']),
            /*(a) {
              late dynamic y;
              return Dialogs.showPage(context,
                  child: CadastroProdutoPage(
                      title: 'Indenficação do produto',
                      //inPagamento: widget.inPagamento,
                      //inRecebimento: widget.inRecebimento,
                      filter: widget.filter,
                      canEdit: widget.canEdit,
                      canInsert: widget.canInsert,
                      //canDelete: widget.canDelete,
                      //onLoaded: (rows) {
                      //  addSuggestions.value = rows;
                      //},
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

              return ProdutoModel()
                  .listCached(
                      select: 'codigo,nome',
                      filter:
                          "(upper(nome) like '%25$u%25' or codigo = '$x') $f ")
                  .then((r) {
                return r;
              });
            } //),
            );
  }
}
