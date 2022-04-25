// @dart=2.12

import 'dart:async';

import 'form_callback.dart';
import 'search_form_field.dart';
import 'package:controls_web/controls/ink_button.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class SigbcoSearchFormField extends StatefulWidget {
  final Function(String?)? onChanged;
  final String? codigo;
  final String? label;
  final dynamic Function(String)? validator;
  final EdgeInsets? padding;
  final bool obrigatorio;
  final FormSearchCallback onSearch;
  final SuggestionController? suggestionController;

  const SigbcoSearchFormField({
    Key? key,
    this.onChanged,
    this.codigo,
    this.label,
    this.padding,
    this.obrigatorio = true,
    this.validator,
    required this.onSearch,
    this.suggestionController,
  }) : super(key: key);

  @override
  _SigbcoSearchFormFieldState createState() => _SigbcoSearchFormFieldState();
}

class _SigbcoSearchFormFieldState extends State<SigbcoSearchFormField> {
  final ValueNotifier<dynamic> notifier = ValueNotifier({});

  buscar(cd) {
    notifier.value = {};
    SigbcoItemModel().buscarByCodigo('$cd').then((rsp) {
      if (rsp.isNotEmpty) {
        notifier.value = rsp;
      } else {
        notifier.value = {};
      }
      bancoController.text = notifier.value['nome'] ?? '';
      _dados = notifier.value;
      return notifier.value;
    });
  }

  ValueNotifier<List> addSuggestions = ValueNotifier<List>([]);
  final TextEditingController bancoController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    if ((widget.codigo ?? '').isNotEmpty) buscar(widget.codigo);
    return SearchFormField(
        minChars: 2,
        controller: bancoController,
        keyStorage: 'sigbco_searchfield',
        nameField: 'nome',
        keyField: 'codigo',
        suggestionController: widget.suggestionController,
        label: widget.label ?? 'Conta (Caixa/Banco)',
        initialValue: notifier.value['nome'] ?? '',
        suggestionsNotifier: addSuggestions,
        stateController: stateController,
        onFocusChanged: (b, texto) {
          if (!b &&
              (codigo ?? '').isEmpty &&
              texto.isNotEmpty &&
              texto.length <= 10) {
            SigbcoItemModel().buscarByCodigo(texto).then((rsp) {
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
              bancoController.text = '';
            }),
        validator: (x) {
          if (widget.validator != null) return widget.validator!(x);
          if (widget.obrigatorio && x.isEmpty) {
            return 'Informação relevante';
          }
          return null;
        },
        onChanged: (v) {
          widget.onChanged!(v['codigo']);
          notifier.value = v;
          bancoController.text = v['nome'] ?? '';
        },
        onSearch: (_) => widget.onSearch(context).then((r) {
              if (!addSuggestions.value.contains(r))
                addSuggestions.value.add(r);
              return r['codigo'];
            }),
        /*(a) {
              late dynamic y;
              return Dialogs.showPage(context,
                  width: 450,
                  //height: 550,
                  child: SigbcoPage(
                      canEdit: false,
                      canInsert: false,
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
          return SigbcoItemModel()
              .listCached(
                  select: 'codigo,nome',
                  filter: "upper(nome) like '%25$u%25' or codigo = '$x' ")
              .then((r) {
            return r;
          });
        } //),
        );
  }
}
