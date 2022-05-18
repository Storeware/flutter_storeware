// @dart=2.12

import 'package:controls_data/odata_client.dart';
import 'package:models/builders/controls.dart';
import 'package:flutter/material.dart';

class AnimalBuilder extends StatelessWidget {
  final double? proprietario;
  final Widget Function(BuildContext, List<dynamic>) builder;
  const AnimalBuilder({Key? key, required this.builder, this.proprietario})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ODataBuilder(
      client: ODataInst(),
      query: ODataQuery(
        resource: 'pet_animal',
        select: 'gid, nome',
        filter: 'sigcad_codigo eq $proprietario',
      ),
      cacheControl: 'no-cache',
      builder: (ctx, snap) {
        List<dynamic> items = [];
        if (snap.hasData) items = snap.data.asMap();
        items.sort((a, b) => (a['nome'] ?? '')
            .toString()
            .toUpperCase()
            .compareTo((b['nome'] ?? '').toString().toUpperCase()));
        items.insert(0, {'gid': '', 'nome': ''});
        return builder(ctx, items);
      },
    );
  }

  static createDropDownFormField(context, double proprietario, String? gid,
      {Function(String?)? onChanged,
      Function(dynamic)? onDataSelected,
      bool readOnly = false}) {
    return AnimalBuilder(
        proprietario: proprietario,
        builder: (ctx, List<dynamic> items) {
          if ((gid ?? '').isEmpty && (items.length == 1)) gid = items[0]['gid'];

          dynamic corrente = {};
          items.forEach((it) {
            if ((it['gid'] ?? '') == (gid ?? '')) corrente = it;
          });
          List<String> keys = [];
          items.forEach((item) {
            if (keys.indexOf(item['nome']) < 0) keys.add(item['nome']);
          });
          //if (keys.length == 0) keys.add('');
          if (onDataSelected != null) onDataSelected(corrente);
          return FormComponents.createDropDownFormFieldContainer(
              padding: EdgeInsets.all(0),
              hintText: "Nome do PET",
              items: keys,
              readOnly: readOnly,
              onChanged: (newValue) {
                var item = items.firstWhere((it) => it['nome'] == newValue);
                if (item != null) {
                  //  print(item);
                  gid = item['gid'];
                  onChanged!(gid);
                  if (onDataSelected != null) onDataSelected(item);
                }
              },
              value: corrente['nome'] ?? '');
        });
  }
}
