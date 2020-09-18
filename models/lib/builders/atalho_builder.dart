import 'package:controls_data/odata_client.dart';
import 'package:console/comum/controls.dart';
import 'package:flutter/material.dart';

class AtalhoBuilder extends StatelessWidget {
  final Widget Function(BuildContext, List<dynamic>) builder;
  const AtalhoBuilder({Key key, @required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ODataInst().send(
          ODataQuery(
            resource: 'ctprod_atalho_titulo',
            select: 'codigo, nome',
          ),
          cacheControl: 'no-cache'),
      builder: (ctx, snap) {
        if (snap.hasData) {
          List<dynamic> items = snap.data['result'];
          try {
            items.sort((a, b) => (a['nome'] ?? '')
                .toString()
                .toUpperCase()
                .compareTo((b['nome'] ?? '').toString().toUpperCase()));
            items.insert(0, {'codigo': 0, 'nome': ''});
          } catch (e) {}
          return builder(ctx, items);
        }
        return Container();
      },
    );
  }

  static createDropDownFormField(context, int codtitulo,
      {Function(int value) onChanged}) {
    return AtalhoBuilder(builder: (ctx, List<dynamic> items) {
      // print('ietms $items');
      var corrente =
          items.firstWhere((item) => (item['codigo'] ?? 0) == (codtitulo ?? 0));
      List<String> keys = [];
      items.forEach((item) {
        if (keys.indexOf(item['nome']) < 0) keys.add(item['nome']);
      });
      if (keys.length == 0) keys.add('');
      // print('$corrente $keys');
      return FormComponents.createDropDownFormFieldContainer(
          padding: EdgeInsets.all(0),
          hintText: "Categoria",
          items: keys,
          onChanged: (newValue) {
            // print('onChange $newValue');
            var item = items.firstWhere((it) => it['nome'] == newValue);
            if (item != null) {
              codtitulo = item['codigo'];
              onChanged(codtitulo);
            }
          },
          value: (corrente ?? {})['nome'] ?? '');
    });
  }
}
