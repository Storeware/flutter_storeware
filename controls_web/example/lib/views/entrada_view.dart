import 'package:app/controls/apps_panel.dart';
import 'package:app/models/apps_items.dart';
import 'package:app/views/drawer_view.dart';
import 'package:controls_web/controls/sliver_scaffold.dart';

import '../models/constantes.dart';
import 'package:flutter/material.dart';

class EntradaView extends StatefulWidget {
  EntradaView({Key key}) : super(key: key);
  @override
  _EntradaViewState createState() => _EntradaViewState();
}

class _EntradaViewState extends State<EntradaView> {
  @override
  Widget build(BuildContext context) {
    return SliverScaffold(
      drawer: Drawer(child: DrawerView()),
      appBar: appBarLight(
        title: Text(Constantes.appName),
      ),
      body: SliverApps(topBars: AppsItems.topBars(), body: AppsItems.body(), grid: AppsItems.builder(context)),
    );
  }
}
