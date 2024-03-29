// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;

class PaginatedDataTableExtended extends StatefulWidget {
  final Widget? footerLeading;
  final Widget? footerTrailing;
  final Widget? footer;
  final Widget? footerSecondary;
  final TextStyle? headingTextStyle;
  PaginatedDataTableExtended({
    Key? key,
    @required this.header,
    this.actions,
    @required this.columns,
    this.sortColumnIndex,
    this.sortAscending = true,
    this.elevation = 1,
    this.dividerThickness = 1,
    this.onSelectAll,
    this.color,
    this.dataRowHeight = kMinInteractiveDimension,
    this.dataTextStyle,
    this.dataRowColor,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
    this.alignment = Alignment.topLeft,
    this.headingRowHeight = kMinInteractiveDimension,
    this.headingTextStyle,
    this.headingRowColor,
    this.headerHeight = 64,
    this.horizontalMargin = 24.0,
    this.columnSpacing = kMinInteractiveDimension,
    this.showCheckboxColumn = true,
    this.initialFirstRowIndex = 0,
    this.onPageChanged,
    this.footerLeading,
    this.footerTrailing,
    this.footerHeight = 56,
    this.footer,
    this.footerSecondary,
    this.rowsPerPage = defaultRowsPerPage,
    this.availableRowsPerPage = const <int>[
      defaultRowsPerPage,
      defaultRowsPerPage * 2,
      defaultRowsPerPage * 5,
      defaultRowsPerPage * 10
    ],
    this.onRowsPerPageChanged,
    this.dragStartBehavior = DragStartBehavior.start,
    @required this.source,
  })  : assert(header != null),
        assert(columns != null),
        assert(dragStartBehavior != null),
        assert(columns!.isNotEmpty),
        assert(sortColumnIndex == null ||
            (sortColumnIndex >= 0 && sortColumnIndex < columns!.length)),
        assert(sortAscending != null),
        assert(dataRowHeight != null),
        assert(headingRowHeight != null),
        assert(horizontalMargin != null),
        assert(columnSpacing != null),
        assert(showCheckboxColumn != null),
        assert(rowsPerPage != null),
        assert(rowsPerPage! > 0),
        assert(() {
          if (onRowsPerPageChanged != null)
            assert(availableRowsPerPage != null &&
                availableRowsPerPage.contains(rowsPerPage));
          return true;
        }()),
        assert(source != null),
        super(key: key);

  /// The table card's header.
  ///
  /// This is typically a [Text] widget, but can also be a [ButtonBar] with
  /// [FlatButton]s. Suitable defaults are automatically provided for the font,
  /// button color, button padding, and so forth.
  ///
  /// If items in the table are selectable, then, when the selection is not
  /// empty, the header is replaced by a count of the selected items.
  final Widget? header;

  /// Icon buttons to show at the top right of the table.
  ///
  /// Typically, the exact actions included in this list will vary based on
  /// whether any rows are selected or not.
  ///
  /// These should be size 24.0 with default padding (8.0).
  final List<Widget>? actions;

  /// The configuration and labels for the columns in the table.
  final List<DataColumn>? columns;
  final double dividerThickness;

  /// The current primary sort key's column.
  ///
  /// See [DataTable.sortColumnIndex].
  final int? sortColumnIndex;

  /// Whether the column mentioned in [sortColumnIndex], if any, is sorted
  /// in ascending order.
  ///
  /// See [DataTable.sortAscending].
  final bool? sortAscending;

  /// Invoked when the user selects or unselects every row, using the
  /// checkbox in the heading row.
  ///
  /// See [DataTable.onSelectAll].
  final ValueSetter<bool>? onSelectAll;

  /// The height of each row (excluding the row that contains column headings).
  ///
  /// This value is optional and defaults to kMinInteractiveDimension if not
  /// specified.
  final double? dataRowHeight;
  final Color? dataRowColor;

  /// The height of the heading row.
  ///
  /// This value is optional and defaults to 56.0 if not specified.
  final double? headingRowHeight;
  final double headerHeight;

  /// The horizontal margin between the edges of the table and the content
  /// in the first and last cells of each row.
  ///
  /// When a checkbox is displayed, it is also the margin between the checkbox
  /// the content in the first data column.
  ///
  /// This value defaults to 24.0 to adhere to the Material Design specifications.
  final double? horizontalMargin;
  final double elevation;
  final CrossAxisAlignment crossAxisAlignment;
  final Alignment alignment;
  final Color? color;
  final Color? headingRowColor;
  final TextStyle? dataTextStyle;

