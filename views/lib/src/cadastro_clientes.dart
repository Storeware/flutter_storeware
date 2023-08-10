// @dart=2.12

//import 'package:console/builders/estados_builder.dart';
//import 'package:console/comum/cep.dart';
import 'cep.dart';
import 'package:flutter_storeware/login.dart';
import 'package:models/builders.dart';
import 'package:models/models.dart';
import 'package:controls_data/local_storage.dart';
import 'package:controls_extensions/validadores.dart';
import 'package:controls_web/controls.dart';
import 'package:controls_web/drivers/bloc_model.dart';
import 'package:flutter/material.dart';
import 'package:controls_extensions/extensions.dart';
import 'package:controls_login/src/config.dart';

import 'tab_view.dart';

// ignore: non_constant_identifier_names, constant_identifier_names
const storage_cliente_ultimo_estado = 'storage_cliente_ultimo_estado';

class CadastroClientePage extends StatefulWidget {
  final double? codigo;
  final double? height;
  final Color? backgoundColor;
  final int top;
  final int page;
  final String? title;
  final String? tipo;
  final bool canInsert;
  final bool canEdit;
  final bool canDelete, canSearch, showPageNavigatorButtons;
  final Function(double?)? onChange;
  final double elevation;
  final CrossAxisAlignment crossAxisAlignment;
  final Alignment alignment;
  final Function(dynamic)? onSelected;
  final Function(List)? onLoaded;
  const CadastroClientePage(
      {Key? key,
      this.codigo,
      this.title,
      this.tipo,
      this.height,
      this.backgoundColor,
      this.elevation = 0,
      this.top = 5,
      this.onChange,
      this.alignment = Alignment.topCenter,
      this.canSearch = true,
      this.showPageNavigatorButtons = true,
      this.crossAxisAlignment = CrossAxisAlignment.center,
      this.page = 1,
      this.onSelected,
      this.onLoaded,
      this.canInsert = false,
      this.canEdit = false,
      this.canDelete = false})
      : super(key: key);

  static menuItem(BuildContext context, {bool small = false, String? title}) =>
      [
        TabChoice(
            label: small ? 'Contatos' : 'Contatos',
            builder: () => TabViewScaffold(
                title: (title == null) ? null : Text(title),
                body: const CadastroClientePage(
                  top: 20,
                  height: double.maxFinite,
                  //backgoundColor: Colors.white,
                  //title: 'Contatos',
                  canEdit: true,
                  canInsert: true,
                  elevation: 0,
                ))),
      ];

  @override
  _CadastroClientePageState createState() => _CadastroClientePageState();

  static editDialog(BuildContext context, {required double? codigo}) {
    assert(codigo != null, 'Não passou o codigo da pessoa para edição');
    DataViewerController? controller;
    return SigcadItemModel().buscarByCodigo(codigo).then((rsp) {
      return ClienteController.doEditItem(
          context,
          controller ??= ClienteController().createController(context),
          rsp,
          PaginatedGridChangeEvent.update);
    });
  }

  static editDialogDados(BuildContext context,
      {required Map<String, dynamic> dados}) {
    DataViewerController? controller;
    return SigcadItemModel()
        .buscarByCodigo(toDouble(dados['codigo']))
        .then((rsp) {
      rsp.forEach((key, value) {
        dados[key] = value;
      });
      return Dialogs.showPage(context,
              child: ClienteController.editItem(
                  controller: controller ??=
                      ClienteController().createController(context),
                  dados: dados,
                  event: PaginatedGridChangeEvent.update))
          .then((rsp) {
        return rsp;
      });
    });
  }

  static Widget edit(BuildContext context, {required double? codigo}) {
    assert(codigo != null, 'Não passou o codigo da pessoa para edição');
    DataViewerController? controller;
    return FutureBuilder<dynamic>(
        future: SigcadItemModel().buscarByCodigo(codigo),
        builder: (_, rsp) {
          if (!rsp.hasData) return Container();
          return ClienteController.editItem(
              controller: controller ??=
                  ClienteController().createController(context),
              dados: rsp.data,
              event: PaginatedGridChangeEvent.update);
        });
  }
}

withDo(item, Function(dynamic) fn) {
  if (item != null) fn(item);
}

class _CadastroClientePageState extends State<CadastroClientePage> {
  int? top;
  //int page;
  int conta = 0;
  ClienteController? clienteController;

  @override
  void initState() {
    super.initState();
    top = widget.top;
  }

  final usuario = configInstance!.usuario;

  pageChange(pg) {
    clienteController!.page = pg;
    pageChanged.notify(conta++);
  }

