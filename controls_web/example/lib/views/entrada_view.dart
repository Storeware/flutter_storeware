import 'package:controls_web/controls/sliver_apps.dart';
import 'package:app/models/apps_items.dart';
import 'package:app/views/drawer_view.dart';
import 'package:controls_web/controls/tab_choice.dart';
import 'package:controls_web/controls/vertical_tab_view.dart';
import 'package:controls_web/controls/vertical_toptab_navigator.dart';
import 'package:flutter/material.dart';

class EntradaView extends StatefulWidget {
  EntradaView({Key key}) : super(key: key);
  @override
  _EntradaViewState createState() => _EntradaViewState();
}

class _EntradaViewState extends State<EntradaView> {
  @override
  Widget build(BuildContext context) {
    return VerticalTabView(choices: [
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
                    topBarsHeight: 120,
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
          builder: () {
            return Text('Outros');
          })
    ]);
  }
}
