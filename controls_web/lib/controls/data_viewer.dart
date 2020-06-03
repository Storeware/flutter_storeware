import 'dart:convert';

import 'package:controls_data/odata_client.dart';
import 'package:controls_web/controls/dialogs_widgets.dart';
import 'package:controls_web/controls/paginated_grid.dart';
import 'package:controls_web/controls/strap_widgets.dart';
import 'package:controls_web/drivers/bloc_model.dart';
import 'package:flutter/material.dart';

class DefaultDataViewer extends InheritedWidget {
  final DataViewerController controller;
  DefaultDataViewer({Key key, @required this.controller, Widget child})
      : super(key: key, child: child);
  @override
  bool updateShouldNotify(DefaultDataViewer oldWidget) {
    return false;
  }

  static of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<DefaultDataViewer>();
}

/// [DataViewerController] Controller de dados para [DataViewer]
class DataViewerController {
  /// API de ligação com o REST
  final ODataModelClass dataSource;

  /// Function de busca dos dados
  final Function() future;

  /// [DataViewerController.keyName] utilizado para localizar uma linha na pilha
  String keyName;
  DataViewerController({
    @required this.future,
    this.context,
    this.dataSource,
    this.onValidate,
    this.top,
    @required this.keyName,
    this.onClearCache,
    this.onInsert,
    this.onUpdate,
    this.onDelete,
    this.onChanged,
  });
  int page = 1;
  int top;
  String filter = '';

  /// Eventos para customização de registro
  final Future<dynamic> Function(dynamic) onInsert;
  final Future<dynamic> Function(dynamic) onUpdate;
  final Future<dynamic> Function(dynamic) onDelete;
  final Function(dynamic) onChanged;

  /// Evento indicando que pode limpar o cache;
  final Function() onClearCache;

  /// Observer que notifica mudança dos dados
  BlocModel<int> subscribeChanges = BlocModel<int>();
  goPage(x) {
    if (onClearCache != null) onClearCache();
    page = x;
    subscribeChanges.notify(page);
  }

  final BuildContext context;

  /// Lista de dados
  List<dynamic> source;

  /// [DataViewerController.skip] indica as linhas iniciais a saltar na busca da API
  get skip => (page - 1) * top;

  /// executa  delete de um linha
  doDelete(dados, {manual = false}) {
    if (onClearCache != null) onClearCache();

    var rsp;
    if (onDelete != null)
      return onDelete(dados).then((r) {
        if (!manual && (rsp != null)) paginatedController.remove(dados);
        return true;
      });
    else if (dataSource != null) {
      if (onValidate != null) dados = onValidate(dados);
      return dataSource.delete(dados).then((rsp) {
        //print('resposta: $rsp');
        if (rsp is String) rsp = jsonDecode(rsp);
        int rows = rsp['rows'] ?? 1;
        if (rows > 0) {
          if (!manual && (rsp != null)) paginatedController.remove(dados);
          if (onChanged != null) onChanged(dados);
          return true;
        }
        show('Não encontrei o registro para executar a tarefa');
        return false;
      });
    }
    return rsp;
  }

  /// executa insert de uma linha
  doInsert(dados, {manual = false}) {
    if (onValidate != null) dados = onValidate(dados);
    if (onClearCache != null) onClearCache();
    var rsp;
    if (onInsert != null)
      return onInsert(dados).then((r) {
        if (!manual && (rsp != null)) paginatedController.remove(dados);
        if (onChanged != null) onChanged(dados);
        return true;
      });
    else if (dataSource != null) {
      return dataSource.post(dados).then((rsp) {
        if (!manual && (rsp != null)) paginatedController.add(dados);
        if (onChanged != null) onChanged(dados);
        return true;
      });
    }
    if (!manual && (rsp != null)) {
      paginatedController.source.add(dados);
      if (onChanged != null) onChanged(dados);
    }
    return rsp;
  }

  /// Update um linha
  doUpdate(dados, {manual = false}) {
    if (onValidate != null) dados = onValidate(dados);
    if (onClearCache != null) onClearCache();
    var rsp;
    if (onUpdate != null)
      return onUpdate(dados).then((r) {
        if (!manual && (rsp != null)) paginatedController.remove(dados);
        if (onChanged != null) onChanged(dados);
        return true;
      });
    else if (dataSource != null) {
      //debugPrint('doUpdate: $dados manual: $manual');
      return dataSource.put(dados).then((rst) {
        //debugPrint('respose: $rst');
        if (!manual && (rst != null)) {
          paginatedController.changeTo(keyName, dados[keyName], dados);
        }
        if (onChanged != null) onChanged(dados);
        return true;
      });
    }
    if (!manual && (rsp != null)) {
      paginatedController.changeTo(keyName, dados[keyName], dados);
      if (onChanged != null) onChanged(dados);
    }
    return false;
  }

