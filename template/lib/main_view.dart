// @dart=2.12
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'settings/config.dart';
import 'injects_build.dart';
import 'routing.dart';
import 'theming.dart';
import 'package:get/get.dart';
import 'package:controls_login/src/config.dart' as cc;
import 'package:controls_web/themes/themes.dart';
import './widgets/windows_size_interfaced.dart'
    if (dart.library.io) './widgets/windows_size_placement.dart' as sz;

configurar(BuildContext context) {
  cc.AppResourcesConst().backgroundColor = Colors.transparent;
  cc.AppResourcesConst().loginBackgroundWidget = Container();
  /*cc.AppResourcesConst().loginChildren = [
    //
  ];*/
  cc.AppResourcesConst().logoAppWidget = Container();
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    if (sz.WindowsSize().isDesktop) {
      sz.WindowsSize().restore();
    }
  }

  @override
  Widget build(BuildContext context) {
    /// carrega as configurações de inicialização do módulo
    configurar(context);

    /// Injects dependências
    /// incluir aqui partes que mudam compartamento em condições
    /// do ambinte que esta utilizando ou em função de algum
    /// recursos a ser injetado para especialização do módulo
    generateInjects(context);

    return FutureBuilder(
      future: Config().setup(autoLogin: inDev),
      builder: (context, snapshot) {
        return DynamicTheme(
          onData: (b) {
            return getTheme(context, brightness: b);
          },
          builder: (_, theme) => GetMaterialApp(
            localizationsDelegates: [
              // ... app-specific localization delegate[s] here
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [const Locale('pt', 'BR')],

            debugShowCheckedModeBanner: false,
            title: appTitle,
            theme: theme,

            /// route de entrada
            initialRoute: homeRoute,

            /// configurar routes ->  em  routing->staticRoutes...
            onGenerateRoute: RoutesApp.generateRoute,
          ),
        );
      },
    );
  }
}
