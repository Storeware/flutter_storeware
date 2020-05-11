import 'package:controls_web/controls/paginated_data_table_ext.dart';
import 'package:flutter/material.dart';

/// [ReportControler] um Controller para os dados a serem processados no relátorio
class ReportController {
  List<dynamic> source;
  ReportController({
    this.source,
    this.columns,
    this.future,
  });
  var future;
  List<ReportColumn> columns;
}

/// [ReportColumn] atributos para as colunas do relatório
class ReportColumn {
  final String name;
  final String label;
  final double width;
  final bool numeric;
  final TextStyle style;

  /// evento para retornar valores transformados
  final String Function(dynamic) onGetValue;
  ReportColumn({
    this.width,
    this.name,
    this.style,
    this.onGetValue,
    this.label,
    this.numeric = false,
  });
}

enum ReportRowType { header, body, footer }

class ReportView extends StatefulWidget {
  final ReportController controller;
  final String title;
  final String subtitle;
  final Widget header;
  final Color backgroundColor;
  //final Widget body;
  final Widget bottom;

  /// lista de colunas do relatorio
  final List<ReportColumn> columns;

  /// altura das linhas
  final double dataRowHeight;

  /// Espação entre colunas
  final double columnSpacing;
  final Function(int, dynamic) onSelectChanged;
  final Function(int, dynamic) onCellTap;

  /// rowCurrent, rowBefore -> return [true] if has aditional row
  //final bool Function(ReportRowType, dynamic, dynamic) onHasAditionalRow;

  /// Permite adicionar linhas totalizadoras ao relatório
  final dynamic Function(ReportRowType, dynamic, List<DataRow>)
      onAditionalBuilder;

  /// chamado antes de montar as linhas
  final dynamic Function(ReportRowType, List<DataRow>) onHeaderBuilder;

  /// chamado ao final das linhas
  final dynamic Function(ReportRowType, List<DataRow>) onFooterBuilder;
  ReportView({
    Key key,
    @required this.controller,
    this.title,
    this.subtitle,
    this.header,
    this.backgroundColor,
    this.onSelectChanged,
    this.onCellTap,
    this.columnSpacing = 56,
    this.onHeaderBuilder,
    this.onFooterBuilder,
    this.dataRowHeight = 40,
    //this.onHasAditionalRow,
    this.onAditionalBuilder,
    //this.body,
    this.bottom,
    this.columns,
  }) : super(key: key);

  @override
  _ReportViewState createState() => _ReportViewState();
}

class _ReportViewState extends State<ReportView> {
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
                  left: widget.columnSpacing / 2,
                  right: widget.columnSpacing / 2,
                ),
                child: Container(
                  alignment: col.numeric
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Text(
                      (col.onGetValue != null)
                          ? col.onGetValue(row[col.name])
                          : '${row[col.name]}',
                      style: col.style),
                ),
              ),
            ),
            onTap: (widget.onCellTap != null)
                ? () {
                    widget.onCellTap(index, row);
                  }
                : null),
      );
    }

    return cells;
  }

  DataRow genRow(index) {
    var row = source[index];
    return DataRow(
      onSelectChanged: (b) => widget.onSelectChanged(index, row),
      cells: genCells(index, row),
    );
  }

  List<ReportColumn> get columns => widget.controller.columns;
  ReportController get controller => widget.controller;
  List<dynamic> get source => widget.controller.source;

  /// gerador das linhas adicionais
  createAditionalRow(rows, row, {Color color}) {
    var dr = DataRow(cells: [
      for (var col in columns)
        DataCell(
          SizedBox.expand(
            child: Container(
              alignment:
                  col.numeric ? Alignment.centerRight : Alignment.centerLeft,
              color: color ?? Colors.grey.withOpacity(0.1),
              child: Padding(
                padding: EdgeInsets.only(
                  left: widget.columnSpacing / 2,
                  right: widget.columnSpacing / 2,
                ),
                child: Text(
                    (col.onGetValue != null)
                        ? col.onGetValue(row[col.name])
                        : '${row[col.name] ?? ''}',
                    style: TextStyle(
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
  generateRow(rows, row) {
    if (row == null) return;
    if (row is List) {
      for (var i = 0; i < row.length; i++)
        createAditionalRow(rows, row[i],
            color: (i == 0)
                ? Colors.grey.withOpacity(0.1)
                : Colors.grey.withOpacity(0.4));
    } else
      createAditionalRow(rows, row);
  }

  /// motor de geração das linhas - global
  getRows() {
    List<DataRow> rows = [];
    int first = 0;
    int last = source.length - 1;

    if (widget.onHeaderBuilder != null) {
      generateRow(rows, widget.onHeaderBuilder(ReportRowType.header, rows));
    }
    for (var i = 0; i < source.length; i++) {
      if (widget.onAditionalBuilder != null) {
        generateRow(
            rows,
            widget.onAditionalBuilder(
                (i == first)
                    ? ReportRowType.header
                    : (i == last) ? ReportRowType.footer : ReportRowType.body,
                source[i],
                rows));
      }

      rows.add(genRow(i));
      oldRow = source[i];
    }
    if (widget.onFooterBuilder != null) {
      generateRow(rows, widget.onFooterBuilder(ReportRowType.footer, rows));
    }

    return rows;
  }

  /// cria colunas caso não tenha sido informado
  createColumns() {
    if (source.length == 0) return;
    Map<String, dynamic> row = source[0];
    controller.columns = [];
    for (var key in row.keys) {
      controller.columns.add(ReportColumn(name: key));
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
                col.numeric ? Alignment.centerRight : Alignment.centerLeft,
            //color: color ?? Colors.grey.withOpacity(0.6),
            child: Padding(
              padding: EdgeInsets.only(
                left: widget.columnSpacing / 2,
                right: widget.columnSpacing / 2,
              ),
              child: Text(col.label ?? col.name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
          numeric: col.numeric,
        )
    ];
  }

  @override
  Widget build(BuildContext context) {
    widget.controller.columns = widget.columns ?? widget.controller.columns;
    return FutureBuilder<dynamic>(
        future: (controller.future != null) ? controller.future : null,
        initialData: controller.source,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Align(child: CircularProgressIndicator());
          controller.source = snapshot.data;
          if ((widget.controller.columns ?? []).length == 0) createColumns();

          return Scaffold(
            //appBar: AppBar(title: Text('')),
            body: Card(
              elevation: 0, //widget.elevation,
              semanticContainer: false,
              color: widget.backgroundColor,

              child: Align(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (widget.title != null)
                      ListTile(
                        title: Text(
                          widget.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          widget.subtitle ?? '',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    if (widget.header != null) widget.header,
                    SingleChildScrollView(
                        child: DataTable(
                      columnSpacing: 0,
                      horizontalMargin: 0,
                      dataRowHeight: widget.dataRowHeight,

                      rows: getRows(),
                      //header: Text(''),
                      //source: createTableSource(),
                      columns: genColumns(),
                      showCheckboxColumn: false,
                    )),
                    if (widget.bottom != null) widget.bottom,
                  ],
                ),
              ),
            ),
          );
        });
  }
}
