// @dart=2.12

import 'package:console/views/os/os_controller.dart';
import 'package:console/views/os/os_view.dart';
import 'package:console/widgets/share_social_message.dart';
import 'package:controls_web/controls/date_time_picker_form.dart';
import 'package:controls_web/controls/dialogs_widgets.dart';
import 'package:controls_web/controls/injects.dart';
import 'package:controls_web/controls/masked_field.dart';
import 'package:controls_web/controls/strap_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_storeware/index.dart';
import 'package:flutter_storeware/login.dart';
import 'package:get/get.dart';
import 'package:models/models.dart';

import 'agenda_controller.dart';
import 'agenda_excluir_item.dart';
import 'agenda_replicar_widget.dart';
import 'agenda_resource.dart';
import 'builders/agenda_estado_builder.dart';
import 'builders/agenda_recursos_builder.dart';
import 'builders/agenda_tipo_builder.dart';
import 'injects/agenda_default_inherited.dart';

import 'models/agenda_estado_model.dart';
import 'models/agenda_item_model.dart';
import 'injects/constantes.dart' as cnt;
import 'models/agenda_model.dart';
import 'models/agenda_recurso_model.dart';
import 'models/agenda_tipo_model.dart';
import 'package:controls_data/odata_client.dart';

import 'models/contatos_model.dart';

class AgendaEdit extends StatefulWidget {
  final AgendaData? data;
  final AgendaItem? item;
  final String? title;
  final AgendaPostEvent? event;
  final Function(AgendaItem?)? onSaved;
  final Widget? header;
  final Widget? extendBuilder;
  final Widget? bottom;
  final int? interval;
  final bool canDelete;
  final AgendaController? controller;
  const AgendaEdit({
    Key? key,
    this.data,
    this.title,
    this.event,
    required this.controller,
    this.extendBuilder,
    this.item,
    this.onSaved,
    this.interval,
    this.header,
    this.bottom,
    this.canDelete = false,
  }) : super(key: key);

  @override
  _AgendaEditState createState() => _AgendaEditState();
}

class _AgendaEditState extends State<AgendaEdit> {
  final _formKey = GlobalKey<FormState>();

  late bool repReplicar;

  int? repDias;

  late int repVezes;
  late ValueNotifier<double> progress;

  @override
  void initState() {
    super.initState();
    repReplicar = false;
    repDias = 1;
    repVezes = 1;
    progress = ValueNotifier<double>(0);
    recarregarDados = false;
  }