  BlocModel<int> pageChanged = BlocModel<int>();

  DataViewerController? get controller => clienteController!.controller;

  final TextEditingController _filtroController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (clienteController == null) {
      clienteController = ClienteController();
      clienteController!.page = widget.page;
      clienteController!.createController(context);
    }
    if (widget.codigo != null) clienteController!.filterCodigo = widget.codigo;

    return Scaffold(
      appBar: (widget.title == null)
          ? null
          : AppBar(
              title: Text(widget.title!),
            ),
      body: StreamBuilder(
          stream: pageChanged.stream,
          builder: (context, snapshot) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: widget.alignment,
                child: DataViewer(
                  elevation: widget.elevation,
                  controller: controller,
                  crossAxisAlignment: widget.crossAxisAlignment,
                  headerHeight: 95,
                  onSelected: (item) {
                    if (widget.onSelected != null) {
                      widget.onSelected!(item);
                      Navigator.pop(context);
                    } else {
                      if (widget.onChange != null) {
                        widget.onChange!(toDouble(item['codigo']));
                        Navigator.pop(context);
                      } else {
                        if (widget.canEdit) {
                          ClienteController.doEditItem(context, controller,
                              item, PaginatedGridChangeEvent.update);
                        }
                      }
                    }
                  },
                  onEditItem: (ctrl) => ClienteController.doEditItem(context,
                      controller, ctrl.data!, PaginatedGridChangeEvent.update),
                  onInsertItem: (ctrl) => ClienteController.doNovoCadastro(
                      context, ctrl.data, onChanged: (x) {
                    if (widget.onChange != null) widget.onChange!(x['codigo']);
                    if (widget.onSelected != null) {
                      widget.onSelected!(x);
                      Navigator.pop(context);
                    }
                  }),
                  header: (!widget.canSearch)
                      ? null
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //if (widget.title != null) Text(widget.title),
                            Form(
                              child: Container(
                                height: 60,
                                alignment: Alignment.center,
                                child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      SizedBox(
                                        width: 200,
                                        height: 56,
                                        child: TextFormField(
                                            //initialValue: filtro,
                                            controller: _filtroController,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontStyle: FontStyle.normal),
                                            decoration: InputDecoration(
                                                //border: InputBorder.none,
                                                labelText: 'procurar por',
                                                suffixIcon: InkWell(
                                                    child: const Icon(
                                                        Icons.delete),
                                                    onTap: () {
                                                      _filtroController.text =
                                                          '';
                                                    })),
                                            onChanged: (x) {
                                              controller!.filter = x;
                                            }),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 10),
                                        // height: 51,
                                        // width: 100,
                                        child: StrapButton(
                                            type: StrapButtonType.light,
                                            text: 'abrir',
                                            onPressed: () {
                                              controller!.page = 1;
                                              pageChanged.notify(conta++);
                                            }),
                                      )
                                    ]),
                              ),
                            ),
                          ],
                        ),
                  headingRowHeight: 30,
                  dataRowHeight: 45,
                  //rowsPerPage: top,
                  canEdit: widget.canEdit,
                  canInsert: widget.canInsert,
                  canDelete: widget.canDelete,
                  canSearch: widget.canSearch,
                  showPageNavigatorButtons: widget.showPageNavigatorButtons,
                ),
              ),
            );
          } //),
          ),
    );
  }
}

//ValueNotifier<bool>? _pessoaFisicaNotifier;

class ClienteController {
  double? filterCodigo;
  final bool canChange;
  final Function(List)? onLoaded;
  ClienteController({
    this.canChange = true,
    this.text,
    this.top,
    this.onLoaded,
    this.onChange,
    this.filterCodigo,
  });
  //DataViewerEditGroupedPage
  static DataViewerEditGroupedPage editItem(
      {DataViewerController? controller,
      PaginatedGridChangeEvent event = PaginatedGridChangeEvent.update,
      required Map<String, dynamic> dados}) {
    var defaultValueStrs = [
      'nome',
      'celular',
      'fone',
      'email',
      'cnpj',
      'cep',
      'ender',
      'bairro',
      'cidade',
      'estado',
      'compl'
    ];
    for (var key in defaultValueStrs) dados[key] ??= '';

    //return Text('OK');
    return DataViewerEditGroupedPage(
      data: dados,
      //actions: [],
      margin: 0,
      canEdit: true,
      canInsert: true,
      canDelete: false,
      subtitle: 'Cadastro de pessoas',
      grouped: [
        DataViewerGroup(
          title: 'Identificação',
          children: ['nome', 'fone', 'celular', 'email'], /* nome */
        ),
        DataViewerGroup(
          initiallyExpanded: true,
          // height: 73,
          children: ['cnpj'],
        ),
        DataViewerGroup(
            title: 'Endereço',
            children: ['cep', 'ender', 'bairro', 'cidade', 'estado', 'compl'])
      ],
      controller: controller,
      event: event,
    );
  }

