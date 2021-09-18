// @dart=2.12
import 'package:controls_web/controls/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

getTheme(context, {Brightness brightness = Brightness.dark}) {
  ThemeData theme;
  if (brightness == Brightness.dark) {
    return ThemeData.dark();
  }

  theme = ThemeData(
    primarySwatch: createMaterialColor(Color(0xff2F80ED)),
  ).copyWith(
    //primaryColor: Colors.blue,
    bottomAppBarColor: Colors.transparent,
    indicatorColor: Colors.amber,
    tabBarTheme: TabBarTheme(
        labelColor: Colors.black,
        labelStyle: TextStyle(
          fontSize: GetPlatform.isWeb ? 13 : 11,
          fontWeight: FontWeight.w400,
        )),
  );

  return theme.copyWith(
      //accentIconTheme: theme.accentIconTheme.copyWith(color: Colors.red),
      //floatingActionButtonTheme: theme.floatingActionButtonTheme.copyWith(
      //  backgroundColor: Colors.amber,
      //),
      /*appBarTheme: theme.appBarTheme.copyWith(
      color: Colors.amber[300],
    ),*/
      );
}
