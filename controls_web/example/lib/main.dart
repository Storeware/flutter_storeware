import 'routing.dart';
import 'package:flutter/material.dart';
import 'main_view.dart';

void main() { 
  Setup.init();
  return  runApp(MyApp()); }

class Setup{
  static init(){

  }
  static starting(){
   AppRouting(); // inicializa routing
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Setup.starting();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Console Framework',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //routes: AppRouting().routes,
      home: MainView(title: 'Console Framework'),
    );
  }
}
