// @dart=2.12
import 'package:app/models/apps_items.dart';
import 'package:app/views/drawer_view.dart';
import 'package:controls_web/controls.dart';
import 'package:flutter/material.dart';
import 'package:controls_web/controls/data_viewer.dart';

class EntradaView extends StatefulWidget {
  EntradaView({Key? key}) : super(key: key);
  @override
  _EntradaViewState createState() => _EntradaViewState();
}

class _EntradaViewState extends State<EntradaView> {
  ValueNotifier<int> tipo = ValueNotifier<int>(0);
  @override
  Widget build(BuildContext context) {
    var tabB = TabViewBottom(
      tabHeight: 70,
      choices: [
        TabChoice(
          title: Text('show1'),
          onPressed: () {},
          child: Container(),
          //icon: Icons.ac_unit_outlined,
          image: Text('1'),
          //builder: () => Text('x'),
        ),
        TabChoice(
          title: Text('show2'),
          builder: () => Text('x'),
        ),
      ],
    );
    return ValueListenableBuilder<int>(
        valueListenable: tipo,
        builder: (_, v, __) {
          if (v == 1)
            return Scaffold(
              appBar: AppBar(title: Text('asss')),
              body: HorizontalTabView(
                //indicatorColor: Colors.amber,
                //tagColor: Colors.amber,
                color: Colors.lightBlue,
                selectedColor: Colors.green,
                indicatorColor: Colors.lightBlue,
                tagColor: Colors.lightBlue,
                choices: [
                  for (var i = 0; i < 5; i++)
                    TabChoice(label: 'opcao $i ', builder: () => Text('$i')),
                ],
              ),
            );
          return VerticalTabView(
              /*bottomNavigationBar: ,*/
              leading: IconButton(
                  icon: Icon(Icons.leak_remove_rounded),
                  onPressed: () {
                    tipo.value = 1;
                  }),
              choices: [
                TabChoice(
                  label: 'Principal',
                  enabled: true,
                  child: VerticalTopTabView(
                    completedColor: Colors.green,
                    //timeline: (x) {
                    // return Icon(Icons.check, size: 10);
                    //},
                    choices: [
                      TabChoice(
                        label: 'Opções',
                        completed: (index) {
                          return true;
                        },
                        builder: () => Scaffold(
                          drawer: Drawer(child: DrawerView()),
                          //appBar: appBarLight(
                          //  title: Text(Constantes.appName),
                          //),
                          body: SliverApps(
                              appBar: SliverAppBar(title: Text('AppBar')),
                              topBars: AppsItems.topBars(context),
                              topBarsHeight: 130,
                              body: AppsItems.body(context),
                              grid: AppsItems.builder(context),
                              bottomBars: AppsItems.bottom(context)),
                        ),
                      ),
                      TabChoice(label: 'Opção 2', builder: () => Text('2')),
                    ],
                  ),
                ),
                TabChoice(
                  label: 'DataViewer',
                  // child: Container(child: Text('pagina outros')),
                  child: DataViewer(
                    rowsPerPage: 100,
                    showPageNavigatorButtons: false,
                    controller: DataViewerController(
                        keyName: 'id',
                        future: () => Future.value(createData()),
                        columns: [
                          DataViewerColumn(name: 'id'),
                          DataViewerColumn(name: 'nome', width: 180),
                          DataViewerColumn(name: 'unidade'),
                          DataViewerColumn(name: 'preco'),
                          DataViewerColumn(name: 'outro', width: 180),
                          DataViewerColumn(name: 'mais', width: 180),
                        ]),
                  ),
                ),
              ]);
        });
  }

  createData() => [
        for (var i = 0; i < 30; i++)
          {
            "id": i,
            "nome": 'asdfasdfs nome aldflj $i',
            "unidade": ['KG', 'PC'][i % 2],
            "preco": i * 0.25,
            "outro": "$i outro teste de coluna",
            "mais": '$i mais uma coluna para navegar lateral'
          }
      ];
}
