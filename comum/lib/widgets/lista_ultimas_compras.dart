import 'package:comum/widgets/widget_data.dart';
import 'package:comum/widgets/widgets_base.dart';
import 'package:controls_data/odata_client.dart';
import 'package:controls_web/controls/home_elements.dart';
import 'package:flutter/material.dart';

class ListaUltimasCompras extends WidgetBase {
  @override
  Widget builder(context) {
    return ODataBuilder(
      query: ODataQuery(
        resource: 'sigflu',
        select:
            'sigflu.data vcto, sigflu.banco,  sigflu.dcto, c.nome, sigflu.valor ',
        top: 10,
        join: 'join sigcad c on (c.codigo=sigflu.clifor)',
        filter: " sigflu.codigo between '201'  and '229' ",
        orderby: 'sigflu.insercao desc',
      ),
      builder: (ctx, snap) {
        //if (snap.hasData) print(['compras:', snap.data.docs]);
        if (!snap.hasData) return Container();
        var docs = snap.data.docs;
        return createItems(context, docs);
      },
    );
  }

  List<Color> cors = [];
  Widget _drawItem(i, docs) {
    var doc = docs[i];
    return ApplienceTimeline(
      height: 70,
      color: cors[i % 2],
      tagColor: ((doc['banco'] ?? '') == '') ? Colors.red : Colors.green,
      body: Container(
          width: double.maxFinite,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      doc['nome'],
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //alignment: WrapAlignment.spaceEvenly,
                  //spacing: 5,
                  //crossAxisAlignment:Axis,
                  children: <Widget>[
                    Container(
                        width: 90,
                        child: Text(' Vcto: ' + doc['vcto'].toString())),
                    Text('Dcto: ' + doc['dcto']),
                    Container(
                        width: 120,
                        alignment: Alignment.centerRight,
                        child: Text(' \$ ' +
                            double.tryParse(doc['valor'].toString())!
                                .toStringAsFixed(2))),
                  ],
                )
              ])),
    );
  }

  createItems(ctx, docs) {
    cors = [
      Theme.of(ctx).primaryColor.withAlpha(10),
      Theme.of(ctx).primaryColor.withAlpha(50),
    ];
    List<Widget> rt = [
      Container(
          child: Text('Compras', style: TextStyle(color: Colors.white54)),
          color: Theme.of(ctx).primaryColor.withAlpha(100)),
      for (var i = 0; i < docs.length; i++) _drawItem(i, docs)
    ];

    return ListView.builder(
      itemCount: rt.length,
      itemBuilder: (ctx, i) {
        return rt[i];
      },
    );
  }

  @override
  void register() {
    // registrar na lista de widgets
    var item = WidgetItem(
        id: '201912211325',
        title: 'Lista últimas compras',
        chartTitle: 'Compras',
        active: true,
        build: (context) {
          return builder(context);
        });
    return WidgetData().footers.add(item);
  }
}
