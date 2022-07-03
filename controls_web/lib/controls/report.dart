// @dart=2.12
import 'package:flutter/material.dart';

/// [ReportControler] um Controller para os dados a serem processados no relátorio
class ReportController {
  List<dynamic>? source;
  ReportController({
    this.source,
    this.columns,
    this.future,
  });
  dynamic future;
  List<ReportColumn>? columns;
}

/// [ReportColumn] atributos para as colunas do relatório
class ReportColumn {
  final String? name;
  final String? label;
  final double? width;
  final bool? numeric;
  final TextStyle? style;
  final Widget Function(dynamic)? builder;

  /// evento para retornar valores transformados
  final String Function(dynamic)? onGetValue;
  ReportColumn({
    this.width,
    this.name,
    this.style,
    this.onGetValue,
    this.label,
    this.builder,
    this.numeric = false,
  });
}

enum ReportRowType { header, body, footer }

class ReportView extends StatefulWidget {
  final ReportController? controller;
  final String? title;
  final String? subtitle;
  final Widget? header;
  final Color? backgroundColor;
  //final Widget body;
  final Widget? bottom;
  final List<Widget>? actions;
  final Widget? leading;
  final CrossAxisAlignment? crossAxisAlignment;

  /// lista de colunas do relatorio
  final List<ReportColumn>? columns;

  /// altura das linhas
  final double? dataRowHeight;

  /// Espação entre colunas
  final double? columnSpacing;
  final Function(int, dynamic)? onSelectChanged;
  final Function(int, dynamic)? onCellTap;
  final String Function(Map<String, dynamic> row)? grouped;
  final Map<String, dynamic> Function(dynamic)? onGroupHeader;
  final Map<String, dynamic> Function(int n, dynamic)? onGroupFooter;
  final Map<String, dynamic> Function(dynamic)? onGroupBody;

  /// rowCurrent, rowBefore -> return [true] if has aditional row
  //final bool Function(ReportRowType, dynamic, dynamic) onHasAditionalRow;

  /// Permite adicionar linhas totalizadoras ao relatório
  final dynamic Function(ReportRowType, dynamic, List<DataRow>)?
      onAditionalBuilder;

  /// chamado antes de montar as linhas
  final Map<String, dynamic> Function(ReportRowType, List<DataRow>)?
      onHeaderBuilder;

  /// chamado ao final das linhas
  final dynamic Function(ReportRowType, List<DataRow>)? onFooterBuilder;
  const ReportView({
    Key? key,
    @required this.controller,
    this.title,
    this.subtitle,
    this.header,
    this.backgroundColor,
    this.onSelectChanged,
    this.onCellTap,
    this.grouped,
    this.columnSpacing = 40,
    this.onGroupHeader,
    this.onGroupBody,
    this.onGroupFooter,
    this.onHeaderBuilder,
    this.onFooterBuilder,
    this.dataRowHeight = 35,
    //this.onHasAditionalRow,
    this.onAditionalBuilder,
    this.crossAxisAlignment,
    //this.body,
    this.bottom,
    this.columns,
    this.actions,
    this.leading,
  }) : super(key: key);

  @override
  State<ReportView> createState() => _ReportViewState();
}

class _ReportViewState extends State<ReportView> {
  bool groupChanged = false;

  /// gerador das linhas
  List<DataCell> genCells(index, row) {
    List<DataCell> cells = [];
    for (int i = 0; i < columns.length; i++) {
      ReportColumn col = columns[i];
      cells.add(
        DataCell(
            SizedBox.expand(
              child: Padding(
                padding: EdgeInsets.only(
                  left: widget.columnSpacing! / 2,
                  right: widget.columnSpacing! / 2,
                ),
                child: Container(
                  alignment: col.numeric!
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: (col.builder != null)
                      ? col.builder!(row)
                      : Text(
                          (col.onGetValue != null)
                              ? col.onGetValue!(row[col.name])
                              : '${row[col.name]}',
                          style: col.style),
                ),
              ),
            ),
            onTap: (widget.onCellTap != null)
                ? () {
                    widget.onCellTap!(index, row);
                  }
                : null),
      );
    }

    return cells;
  }

  DataRow genRow(index) {
    var row = source[index];
    return DataRow(
      onSelectChanged: (b) => widget.onSelectChanged!(index, row),
      cells: genCells(index, row),
    );
  }

  DataRow genRowData(index, row) {
    return DataRow(
      onSelectChanged: (b) => widget.onSelectChanged!(index, row),
      cells: genCells(index, row),
    );
  }

  List<ReportColumn> get columns => widget.controller!.columns!;
  ReportController get controller => widget.controller!;
  List<dynamic> get source => widget.controller!.source!;

