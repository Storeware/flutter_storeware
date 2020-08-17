import 'dart:convert';

import 'package:controls_data/odata_client.dart';
import 'package:controls_web/controls/dialogs_widgets.dart';
import 'package:controls_web/controls/paginated_grid.dart';
import 'package:controls_web/controls/strap_widgets.dart';
import 'package:controls_web/drivers/bloc_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/constants.dart';

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
  Function() future;
  final Function(dynamic, PaginatedGridChangeEvent) beforeChange;

  /// [DataViewerController.keyName] utilizado para localizar uma linha na pilha
  String keyName;
  DataViewerController({
    this.future,
    this.context,
    this.dataSource,
    this.onValidate,
    this.beforeChange,
    Function(DataViewerController) futureExtended,
    this.top,
    @required this.keyName,
    this.onClearCache,
    this.onInsert,
    this.onUpdate,
    this.onDelete,
    this.onChanged,
    this.columns,
  }) {
    if (futureExtended != null) {
      this.future = () => futureExtended(this);
    }
    paginatedController.parent = this;
  }
  int page = 1;
  int top;
  String get filter => filterValue.value;
  set filter(String v) => filterValue.value = v;
  ValueNotifier filterValue = ValueNotifier<String>('');

  /// Eventos para customização de registro
  final Future<dynamic> Function(dynamic) onInsert;
  final Future<dynamic> Function(dynamic) onUpdate;
  final Future<dynamic> Function(dynamic) onDelete;
  final Function(dynamic) onChanged;
  List<PaginatedGridColumn> columns;

  /// Evento indicando que pode limpar o cache;
  final Function() onClearCache;

  /// Lista de dados
  //List<dynamic> source;
  set source(List<Map<String, dynamic>> data) => paginatedController.source;
  get source => paginatedController.source;

  /// Observer que notifica mudança dos dados
  BlocModel<int> subscribeChanges = BlocModel<int>();
  goPage(x) {
    if (onClearCache != null) onClearCache();
    page = x;
    subscribeChanges.notify((page == 1) ? -1 : page);
  }

  final BuildContext context;

  /// [DataViewerController.skip] indica as linhas iniciais a saltar na busca da API
  get skip => (page - 1) * top;

  findColumn(name) {
    var index = -1;
    for (int i = 0; i < columns.length; i++)
      if (columns[i].name == name) index = i;
    if (index > -1) return columns[index];
    return null;
  }

  createColumns(List<Map<String, dynamic>> source) {
    paginatedController.createColumns(source);
  }

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

  reopen() {
    page = 1;
    subscribeChanges.notify(-1);
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
    Function(PaginatedGridController) onEditIconPressed,
    bool numeric = false,
    bool autofocus = false,
    bool visible = true,
    int maxLines,
    Color color,
    int maxLength,
    int minLength,
    double width,
    String tooltip,
    Alignment align,
    TextStyle style,
    String name,
    bool required = false,
    bool readOnly = false,
    bool isPrimaryKey = false,
    onSort,
    bool placeHolder = false,
    String label,
    String editInfo = '{label}',
    bool sort = true,
    double editWidth,
    double editHeight,
    Function(dynamic) onFocusChanged,
    Widget Function(int, Map<String, dynamic>) builder,
    Widget Function(PaginatedGridController, PaginatedGridColumn, dynamic,
            Map<String, dynamic>)
        editBuilder,
    bool isVirtual = false,
    String Function(dynamic) onGetValue,
    final dynamic Function(dynamic) onSetValue,
    final String Function(dynamic) onValidate,
    folded,
  }) : super(
          onEditIconPressed: onEditIconPressed,
          numeric: numeric,
          autofocus: autofocus,
          visible: visible,
          maxLines: maxLines,
          color: color,
          maxLength: maxLength,
          minLength: minLength,
          width: width,
          editWidth: editWidth,
          editHeight: editHeight,
          tooltip: tooltip,
          align: align,
          style: style,
          name: name,
          onFocusChanged: onFocusChanged,
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
  final double elevation;
  final bool canSort;

  /// se permite editar um dado - default: true;
  final bool canEdit;

  /// se permite apagar uma linha
  final bool canDelete;

  /// se permite incluir uma linha
  final bool canInsert;

  /// se o header de filtro esta habilitado - default: true;
  final bool canSearch;
  final Widget title;
  final Widget subtitle;
  final Future<dynamic> Function(PaginatedGridController) onInsertItem;
  final Future<dynamic> Function(PaginatedGridController) onEditItem;
  final Future<dynamic> Function(PaginatedGridController) onDeleteItem;
  final List<Widget> actions;
  final Widget leading;

  /// pressionou o botam abrir da barra de filtro
  final Function() onSearchPressed;
  final CrossAxisAlignment crossAxisAlignment;
  //final Color backgroundColor;

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
  final bool oneRowAutoEdit;
  DataViewer({
    Key key,
    this.controller,
    this.child,
    this.oneRowAutoEdit = false,
    this.keyName,
    this.source,
    this.evenRowColor,
    this.elevation = 0,
    this.oddRowColor,
    this.rowsPerPage,
    this.headerHeight = kToolbarHeight + 48,
    this.headingRowHeight = kMinInteractiveDimension,
    this.showPageNavigatorButtons = true,
    this.header,
    this.canSort = true,
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
    //this.backgroundColor,
    this.title,
    this.subtitle,
    this.onInsertItem,
    this.onEditItem,
    this.onSearchPressed,
    this.onDeleteItem,
    this.actions,
    this.leading,
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
    controller.columns ??= widget.columns;
    controller.paginatedController.beforeChange = controller.beforeChange;
    super.initState();
  }

  final TextEditingController _filtroController = TextEditingController();
  Size size;
  ThemeData theme;

  createHeader() {
    bool isSmall = size.width < 500;
    int nActions = widget.actions?.length ?? 0;
    double bwidth = 350.0 - (isSmall ? ((nActions) * kToolbarHeight) : 0.0);
    return LayoutBuilder(builder: (ctr, sizes) {
      return Form(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.title != null) widget.title,
              Container(
                  height: kToolbarHeight + 4,
                  width: sizes.maxWidth,
                  alignment: Alignment.center,
                  child: Align(
                    child: Container(
                        width: bwidth,
                        child: Column(children: [
                          Row(children: [
                            if (widget.leading != null) widget.leading,
                            Expanded(
                              child: TextFormField(
                                controller: _filtroController,
                                style: theme.textTheme.bodyText1,
                                /*TextStyle(
                            fontSize: 16, fontStyle: FontStyle.normal),*/
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
                              padding: EdgeInsets.symmetric(
                                  vertical: 5), // ios usa 5
                              width: 90,
                              child: StrapButton(
                                  //type: StrapButtonType.primary ,
                                  text: 'abrir',
                                  onPressed: () {
                                    controller.page = 1;
                                    controller.filter = _filtroController.text;
                                    if (controller.onClearCache != null)
                                      controller.onClearCache();
                                    if (widget.onSearchPressed != null)
                                      widget.onSearchPressed();
                                    controller.goPage(1);
                                  }),
                            ),
                          ]),
                        ])),
                  )),
              if (widget.subtitle != null) widget.subtitle,
            ],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
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
                    elevation: widget.elevation,
                    canSort: widget.canSort,
                    evenRowColor: widget.evenRowColor,
                    oddRowColor: widget.oddRowColor,
                    //sortColumnIndex: widget.sortColumnIndex,
                    actions: widget.actions,
                    onSelectChanged: (widget.onSelected != null)
                        ? (b, ctrl) {
                            return widget.onSelected(ctrl.data);
                          }
                        : null,
                    columnSpacing: 10,
                    onEditItem: widget.onEditItem,
                    onInsertItem: widget.onInsertItem,
                    onDeleteItem: widget.onDeleteItem,
                    crossAxisAlignment: widget.crossAxisAlignment,
                    //backgroundColor: widget.backgroundColor,
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
                    columns: controller.columns ??
                        controller.paginatedController.columns,
                    source: widget.source ?? controller.source,
                    rowsPerPage: widget.rowsPerPage ?? _top,
                    currentPage: controller.page,
                    canEdit: widget.canEdit,
                    canInsert: widget.canInsert,
                    canDelete: widget.canDelete,
                    footerHeight: widget.footerHeight,
                    oneRowAutoEdit: widget.oneRowAutoEdit,
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
  }
}

class DataViewerGroup {
  final String title;
  final List<String> children;

  DataViewerGroup({this.title, this.children});
}

class DataViewerEditGroupedPage extends StatefulWidget {
  final String title;
  final Map<String, dynamic> data;
  final List<DataViewerGroup> grouped;
  final DataViewerController controller;
  final bool canEdit, canInsert, canDelete;
  final PaginatedGridChangeEvent event;
  final double dataRowHeight;
  final Function(dynamic) onSaved;
  const DataViewerEditGroupedPage({
    Key key,
    @required this.data,
    @required this.grouped,
    @required this.controller,
    this.title,
    this.dataRowHeight,
    this.canEdit = false,
    this.canInsert = false,
    this.canDelete = false,
    this.onSaved,
    @required this.event,
  }) : super(key: key);

  @override
  _DataViewEditGroupedPageState createState() =>
      _DataViewEditGroupedPageState();
}

class _DataViewEditGroupedPageState extends State<DataViewerEditGroupedPage> {
  ThemeData theme;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? 'Edição'),
        actions: [
          if (widget.canDelete)
            IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  widget.controller.doDelete(widget.data).then((rsp) {
                    Navigator.pop(context);
                  });
                }),
        ],
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var row in widget.grouped) createRow(row, widget.data),
                SizedBox(
                  height: 15,
                ),
                if (widget.canEdit || widget.canInsert)
                  Container(
                      alignment: Alignment.center,
                      child: StrapButton(
                        text: 'Salvar',
                        onPressed: () {
                          _save(context);
                        },
                      )),
              ]),
        ),
      )),
    );
  }

  createRow(DataViewerGroup rows, Map<String, dynamic> data) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (rows.title != null)
          Container(
              color: theme.primaryColor.withAlpha(50),
              alignment: Alignment.centerLeft,
              height: kMinInteractiveDimension * 0.6,
              child: Text(rows.title, style: theme.textTheme.caption)),
        Wrap(
          direction: Axis.horizontal,
          children: [for (var column in rows.children) createColumn(column)],
        ),
      ],
    );
  }

  createColumn(column) {
    var col;
    var ctrl;

    if (widget.controller.columns != null) {
      ctrl = widget.controller;
      col = ctrl?.findColumn(column);
    } else {
      ctrl = widget.controller.paginatedController;
      col = ctrl?.findColumn(column);
    }

    if (col == null) return (Text('null $column'));
    var edit;
    if (col.editBuilder != null)
      edit = col.editBuilder(
          widget.controller.paginatedController, col, widget.data, widget.data);
    if (edit == null) {
      edit = createFormField(col);
    }
    return Container(
        padding: EdgeInsets.only(right: 8),
        height: widget.dataRowHeight ??
            (col.editHeight ??
                kToolbarHeight + (((col.maxLength ?? 0) > 0) ? 24.0 : 8)),
        width: col.editWidth ?? col.width ?? 150.0,
        child: edit ?? Text('${widget.data[column]}'));
  }

  bool _focused = false;
  int _first = 0;
  bool canFocus(PaginatedGridColumn col) {
    if (_focused) return false;
    if (col.readOnly) return false;
    if (widget.event == PaginatedGridChangeEvent.update) if (col.isPrimaryKey)
      return false;

    if (widget.event == PaginatedGridChangeEvent.insert) {
      if (_first > 0) return false;
    }
    _first++;
    _focused = true;
    return true;
  }

  get p => widget.data;
  createFormField(item) {
    final TextEditingController txt_controller = TextEditingController(
        text: (item.onGetValue != null)
            ? item.onGetValue(p[item.name])
            : (p[item.name] ?? '').toString());
    return Focus(
      //descendantsAreFocusable: canFocus(item),
      canRequestFocus: false,
      onFocusChange: (b) {
        if (!b) if (item.onFocusChanged != null)
          item.onFocusChanged(txt_controller.text);
      },
      child: TextFormField(
        readOnly: (item.isPrimaryKey || item.readOnly),
        autofocus: canFocus(item),
        maxLines: item.maxLines,
        maxLength: item.maxLength,
        enabled: (widget.canEdit || widget.canInsert) && (!item.readOnly),
        controller: txt_controller,
        style: TextStyle(fontSize: 16, fontStyle: FontStyle.normal),
        decoration: InputDecoration(
          labelText: item.label ?? item.name,
        ),
        validator: (value) {
          if (item.onValidate != null) return item.onValidate(value);
          if (item.required) if (value.isEmpty) {
            return (item.editInfo
                .replaceAll('{label}', item.label ?? item.name));
          }
          if ((item.minLength != null) && (value.length < item.minLength))
            return 'Texto insuficientes (min: ${item.minLength} caracteres)';

          return null;
        },
        onSaved: (x) {
          if (item.onSetValue != null) {
            p[item.name] = item.onSetValue(x);
            return;
          }
          if (p[item.name] is int)
            p[item.name] = int.tryParse(x);
          else if (p[item.name] is double)
            p[item.name] = double.tryParse(x);
          else if (p[item.name] is bool)
            p[item.name] = x;
          else
            p[item.name] = x;
        },
      ),
    );
  }

  _save(context) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      doPostEvent(widget.controller.paginatedController, p, widget.event)
          .then((rsp) {
        if (widget.onSaved != null) widget.onSaved(p);
        Navigator.pop(context);
      });
    }
  }

  doPostEvent(PaginatedGridController ctrl, dynamic dados,
      PaginatedGridChangeEvent event) async {
    if (event == PaginatedGridChangeEvent.delete) {
      return widget.controller.doDelete(dados, manual: false);
    }
    if (event == PaginatedGridChangeEvent.insert) {
      return widget.controller.doInsert(dados, manual: false);
    }
    if (event == PaginatedGridChangeEvent.update) {
      return widget.controller.doUpdate(dados, manual: false);
    }
    return false;
  }
}
