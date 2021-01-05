//import 'package:controls_data/odata_client.dart';
//import 'dart:async';

//import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:console/widgets/masked_auto_complete_text_field.dart';
import 'package:controls_data/local_storage.dart';
import 'package:controls_web/controls/dialogs_widgets.dart';
import 'package:controls_web/controls/masked_field.dart';
import 'package:controls_web/controls/responsive.dart';
import 'package:controls_web/drivers/bloc_model.dart';
import 'package:console/views/agenda/injects/agenda_default_inherited.dart';
import 'package:console/views/agenda/injects/constantes.dart';
import 'package:console/views/agenda/models/agenda_item_model.dart';
import 'package:console/views/agenda/models/contatos_model.dart';
import 'package:console/views/cadastros/clientes/cadastro_clientes.dart';
import 'package:flutter/material.dart';
import 'package:models/models/sigcad_model.dart';
import 'package:provider/provider.dart';

class ContatosBloc extends BlocModel<double> {
  static final _singleton = ContatosBloc._create();
  ContatosBloc._create();
  factory ContatosBloc() => _singleton;
}

class ContatosChanged extends ChangeNotifier {
  double value;
  ContatosChanged(this.value);

  notify(double v) {
    if (this.value != v) {
      value = v;
      notifyListeners();
    }
  }

  final proprietario = ContatoItem();
}

class ContatosFormField extends StatefulWidget {
  final AgendaItem dados;
  final Function(double) onChanged;
  final bool expanded;
  ContatosFormField(this.dados,
      {Key key, this.expanded = false, this.onChanged})
      : super(key: key);

  @override
  _AgendaEditContatosFormFieldState createState() =>
      _AgendaEditContatosFormFieldState();
}

class _AgendaEditContatosFormFieldState extends State<ContatosFormField> {
  FocusNode focusNode;
  ValueNotifier<bool> _expanded;
  @override
  void initState() {
    super.initState();
    bool v = LocalStorage().getBool('codigo_contato_expanded');
    _expanded = ValueNotifier<bool>(v ?? widget.expanded);
  }

  @override
  void dispose() {
    super.dispose();
  }

  DefaultAgendaEdit agendaEdit;
  bool carregou = true;
  ResponsiveInfo resposive;
  ValueNotifier<int> achouNaBusca = ValueNotifier<int>(-1);
  ValueNotifier<String> nomeDigitando = ValueNotifier<String>('');
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    /// atributos da agenda
    //print(['dados', widget.dados]);
    agendaEdit = DefaultAgendaEdit.of(context);
    resposive = ResponsiveInfo(context);