  static doEditItem(BuildContext context, DataViewerController? controller,
      Map<String, dynamic> dados, PaginatedGridChangeEvent event) async {
    var responsive = ResponsiveInfo(context);

    return Dialogs.showPage(context,
            fullPage: responsive.isMobile,
            height: 600,
            width: responsive.size.width > 650 ? 650.0 : null,
            child: editItem(controller: controller, dados: dados, event: event))
        .then((rsp) => true);
  }

  static doNovoCadastro(BuildContext context, Map<String, dynamic>? dados,
      {Function(dynamic)? onChanged, Function(List)? onLoaded}) {
    final c = ClienteController(onLoaded: onLoaded)..createController(context);

    // obter o proximo numero
    SigcadItemModel().proximoCodigo(configInstance!.filial).then((rsp) {
      dados!['codigo'] = rsp;
      /* ['nome', 'ender', 'cidade'].forEach((item) {
        dados[item] ??= '';
      });*/
      ClienteController.doEditItem(
              context, c.controller, dados, PaginatedGridChangeEvent.insert)
          .then((rsp) {
        if (onChanged != null) onChanged(dados);
      }); //
    });
  }

  DataViewerController? controller;
  String formatCEP(String cep) {
    cep = cep.cleanString().padLeft(8, '0');
    return cep.substring(0, 5) + '-' + cep.substring(5, 8);
  }

  _buscarCEP(Map<String, dynamic> r) async {
    r['cep'] = formatCEP(r['cep']);
    dynamic json = null;
    try {
      json = await CEP.buscar(r['cep']);
    } catch (err) {
      return;
    }
    var rsp = CEPItem.fromJson(json);
    r['cidade'] = rsp.cidade;
    r['estado'] = rsp.estado;
    r['bairro'] = rsp.bairro;
    r['ender'] = rsp.logradouro;
    cepChanged.value = formatCEP(rsp.cep!);
    return r;
  }

  ValueNotifier<String> cepChanged = ValueNotifier<String>('');

//  static get pessoaFisicaNotifier => _pessoaFisicaNotifier ??=
//      ValueNotifier<bool>(LocalStorage().getBool('pessoaFisica'));