  /// mostra uma janela filha
  show(texto) {
    if (context != null) Dialogs.showModal(context, title: texto);
  }

  /// [DataViewerController.onValidate] permite  transformar um dados antes de enviar para a API
  dynamic Function(dynamic) onValidate;

  /// [PaginatedGridController] controller para paginação dos dados.
  PaginatedGridController paginatedController = PaginatedGridController();

  edit(BuildContext context, Map<String, dynamic> data,
      {String title,
      double width,
      double height,
      PaginatedGridChangeEvent event = PaginatedGridChangeEvent.update}) {
    return paginatedController.edit(context, data,
        title: title, width: width, height: height, event: event);
  }
}

class DataViewerColumn extends PaginatedGridColumn {
  DataViewerColumn({
    onEditIconPressed,
    numeric = false,
    autofocus = false,
    visible = true,
    maxLines,
    color,
    maxLength,
    width,
    tooltip,
    align,
    style,
    name,
    required = false,
    readOnly = false,
    isPrimaryKey = false,
    onSort,
    placeHolder = false,
    label,
    editInfo = '{label}',
    bool sort = true,
    builder,
    editBuilder,
    isVirtual = false,
    onGetValue,
    onSetValue,
    onValidate,
    folded,
  }) : super(
          onEditIconPressed: onEditIconPressed,
          numeric: numeric,
          autofocus: autofocus,
          visible: visible,
          maxLines: maxLines,
          color: color,
          maxLength: maxLength,
          width: width,
          tooltip: tooltip,
          align: align,
          style: style,
          name: name,
          required: required,
          readOnly: readOnly,
          isPrimaryKey: isPrimaryKey,
          onSort: onSort,
          placeHolder: placeHolder,
          label: label,
          editInfo: editInfo,
          sort: sort,
          builder: builder,
          editBuilder: editBuilder,
          isVirtual: isVirtual,
          onGetValue: onGetValue,
          onSetValue: onSetValue,
          onValidate: onValidate,
          folded: folded,
        );
}

/// [DataViewer] Cria um objeto completo de navegação dos dados
class DataViewer extends StatefulWidget {
  final String keyName;
  final DataViewerController controller;
  final Widget child;
  final List<Map<String, dynamic>> source;
  final int rowsPerPage;
  final Function(dynamic) beforeShow;
  final List<PaginatedGridColumn> columns;
  final double height;
  final double width;

  /// se permite editar um dado - default: true;
  final bool canEdit;

  /// se permite apagar uma linha
  final bool canDelete;

  /// se permite incluir uma linha
  final bool canInsert;

  /// se o header de filtro esta habilitado - default: true;
  final bool canSearch;
  final String title;
  final Future<dynamic> Function(PaginatedGridController) onInsertItem;
  final Future<dynamic> Function(PaginatedGridController) onEditItem;
  final Future<dynamic> Function(PaginatedGridController) onDeleteItem;
  final List<Widget> actions;

  /// pressionou o botam abrir da barra de filtro
  final Function() onSearchPressed;
  final CrossAxisAlignment crossAxisAlignment;
  final Color backgroundColor;

  /// altura da linha de header de coluna
  final double headerHeight;
  final Widget header;
  final bool showPageNavigatorButtons;
  final double dataRowHeight;
  final double headingRowHeight;
  final double footerHeight;
  final Function(dynamic) onSelected;
  final Color evenRowColor; //: widget.evenRowColor,
  final Color oddRowColor; //: widget.oddRowColor,

  DataViewer({
    Key key,
    this.controller,
    this.child,
    this.keyName,
    this.source,
    this.evenRowColor,
    this.oddRowColor,
    this.rowsPerPage,
    this.headerHeight = kMinInteractiveDimension * 1.7,
    this.headingRowHeight = kMinInteractiveDimension,
    this.showPageNavigatorButtons = true,
    this.header,
    this.onSelected,
    this.footerHeight = kToolbarHeight,
    this.dataRowHeight = kMinInteractiveDimension,
    this.beforeShow,
    this.columns,
    this.canEdit = true,
    this.canDelete = false,
    this.canInsert = false,
    this.canSearch = true,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.backgroundColor,
    this.title,
    this.onInsertItem,
    this.onEditItem,
    this.onSearchPressed,
    this.onDeleteItem,
    this.actions,
    this.height,
    this.width,
  })  : assert(source != null || controller != null),
        assert((columns == null) || (columns.length > 0)),
        super(key: key);

  @override
  _DataViewerState createState() => _DataViewerState();
}

class _DataViewerState extends State<DataViewer> {
  DataViewerController controller;

