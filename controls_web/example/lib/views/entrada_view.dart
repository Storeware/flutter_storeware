// @dart=2.12
import 'package:controls_web/controls/index.dart';
import 'package:controls_web/controls/sliver_apps.dart';
import 'package:app/models/apps_items.dart';
import 'package:app/views/drawer_view.dart';
import 'package:controls_web/controls/tab_choice.dart';
import 'package:controls_web/controls/tabview_bottom.dart';
import 'package:controls_web/controls/vertical_tab_view.dart';
import 'package:controls_web/controls/vertical_toptab_navigator.dart';
import 'package:flutter/material.dart';

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
                    label: 'Outros',
                    // child: Container(child: Text('pagina outros')),
                    builder: () {
                      return Text('Outros');
                    })
              ]);
        });
  }
}
