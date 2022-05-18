// @dart=2.12
import 'package:controls_web/controls/data_viewer.dart';
import 'package:controls_web/controls/strap_widgets.dart';
import 'package:controls_web/drivers/bloc_model.dart';
import 'package:models/models.dart';
import 'package:flutter/material.dart';

class CadastroContatosPage extends StatefulWidget {
  final double? height;
  final int? top;
  final int page;
  final String? title;
  final String? tipo;
  final bool canInsert;
  final bool canChange;
  final bool canDelete;
  final Function(num?)? onSelected;
  final CrossAxisAlignment crossAxisAlignment;
  CadastroContatosPage(
      {Key? key,
      this.title,
      this.tipo,
      this.height,
      this.top,
      this.crossAxisAlignment = CrossAxisAlignment.center,
      this.page = 1,
      this.canInsert = false,
      this.canChange = false,
      this.canDelete = false,
      this.onSelected})
      : super(key: key);

  @override
  _CadastroClienteWidgetState createState() => _CadastroClienteWidgetState();
}

withDo(item, Function(dynamic) fn) {
  if (item != null) fn(item);
}

class _CadastroClienteWidgetState extends State<CadastroContatosPage> {
  int? top;
  int? page;
  int conta = 0;

  @override
  void initState() {
    top = widget.top;
    page = widget.page;
    controller = DataViewerController(
      onValidate: (x) {
        return SigcadItem.fromJson(x).toJson();
      },
      future: () => getSource(),
      keyName: 'codigo',
      top: widget.top,
    );
    super.initState();
  }

  pageChange(pg) {
    page = pg;
    pageChanged.notify(conta++);
  }

  BlocModel<int> pageChanged = BlocModel<int>();
  ehNumero(t) {
    return double.tryParse(t) != null;
  }

  getFiltro() {
    String s = _filtroController.text;
    String sUpper = s.toUpperCase();
    String rsp = '';
    if (s != '') {
      rsp =
          "  (upper(nome) like '%25$sUpper%25') or (ender like '%25$s%25') or (bairro eq '$s') or (cep='$s')  ";
    }
    bool b = ehNumero(_filtroController.text);
    if (b)
      rsp =
          "  (celular like '%25$s%25' or cnpj like '%25$s%25') or cep like '%25$s%25'   ";
    // print('filter: $rsp');
    return rsp;
  }

  DataViewerController? controller;

  getSource() async {
    String filtro = getFiltro();
    page = 1;
    String tipo = '';

    if (widget.tipo != null) tipo = "tipo eq '$tipo'";
    if (filtro != '') filtro = (tipo != '') ? ' and ' : '' + '($filtro)';
    //print('filtro: $filtro');
    return SigcadItemModel()
        .listRows(
            select: 'codigo,nome,celular,cep,cidade,bairro,ender,numero,email',
            filter: ((tipo.trim() != '') && (filtro.trim() != ''))
                ? " $tipo $filtro  "
                : null,
            top: controller!.top,
            skip: controller!.skip,
            orderBy: (filtro != '') ? 'nome' : 'data desc')
        .then((rsp) => rsp.asMap());
  }

  final TextEditingController _filtroController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    /// se precisar ter uma pagina, criar no chamador
    /// manter aqui somente o widget dos dados para Permitir
    /// reutilizar em outros locais
    return Container(
      height: widget.height ?? MediaQuery.of(context).size.height / 2,
      color: Colors.grey.withOpacity(0.1),
      child: StreamBuilder<Object>(
          stream: pageChanged.stream,
          builder: (context, snapshot) {
            // debugPrint('$page');
            return DataViewer(
              controller: controller,
              crossAxisAlignment: widget.crossAxisAlignment,
              headerHeight: 95,
              onSelected: (x) {
                widget.onSelected!(x['codigo']);
                Navigator.pop(context);
              },
              header: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.title != null) Text(widget.title!),
                  Form(
                    child: Container(
                      height: 60,
                      alignment: Alignment.center,
                      child:
                          ListView(scrollDirection: Axis.horizontal, children: [
                        Container(
                          width: 200,
                          height: 56,
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
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                          height: 50,
                          width: 100,
                          child: StrapButton(
                              type: StrapButtonType.light,
                              text: 'abrir',
                              onPressed: () {
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
              rowsPerPage: top,
              canEdit: widget.canChange,
              canInsert: widget.canInsert,
              canDelete: widget.canDelete,
            );
          }),
    );
  }
}