  AgendaItem? _item;
  late bool recarregarDados;
  @override
  Widget build(BuildContext context) {
    /// preparar horarios de inico e fim do evento
    final DateTime dataRef = widget.data!.date ?? DateTime.now();
    final int hora = widget.data!.hour!.toInt();
    final int minutos = ((widget.data!.hour! - hora) * 60).toInt();

    /// hora de inicio do evento agenda
    DateTime d = DateTime(dataRef.year, dataRef.month, dataRef.day)
        .add(Duration(hours: hora, minutes: minutos));

    AgendaController? controller = widget.data!.controller;

    int? resourceIntervalo; // DONE: pegar do resource quando foi indicado
    if (widget.data!.resource != null) {
      // procura o resource
      AgendaResource? resourceObj =
          controller!.resourceFind(widget.data!.resource);
      if ((resourceObj?.intervalo ?? 0) > 0) {
        resourceIntervalo = resourceObj!.intervalo ~/ 1;
      }
    }

    /// hora de fim do evento
    DateTime f = d.add(Duration(
        minutes: widget.interval ?? // passou como parametro na chamada
            resourceIntervalo ?? // o recurso tem intervalo
            widget.data!.controller!
                .defaultDuracaoAgenda // pega o default da agenda
        ));

    _item = (widget.event == AgendaPostEvent.insert || widget.item == null)
        ? AgendaItem(
            datainicio: d, datafim: f, recursoGid: widget.data!.resource)
        : widget.item;

    /// pega evento ou cria um novo

    var injects = InjectBuilder.of(context)!;

    /// inject dependencias na  edição da agenda
    var injectAgendaEditHeader = injects[cnt.injectAgendaEditHeader];
    var injectAgendaEditPosTitulo = injects[cnt.injectAgendaEditPosTitulo];
    var injectAgendaEditBottom = injects[cnt.injectAgendaEditBottom];
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? 'Edit'),
        actions: [
          if (widget.canDelete)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                String? gid = widget.item!.gid;
                AgendaDialogs.excluirItem(widget.data?.parentContext ?? context,
                        controller, widget.item!)
                    .then((rsp) {
                  widget.data!.sources!.delete(gid);
                });
                Navigator.of(context).pop();
              },
            ),
          if (configInstance!.configuracao.ativarOrdemServico)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: OutlinedButton(
                    //color: ,
                    child: const Text('\$\$\$',
                        style: TextStyle(color: Colors.white)),
                    //width: 120,
                    //image: Icon(Icons.money),
                    //height: 30,
                    //type: StrapButtonType.warning,
                    onPressed: () {
                      gerarVenda(context, injects, _item!);
                    },
                  ),
                ),
              ],
            ),
          if (canShare)
            IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  compartilharAgenda(_item!);
                }),
          if (isShareWeb && ((_item?.sigcadCodigo ?? 0) > 0))
            FutureBuilder<SigcadItem>(
                future: ContatoItemModel()
                    .buscarPorCodigo(_item!.sigcadCodigo)
                    .then((rsp) => rsp),
                builder: (a, AsyncSnapshot<SigcadItem> b) {
                  if (!b.hasData) return Container();
                  return ShareWhatsAppWebButton(
                    fone: b.data?.celular ?? '',
                    builder: () => generateTextoSharable(_item!),
                  );
                }),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: DefaultAgendaEdit(
            widget: this,
            item: _item,
            dataRef: dataRef,
            child: Form(
                key: _formKey,
                child: Column(children: [
                  if (widget.header != null) widget.header!,

                  /// mostra dados do contato
                  if (injectAgendaEditHeader != null)
                    injectAgendaEditHeader.builder!(context, _item),

                  /// mostra resources
                  if ((_item!.recursoGid == null) ||
                      widget.data!.mostrarResource ||
                      [AgendaViewerType.semanal, AgendaViewerType.mensal]
                          .contains(controller!.viewerNotifier.viewer))
                    AgendaResourceBuilder.createDropDownFormField(
                        context, _item!.recursoGid, onChanged: (gid) {
                      if (_item!.recursoGid != gid) recarregarDados = true;
                      _item!.recursoGid = gid;
                    }),

                  /// classifica a agenda por tipo   (tipo agenda)
                  AgendaTipoBuilder.createDropDownFormField(
                    context,
                    _item!.tipoGid,
                    onChanged: (gid) {
                      // print(gid);
                      _item!.tipoGid = gid;
                    },
                  ),

                  /// identifica o que ser feito na execução da agenda.
                  TextFormField(
                      initialValue: _item!.titulo,
                      style: const TextStyle(
                          fontSize: 16, fontStyle: FontStyle.normal),
                      decoration: const InputDecoration(
                        labelText: 'O quê será feito ?',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'titulo';
                        }
                        return null;
                      },
                      onSaved: (x) {
                        // alterado = true;
                        _item!.titulo = x;
                      }),

                  /// injeta informações adicionais do tipo de aplicação que esta rodando
                  if (injectAgendaEditPosTitulo != null)
                    injectAgendaEditPosTitulo.builder!(context, _item),

                  /// dados de, ate
                  buildDatas(_item!),

                  /// builder injetado pelo chamador
                  if (widget.extendBuilder != null) widget.extendBuilder!,

                  /// Local de execução do serviço
                  TextFormField(
                      initialValue: _item!.local,
                      style: const TextStyle(
                          fontSize: 16, fontStyle: FontStyle.normal),
                      decoration: const InputDecoration(
                        labelText: 'Local do serviço',
                      ),
                      onSaved: (x) {
                        //alterado = true;
                        _item!.local = x;
                      }),
                  Row(
                    children: [
                      // execução em domicilio ?
                      MaskedSwitchFormField(
                        label: 'Em domicilio',
                        value: (_item!.domicilio ?? 'N') == 'S',
                        onChanged: (v) {
                          // alterado = true;
                          _item!.domicilio = (v) ? 'S' : 'N';
                        },
                      ),

                      // Estado da agenda
                      Expanded(
                        child: SizedBox(
                            width: 200,
                            child: AgendaEstadoBuilder.createDropDownFormField(
                                context, _item!.estadoGid, onChanged: (gid) {
                              _item!.estadoGid = gid;
                              AgendaEstadoItemModel()
                                  .procurar(gid)
                                  .then((item) {
                                if (item != null) {
                                  _item!.completada =
                                      (item.encerrado == 'S') ? 1 : 0;
                                }
                                //print(['Estadoitem', gid, item]);
                              });
                            })),
                      ),
                    ],
                  ),
                  TextFormField(
                      initialValue: _item!.texto,
                      style: const TextStyle(
                          fontSize: 16, fontStyle: FontStyle.normal),
                      decoration: const InputDecoration(
                        labelText: 'Informações complementares',
                      ),
                      onSaved: (x) {
                        _item!.texto = x;
                      }),
                  if (injectAgendaEditBottom != null)
                    injectAgendaEditBottom.builder!(context, _item),
                  if (widget.bottom != null) widget.bottom!,
                  const SizedBox(
                    height: 10,
                  ),
                  //Divider(),
                  ValueListenableBuilder<double>(
                      valueListenable: progress,
                      builder: (x, y, z) {
                        if (y == 0) {
                          return StrapButton(
                            text: 'Salvar',
                            onPressed: () {
                              // processando = true;
                              try {
                                _save(context, injects, _item, fechar: true);
                              } finally {
                                //  processando = false;
                              }
                            },
                          );
                        }
                        return SizedBox(
                            width: 60.0,
                            height: 60.0,
                            child: CircularProgressIndicator(
                              value: y,
                              backgroundColor: Colors.white,
                              valueColor:
                                  const AlwaysStoppedAnimation(Colors.blue),

                              /*center: Text(
                                "${(y * 100.0).toStringAsFixed(0)}%",
                                style: TextStyle(
                                  color: Colors.lightBlueAccent,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),*/
                            ));

                        //return CircularProgressIndicator(
                        //  value: y + 0.0,
                        //  semanticsLabel: '${y * 100}%',
                        //);
                      }),
                ])),
          ),
        ),
      ),
    );
  }

  gerarVenda(BuildContext context, injects, AgendaItem item) async {
    //bool abrirNova = true;
    num? cliente = item.sigcadCodigo;
    DadosNovoFaturamento row = DadosNovoFaturamento.fromJson({});

    var at = (await AgendaTipoItemModel()
            .listNoCached(filter: "gid eq '${item.tipoGid}'", top: 1))
        .first;
    AgendaTipoItem agendaTipo = (AgendaTipoItem.fromJson(at ?? {}));

    // gerar um venda nova para a agenda
    //print('----------------------------------------');
    //print(['gerando venda ', agendaTipo, item.toJson()]);
    _save(context, injects, item, fechar: false).then((_) async {
      //if (!salvou ?? false) return false;

      // gera o cabeçalho da OS;
      /// poderia olhar se o cliente tem um OS em andamento e Perguntar,
      /// se quer adicionar produto na OS;
      var existe = await Sigcaut1ItemModel().listNoCached(
          filter: "qtde>qtdebaixa and clifor eq $cliente and remessa is null",
          select: 'dcto,clifor cliente,data,filial',
          top: 1,
          orderBy: 'data desc');
      if (existe.length > 0) {
        /// juntar o produto ?
        row = DadosNovoFaturamento.fromJson(existe[0]);
        //abrirNova = false;
      }
      row.produto = agendaTipo.ctprodCodigo;
      row.cliente = cliente as double?;
      row.filial = configInstance!.filial;
      row.data = toDate(item.datafim);
      // se há produto associao ao tipo, então insere o item na OS;
      // permite entrar com mais itens;
      // pronto para pagamento;
      row.preco = null;
      bool r = true;
      await Dialogs.showPage(context,
          fullPage: true,
          child: WillPopScope(
              onWillPop: () {
                r = false;
                return Future.value(true);
              },
              child: Scaffold(
                  appBar: AppBar(title: const Text('Faturar serviço')),
                  body: OsMainView(
                    dados: row,
                    popAfterPayment: true,
                  ))));
      if (r) Navigator.pop(context);
    });
  }

  Row buildDatas(AgendaItem item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          flex: 1,
          child: DateTimePickerFormField(
              initialValue: item.datainicio,
              format: 'dd/MM/y HH:mm',
              decoration: const InputDecoration(
                labelText: 'Início',
              ),
              validator: (DateTime? value) {
                if (value == null) {
                  return ' requerido ';
                }
                return null;
              },
              onChanged: (x) {
                //print(x);
                item.datainicio = x;
              }),
        ),
        Expanded(
          flex: 1,
          child: DateTimePickerFormField(
            decoration: const InputDecoration(
              labelText: 'Término',
            ),
            format: 'dd/MM/y HH:mm',
            initialValue: item.datafim,
            onChanged: (x) {
              // print(x);
              item.datafim = x;
            },
          ),
        ),
        ReplicarAgendaWidget(
          item: item,
          onChange: (repl, dias, vezes) {
            repReplicar = repl ?? false;
            repDias = dias;
            repVezes = vezes ?? 1;
          },
        ),
      ],
    );
  }

  _validar(AgendaItem item) {
    if (isEmptyOrNull(item.recursoGid)) return 'Não indicou quem irá executar';
    if (isEmptyOrNull(item.tipoGid)) {
      return 'Não indicou o tipo de agenda a ser executada';
    }
    return null;
  }

  _save(context, InjectBuilder injects, AgendaItem? item,
      {bool fechar = true}) async {
    /// validações
    InjectItem? registrarObjectServico = injects['RegistrarObjetoDoServico'];
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      var validacao = _validar(item!);
      if (validacao != null) {
        MensagemNotifier().notify('Informação |$validacao');
        return false;
      }

      return Dialogs.showWaitDialog(context, title: 'atualizando',
          onWaiting: () {
        if (widget.onSaved != null) {
          widget.onSaved!(item);
          if (fechar) Navigator.of(context).pop();
          return true;
        } else {
          validar(item).then((b) {
            if (!b) return false;

            /// inserir novo item na agenda
            if (widget.event == AgendaPostEvent.insert) {
              widget.data!.controller!.add(item).then((rsp) {
                if (registrarObjectServico != null) {
                  registrarObjectServico.builder!(context, item);
                }
                widget.data!.sources!.add(rsp);
                replicar(item).then((rsp) {
                  if (fechar) Navigator.of(context).pop();
                });
              });
            }

            /// atualizar a agenda
            if (widget.event == AgendaPostEvent.update) {
              widget.data!.controller!
                  .update(item, forceReload: recarregarDados)
                  .then((rsp) {
                if (registrarObjectServico != null) {
                  registrarObjectServico.builder!(context, item);
                }
                widget.data!.sources!.update(rsp);
                replicar(item).then((rsp) {
                  if (fechar) Navigator.of(context).pop();
                });
              });
            }
          });
        }
        return true;
      });
    }
  }

  replicar(item) async {
    if (!repReplicar) return false;
    return AgendaItemModel()
        .replicarAgenda(
            item: item,
            dias: repDias,
            vezes: repVezes,
            estado: '1',
            onProgress: (a, b) {
              //print([a, b]);
              progress.value = (a / b);
            })
        .then((List<AgendaItem> its) {
      AgendaResourceNotifyChanged().notify(0);
      return true;
    });
  }

  Future<bool> validar(AgendaItem item) async {
    // valida se exige contato
    if (item.sigcadCodigo == 0) {
      // requer contato ?
      AgendaTipoItem rsr = await AgendaTipoItemModel()
          .findOne(item.tipoGid)
          .then((it) => AgendaTipoItem.fromJson(it));
      if (rsr.requerContato!) {
        Get.snackbar('Ops', 'Não informou o contato');
        return false;
      }
    }
    return true;
  }

  void compartilharAgenda(AgendaItem item) async {
    generateTextoSharable(item)
        .then((texto) => ShareSocial.shareMessage('Agendamento', texto));
  }

  bool get canShare => configInstance!.resources.shareEnable;
  bool get isShareWeb => configInstance!.resources.shareWhatsWebEnable;

  Future<String> generateTextoSharable(AgendaItem item) async {
    return await TemplatesItemModel(configInstance).procurarETraduzir(
      'WHASTAPP_AGENDA_USUARIO',
      '''Olá, tenho uma agenda para vc no dia {dia} de {mes} às {hora}. Caso haja algum imprevisto nos avise.\n Agradecimentos 
{loja.nome} fone {loja.fone}''',
      titulo: 'Agendamento',
      data: item.datainicio,
      sigcadCodigo: item.sigcadCodigo as double?,
      filial: configInstance!.filial,
    );
  }

  isEmptyOrNull(value) => (value == null || '$value' == '');
}