  @override
  void initState() {
    controller = widget.controller ??
        DataViewerController(
            keyName: widget.keyName,
            future: () async {
              return widget.source;
            });
    if (widget.keyName != null) controller.keyName = widget.keyName;
    //controller.viewer = this.widget;
    super.initState();
  }

  final TextEditingController _filtroController = TextEditingController();
  Size size;

  createHeader() {
    bool isSmall = size.width < 500;
    int nActions = widget.actions?.length ?? 0;
    double bwidth = 350.0 - (isSmall ? ((nActions) * kToolbarHeight) : 0.0);
    return LayoutBuilder(builder: (ctr, sizes) {
      return Form(
        child: SafeArea(
          child: Container(
              height: 60,
              width: sizes.maxWidth,
              alignment: Alignment.center,
              child: Align(
                child: Container(
                  width: bwidth,
                  child: Row(children: [
                    Expanded(
                      child: TextFormField(
                        controller: _filtroController,
                        style: TextStyle(
                            fontSize: 16, fontStyle: FontStyle.normal),
                        decoration: InputDecoration(
                            labelText: 'procurar por',
                            suffixIcon: InkWell(
                                child: Icon(Icons.delete),
                                onTap: () {
                                  _filtroController.text = '';
                                })),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      width: 95,
                      child: StrapButton(
                          type: StrapButtonType.light,
                          text: 'abrir',
                          onPressed: () {
                            controller.filter = _filtroController.text;
                            if (controller.onClearCache != null)
                              controller.onClearCache();
                            if (widget.onSearchPressed != null)
                              widget.onSearchPressed();
                            controller.goPage(1);
                          }),
                    ),
                  ]),
                ),
              )),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    int _top = (widget.height ??
            ((size.height * 0.90) - kToolbarHeight - 20) -
                (widget.headerHeight) -
                widget.headingRowHeight -
                (widget.footerHeight * 2)) ~/
        widget.dataRowHeight;
    if (_top <= 3) _top = 3;
    if (controller.top == null) controller.top = _top;
    return StreamBuilder<dynamic>(
        stream: controller.subscribeChanges.stream,
        builder: (context, snapshot) {
          // print('subscribeChanges: ${snapshot.data}');
          return DefaultDataViewer(
            controller: widget.controller,
            child: Container(
              height: widget.height,
              width: widget.width,
              child: widget.child ??
                  PaginatedGrid(
                    evenRowColor: widget.evenRowColor,
                    oddRowColor: widget.oddRowColor,
                    //sortColumnIndex: widget.sortColumnIndex,
                    actions: widget.actions,
                    onSelectChanged: (widget.onSelected != null)
                        ? (b, ctrl) {
                            widget.onSelected(ctrl.data);
                          }
                        : null,
                    columnSpacing: 10,
                    onEditItem: widget.onEditItem,
                    onInsertItem: widget.onInsertItem,
                    onDeleteItem: widget.onDeleteItem,
                    crossAxisAlignment: widget.crossAxisAlignment,
                    backgroundColor: widget.backgroundColor,
                    headerHeight: (widget.canSearch || widget.header != null)
                        ? widget.headerHeight
                        : 0,
                    header: (widget.header != null)
                        ? widget.header
                        : (widget.canSearch) ? createHeader() : null,
                    headingRowHeight: widget.headingRowHeight,
                    dataRowHeight: widget.dataRowHeight,
                    controller: controller.paginatedController,
                    beforeShow: (p) {
                      if (widget.beforeShow != null)
                        return widget.beforeShow(p);
                    },
                    columns: widget.columns,
                    source: widget.source,
                    rowsPerPage: widget.rowsPerPage ?? _top,
                    currentPage: controller.page,
                    canEdit: widget.canEdit,
                    canInsert: widget.canInsert,
                    canDelete: widget.canDelete,
                    footerHeight: widget.footerHeight,
                    futureSource: (controller.future != null)
                        ? controller.future()
                        : null,
                    onPageSelected: (widget.showPageNavigatorButtons)
                        ? (x) {
                            //print(x);
                            controller.goPage(x);
                          }
                        : null,
                    onPostEvent: (widget.canEdit ||
                            widget.canInsert ||
                            widget.canDelete)
                        ? (PaginatedGridController ctrl, dynamic dados,
                            PaginatedGridChangeEvent event) async {
                            if (event == PaginatedGridChangeEvent.delete) {
                              return controller.doDelete(dados, manual: false);
                            }
                            if (event == PaginatedGridChangeEvent.insert) {
                              return controller.doInsert(dados, manual: false);
                            }
                            if (event == PaginatedGridChangeEvent.update) {
                              return controller.doUpdate(dados, manual: false);
                            }
                            return false;
                          }
                        : null,
                  ),
            ),
          );
        });
    // },
    //);
  }
}
