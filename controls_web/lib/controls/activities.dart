import 'package:controls_web/controls/data_viewer.dart';
import 'package:controls_web/controls/data_viewer_helper.dart';
import 'package:controls_web/controls/dialogs_widgets.dart';
import 'package:controls_web/controls/paginated_grid.dart';
import 'package:controls_web/controls/responsive.dart';
import 'package:estoque/builders/codigo_produto_form_field.dart';
import 'package:estoque/builders/estoper_form_field.dart';
import 'package:estoque/config/config.dart';
import 'package:estoque/models/estmvto_model.dart';
import 'package:flutter/material.dart';
import 'package:controls_extensions/extensions.dart';

/// [class]
class MvtoFichaEstoqueView extends StatefulWidget {
  final String operacao;
  final double filial;
  final String codigo;
  final bool autoEdit;
  MvtoFichaEstoqueView(
      {Key key, this.operacao, this.filial, this.codigo, this.autoEdit = false})
      : super(key: key);

  @override
  _MvtoFichaEstoqueViewState createState() => _MvtoFichaEstoqueViewState();
  static insert(BuildContext context,
      {DataViewerController controller,
      String codigo,
      double filial,
      String operacao}) {
    return Dialogs.showPage(context,
        child: MvtoFichaEstoqueEdit(
          controller: controller ?? MvtoFichaEstoqueView.controller(context),
          data: EstmvtoItem(
            filial: filial ?? Config().filial,
            data: DateTime.now().toDate(),
            bdregestoque: '1',
            operacao: operacao,
            codigo: codigo,
          ).toJson(),
          event: PaginatedGridChangeEvent.insert,
        )).then((rsp) {
      return true;
    });
  }

  static controller(BuildContext context) {
    ResponsiveInfo responsive = ResponsiveInfo(context);
    DataViewerController _controller;
    _controller = DataViewerController(
        top: 10,
        onValidate: (x) {
          return EstmvtoItem.fromJson(x).toJson();
        },
        future: () => EstmvtoItemModel().listMvtoEstoque(
              filter: "a.filial eq ${Config().filial} ",
              orderBy: 'a.id desc',
              top: _controller.top,
              skip: _controller.skip,
            ),
        dataSource: EstmvtoItemModel(),
        keyName: 'id',
        columns: [
          DataViewerHelper.dateTimeColumn(
            DataViewerColumn(name: 'data', label: 'Data', readOnly: true),
            firstDate: DateTime.now().toDate(),
          ),
          DataViewerColumn(name: 'dcto', label: 'dcto'),
          DataViewerColumn(
              name: 'codigo',
              label: 'Código',
              editWidth: (responsive.isSmall) ? responsive.size.width : 450,
              //editHeight: 61,
              editBuilder: (ctrl, column, row, data) {
                return CodigoProdutoFormField(
                    codigo: row['codigo'],
                    onSaved: (x) {
                      row['codigo'] = x;
                    });
              }),
          DataViewerColumn(
              name: 'operacao',
              label: 'Operação',
              editWidth: (responsive.isSmall) ? responsive.size.width : 450,
              editBuilder: (ctrl, column, row, data) {
                return EstOperFormField(
                    codigo: row['operacao'],
                    onSaved: (x) {
                      row['operacao'] = x;
                    });
              }),
          DataViewerColumn(
              name: 'nome',
              label: 'Finalidade/Descrição',
              width: (responsive.isSmall) ? responsive.size.width : 450),
          DataViewerColumn(name: 'qtde', label: 'Qtde', numeric: true),
          DataViewerColumn(name: 'preco', label: 'Preço', numeric: true),
          DataViewerColumn(
            name: 'valor',
            label: 'Valor',
            numeric: true,
            readOnly: true,
          ),
          DataViewerColumn(
              name: 'qestfin',
              label: 'Estoq.Atual',
              numeric: true,
              readOnly: true),
        ]);
    return _controller;
  }
}

class _MvtoFichaEstoqueViewState extends State<MvtoFichaEstoqueView> {
  DataViewerController controller;
  @override
  void initState() {
    super.initState();
    controller = MvtoFichaEstoqueView.controller(context);
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveInfo responsive = ResponsiveInfo(context);
    return Scaffold(
        //appBar: AppBar(title: Text('Movimentação')),
        body: DataViewer(
      canEdit: false,
      canInsert: true,
      canDelete: false,
      header: Container(),
      headerHeight: 1,
      controller: controller,
      onInsertItem: (ctrl) {
        return MvtoFichaEstoqueView.insert(context, controller: controller);
      },
    ));
  }
}

class MvtoFichaEstoqueEdit extends StatelessWidget {
  final DataViewerController controller;
  final Map<String, dynamic> data;
  final PaginatedGridChangeEvent event;
  const MvtoFichaEstoqueEdit({
    Key key,
    this.controller,
    this.data,
    this.event = PaginatedGridChangeEvent.insert,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DataViewerEditGroupedPage(
      controller: controller,
      data: data,
      event: event,
      canInsert: true,
      title: "Lançamento de movimentação de estoques",
      grouped: [
        DataViewerGroup(
          title: 'Identificação',
          children: [
            'data',
            'codigo',
          ],
        ),
        DataViewerGroup(title: 'Operação', children: [
          'dcto',
          'operacao',
        ]),
        DataViewerGroup(
          title: 'Dados',
          children: [
            'qtde',
            'preco',
            'valor',
            'nome',
          ],
        ),
      ],
    );
  }
}
