import 'package:flutter/material.dart';

class Routes {
  static final _singleton = Routes._create();
  Routes._create();
  factory Routes() => _singleton;
  static Routes of(context) {
    return Routes();
  }

  Map<String, Widget Function(BuildContext)> routes = {};
  staticRoutes() {
    return this;
  }


  add(route, Widget Function(BuildContext) build) {
    routes.addAll({route: build});
    return this;
  }

  addAll(map) {
    return routes.addAll(map);
  }
}
