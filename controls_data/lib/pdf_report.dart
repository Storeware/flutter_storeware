import 'dart:typed_data';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:universal_io/io.dart';
import 'package:universal_platform/universal_platform.dart';
//import 'package:controls_extensions/extensions.dart';

/// [PdvReportController] controller para PdfDataPreview
class PdfReportController {
  pw.Document document;
  PdfPageFormat pageFormat;
  String fileName;
  PdfReportController(
      {this.fileName,
      this.pageFormat = PdfPageFormat.a4,
      this.document,
      this.build}) {
    this.document ??= pw.Document();
  }
  Future<Uint8List> save({PdfPageFormat format}) {
    if (format != null) this.pageFormat = format;
    if (!inited) callBuild();
    return document.save();
  }

  final Function(pw.Document document) build;
  callBuild() {
    if (build != null) build(this.document);
    this.inited = true;
  }

  bool inited = false;

  preview() {
    return PdfReportView(controller: this);
  }

  Future<bool> printAsHtml() async {
    return await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => await Printing.convertHtml(
              format: format,
              html: '<html><body><p>Hello!</p></body></html>',
            ));
  }

  Future<bool> print() async {
    if (UniversalPlatform.isWeb) {
      return printAsHtml();
    } else
      return await Printing.layoutPdf(
          onLayout: (pageFormat) async => this.save(format: pageFormat));
  }

  Future<File> saveAs({String path}) async {
    String _path = path;

    if (path == null) {
      final output = await getTemporaryDirectory();
      _path = '${output.path}/${fileName ?? 'examplo.pdf'}';
    }
    final file = File('$_path');
    return await file.writeAsBytes(await document.save());
  }

  Future<bool> sharePdf({String name}) async {
    return await Printing.sharePdf(
        bytes: await document.save(),
        filename: name ?? fileName ?? 'exemplo.pdf');
  }

  Future<List<Uint8List>> pagesAsByte(
      {int pageFrom = 1, int pageTo = 1}) async {
    List<Uint8List> rt = [];
    await for (var page in Printing.raster(await document.save(),
        pages: [
          for (var i = pageFrom; i <= pageTo; i++) i,
        ],
        dpi: 72)) {
      final image = await page.toPng();
      rt.add(image);
    }
    return rt;
  }
}

/// [PdfReportView] - Visualziador de PDF
class PdfReportView extends StatefulWidget {
  final bool canPrint;
  final bool canShare;
  final String title;
  final List<Widget> actions;
  final PdfReportController controller;
  final List<PdfPreviewAction> pageActions;
  final AppBar appBar;
  final void Function(pw.Document document) builder;
  const PdfReportView(
      {Key key,
      @required this.controller,
      this.actions,
      this.builder,
      this.title,
      this.canPrint = true,
      this.canShare = true,
      this.pageActions,
      this.appBar})
      : super(key: key);

  @override
  _PdfReportViewState createState() => _PdfReportViewState();
}

class _PdfReportViewState extends State<PdfReportView> {
  @override
  void initState() {
    super.initState();
    //widget.controller.callBuild();
    if (widget.builder != null) widget.builder(widget.controller.document);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBar ??
          AppBar(
            title: (widget.title == null) ? null : Text(widget.title),
            /*leading: IconButton(
          icon: Icon(Icons.print),
          onPressed: () {
            widget.controller.print();
          },
        ),*/
            actions: [
              ...widget.actions ?? [],
              if (widget.canPrint)
                IconButton(
                    icon: Icon(Icons.print),
                    onPressed: () {
                      widget.controller.print();
                    }),
              if (widget.canShare)
                IconButton(
                    icon: Icon(Icons.share),
                    onPressed: () {
                      widget.controller.sharePdf();
                    }),
            ],
          ),
      body: PdfPreview(
        allowPrinting: false,
        allowSharing: false,
        canChangePageFormat: false,
        onError: (BuildContext context) {
          return Container(child: Text('Não há dados no documento'));
        },
        actions: widget.pageActions,
        initialPageFormat: widget.controller.pageFormat,
        onPrinted: (context) => widget.controller.print(),
        onShared: (context) => widget.controller.sharePdf(),
        build: (format) => widget.controller.save(format: format),
      ),
    );
  }
}

class PdfReportColumn {
  final String name;
  final String label;
  final double width;
  final bool numeric;
  final pw.Alignment alignment;
  final int maxLines;
  final String Function(dynamic) getValue;
  final PdfColor color;
  final pw.Widget Function(
          pw.Context context, PdfReportColumn column, Map<String, dynamic> row)
      builder;
  PdfReportColumn(
      {@required this.name,
      this.numeric = false,
      this.alignment = pw.Alignment.centerLeft,
      this.getValue,
      this.label,
      this.builder,
      this.maxLines = 2,
      this.color,
      this.width = 100});
}