  /// gerador das linhas adicionais
  createAditionalRow(rows, row, {Color? color}) {
    var dr = DataRow(cells: [
      for (var col in columns)
        DataCell(
          SizedBox.expand(
            child: Container(
              alignment:
                  col.numeric! ? Alignment.centerRight : Alignment.centerLeft,
              color: color ?? Colors.grey.withOpacity(0.1),
              child: Padding(
                padding: EdgeInsets.only(
                  left: widget.columnSpacing! / 2,
                  right: widget.columnSpacing! / 2,
                ),
                child: Text(
                    (col.onGetValue != null)
                        ? col.onGetValue!(row[col.name])
                        : '${row[col.name] ?? ''}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )),
              ),
            ),
          ),
        )
    ]);
    rows.add(dr);
  }

  dynamic oldRow;
  int groupCount = 0;
  String groupKey = '';
  generateRow(rows, row, {Color? color}) {
    if (row == null) return;
    if (row is List) {
      for (var i = 0; i < row.length; i++)
        createAditionalRow(rows, row[i],
            color: (i == 0)
                ? color ?? Colors.grey.withOpacity(0.1)
                : color ?? Colors.grey.withOpacity(0.4));
    } else
      createAditionalRow(rows, row, color: color);
  }

  /// motor de geração das linhas - global
  getRows() {
    List<DataRow> rows = [];
    int first = 0;
    int last = source.length - 1;

    if (widget.onHeaderBuilder != null) {
      generateRow(rows, widget.onHeaderBuilder!(ReportRowType.header, rows));
    }
    for (var i = 0; i < source.length; i++) {
      if (widget.grouped != null) {
        String k = widget.grouped!(source[i]);
        groupChanged = (k != groupKey);
        groupKey = k;
      }

      if (i > 0 && groupChanged && widget.onGroupFooter != null) {
        generateRow(rows, widget.onGroupFooter!(groupCount, source[i - 1]));
        groupCount = 0;
      }

      if (groupCount == 0 && widget.onGroupHeader != null)
        generateRow(
          rows,
          widget.onGroupHeader!(source[i]),
          color: Colors.grey.withOpacity(0.1),
        );
      if (widget.onGroupBody != null)
        rows.add(genRowData(
          i,
          widget.onGroupBody!(source[i]),
        ));
      if (widget.onAditionalBuilder != null) {
        generateRow(
            rows,
            widget.onAditionalBuilder!(
                (i == first)
                    ? ReportRowType.header
                    : (i == last)
                        ? ReportRowType.footer
                        : ReportRowType.body,
                source[i],
                rows));
      }
      if (widget.onGroupBody == null) rows.add(genRow(i));
      oldRow = source[i];
      groupChanged = false;
      groupCount++;
    }
    if (groupCount > 0 && widget.onGroupFooter != null) {
      generateRow(rows, widget.onGroupFooter!(groupCount, source.last));
      groupCount = 0;
    }
    if (widget.onFooterBuilder != null) {
      generateRow(rows, widget.onFooterBuilder!(ReportRowType.footer, rows));
    }

    return rows;
  }

  /// cria colunas caso não tenha sido informado
  createColumns() {
    if (source.isEmpty) return;
    Map<String, dynamic> row = source[0];
    controller.columns = [];
    for (var key in row.keys) {
      controller.columns!.add(ReportColumn(name: key));
    }
  }

  /// gerador de colunas
  genColumns({color}) {
    return [
      for (var col in columns)
        DataColumn(
          label: Container(
            width: col.width,
            alignment:
                col.numeric! ? Alignment.centerRight : Alignment.centerLeft,
            //color: color ?? Colors.grey.withOpacity(0.6),
            child: Padding(
              padding: EdgeInsets.only(
                left: widget.columnSpacing! / 2,
                right: widget.columnSpacing! / 2,
              ),
              child: Text(col.label ?? col.name!,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
          numeric: col.numeric!,
        )
    ];
  }

  @override
  Widget build(BuildContext context) {
    widget.controller!.columns = widget.columns ?? widget.controller!.columns;
    return FutureBuilder<dynamic>(
        future: (controller.future != null) ? controller.future : null,
        initialData: controller.source,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Align(child: CircularProgressIndicator());
          controller.source = snapshot.data;
          if ((widget.controller!.columns ?? []).isEmpty) createColumns();

          return Scaffold(
              body: Container(
            //elevation: 0,
            //semanticContainer: false,
            color: widget.backgroundColor,
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                crossAxisAlignment:
                    widget.crossAxisAlignment ?? CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.title != null)
                    ListTile(
                      title: Text(
                        widget.title!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        widget.subtitle ?? '',
                        textAlign: TextAlign.center,
                      ),
                      trailing: (widget.actions == null)
                          ? null
                          : Row(children: widget.actions!),
                      leading: widget.leading,
                    ),
                  if (widget.header != null) widget.header!,
                  const Divider(),
                  Expanded(
                      child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columnSpacing: 0,
                              horizontalMargin: 0,
                              dataRowHeight: widget.dataRowHeight,
                              rows: getRows(),
                              columns: genColumns(),
                              showCheckboxColumn: false,
                            ),
                          ))),
                  if (widget.bottom != null) widget.bottom!,
                ],
              ),
            ),
          ));
        });
  }
}
