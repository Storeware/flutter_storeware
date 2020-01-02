import 'package:controls_web/services/routes.dart';
import 'package:flutter/material.dart';

import 'views/produto_view.dart';

class RoutesApp {
  static final _singleton = RoutesApp._create();
  factory RoutesApp() => _singleton;
  get routes => Routes().routes;

  RoutesApp._create() {
    Routes().addAll({
      '/produtos': (BuildContext context) => ProdutoGridView()
      // checkLogin(context, acesso: 'admin', next: () {
      //   return ProdutoView();
      // }),
    });
  }
}
