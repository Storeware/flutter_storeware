// @dart=2.12

import 'package:controls_data/odata_client.dart';
import 'package:console/comum/controls.dart';
import 'package:flutter/material.dart';

class UnidadeBuilder extends StatelessWidget {
  final Widget Function(BuildContext, List<String>) builder;
  const UnidadeBuilder({Key? key, required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ODataQuery q = ODataQuery(
        resource: 'wba_ctprod_unidade',
        select: 'codigo,descricao',
        orderby: 'codigo');
    return ODataBuilder(
      cacheControl: 'no-cache',
      query: q,
      builder: (ctx, snap) {
        List<String> items = [
          'UN',
          'KG',
          'MT',
          'PT',
          'PC',
          'JG',
          'CX',
          'LT',
          'PR'
        ];
        if (snap.hasData) {
          //print(snap.data);
          items.clear();
          for (var it in snap.data.docs) {
            if (!items.contains(it['codigo'])) items.add(it['codigo']);
          }
        }
        return builder(ctx, items);
      },
    );
  }

  static createDropDownFormField(context,
      {String? unidade,
      Function(String)? onChanged,
      Function(String)? onSaved}) {
    return UnidadeBuilder(builder: (ctx, snap) {
      var _unidade = (unidade ?? 'UN').toUpperCase();
      if (!snap.contains(_unidade)) {
        snap.insert(0, '');
        _unidade = '';
      }
      return FormComponents.createDropDownFormFieldContainer(
          padding: const EdgeInsets.all(0),
          hintText: "Unidade",
          items: snap,
          onChanged: (newValue) {
            // print(newValue);
            unidade = newValue ?? _unidade;
            if (onChanged != null) onChanged(unidade!);
          },
          onSaved: (v) {
            //  print(v);
            unidade = v ?? 'UN';
            if (onSaved != null) onSaved(unidade!);
          },
          value: _unidade);
    });
  }
}