  _buildColumn(context) {
    //ResponsiveInfo responsive = ResponsiveInfo(context);
    return [
      DataViewerColumn(
          editWidth: 100,
          width: 100,
          name: 'codigo',
          readOnly: true,
          visible: false),
      DataViewerColumn(
          name: 'nome',
          width: 250,
          editWidth: 350,
          onGetValue: (x) => (configInstance!.isDemo && x != null)
              ? (x).substring(0, ((x).length > 20) ? 20 : x.length)
              : x),
      DataViewerColumn(
          name: 'celular',
          width: 120,
          editWidth: 120,
          onGetValue: (x) => configInstance!.isDemo ? 'xxxxxxxx' : x),
      DataViewerColumn(
          name: 'cep',
          width: 100,
          editWidth: 100,
          editBuilder: (a, b, _, dados) {
            cepChanged.value = dados['cep'] ?? '';
            return MaskedTextField(
              label: 'CEP',
              mask: '00000-000',
              initialValue: dados['cep'] ?? '',
              onChanged: (x) {
                dados['cep'] = x;
              },
              onFocusChange: (x) {
                // ignore: curly_braces_in_flow_control_structures
                if (!x) if (dados['cep'].toString().isNotEmpty) {
                  if (dados['cep'] != cepChanged.value ||
                      dados['cidade'].toString().isEmpty) {
                    _buscarCEP(dados);
                    controller!.invalidate();
                  }
                }
              },
            );
          },
          onGetValue: (x) => configInstance!.isDemo ? 'xxxxxxxx' : x),
      DataViewerColumn(
          name: 'cnpj',
          label: 'CPF/CNPJ',
          editWidth: 450,
          width: 120,
          editHeight: 80,
          editBuilder: (a, b, c, row) {
            return TextFieldCNPJxCPFxIE(
                dados: row,
                onChanged: (x) {
                  controller!.invalidate();
                });
          }),
      DataViewerColumn(
        name: 'ie',
        label: 'RG/IE',
        width: 120,
        visible: false,
      ),
      DataViewerColumn(
        name: 'cidade',
        label: 'Cidade',
        editWidth: 250,
        width: 120,
        minLength: 2,
        maxLength: 25,
        /*editBuilder: (a, b, dados, d) {
            return ValueListenableBuilder<String>(
                valueListenable: cepChanged,
                builder: (a, b, c) => MaskedTextField(
                      label: 'Cidade',
                      initialValue: dados['cidade'],
                      onChanged: (x) {
                        dados['cidade'] = x;
                      },
                    ));
          }*/
      ),
      DataViewerColumn(
          name: 'estado',
          label: 'UF',
          editWidth: 350,
          width: 30,
          editBuilder: (a, b, c, d) {
            return SizedBox(
              width: 300,
              child: EstadosFormField(
                value: ((d['estado'] ?? '').length > 0)
                    ? d['estado']
                    : LocalStorage().getKey(storage_cliente_ultimo_estado),
                onChanged: (sigla) {
                  LocalStorage().setKey(storage_cliente_ultimo_estado, sigla);
                  return d['estado'] = sigla;
                },
              ),
            );
          }),
      DataViewerColumn(name: 'bairro', width: 150, visible: false),
      DataViewerColumn(
          name: 'ender',
          label: 'Endereço',
          editWidth: 350,
          width: 120,
          onGetValue: (x) => configInstance!.isDemo ? 'xxxxxxxx' : x),
      DataViewerColumn(name: 'numero'),
      DataViewerColumn(
          name: 'email',
          width: 120,
          editWidth: 300,
          onGetValue: (x) => configInstance!.isDemo ? 'xxxxxxxx' : x),
      if (canChange)
        DataViewerColumn(
            name: 'alterar',
            label: '',
            // onEditIconPressed: () {
            //   Dialogs.info(context, text: 'onEditIconPressed');
            // },
            isVirtual: true,
            builder: (x, y) {
              return IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  ClienteController.doEditItem(
                      context, controller, y, PaginatedGridChangeEvent.update);
                  /*controller!.edit(context, y,
                      title: 'Alteração',
                      width: 650,
                      height: responsive.size.height * 0.9,
                      event: PaginatedGridChangeEvent.update);*/
                },
              );
            }),
      DataViewerColumn(name: 'fone', visible: false, width: 120),
      DataViewerColumn(
        name: 'compl',
        visible: false,
        editWidth: 350,
      ),
    ];
  }

  int page = 1;
  String? tipo;
  Future<List> getSource() async {
    text = controller!.filter;
    String filtro = getFiltro() ?? '';
    page = 1;
    if (tipo != null) {
      filtro += ((filtro != '') ? ' and ' : '') + "  tipo eq '$tipo'";
    }
    // print('Filtro: $filtro');
    return SigcadItemModel()
        .listRows(
            select:
                'codigo,nome,celular,cep,cidade,estado,bairro,ender,numero,email,fone,compl,cnpj,ie',
            filter: (filtro != '') ? " $filtro  " : null,
            top: (text != '') ? 100 : controller!.top,
            skip: (text != '') ? 0 : controller!.skip,
            orderBy: (filtro != '') ? 'nome' : 'data desc')
        .then((rsp) {
      var r = rsp.asMap();

      if (onLoaded != null) onLoaded!(r);
      return r;
    });
  }

  ehNumero(t) {
    if (t == null) return false;
    return double.tryParse(t) != null;
  }

  getFiltro() {
    String s = (text ?? '').replaceAll('%', '%25').replaceAll('+', '%25');
    String sUpper = s.toUpperCase();
    String rsp = '';
    if (s != '') {
      rsp =
          " ( upper(nome) like '%25$sUpper%25') or (ender like '%25$s%25') or (bairro eq '$s%25') or cep = '$s'  ";
    }
    bool b = ehNumero(text);
    if (b) {
      rsp =
          "(codigo = $text or  fone like '$s%25' or  celular like '$s%25' or cnpj like '$s%25') or cep like '$s%25'   ";
    }

    if (filterCodigo != null) {
      rsp += ((rsp != '') ? ' and ' : '') + 'codigo eq $filterCodigo';
    }
    return rsp;
  }

  gravarLog(old, novo) {
    var s = '';
    var tit = 'Alteração contato';
    if (old.length == 0) {
      s = '';
      tit = 'Novo contato';
    } else {
      s += '';
      novo.forEach((k, v) {
        if (old[k] != null && old[k] != v) {
          if (s != '') s += ', ';
          s += '$k';
        }
      });
      if (s != '') s = 'Alterado: ' + s;
    }
    s += ' contato:  ${novo['nome']}';

    final double d = toDouble(novo['codigo']);
    HistoricoItemModel.registerLGPD(
      codigoPessoa: d,
      usuario: configInstance!.usuario,
      titulo: tit,
      info: s,
      origem: 'SIGCAD',
      origemId: d,
    );
  }

  DataViewerController createController(context) {
    return controller ??= DataViewerController(
      onLog: (old, row) => gravarLog(old, row),
      onValidate: (x) {
        x['filial'] ??= ((ConsoleConfig.instance.filial ?? 1) + 0.0);
        var r = SigcadItem.fromJson(x).toJson();

        if ((r['cep'] ?? '').length >= 8 && ((r['cidade'] ?? '').length == 0)) {
          return _buscarCEP(r).then((c) {
            return r;
          });
        }
        return r;
      },
      onChanged: (item) {
        // print(item);
        if (onChange != null) {
          onChange!(item['codigo']);
          Navigator.pop(context);
        }
      },
      dataSource: SigcadItemModel(),
      //..filial = (ConsoleConfig.instance.filial ?? 1) + 0.0,
      future: () => getSource(),
      keyName: 'codigo',
      top: top,
      columns: _buildColumn(context),
    );
    //return controller;
  }

  int? top = 10;
  final Function(dynamic)? onChange;
  String? text;
}