enum PdfBandType {
  header,
  headerDetail,
  detail,
  footerDetail,
  detailTotal,
  pageFooter,
  summary
}

class PdfBand {
  final PdfBandType type;
  int pageNumber;
  PdfBand({this.type, this.pageNumber});
  pw.Widget doBuilder(pw.Context context) {
    return pw.Container();
  }
}

class PdfTitleBand extends PdfBand {
  final String title;
  final double height;
  final pw.Widget Function(pw.Context context) builder;
  PdfTitleBand({this.title, this.builder, this.height = kToolbarHeight})
      : super(type: PdfBandType.header);
  @override
  pw.Widget doBuilder(context) {
    if (builder != null) return builder(context);
    return pw.Container(
        height: this.height,
        child: pw.Column(mainAxisSize: pw.MainAxisSize.min, children: [
          pw.Expanded(
              child: pw.Row(mainAxisSize: pw.MainAxisSize.min, children: [
            pw.Expanded(
                child: pw.Text(this.title,
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    ))),
            pw.Text(formatDate(
                DateTime.now(), [dd, '/', mm, '/', yy, ' ', HH, ':', nn])),
          ])),
          pw.Divider(height: 3),
        ]));
  }
}

class PdfPageHeaderBand extends PdfBand {
  final double height;
  final PdfColor color;
  PdfPageHeaderBand({this.color, this.builder, this.height = 35})
      : super(type: PdfBandType.headerDetail);
  final pw.Widget Function(pw.Context context, PdfPageHeaderBand band) builder;

  @override
  pw.Widget doBuilder(context) {
    return pw.Container(
        height: this.height, color: color, child: builder(context, this));
  }
}

class PdfPageFooterBand extends PdfBand {
  final double height;
  final PdfColor color;
  PdfPageFooterBand({this.color, this.builder, this.height = 35})
      : super(type: PdfBandType.headerDetail);
  final pw.Widget Function(pw.Context context, PdfPageFooterBand band) builder;

  @override
  pw.Widget doBuilder(context) {
    return pw.Container(
        height: this.height, color: color, child: builder(context, this));
  }
}

class PdfHeaderDetailBand extends PdfBand {
  final double height;
  final PdfColor color;
  PdfHeaderDetailBand({this.color, this.builder, this.height = 35})
      : super(type: PdfBandType.headerDetail);
  final pw.Widget Function(pw.Context context, PdfHeaderDetailBand band)
      builder;

  @override
  pw.Widget doBuilder(context) {
    return pw.Container(
        height: this.height, color: color, child: builder(context, this));
  }
}

class PdfFooterDetailBand extends PdfBand {
  final double height;
  final PdfColor color;
  PdfFooterDetailBand({this.color, this.builder, this.height = 35})
      : super(type: PdfBandType.footerDetail);
  final pw.Widget Function(pw.Context context, PdfFooterDetailBand band)
      builder;

  @override
  pw.Widget doBuilder(context) {
    return pw.Container(
        height: this.height, color: color, child: builder(context, this));
  }
}

/// [PdfDetailBand] Banda detalhe
class PdfDetailBand extends PdfBand {
  int index;
  Map<String, dynamic> data;
  final double height;
  final pw.Widget Function(pw.Context context, int index,
      Map<String, dynamic> row, PdfDetailBand band) builder;
  PdfDetailBand(
      {this.data,
      this.index,
      this.afterPrint,
      this.beforePrint,
      this.height,
      this.builder})
      : super(type: PdfBandType.detail);
  final void Function(Map<String, dynamic> data) afterPrint;
  final void Function(Map<String, dynamic> data) beforePrint;
  @override
  doBuilder(context) {
    if (beforePrint != null) beforePrint(data);
    var r = builder(context, index, data, this);
    if (afterPrint != null) afterPrint(data);
    return r;
  }
}

class PdfDetailTotalBand extends PdfBand {
  final pw.Widget Function(pw.Context context) builder;
  final List<String> keys;
  PdfDetailTotalBand({this.keys, this.builder}) : super();
  @override
  doBuilder(context) {
    return builder(context);
  }

  eval(Map<String, dynamic> data) {
    var r = '';
    keys.forEach((key) {
      var v = data[key];
      r += '$v;';
    });

    return r;
  }
}

class PdfFooterBand extends PdfBand {
  final pw.Widget Function(pw.Context context) builder;
  PdfFooterBand({@required this.builder});
  @override
  doBuilder(context) {
    return builder(context);
  }
}

