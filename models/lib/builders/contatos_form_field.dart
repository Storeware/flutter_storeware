import 'package:controls_data/odata_client.dart';
import 'package:controls_web/controls/dialogs_widgets.dart';
import 'package:controls_web/controls/masked_field.dart';
import 'package:controls_web/controls/responsive.dart';
import 'package:controls_web/drivers/bloc_model.dart';
import 'package:console/views/agenda/injects/agenda_default_inherited.dart';
import 'package:console/views/agenda/injects/constantes.dart';
import 'package:console/views/agenda/models/agenda_item_model.dart';
import 'package:console/views/agenda/models/contatos_model.dart';
import 'package:console/views/cadastros/cadastro_clientes.dart';
import 'package:flutter/material.dart';
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
  ContatosFormField(this.dados, {Key key, this.onChanged}) : super(key: key);

  @override
  _AgendaEditContatosFormFieldState createState() =>
      _AgendaEditContatosFormFieldState();
}

class _AgendaEditContatosFormFieldState extends State<ContatosFormField> {
  FocusNode focusNode;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  DefaultAgendaEdit agendaEdit;
  bool carregou = true;
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    /// atributos da agenda
    //print(['dados', widget.dados]);
    agendaEdit = DefaultAgendaEdit.of(context);
    ResponsiveInfo resposive = ResponsiveInfo(context);

    /// refresh mudança do codigo
    /// dados do proprietario
    carregou = true;
    return ChangeNotifierProvider<ContatosChanged>(
        create: (c) => ContatosChanged(agendaEdit.item.sigcadCodigo),
        builder: (context, w) {
          var f = context.watch<ContatosChanged>();
          return FutureBuilder<ODataDocument>(
              future: ContatoItemModel().buscarPorCodigo(f.value),
              builder: (context, snapshot) {
                if (snapshot.hasData)
                  f.proprietario.fromMap(snapshot.data.data());
                widget.dados.nomeCliente = f.proprietario.nome;
                if (!carregou) ContatosBloc().notify(f.proprietario.codigo);
                carregou = false;
                return Column(
                  children: [
                    Container(
                      height: kToolbarHeight + 4,
                      child: Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: MaskedSearchFormField<int>(
                                onFocusChange: (b, value) {
                                  var v = value + 0.0;
                                  if (!b) if (v != f.proprietario.codigo) {
                                    agendaEdit.item.sigcadCodigo = v + 0.0;
                                    f.notify(v + 0.0);
                                    if (widget.onChanged != null)
                                      widget.onChanged(v + 0.0);
                                  }
                                },
                                initialValue: (f.proprietario.codigo ?? 0) ~/ 1,
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

                                  return await Dialogs.showPage(context,
                                      child: Scaffold(
                                          appBar:
                                              AppBar(title: Text('Contatos')),
                                          body: CadastroClienteWidget(
                                              canChange: true,
                                              canInsert: true,
                                              top: 10,
                                              height:
                                                  resposive.size.height * 0.90,
                                              //title: 'Contatos',
                                              onChange: (x) {
                                                print('selecionado: $x');
                                                agendaEdit.item.sigcadCodigo =
                                                    x;
                                                f.notify(x);

                                                return x;
                                              }))).then((rsp) {
                                    print('f.value ${f.value}');
                                    if (widget.onChanged != null)
                                      widget.onChanged(f.value);
                                    return f.value;
                                  });

                                  /// mudou o codigo do contato;
                                },
                              )),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: MaskedLabeled(
                                label: 'Nome',
                                sublabel: f.proprietario.celular ?? '',
                                value: f.proprietario?.nome ?? '',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              });
        });
  }
}