  /// The horizontal margin between the contents of each data column.
  ///
  /// This value defaults to 56.0 to adhere to the Material Design specifications.
  final double? columnSpacing;

  /// {@macro flutter.material.dataTable.showCheckboxColumn}
  final bool? showCheckboxColumn;

  /// The index of the first row to display when the widget is first created.
  final int? initialFirstRowIndex;

  /// Invoked when the user switches to another page.
  ///
  /// The value is the index of the first row on the currently displayed page.
  final ValueChanged<int>? onPageChanged;

  /// The number of rows to show on each page.
  ///
  /// See also:
  ///
  ///  * [onRowsPerPageChanged]
  ///  * [defaultRowsPerPage]
  final int? rowsPerPage;

  /// The default value for [rowsPerPage].
  ///
  /// Useful when initializing the field that will hold the current
  /// [rowsPerPage], when implemented [onRowsPerPageChanged].
  static const int defaultRowsPerPage = 10;

  /// The options to offer for the rowsPerPage.
  ///
  /// The current [rowsPerPage] must be a value in this list.
  ///
  /// The values in this list should be sorted in ascending order.
  final List<int>? availableRowsPerPage;

  /// Invoked when the user selects a different number of rows per page.
  ///
  /// If this is null, then the value given by [rowsPerPage] will be used
  /// and no affordance will be provided to change the value.
  final ValueChanged<int>? onRowsPerPageChanged;

  /// The data source which provides data to show in each row. Must be non-null.
  ///
  /// This object should generally have a lifetime longer than the
  /// [PaginatedDataTableExtended] widget itself; it should be reused each time the
  /// [PaginatedDataTableExtended] constructor is called.
  final DataTableSource? source;

  /// {@macro flutter.widgets.scrollable.dragStartBehavior}
  final DragStartBehavior? dragStartBehavior;
  final double footerHeight;

  @override
  PaginatedDataTableExtendedState createState() =>
      PaginatedDataTableExtendedState();
}