class PdfSummaryBand extends PdfBand {
  final pw.Widget Function(pw.Context context) builder;
  PdfSummaryBand({@required this.builder});
  @override
  doBuilder(context) {
    return builder(context);
  }
}

/// [PdfBands] - tipo de dados para o pdf report
class PdfBands {
  PdfTitleBand title;
  PdfPageHeaderBand pageHeader;
  PdfPageFooterBand pageFooter;
  PdfDetailBand detail;
  PdfHeaderDetailBand headerDetail;
  PdfFooterDetailBand footerDetail;
  PdfDetailTotalBand totalDetail;
  PdfSummaryBand summary;
  PdfFooterBand footer;

  PdfBands({
    this.title,
    this.pageHeader,
    this.pageFooter,
    this.headerDetail,
    this.detail,
    this.footerDetail,
    this.totalDetail,
    this.summary,
    this.footer,
  });
}

//////////////////////////////////////////////////////////////
/// [PdfDataPreview] criar Pdf com base em uma lsita de dados
///

class PdfDataPreview extends StatefulWidget {
  final PdfBands bands;
  final AppBar appBar;
  final String appBarTitle;
  final String reportTitle;
  final List<Map<String, dynamic>> source;
  final List<PdfReportColumn> columns;
  final double dataRowHeight;
  final double dataHeaderHeight;
  final double headerHeight;
  final PdfColor headerColor;
  final double footerHeight;
  final pw.EdgeInsets padding;
  final PdfReportController controller;
  //final pw.Widget Function(
  //    pw.Context context, int index, Map<String, dynamic> row) detailBuilder;
  final pw.Widget Function(pw.Context context, int page) header;
  final pw.Widget Function(pw.Context context, int page) footer;
  final int rowsPerPage;

  final bool canPrint;

  final bool canShare;
  const PdfDataPreview({
    Key key,
    this.reportTitle,
    this.appBarTitle,
    this.padding,
    this.bands,
    this.controller,
    @required this.source,
    @required this.columns,
    //this.controller,
    //this.detailBuilder,
    this.header,
    this.footer,
    this.rowsPerPage,
    this.dataRowHeight = 25,
    this.headerHeight = kToolbarHeight,
    this.dataHeaderHeight = kMinInteractiveDimension,
    this.footerHeight = kMinInteractiveDimension,
    this.headerColor,
    this.appBar,
    this.canPrint = true,
    this.canShare = true,
  }) : super(key: key);

  @override
  _PdfDataPreviewState createState() => _PdfDataPreviewState();

  static tests() {
    return PdfDataPreview(
      reportTitle: 'Movimentações',
      source: [
        for (var i = 1; i < 50; i++) {"codigo": '$i', "nome": "teste$i"},
      ],
      columns: [
        PdfReportColumn(name: 'codigo', label: 'Código'),
        PdfReportColumn(name: 'nome', label: 'Descrição'),
      ],
      bands: PdfBands(
          title: PdfTitleBand(height: 100, title: "Movimento suspeito")),
    );
  }
}

class _PdfDataPreviewState extends State<PdfDataPreview> {
  PdfReportController _controller;
  int get length => widget.source.length;
  int get columnCount => widget.columns.length;
  int rowIndex;
  int _rowsPerPage;
  int get pageCount => pages.length;
  bool inited;
  @override
  void initState() {
    super.initState();
    rows = [];
    inited = false;
    _rowsPerPage = widget.rowsPerPage;
    rowIndex = 0;
    _controller = widget.controller ?? PdfReportController();
    _bands = widget.bands ??
        PdfBands(
          pageFooter: PdfPageFooterBand(
              builder: (ctx, band) => buildFooter(ctx, band.pageNumber)),
        );

    if (widget.columns != null) {
      _bands.detail ??= PdfDetailBand(
          height: widget.dataRowHeight,
          builder: (ctx, index, data, band) => buildRow(context, index, data));
      _bands.pageHeader ??= PdfPageHeaderBand(
          builder: (ctx, band) => buildHeader(ctx, band.pageNumber));
    }

    if (widget.reportTitle != null)
      _bands.title ??=
          PdfTitleBand(title: widget.reportTitle, height: widget.headerHeight);
    //_bands.totalDetail ??= PdfDetailTotalBand(keys: [], builder: (ctx) => null);

    double h = _controller.pageFormat.availableHeight / widget.dataRowHeight;
    double resta = _controller.pageFormat.availableHeight -
        widget.dataHeaderHeight -
        widget.headerHeight -
        widget.footerHeight;
    _rowsPerPage = widget.rowsPerPage ?? (resta ~/ h) + 1;
    buildPdf();
  }

  PdfBands _bands;
  List<PdfBand> rows;

  final Map<int, List<PdfBand>> pages = {};

