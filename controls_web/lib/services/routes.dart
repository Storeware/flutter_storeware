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

  var onCallHome;

  static bool goHome(context, String name) {
    if (name == '/home' || name == '/') {
      if (_singleton.onCallHome!=null){
        var h = _singleton.onCallHome(context);
        if (h!=null)
          {
            Navigator.of(context).pushReplacement(h);
            return true;
          }
      }
      Navigator.of(context).pushReplacementNamed(name);
      return true;
    }
    return false;
  }

  static pushNamed(context, name) {
    if (!goHome(context, name)) {
      print('pushNamed: $name');
      var func = Routes().routes[name];
      if (func != null) Navigator.of(context).push(MaterialPageRoute(builder:func));
    }
  }

  static push(context, MaterialPageRoute page) {
    Navigator.of(context).push(page);
  }

  static go(context, page){
     Routes.push(context, MaterialPageRoute(builder:(x)=>page));
  }

  static pushReplacement(context, MaterialPageRoute page) {
    Navigator.of(context).pushReplacement(page);
  }

  static pushReplacementNamed(context, name) {
    if (!goHome(context, name)) {
      var func = Routes().routes[name];
      if (func != null) Navigator.of(context).pushReplacement(MaterialPageRoute(builder:func));
    }
  }

  static pop(context) {
    return Navigator.of(context).pop();
  }

  static popAndPushNamed(context, String name) {
    if (!goHome(context, name)) {
      var func = Routes().routes[name];
      if (func != null) {
        Navigator.of(context).pop();
        Navigator.push(context, MaterialPageRoute(builder:func));
      }
      ;
    }
  }

  static goPage(BuildContext context, {Function next}) {
    var scaff = Scaffold.of(context);
    if (scaff != null && scaff.hasDrawer) {
      Scaffold.of(context).openEndDrawer();
    }
    var page = next();
    Routes.push(context, page);
  }

  add(route, Widget Function(BuildContext) build) {
    routes.addAll({route: build});
    return this;
  }

  addAll(map) {
    return routes.addAll(map);
  }
}