/// Holds the state of a [PaginatedDataTableExtended].
///
/// The table can be programmatically paged using the [pageTo] method.
class PaginatedDataTableExtendedState
    extends State<PaginatedDataTableExtended> {
  int? _firstRowIndex;
  int? _rowCount;
  bool? _rowCountApproximate;
  int? _selectedRowCount;
  final Map<int, DataRow> _rows = <int, DataRow>{};

  @override
  void initState() {
    super.initState();
    _firstRowIndex = widget.initialFirstRowIndex ??
        (PageStorage.of(context)?.readState(context) as int);
    widget.source!.addListener(_handleDataSourceChanged);
    _handleDataSourceChanged();
  }

  @override
  void didUpdateWidget(PaginatedDataTableExtended oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.source != widget.source) {
      oldWidget.source!.removeListener(_handleDataSourceChanged);
      widget.source!.addListener(_handleDataSourceChanged);
      _handleDataSourceChanged();
    }
  }

  @override
  void dispose() {
    widget.source!.removeListener(_handleDataSourceChanged);
    super.dispose();
  }

  void _handleDataSourceChanged() {
    setState(() {
      _rowCount = widget.source!.rowCount;
      _rowCountApproximate = widget.source!.isRowCountApproximate;
      _selectedRowCount = widget.source!.selectedRowCount;
      _rows.clear();
    });
  }

  /// Ensures that the given row is visible.
  void pageTo(int rowIndex) {
    final int oldFirstRowIndex = _firstRowIndex!;
    setState(() {
      final int rowsPerPage = widget.rowsPerPage!;
      _firstRowIndex = (rowIndex ~/ rowsPerPage) * rowsPerPage;
    });
    if ((widget.onPageChanged != null) && (oldFirstRowIndex != _firstRowIndex))
      widget.onPageChanged!(_firstRowIndex!);
  }

  DataRow _getBlankRowFor(int index) {
    return DataRow.byIndex(
      index: index,
      cells: widget.columns!
          .map<DataCell>((DataColumn column) => DataCell.empty)
          .toList(),
    );
  }

  DataRow _getProgressIndicatorRowFor(int index) {
    bool haveProgressIndicator = false;
    final List<DataCell> cells =
        widget.columns!.map<DataCell>((DataColumn column) {
      if (!column.numeric) {
        haveProgressIndicator = true;
        return const DataCell(CircularProgressIndicator());
      }
      return DataCell.empty;
    }).toList();
    if (!haveProgressIndicator) {
      haveProgressIndicator = true;
      cells[0] = const DataCell(CircularProgressIndicator());
    }
    return DataRow.byIndex(
      index: index,
      cells: cells,
    );
  }

  List<DataRow> _getRows(int firstRowIndex, int rowsPerPage) {
    final List<DataRow> result = <DataRow>[];
    final int nextPageFirstRowIndex = firstRowIndex + rowsPerPage;
    bool haveProgressIndicator = false;
    for (int index = firstRowIndex; index < nextPageFirstRowIndex; index += 1) {
      DataRow? row;
      if ((index < (_rowCount ?? 0)) || (_rowCountApproximate ?? false)) {
        row = _rows.putIfAbsent(index, () => widget.source!.getRow(index)!);
        /*if ((row == null) && !haveProgressIndicator) {
          row = _getProgressIndicatorRowFor(index);
          haveProgressIndicator = true;
        }*/
      }
      row ??= _getBlankRowFor(index);
      result.add(row);
    }
    return result;
  }

  void _handlePrevious() {
    pageTo(math.max((_firstRowIndex!) - widget.rowsPerPage!, 0));
  }

  void _handleNext() {
    pageTo(_firstRowIndex! + widget.rowsPerPage!);
  }

  final GlobalKey _tableKey = GlobalKey();

  //final _scrollContoller = ScrollController();

  @override
  Widget build(BuildContext context) {
    // TODO(ianh): This whole build function doesn't handle RTL yet.
    assert(debugCheckHasMaterialLocalizations(context));
    final ThemeData themeData = Theme.of(context);
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    // HEADER
    final List<Widget> headerWidgets = <Widget>[];
    double startPadding = 24.0;
    if (_selectedRowCount == 0) {
      headerWidgets.add(Expanded(child: widget.header!));
      if (widget.header is ButtonBar) {
        // We adjust the padding when a button bar is present, because the
        // ButtonBar introduces 2 pixels of outside padding, plus 2 pixels
        // around each button on each side, and the button itself will have 8
        // pixels internally on each side, yet we want the left edge of the
        // inside of the button to line up with the 24.0 left inset.
        // TODO(ianh): Better magic. See https://github.com/flutter/flutter/issues/4460
        startPadding = 12.0;
      }
    } else {
      headerWidgets.add(Expanded(
        child: Text(localizations.selectedRowCountTitle(_selectedRowCount!)),
      ));
    }
    if (widget.actions != null) {
      headerWidgets.addAll(widget.actions!.map<Widget>((Widget action) {
        return Padding(
          // 8.0 is the default padding of an icon button
          padding: const EdgeInsetsDirectional.only(start: 24.0 - 8.0 * 2.0),
          child: action,
        );
      }).toList());
    }

    // FOOTER
    final TextStyle footerTextStyle = themeData.textTheme.caption!;
    final List<Widget> footerWidgets = <Widget>[];
    if (widget.footer != null) {
      footerWidgets.add(widget.footer!);
    } else {
      if (widget.footerLeading != null)
        footerWidgets.add(widget.footerLeading!);

      if (widget.onRowsPerPageChanged != null) {
        final List<Widget> availableRowsPerPage = widget.availableRowsPerPage!
            .where((int value) =>
                value <= _rowCount! || value == widget.rowsPerPage)
            .map<DropdownMenuItem<int>>((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text('$value'),
          );
        }).toList();
        footerWidgets.addAll(<Widget>[
          Container(
              width:
                  14.0), // to match trailing padding in case we overflow and end up scrolling
          Text(localizations.rowsPerPageTitle),
          ConstrainedBox(
            constraints: const BoxConstraints(
                minWidth: 64.0), // 40.0 for the text, 24.0 for the icon
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  items: availableRowsPerPage.cast<DropdownMenuItem<int>>(),
                  value: widget.rowsPerPage,
                  onChanged: (i) => widget.onRowsPerPageChanged!(i!),
                  style: footerTextStyle,
                  iconSize: 24.0,
                ),
              ),
            ),
          ),
        ]);
      }

      //print('perPage ${widget.rowsPerPage} rows: ${widget.source.rowCount} ');
      if (widget.rowsPerPage! < widget.source!.rowCount)
        footerWidgets.addAll(<Widget>[
          Container(width: 32.0),
          Text(
            localizations.pageRowsInfoTitle(
              _firstRowIndex! + 1,
              _firstRowIndex! + widget.rowsPerPage!,
              _rowCount!,
              _rowCountApproximate!,
            ),
          ),
          Container(width: 32.0),
          IconButton(
            icon: const Icon(Icons.chevron_left),
            padding: EdgeInsets.zero,
            tooltip: localizations.previousPageTooltip,
            onPressed: _firstRowIndex! <= 0 ? null : _handlePrevious,
          ),
          Container(width: 24.0),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            padding: EdgeInsets.zero,
            tooltip: localizations.nextPageTooltip,
            onPressed: (!_rowCountApproximate! &&
                    (_firstRowIndex! + widget.rowsPerPage! >= _rowCount!))
                ? null
                : _handleNext,
          ),
          Container(width: 65.0),
        ]);
    }
    // CARD
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Card(
          elevation: widget.elevation,
          semanticContainer: false,
          color: widget.color,
          child: Container(
            padding: EdgeInsets.only(
                left: widget.horizontalMargin! / 2,
                right: widget.horizontalMargin! / 2),
            child: Align(
              alignment: widget.alignment,
              child: Column(
                crossAxisAlignment: widget.crossAxisAlignment,
                children: <Widget>[
                  Semantics(
                    container: true,
                    child: DefaultTextStyle(
                      // These typographic styles aren't quite the regular ones. We pick the closest ones from the regular
                      // list and then tweak them appropriately.
                      // See https://material.io/design/components/data-tables.html#tables-within-cards
                      style: _selectedRowCount! > 0
                          ? themeData.textTheme.subtitle1!
                              .copyWith(color: themeData.colorScheme.secondary)
                          : themeData.textTheme.headline6!
                              .copyWith(fontWeight: FontWeight.w400),
                      child: IconTheme.merge(
                        data: const IconThemeData(opacity: 0.54),
                        child: Ink(
                          height: widget.headerHeight,
                          color: _selectedRowCount! > 0
                              ? themeData.secondaryHeaderColor
                              : null,
                          child: Padding(
                            padding: EdgeInsetsDirectional.only(
                                start: startPadding, end: 14.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: headerWidgets,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: constraints.minWidth,
                        maxWidth: double.maxFinite,
                      ),
                      child: createDataTable(context)),
                  DefaultTextStyle(
                    style: footerTextStyle,
                    child: IconTheme.merge(
                      data: const IconThemeData(opacity: 0.54),
                      child: Container(
                        // TODO(bkonyi): this won't handle text zoom correctly, https://github.com/flutter/flutter/issues/48522
                        height: widget.footerHeight,
                        //width: double.maxFinite,
                        //alignment: Alignment.center,
                        child: SingleChildScrollView(
                            dragStartBehavior: widget.dragStartBehavior!,
                            scrollDirection: Axis.horizontal,
                            reverse: true,
                            child: Column(children: [
                              Row(
                                children: [
                                  ...footerWidgets,
                                  if (widget.footerTrailing != null)
                                    widget.footerTrailing!
                                ],
                              ),
                              if (widget.footerSecondary != null)
                                widget.footerSecondary!,
                            ])),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget createDataTable(context) {
    return SingleScroller(
        child: DataTable(
      key: _tableKey,
      dividerThickness: widget.dividerThickness,
      columns: widget.columns!,
      sortColumnIndex: widget.sortColumnIndex,
      sortAscending: widget.sortAscending!,
      onSelectAll: (a) => widget.onSelectAll!(a!),
      dataRowHeight: widget.dataRowHeight,
      dataRowColor: (widget.dataRowColor == null)
          ? null
          : MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
              return widget.dataRowColor!;
            }),
      dataTextStyle: widget.dataTextStyle,
      headingRowHeight: widget.headingRowHeight,
      horizontalMargin: 0,
      columnSpacing: widget.columnSpacing,
      showCheckboxColumn: widget.showCheckboxColumn!,
      headingRowColor: (widget.headingRowColor == null)
          ? null
          : MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
              return widget.headingRowColor!;
            }),
      headingTextStyle: widget.headingTextStyle,
      rows: _getRows(_firstRowIndex!, widget.rowsPerPage!),
    ));
  }
}

class SingleScroller extends StatelessWidget {
  final Widget child;
  final Axis scrollDirection;
  SingleScroller(
      {Key? key, required this.child, this.scrollDirection = Axis.horizontal})
      : super(key: key);
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        },
      ),
      child: SingleChildScrollView(
        controller: _controller,
        physics: const AlwaysScrollableScrollPhysics(),
        scrollDirection: scrollDirection,
        child: child,
      ),
    );
  }
}