  add(int pag, PdfBand obj) {
    pages[pag] ??= [];
    obj.pageNumber = pag;
    return pages[pag].add(obj);
  }

  addLast(PdfBand obj) {
    int pag = pages.keys?.last ?? 1;
    return add(pag, obj);
  }

  insert(int pos, int pag, PdfBand obj) {
    pages[pag] ??= [];
    obj.pageNumber = pag;
    return pages[pag].insert(pos, obj);
  }

  buildPdf() {
    //if (inited) return null;
    inited = true;

    //rows.add(PdfHeaderDetailBand(builder: (ctx) => buildHeader(ctx, 1)));

    if (_bands.detail != null)
      for (var i = 0; i < widget.source.length; i++)
        add(
          ((i ~/ _rowsPerPage) + 1),
          PdfDetailBand(
              data: widget.source[i],
              index: i,
              height: _bands.detail.height,
              afterPrint: (_bands.detail.afterPrint == null)
                  ? null
                  : (a) => _bands.detail.afterPrint(a),
              beforePrint: (_bands.detail.beforePrint == null)
                  ? null
                  : (a) => _bands.detail.beforePrint(a),
              builder: (a, b, c, d) => _bands.detail.builder(a, b, c, d)),
        );

    /// inserir sub-totais
    ///

    /// inserir os header e rodapes
    pages.forEach((key, value) {
      if (_bands.pageHeader != null) insert(0, key, _bands.pageHeader);
      if (_bands.pageFooter != null) add(key, _bands.pageFooter);
    });

    /// titulo
    if (_bands.title != null) insert(0, 1, _bands.title);

    /// summary
    if (_bands.summary != null) addLast(_bands.summary);
    if (_bands.footer != null) addLast(_bands.footer);

    /// Construindo o PDF
    _controller.document.document.pdfPageList.pages.clear();

    pages.forEach((key, lst) {
      //lst.forEach((item) {
      //  print([key, item, if (item is PdfDetailBand) item.data]);
      //});
      var items = pw.ListView(children: [
        for (var item in lst) item.doBuilder(null),
      ]);
      var _page = pw.Page(
          pageFormat: _controller.pageFormat,
          margin: widget.padding ?? pw.EdgeInsets.all(8),
          build: (ctx) {
            //final int pg = pagina++;
            return items;
          });
      try {
        _controller.document.addPage(
          _page,
        );
      } catch (e) {
        print('$e');
      }
    });
  }

  T printx<T>(item) {
    print(item);
    return item;
  }

  buildFooter(ctx, page) {
    return pw.Container(
        padding: pw.EdgeInsets.only(left: 8, right: 8),
        color: PdfColor.fromHex('#d0d0d0'),
        height: widget.footerHeight,
        child: pw.Row(children: [
          pw.Expanded(child: pw.Container()),
          pw.Text('$page/$pageCount'),
        ]));
  }

  pw.Widget buildHeader(ctx, page) {
    List<pw.Widget> r = [];
    for (var i = 0; i < columnCount; i++) {
      var column = widget.columns[i];
      var t = column.label ?? column.name;
      r.add(pw.Container(
          width: column.width,
          alignment:
              column.numeric ? pw.Alignment.centerRight : column.alignment,
          child: pw.Text(t,
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
              ))));
    }

    return pw.Container(
        padding: pw.EdgeInsets.only(left: 8, right: 8),
        color: widget.headerColor ?? PdfColor.fromHex('#d0d0d0'),
        height: widget.dataHeaderHeight,
        child: pw.Row(children: r));
  }

  column(int index) => widget.columns[index];

  buildRow(context, index, data) {
    var r = pw.Container(
        padding: pw.EdgeInsets.only(left: 8, right: 8),
        alignment: pw.Alignment.centerLeft,
        height: widget.dataRowHeight,
        child: pw.Row(
          mainAxisSize: pw.MainAxisSize.min,
          mainAxisAlignment: pw.MainAxisAlignment.start,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            for (int col = 0; col < widget.columns.length; col++)
              buildCell(context, col, widget.columns[col], data),
          ],
        ));
    return r;
  }

  buildCell(
      context, int col, PdfReportColumn column, Map<String, dynamic> data) {
    var v = data[column.name];
    return pw.Container(
      alignment: column.numeric ? pw.Alignment.centerRight : column.alignment,
      color: column.color,
      width: column.width,
      child: (column.builder != null)
          ? column.builder(context, column, data)
          : pw.Text(
              (column.getValue != null) ? column.getValue(v) : '$v',
              maxLines: column.maxLines ?? 2,
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PdfReportView(
        title: widget.appBarTitle,
        appBar: widget.appBar,
        canPrint: widget.canPrint,
        canShare: widget.canShare,
        controller: _controller);
  }
}
