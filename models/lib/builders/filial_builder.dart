// @dart=2.12

import 'package:controls_data/odata_client.dart';
import 'controls.dart';
import 'package:flutter/material.dart';

class FilialBuilder extends StatelessWidget {
  final Widget Function(BuildContext, List<dynamic>) builder;
  const FilialBuilder({Key? key, required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ODataBuilder(
      client: ODataInst(),
      query: ODataQuery(
        resource: 'filial_todas',
        filter: 'codigo>0',
        select: 'codigo, nome',
      ),
      cacheControl: 'max-age=360',
      builder: (ctx, snap) {
        List<dynamic> items = [];
        if (snap.hasData) items = snap.data.asMap();
        items.sort((a, b) => (a['nome'] ?? '')
            .toString()
            .toUpperCase()
            .compareTo((b['nome'] ?? '').toString().toUpperCase()));
        items.insert(0, {'codigo': 0, 'nome': ''});
        return builder(ctx, items);
      },
    );
  }

  static createDropDownFormField(double? codigo,
      {Function(double? value)? onChanged}) {
    return FilialBuilder(builder: (ctx, List<dynamic> items) {
      var i = items.indexWhere(
          (item) => (toDouble(item['codigo'])) == (toDouble(codigo)));
      var corrente = (i < 0) ? {} : items[i];
      List<String> keys = [];
      for (var item in items) {
        if (!keys.contains(item['nome'])) keys.add(item['nome']);
      }
      return FormComponents.createDropDownFormFieldContainer(
          padding: const EdgeInsets.all(0),
          hintText: "Filial",
          items: keys,
          onChanged: (newValue) {
            var item = items.firstWhere((it) => it['nome'] == newValue);
            if (item != null) {
              codigo = item['codigo'] + 0.0;
              onChanged!(codigo);
            }
          },
          value: corrente['nome'] ?? '');
    });
  }
}