class TextFieldCNPJxCPFxIE extends StatefulWidget {
  final Map<String, dynamic> dados;
  final Function(dynamic dados)? onChanged;

  const TextFieldCNPJxCPFxIE({
    Key? key,
    this.onChanged,
    required this.dados,
  }) : super(key: key);

  @override
  State<TextFieldCNPJxCPFxIE> createState() => _TextFieldCNPJxCPFxIEState();
}

class _TextFieldCNPJxCPFxIEState extends State<TextFieldCNPJxCPFxIE> {
  late ValueNotifier<bool> pessoaFisica;

  @override
  void initState() {
    super.initState();
    pessoaFisica = ValueNotifier<bool>(true);
  }

  mudou() {
    if (widget.onChanged != null) widget.onChanged!(widget.dados);
  }

  @override
  Widget build(BuildContext context) {
    String cnpj = (widget.dados['cnpj'] ?? '');

    if (cnpj.cleanString('1234567890').length > 11) pessoaFisica.value = false;
    return SizedBox(
      height: 100,
      child: ValueListenableBuilder<bool>(
        valueListenable: pessoaFisica,
        builder: (a, b, c) {
          return Stack(
            children: [
              Positioned(
                top: -10,
                right: 0,
                child: RadioGrouped(
                  direction: Axis.horizontal,
                  selected: (b) ? 0 : 1,
                  children: const ['Pessoa Física', 'Pessoa Jurídica'],
                  onChanged: (x) {
                    pessoaFisica.value = x == 0;
                  },
                ),
              ),
              Positioned(
                top: 20,
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const SizedBox(width: 30),
                  if (b)
                    SizedBox(
                        height: 50,
                        width: 150,
                        child: MaskedTextFieldBr.cpf(
                            key: const ValueKey('cpf'),
                            initialValue: widget.dados['cnpj'],
                            validator: (x) {
                              if (x.isNotEmpty) {
                                var s = validarCPF(x);
                                if (s != '') return s;
                              }
                              return null;
                            },
                            onChanged: (x) {
                              widget.dados['cnpj'] = x;
                              mudou();
                            })),
                  if (!b)
                    SizedBox(
                        height: 50,
                        width: 180,
                        child: MaskedTextFieldBr.cnpj(
                            key: const ValueKey('cnpj'),
                            initialValue: widget.dados['cnpj'],
                            validator: (x) {
                              if (x.isNotEmpty) {
                                var s = validarCNPJ(x);
                                if (s != '') return s;
                              }
                              return null;
                            },
                            onChanged: (x) {
                              widget.dados['cnpj'] = x;
                              mudou();
                            })),
                  const SizedBox(width: 8),
                  SizedBox(
                      height: 50,
                      width: 150,
                      child: MaskedTextField(
                          key: const ValueKey('ie'),
                          initialValue: widget.dados['ie'],
                          label: b ? 'RG' : 'IE',
                          validator: (x) => null,
                          onChanged: (x) {
                            widget.dados['ie'] = x;
                            mudou();
                          })),
                ]),
              ),
            ],
          );
        },
      ),
    );
  }
}
