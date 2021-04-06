// @dart=2.12

import '../controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'pdf_report.dart';
import 'package:pdf/widgets.dart' as pw;
//import 'package:controls_extensions/extensions.dart';

class DataViewerPdfReportController {
  final DataViewerController controller;
  final double dataHeadereHeight;
  late final PdfBands? bands;
  DataViewerPdfReportController(this.controller,
      {this.dataHeadereHeight = kMinInteractiveDimension, this.bands});
}

class DataViewerPdfReport extends StatefulWidget {
  final DataViewerPdfReportController controller;
  late final List<dynamic>? source;
  late final String? title;
  DataViewerPdfReport({
    this.title,
    required this.source,
    required this.controller,
  });

  @override
  _DataViewerPdfReportState createState() => _DataViewerPdfReportState();

  /// criar link de botom para chamada do pdf.
  static Widget createIconButtonLink(
    BuildContext context, {
    required String? title,
    required DataViewerPdfReportController controller,
  }) {
    return IconButton(
        icon: Icon(Icons.share),
        onPressed: () {
          Dialogs.showPage(context,
              child: DataViewerPdfReport(
                  title: title,
                  source: controller.controller.source,
                  controller: controller));
        });
  }
}

class _DataViewerPdfReportState extends State<DataViewerPdfReport> {
  late PdfReportController pdfController;
  @override
  void initState() {
    super.initState();
    pdfController = PdfReportController();
  }

  @override
  Widget build(BuildContext context) {
    return PdfDataPreview(
      controller: pdfController,
      source: [for (var row in widget.source!) row],
      //appBarTitle: widget.title,
      columns: [
        for (var it in widget.controller.controller.columns!)
          if (it.visible)
            PdfReportColumn(
                name: it.name,
                label: (it.label ?? it.name!).toUpperCapital(),
                numeric: it.numeric,
                getValue: it.onGetValue,
                // width: it.width ?? 120,
                builder: (pw.Context? ctx, column, row) {
                  var value = '${row[column.name] ?? ''}';
                  if (column.getValue != null)
                    value = column.getValue!(row[column.name]);

                  return pw.Container(
                      width: column.width,
                      child: pw.Text(
                        value,
                      ));
                })
      ],

      reportTitle: widget.title,
      headerHeight: 40,
      rowsPerPage: 60,
      dataHeaderHeight: widget.controller.dataHeadereHeight,
      bands: widget.controller.bands,
    );
  }
}
