// @dart=2.12

import 'dart:async';

import 'form_callback.dart';
import 'search_form_field.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class EstoperSearchFormField extends StatefulWidget {
  final Function(String?)? onChanged;
  final String? codigo;
  final bool inPagamento;
  final bool inRecebimento;
  final String? filter;
  final bool canEdit;
  final bool canInsert;
  final bool canDelete;
  final bool? readOnly;
  final String? Function(String)? validator;
  final FormSearchCallback onSearch;
  final SuggestionController? suggestionController;

  const EstoperSearchFormField({
    Key? key,
    this.onChanged,
    this.codigo,
    this.inPagamento = true,
    this.inRecebimento = true,
    this.filter,
    this.readOnly = false,
    this.validator,
    this.canEdit = false,
    this.canInsert = false,
    this.canDelete = false,
    required this.onSearch,
    this.suggestionController,
  }) : super(key: key);

  @override
  _EstoperSearchFormFieldState createState() => _EstoperSearchFormFieldState();
}

class _EstoperSearchFormFieldState extends State<EstoperSearchFormField> {
  final ValueNotifier<dynamic> notifier = ValueNotifier({});

  buscar(cd) {
    notifier.value = {};
    EstoperItemModel().buscarByCodigo('$cd').then((rsp) {
      if (rsp.isNotEmpty) {
        notify(rsp);
      } else {
        notify({});
      }
      textController.text = notifier.value['nome'] ?? '';
      return notifier.value;
    });
  }

  late dynamic _dados;
  notify(dados) {
    _dados = dados;
    notifier.value = dados;
  }

  get codigo => _dados['codigo'];
  get nome => _dados['nome'];
  set codigo(x) => _dados['codigo'] = x;
  set nome(x) => _dados['nome'] = x;

  final TextEditingController textController = TextEditingController();
  ValueNotifier<List> addSuggestions = ValueNotifier<List>([]);
  @override
  void initState() {
    super.initState();
    _dados = {};
    stateController = SearchFormFieldController();
  }

  dynamic stateController;
  @override
  Widget build(BuildContext context) {
    if ((widget.codigo ?? '').isNotEmpty) buscar(widget.codigo);
    return /*ValueListenableBuilder(
      valueListenable: notifier,
      builder: (a, b, c) =>*/
        SearchFormField(
            minChars: 2,
            controller: textController,
            keyStorage: 'estoper_searchfield',
            nameField: 'nome',
            keyField: 'codigo',
            label: 'Classificação da Operação',
            initialValue: notifier.value['nome'] ?? '',
            suggestionsNotifier: addSuggestions,
            suggestionController: widget.suggestionController,
            stateController: stateController,
            onFocusChanged: (b, texto) {
              if (!b &&
                  (codigo ?? '').isEmpty &&
                  texto.isNotEmpty &&
                  texto.length <= 10) {
                EstoperItemModel().buscarByCodigo(texto).then((rsp) {
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
            onChanged: (v) {
              widget.onChanged!(v['codigo']);
              notifier.value = v;
              textController.text = v['nome'] ?? '';
            },
            validator: (x) {
              if (widget.validator != null) return widget.validator!(x);
              return (notifier.value['nome'] == null)
                  ? 'indicar a classificação para a operação'
                  : null;
            },
            onSearch: (c) => widget.onSearch(context).then((r) {
                  addSuggestions.value = [r];
                  return r['codigo'];
                }),
            /* (a) {
              dynamic y;
              return Dialogs.showPage(context,
                  width: 400,
                  //height: 650,
                  child: EstOperView(
                      //title: 'Classificação da Operação',
                      //inPagamento: widget.inPagamento,
                      //inRecebimento: widget.inRecebimento,
                      //filter: widget.filter,
                      canEdit: widget.canEdit,
                      canInsert: widget.canInsert,
                      canDelete: widget.canDelete,
                      searchOnly: true,
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
              return EstoperItemModel()
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
