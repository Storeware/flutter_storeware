// @dart=2.12

import 'dart:async';

import 'package:models/builders/form_callback.dart';

import 'search_form_field.dart';
import 'package:controls_web/controls/ink_button.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class AtalhosSearchFormField extends StatefulWidget {
  final Function(double?)? onChanged;
  final double? codigo;
  final dynamic Function(String)? validator;
  final bool obrigatorio;
  final FormSearchCallback? onSearch;
  final SuggestionController? suggestionController;

  const AtalhosSearchFormField({
    Key? key,
    this.onChanged,
    this.codigo,
    this.validator,
    this.obrigatorio = true,
    this.onSearch,
    this.suggestionController,
  }) : super(key: key);

  @override
  _AtalhosSearchFormFieldState createState() => _AtalhosSearchFormFieldState();
}

class _AtalhosSearchFormFieldState extends State<AtalhosSearchFormField> {
  final ValueNotifier<dynamic> notifier = ValueNotifier({});

  buscar(cd) {
    notifier.value = {};
    CategoriaModel().buscarByCodigo('$cd').then((rsp) {
      if (rsp.length > 0) {
        notifier.value = rsp;
      } else {
        notifier.value = {};
      }
      textoController.text = notifier.value['nome'] ?? '';
      _dados = notifier.value;
      return notifier.value;
    });
  }

  @override
  void initState() {
    super.initState();
    _dados = {};
    stateController = SearchFormFieldController();
  }

  ValueNotifier<List> addSuggestions = ValueNotifier<List>([]);
  final TextEditingController textoController = TextEditingController();

  late dynamic _dados;
  dynamic stateController;
  get codigo => _dados['codigo'];
  get nome => _dados['nome'];
  set codigo(x) => _dados['codigo'] = x;
  set nome(x) => _dados['nome'] = x;

  @override
  Widget build(BuildContext context) {
    if (widget.codigo != null) buscar(widget.codigo);
    return SearchFormField(
      minChars: 2,
      controller: textoController,
      keyStorage: 'atalhos_searchfield',
      nameField: 'nome',
      keyField: 'codigo',
      label: 'Categoria',
      initialValue: notifier.value['nome'] ?? '',
      suggestionsNotifier: addSuggestions,
      suggestionController: widget.suggestionController,
      stateController: stateController,
      onFocusChanged: (b, texto) {
        double? cod = double.tryParse(texto);
        if (!b &&
            (cod != null) &&
            //((codigo ?? 0.0) == 0.0) &&
            texto.isNotEmpty &&
            texto.length <= 10) {
          CategoriaModel().buscarByCodigo(cod).then((rsp) {
            if (rsp != null && rsp.length > 0) {
              codigo = rsp['codigo'] + 0.0;
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
            textoController.text = '';
          }),
      validator: (x) {
        if (widget.validator != null) return widget.validator!(x);
        if (widget.obrigatorio && x.isEmpty) {
          return 'Não identificou a categoria';
        }
        return null;
      },
      onChanged: (v) {
        widget.onChanged!(v['codigo'] + 0.0);
        notifier.value = v;
        textoController.text = v['nome'] ?? '';
      },
      onSearch: widget.onSearch == null
          ? null
          : (x) => widget.onSearch!(context).then((r) {
                addSuggestions.value = [r];
                return r['codigo'];
              }) /* (a) {
              late dynamic y;
              return Dialogs.showPage(context,
                  width: 450,
                  //height: 550,
                  child: widget.childDialog(context, (r) {
                    y = r;
                  }) CadastroCategoriaView(
                      title: 'Selecione uma categoria',
                      canEdit: false,
                      canInsert: false,
                      onLoaded: (rows) {
                        addSuggestions.value = rows;
                      },
                      onSelected: (x) async {
                        y = x;
                        return x['codigo'];
                      })
                  ).then((rsp) {
                return y;
              })*/
      ,
      future: (x) {
        var u = x.toUpperCase();
        var d = double.tryParse(x);
        return CategoriaModel()
            .listCached(
                select: 'codigo,nome',
                filter: "upper(nome) like '%25$u%25' " +
                    ((d != null) ? ' or codigo = $d ' : ''))
            .then((r) {
          return r;
        });
      },
    );
  }
}
