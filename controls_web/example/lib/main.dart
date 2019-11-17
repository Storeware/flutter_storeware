import 'package:app/models/config_app.dart';
import 'package:controls_web/services/routes.dart';
import 'models/apps_items.dart';
import 'routing.dart';
import 'package:flutter/material.dart';
import 'main_view.dart';
import './themes/themes.dart';
import 'models/constantes.dart';

void main() {
  Setup.init();
  return runApp(MyApp());
}

class Setup {
  static init() 
  {
    ConfigApp();
    AppsItems();
  }
  static starting() {
    AppRouting(); // inicializa routing
  }
}

class MyApp extends StatelessWidget {

  ThemeData themesEvents(Brightness b) {
    if (b==Brightness.light) return ThemeData.light();
    return ThemeData.dark();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Setup.starting();
    return DynamicTheme(
        onData: (b) {
          return themesEvents(b);
        },
        initial: Brightness.dark,
        builder: (ctx, theme) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: Constantes.appName,
            theme: theme,
            routes: Routes().routes,
            home: MainView(title: Constantes.appName ),
          );
        });
  }
}
