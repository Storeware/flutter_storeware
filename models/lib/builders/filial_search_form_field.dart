// @dart=2.12

import 'dart:async';

import 'search_form_field.dart';
import 'package:console/views/cadastros/filiais/filial_page.dart';
//import 'package:console/views/financas/cadastros/filial_page.dart';
import 'package:controls_web/controls/dialogs_widgets.dart';
import 'package:controls_web/controls/ink_button.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class FilialSearchFormField extends StatefulWidget {
  final Function(double?) onChanged;
  final double? codigo;
  final String? label;
  final dynamic Function(double?)? validator;
  final bool todas;
  const FilialSearchFormField({
    Key? key,
    required this.onChanged,
    this.codigo,
    this.label,
    this.todas = false,
    this.validator,
  }) : super(key: key);

  @override
  _SigbcoSearchFormFieldState createState() => _SigbcoSearchFormFieldState();
}

class _SigbcoSearchFormFieldState extends State<FilialSearchFormField> {
  final ValueNotifier<dynamic> notifier = ValueNotifier({});

  buscar(double? cd) {
    notifier.value = {};
    FilialItemModel().buscarByCodigo(cd).then((rsp) {
      if (rsp.isNotEmpty) {
        notifier.value = rsp;
      } else {
        notifier.value = {};
      }
      filialController.text = notifier.value['nome'] ?? '';
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

  late dynamic _dados;
  dynamic stateController;
  get codigo => _dados['codigo'];
  get nome => _dados['nome'];
  set codigo(x) => _dados['codigo'] = x;
  set nome(x) => _dados['nome'] = x;

  ValueNotifier<List> addSuggestions = ValueNotifier<List>([]);
  final TextEditingController filialController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (('${widget.codigo ?? ''}').isNotEmpty) buscar(widget.codigo);
    return /*ValueListenableBuilder(
      valueListenable: notifier,
      builder: (a, b, c) =>*/
        SearchFormField(
            minChars: 2,
            controller: filialController,
            keyStorage: 'filial_searchfield',
            nameField: 'nome',
            keyField: 'codigo',
            label: widget.label ?? 'Filial',
            initialValue: notifier.value['nome'] ?? '',
            suggestionsNotifier: addSuggestions,
            stateController: stateController,
            onFocusChanged: (b, texto) {
              double? cod = double.tryParse(texto);
              if (!b &&
                  (cod != null) &&
                  //((codigo ?? 0.0) == 0.0) &&
                  ((cod > 0) || widget.todas) &&
                  texto.isNotEmpty &&
                  texto.length <= 10) {
                FilialItemModel().buscarByCodigo(cod).then((rsp) {
                  if (rsp.isNotEmpty) {
                    codigo = rsp['codigo'] + 0.0;
                    nome = rsp['nome'];
                    widget.onChanged(codigo);
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
              widget.onChanged(v['codigo'] + 0.0);
              notifier.value = v;
              filialController.text = v['nome'] ?? '';
            },
            sufixIcon: InkButton(
                child: const Icon(Icons.clear),
                onTap: () {
                  widget.onChanged(0.0);
                  filialController.text = '';
                }),
            validator: (x) {
              if (widget.validator != null) {
                return widget.validator!(double.tryParse(x));
              }
              if (filialController.text.isEmpty) {
                return 'Não identificou a filial';
              }
              return null;
            },
            onSearch: (a) {
              late dynamic y;
              return Dialogs.showPage(context,
                  width: 450,
                  child: FilialPage(
                      title: 'Identificar a unidade',
                      canEdit: false,
                      canInsert: false,
                      todas: widget.todas,
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
              var cod = double.tryParse(x);
              String filter = '';
              if (cod != null && cod > 0) filter += ' or codigo eq $cod';
              String todas = 'codigo gt 0 and ';
              return FilialItemModel()
                  .listCached(
                      select: 'codigo,nome',
                      filter:
                          "$todas (upper(nome) like '%25$u%25' $filter or sigla eq '$u' or cidade like '%25$u%025') ")
                  .then((r) {
                if (widget.todas) r.insert(0, {'codigo': 0.0, 'nome': 'Todas'});
                return r;
              });
            } //),
            );
  }
}
