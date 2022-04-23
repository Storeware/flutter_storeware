// @dart=2.12

import 'package:controls_data/odata_client.dart';
import 'package:models/builders/controls.dart';
import 'package:flutter/material.dart';

class AgendaResourceBuilder extends StatelessWidget {
  final Widget Function(BuildContext, List<dynamic>) builder;
  const AgendaResourceBuilder({Key? key, required this.builder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ODataBuilder(
      client: ODataInst(),
      query: ODataQuery(
        resource: 'agenda_recurso',
        select: 'gid, nome',
      ),
      cacheControl: 'no-cache',
      builder: (ctx, snap) {
        List<dynamic> items = [];
        if (snap.hasData) items = snap.data.asMap();
        items.sort((a, b) => (a['nome'] ?? '')
            .toString()
            .toUpperCase()
            .compareTo((b['nome'] ?? '').toString().toUpperCase()));
        if (items.isEmpty) items.insert(0, {'gid': '', 'nome': ''});
        return builder(ctx, items);
      },
    );
  }

  static createDropDownFormField(context, String? gid,
      {Function(String)? onChanged}) {
    return AgendaResourceBuilder(builder: (ctx, List<dynamic> items) {
      if ((gid ?? '').isEmpty && (items.length == 1)) gid = items[0]['gid'];

      dynamic corrente = {};
      for (var it in items) {
        if ((it['gid'] ?? '') == (gid ?? '')) corrente = it;
      }
      List<String> keys = [];
      for (var item in items) {
        if (!keys.contains(item['nome'])) keys.add(item['nome']);
      }
      //if (keys.length == 0) keys.add('');

      return FormComponents.createDropDownFormFieldContainer(
          padding: const EdgeInsets.all(0),
          hintText: "Recurso",
          items: keys,
          onChanged: (newValue) {
            var item = items.firstWhere((it) => it['nome'] == newValue);
            if (item != null) {
              //  print(item);
              gid = item['gid'];
              onChanged!(gid ?? '');
            }
          },
          value: corrente['nome'] ?? '');
    });
  }
}
