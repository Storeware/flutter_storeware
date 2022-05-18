// @dart=2.12
import 'package:models/models.dart';

import 'package:controls_web/controls/data_viewer.dart';
import 'package:flutter/material.dart' hide FormFieldBuilder;

import 'dropdown_builder.dart';
import 'form_field_search_builder.dart';

class EstadosDropdownBuilder extends StatelessWidget {
  final String? value;
  final Function(String) onChanged;
  const EstadosDropdownBuilder({Key? key, this.value, required this.onChanged})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return DropdownDataBuilder.createDropDownFormField(context,
        value: value,
        collection: 'estados',
        fields: 'sigla,nome',
        keyField: 'sigla',
        nameField: 'nome',
        label: 'Estado',
        onChanged: onChanged);
  }
}

class EstadosFormField extends StatelessWidget {
  final String? value;
  final Function(String)? onChanged;
  const EstadosFormField({Key? key, this.value, this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormFieldSearchBuilder(
        label: 'Estado',
        value: value,
        dialogSize: const Size(380, 650),
        onDialogBuild: (v, callback) =>
            EstadosPage(onSelected: (x) => callback(x)),
        onSearch: (sigla, callback) {
          return EstadosItemModel()
              .procurar(sigla ?? '')
              .then((rsp) => callback(rsp));
        },
        keyField: 'sigla',
        onChanged: (x) {
          onChanged!(x ?? '');
        },
        nameField: 'nome');
  }
}

/// [class]
class EstadosPage extends StatefulWidget {
  final Function(dynamic)? onSelected;
  const EstadosPage({Key? key, this.onSelected}) : super(key: key);

  @override
  _EstadosPageState createState() => _EstadosPageState();
}

class _EstadosPageState extends State<EstadosPage> {
  DataViewerController? controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Estados - UFs')),
      body: DataViewer(
          canDelete: false,
          canEdit: false,
          canInsert: false,
          showPageNavigatorButtons: false,
          onSelected: (x) {
            widget.onSelected!(x);
            Navigator.pop(context, x);
          },
          controller: controller ??= DataViewerController(
              onValidate: (x) {
                return EstadosItem.fromJson(x).toJson();
              },
              future: () {
                String? filter;
                if (controller!.filter.isNotEmpty) {
                  filter =
                      "sigla = '${controller!.filter}' or nome like '%25${controller!.filter}%25' ";
                }

                return EstadosItemModel()
                    .listCached(filter: filter, orderBy: 'sigla');
              },
              dataSource: EstadosItemModel(),
              keyName: 'sigla',
              columns: [
                DataViewerColumn(name: 'sigla', label: 'Sigla UF'),
                DataViewerColumn(name: 'nome', label: 'Nome'),
                //DataViewerColumn(name: 'aliqicms', label: 'Alíq.ICMS'),
                //DataViewerColumn(name: 'codigoibge_uf', label: 'Cód.IBGE UF'),
              ]),
          beforeShow: (ctrl) {
            /// redefine atributos para as colunas
            // if (ctrl is PaginatedGridController) {
//            DataViewerHelper.hideColumn(ctrl.findColumn('gid_servidor'));
//            DataViewerHelper.simnaoColumn(ctrl.findColumn('inativo'));
          }
          //},
          ),
    );
  }
}
