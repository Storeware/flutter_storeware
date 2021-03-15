import 'constantes.dart';
import 'package:flutter/material.dart';

import 'package:controls_web/services/routes.dart';

class Menu {
  static final _singleton = Menu._create();
  factory Menu() => _singleton;
  Menu._create() {
    init();
  }
  init() {}

  static builder(context) {
    return ListView(children: [
      ListTile(
        title: Text('Shopping widget demo'),
        onTap: () {
          Routes.pushNamed(context, '/shopping');
        },
      )
    ]);
  }

  static Widget profile() {
    return Column(
        children: [Image.network(Constantes.imagemEntrar), Text('Nome: xyz')]);
  }
}
