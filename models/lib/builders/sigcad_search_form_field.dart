// @dart=2.12

import 'dart:async';

import 'package:controls_web/controls/ink_button.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

import 'form_callback.dart';
import 'search_form_field.dart';

class SigcadSearchFormField extends StatefulWidget {
  final Function(double?)? onChanged;
  final TextEditingController? controller;
  final double? codigo;
  final String? label;
  final Function(BuildContext context, String value)? onInsert;
  final bool canInsert;
  final bool readOnly;
  final bool autofocus;
  final bool canClear;
  final bool obrigatorio;
  final String Function(String)? validator;
  final FormSearchCallback? onSearch;
  final FormValueCallback? onNew;
  final SuggestionController? suggestionController;

  const SigcadSearchFormField({
    Key? key,
    this.onChanged,
    this.controller,
    this.codigo,
    this.label,
    this.onInsert,
    this.obrigatorio = true,
    this.canClear = false,
    this.autofocus = false,
    this.readOnly = false,
    this.canInsert = true,
    this.validator,
    this.onSearch,
    this.onNew,
    this.suggestionController,
  }) : super(key: key);

  @override
  _SigbcoSearchFormFieldState createState() => _SigbcoSearchFormFieldState();
}

class _SigbcoSearchFormFieldState extends State<SigcadSearchFormField> {
  final ValueNotifier<dynamic> notifier = ValueNotifier({});

  buscar(double? cd) {
    notifier.value = {};
    if (cd == 0) return;
    SigcadItemModel().buscarByCodigo(cd!).then((rsp) {
      if (rsp.isNotEmpty) {
        notifier.value = rsp;
      } else {
        notifier.value = {};
      }
      _digitadoController.text = notifier.value['nome'];
      _dados = notifier.value;
      return notifier.value;
    });
  }

  ValueNotifier<List<dynamic>> addSuggestions =
      ValueNotifier<List<dynamic>>([]);
  ValueNotifier<bool> addButton = ValueNotifier<bool>(false);

  late TextEditingController _digitadoController;

  @override
  void initState() {
    _digitadoController = widget.controller ?? TextEditingController();
    super.initState();
    _dados = {};
    stateController = SearchFormFieldController();
  }

  late dynamic _dados;
  late dynamic stateController;
  get codigo => _dados['codigo'];
  get nome => _dados['nome'];
  set codigo(x) => _dados['codigo'] = x;
  set nome(x) => _dados['nome'] = x;

  @override
  Widget build(BuildContext context) {
    if (('${widget.codigo ?? ''}').isNotEmpty) buscar(widget.codigo);
    return /*ValueListenableBuilder(
      valueListenable: notifier,
      builder: (a, b, c) => Container(
        child:*/
        Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: SearchFormField(
              controller: _digitadoController,
              minChars: 2,
              keyStorage: 'sigcad_searchfield',
              nameField: 'nome',
              keyField: 'codigo',
              label: widget.label ?? 'Parceiro',
              initialValue: notifier.value['nome'] ?? '',
              suggestionsNotifier: addSuggestions,
              // controller
              suggestionController: widget.suggestionController,
              onFocusChanged: (b, texto) {
                double? cod = double.tryParse(texto);
                if (!b &&
                    (cod != null) &&
                    //((codigo ?? 0.0) == 0.0) &&
                    ((cod > 0)) &&
                    texto.isNotEmpty &&
                    texto.length <= 10) {
                  SigcadItemModel().buscarByCodigo(cod).then((rsp) {
                    if (rsp.isNotEmpty) {
                      codigo = rsp['codigo'] + 0.0;
                      nome = rsp['nome'];
                      if (widget.onChanged != null) widget.onChanged!(codigo);
                      Timer(const Duration(milliseconds: 500), () {
                        stateController.closeOverlay(nome);
                      });
                    } else {
                      stateController.closeOverlay('');
                    }
                  });
                }
              },
              readOnly: widget.readOnly,
              autofocus: widget.autofocus,
              validator: (x) {
                if (widget.validator != null) return widget.validator!(x);
                if (x.isEmpty && widget.obrigatorio) {
                  return 'Falta indentificação';
                }
                return null;
              },
              sufixIcon: (widget.canClear && !widget.readOnly)
                  ? InkButton(
                      child: const Icon(Icons.clear),
                      onTap: () {
                        if (widget.onChanged != null) widget.onChanged!(0.0);
                        notifier.value = 0;
                        _digitadoController.text = '';
                      })
                  : null,
              onChanged: (v) {
                if (widget.onChanged != null)
                  widget.onChanged!(v['codigo'] + 0.0);
                notifier.value = v;
                _digitadoController.text = v['nome'] ?? '';
              },
              onSearch: widget.readOnly || widget.onSearch == null
                  ? null
                  : (a) {
                      return widget.onSearch!(context).then((r) {
                        addSuggestions.value = [r];
                        return r['codigo'];
                      });
                      /* Map<String, dynamic>? y;
                      return Dialogs.showPage(context,
                          child: CadastroClientePage(
                              title: widget.label ?? 'Parceiros',
                              //canEdit: widget.canInsert,
                              canInsert: widget.canInsert,
                              //todas: false,
                              onLoaded: (rows) {
                                addSuggestions.value = rows;
                              },
                              onSelected: (x) async {
                                y = x;
                                return x['codigo'];
                              })).then((rsp) {
                        return y;
                      });*/
                    },
              future: (x) {
                var u = x.toUpperCase();
                var cod = double.tryParse(x);
                String filter = '';
                if (cod != null && cod > 0) {
                  filter += " or cnpj eq $cod or cep eq '$cod' ";
                }
                return SigcadItemModel()
                    .listCached(
                        select: 'codigo,nome, cnpj,cep,cidade',
                        filter:
                            "upper(nome) like '%25$u%25' $filter or fone eq '$u' or upper(cidade) like '%25$u%025' ")
                    .then((r) {
                  addButton.value = r.isEmpty;
                  return r.isEmpty ? [] : r;
                });
              }),
        ),
        ValueListenableBuilder(
          valueListenable: addButton,
          builder: (a, dynamic btn, c) =>
              (btn && (widget.canInsert || (widget.onInsert != null)))
                  ? InkButton(
                      child: const Icon(Icons.add),
                      onTap: () {
                        if (widget.onInsert != null) {
                          widget.onInsert!(context, _digitadoController.text);
                        } else {
                          if (widget.onNew != null)
                            widget.onNew!(
                                    context, {"nome": _digitadoController.text})
                                .then((row) {
                              buscar(row['codigo']);
                              if (widget.onChanged != null)
                                widget.onChanged!(row['codigo']);
                            });
                          /*ClienteController.doNovoCadastro(
                              context, {"nome": _digitadoController.text},
                              onChanged: (row) {
                            widget.onChanged(row['codigo']);
                            buscar(row['codigo']);
                          });*/
                        }
                      },
                    )
                  : Container(),
        )
      ],
//        ),
      //    ),
    );
  }
}
