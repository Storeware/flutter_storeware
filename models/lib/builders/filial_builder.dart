import 'package:controls_data/odata_client.dart';
import 'package:console/comum/controls.dart';
import 'package:flutter/material.dart';

class FilialBuilder extends StatelessWidget {
  final Widget Function(BuildContext, List<dynamic>) builder;
  const FilialBuilder({Key key, @required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ODataBuilder(
      query: ODataQuery(
        resource: 'filial_todas',
        select: 'codigo, nome',
      ),
      cacheControl: 'max-age=360',
      builder: (ctx, snap) {
        if (snap.hasData) {
          List<dynamic> items = snap.data.asMap();
          items.sort((a, b) => (a['nome'] ?? '')
              .toString()
              .toUpperCase()
              .compareTo((b['nome'] ?? '').toString().toUpperCase()));
          items.insert(0, {'codigo': 0, 'nome': ''});
          return builder(ctx, items);
        }
        return Container();
      },
    );
  }

  static createDropDownFormField(double codigo,
      {Function(double value) onChanged}) {
    return FilialBuilder(builder: (ctx, List<dynamic> items) {
      var corrente =
          items.firstWhere((item) => (item['codigo'] ?? 0) == (codigo ?? 0));
      List<String> keys = [];
      items.forEach((item) {
        if (keys.indexOf(item['nome']) < 0) keys.add(item['nome']);
      });
      return FormComponents.createDropDownFormFieldContainer(
          padding: EdgeInsets.all(0),
          hintText: "Filial",
          items: keys,
          onChanged: (newValue) {
            var item = items.firstWhere((it) => it['nome'] == newValue);
            if (item != null) {
              codigo = item['codigo'] + 0.0;
              onChanged(codigo);
            }
          },
          value: corrente['nome'] ?? '');
    });
  }
}