    /// refresh mudança do codigo
    /// dados do proprietario
    carregou = true;
    return ChangeNotifierProvider<ContatosChanged>(
        create: (c) => ContatosChanged(agendaEdit.item.sigcadCodigo),
        builder: (context, w) {
          var f = context.watch<ContatosChanged>();
          return FutureBuilder<SigcadItem>(
              future: ContatoItemModel().buscarPorCodigo(f.value),
              builder: (context, snapshot) {
                if (snapshot.hasData)
                  f.proprietario.fromMap(snapshot.data.toJson());
                widget.dados.nomeCliente = f.proprietario.nome;
                if (!carregou) ContatosBloc().notify(f.proprietario.codigo);
                carregou = false;
                return Column(
                  children: [
                    Container(
                      height: kToolbarHeight + 4,
                      child: ValueListenableBuilder(
                        valueListenable: _expanded,
                        builder: (a, b, c) => Row(
                          children: [
                            if (_expanded.value)
                              Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 5.0),
                                    child: MaskedSearchFormField<int>(
                                      onFocusChange: (b, value) {
                                        var v = value + 0.0;
                                        if (!b) if (v !=
                                            f.proprietario.codigo) {
                                          alterarCodigo(f, v + 0.0);
                                        }
                                      },
                                      initialValue:
                                          (f.proprietario.codigo ?? 0) ~/ 1,
                                      style: theme.textTheme.bodyText1,
                                      labelText: labelContatoAgenda,
                                      validator: (value) {
                                        if (identificacaoContatoObrigatorio) if ((value ??
                                                0) <=
                                            0) {
                                          return 'Informação necessária';
                                        }
                                        return null;
                                      },
                                      onChanged: (x) {
                                        /// digitando um coidgo
                                        print('onChanged $x');
                                        //if (onChanged != null) onChanged(x);
                                      },
                                      onSaved: (x) {
                                        print('onSaved: $x ');
                                        agendaEdit.item.sigcadCodigo = x + 0.0;
                                      },
                                      onSearch: () async {
                                        /// DONE: criar janela de busca

                                        var rt = await showCadastroCliente(
                                            context, f);

                                        return rt ~/ 1;

                                        /// mudou o codigo do contato;
                                      },
                                    ),
                                  )),
                            InkWell(
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: !_expanded.value
                                          ? theme.dividerColor
                                          : Colors.transparent,
                                      //borderRadius:
                                      //    BorderRadius.all(Radius.circular(8)),
                                      //border: Border.all(
                                      //    width: 1, color: theme.dividerColor),
                                    ),
                                    width: 3,
                                    height: kMinInteractiveDimension,
                                  ),
                                  Icon(
                                      _expanded.value
                                          ? Icons.arrow_left
                                          : Icons.arrow_right,
                                      size: 10)
                                ],
                              ),
                              onTap: () {
                                LocalStorage().setBool(
                                    'codigo_contato_expanded',
                                    !_expanded.value);
                                _expanded.value = !_expanded.value;
                              },
                            ),
                            Expanded(
                                flex: 2,
                                child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: MaskedAutoCompleteTextField(
                                        name: 'nome',
                                        future: (x) async {
                                          String y = x.toUpperCase();
                                          print(y);
                                          return await ContatoItemModel()
                                              .listNoCached(
                                                  select: 'codigo,nome',
                                                  top: 30,
                                                  filter:
                                                      "nome_upper like '%25$y%25'")
                                              .then((rsp) {
                                            nomeDigitando.value = x;
                                            achouNaBusca.value = rsp.length;
                                            return rsp;
                                          });
                                        },
                                        suggestions: _suggestions,
                                        onLoaded: (lst) => addSugestions(lst),
                                        onChanged: (x) {
                                          alterarCodigo(f, x['codigo'] + 0.0);
                                        },
                                        sublabel: f.proprietario.celular ?? '',
                                        initialValue:
                                            f.proprietario?.nome ?? ''))),
                            IconButton(
                                icon: Icon(Icons.search),
                                onPressed: () {
                                  _expanded.value = false;
                                  showCadastroCliente(context, f);
                                }),
                            ValueListenableBuilder<int>(
                              valueListenable: achouNaBusca,
                              builder: (BuildContext context, int value,
                                  Widget child) {
                                return (value != 0)
                                    ? Container()
                                    : IconButton(
                                        icon: Icon(Icons.add),
                                        onPressed: () {
                                          ClienteController.doNovoCadastro(
                                              context,
                                              {"nome": nomeDigitando.value},
                                              onChanged: (values) {
                                            alterarCodigo(f, values['codigo']);
                                            achouNaBusca.value = -1;
                                          });
                                          // abrir para cadastrar um novo com o nome ja inserido
                                        });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              });
        });
  }

  alterarCodigo(f, double cod) {
    agendaEdit.item.sigcadCodigo = cod;
    f.notify(agendaEdit.item.sigcadCodigo);
    if (widget.onChanged != null) widget.onChanged(cod);
  }

  showCadastroCliente(BuildContext context, f) {
    return Dialogs.showPage(context,
        child: Scaffold(
            appBar: AppBar(title: Text('Contatos')),
            body: CadastroClienteWidget(
                canChange: true,
                canInsert: true,
                top: 10,
                height: resposive.size.height * 0.90,
                //title: 'Contatos',
                onChange: (x) {
                  print('selecionado: $x');
                  agendaEdit.item.sigcadCodigo = x;
                  f.notify(x);

                  return x;
                }))).then((rsp) {
      //print('f.value ${f.value}');
      if (widget.onChanged != null) widget.onChanged(f.value);
      return f.value;
    });
  }

  addSugestions(lst) {
    if (lst != null)
      lst.forEach((item) {
        var achou = false;
        _suggestions.forEach((element) {
          if (element['nome'] == item['nome']) achou = true;
        });
        if (!achou) _suggestions.add(item);
      });
  }
}

/// listas dos ultimos cadastros que foram buscados no banco de dados.
final _suggestions = [];
