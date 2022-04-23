// @dart=2.12

import 'package:controls_data/odata_client.dart';
import 'package:console/comum/controls.dart';
import 'package:flutter/material.dart';

class AgendaEstadoBuilder extends StatelessWidget {
  final Widget Function(BuildContext, List<dynamic>) builder;
  const AgendaEstadoBuilder({Key? key, required this.builder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ODataBuilder(
      client: ODataInst(),
      query: ODataQuery(
        resource: 'agenda_estado',
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
        items.insert(0, {'gid': '', 'nome': ''});
        return builder(ctx, items);
      },
    );
  }

  static createDropDownFormField(context, String? gid,
      {Function(String)? onChanged, String? label}) {
    return AgendaEstadoBuilder(builder: (ctx, List<dynamic> items) {
      if ((gid ?? '').isEmpty && (items.length == 1)) gid = items[0]['gid'];

      dynamic corrente = {};
      items.forEach((it) {
        if ((it['gid'] ?? '') == (gid ?? '')) corrente = it;
      });
      List<String> keys = [];
      items.forEach((item) {
        if (keys.indexOf(item['nome']) < 0) keys.add(item['nome']);
      });
      if (keys.length == 0) keys.add('');

      if (corrente['nome'] == '' && items.length > 1) corrente = items[1];

      return FormComponents.createDropDownFormFieldContainer(
          padding: EdgeInsets.all(0),
          hintText: label ?? "Estado da Agenda",
          style: TextStyle(color: Colors.grey[400]),
          items: keys,
          onChanged: (newValue) {
            var item = items.firstWhere((it) => it['nome'] == newValue);
            if (item != null) {
              gid = item['gid'];
              onChanged!(gid ?? '');
            }
          },
          value: corrente['nome'] ?? '');
    });
  }
}
