import 'package:controls_web/services/routes.dart';
import 'package:controls_web/themes/themes.dart';

import 'routing.dart';
import 'package:flutter/material.dart';
import 'main_view.dart';

void main() {
  Setup.init();
  return runApp(MyApp());
}

class Setup {
  static init() {}
  static starting() {
    AppRouting(); // inicializa routing
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Setup.starting();
    return DynamicTheme(
      initial: Brightness.dark,
      builder: (ctx, theme) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Console Framework',
        theme: theme,
        routes: Routes().routes,
        home: MainView(title: 'Console Framework'),
      );
    });
  }
}
