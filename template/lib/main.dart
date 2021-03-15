//import 'package:controls_web/themes/themes.dart';
import 'package:flutter/material.dart';

import 'package:controls_web/themes/themes.dart';
import 'routing.dart';
import 'views/main_view.dart';

import 'config/config.dart';
//import 'views/main_view.dart';

void main() {
  ConfigApp().init();
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ConfigApp().setup();
    return DynamicTheme(
        initial: Brightness.dark,
        onData: (b) => DynamicTheme.changeTo(b),
        builder: (ctx, theme) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Console checkout',
            theme: theme,
            routes: RoutesApp().routes,
            home: MainView(),
            //home: TesteView(),
          );
        });
  }
}

class TesteView extends StatefulWidget {
  TesteView({Key? key}) : super(key: key);

  @override
  _TesteViewState createState() => _TesteViewState();
}

class _TesteViewState extends State<TesteView> {
  @override
  Widget build(BuildContext context) {
    print('builder teste');
    return Scaffold(
      appBar: AppBar(title: Text('teste')),
      body: Container(color: Colors.red),
    );
  }
}
