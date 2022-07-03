// @dart=2.12
import 'package:controls_data/local_storage.dart';
import 'package:controls_web/controls/color_picker.dart';
import 'package:controls_web/controls/colors.dart';
import 'package:controls_web/controls/data_viewer.dart';
import 'package:flutter/material.dart';
import 'package:controls_extensions/extensions.dart';
import 'package:universal_platform/universal_platform.dart';

const defaultButtonBackgoundAvatar = Color(0xFFb3e5fc);
Color scaffoldBackgroundColor = const Color(0xFFf5f5f5);
Color backgroundColor = const Color(0xFFf5f5f5);
Color sidebarBackgroundColor = Colors.transparent; //Colors.lightBlue[50];
Color primaryColor = Colors.blue[200]!;
const primaryAssentColor = Color(0xFF808080);
const primaryDarkColor = Color(0xFF808080);
const errorColor = Color(0xFF808080);
Color cardColor = Colors.blue.withAlpha(30);
Color gridColor = Colors.white.withAlpha(100);
Color oddColor = Colors.blue[200]!.withAlpha(20);
Color evenColor = Colors.blue[200]!.withAlpha(10);
Color titleColor = Colors.lightBlue.withAlpha(30);
Color footerColor = Colors.lightBlue.withAlpha(15);
Color tabBarThemeLabelColor = Colors.blue;
Color sidebarHeaderColor = Colors.lightBlue.withOpacity(0.5);
Color textColor = Colors.black87;
Color primaryTextColor = Colors.white;
Color curvaColor = Colors.blue.shade500;

_base() {
  oddColor = primaryColor.withAlpha(30);
  evenColor = primaryColor.withAlpha(10);
  DefaultDataViewerTheme()
    ..dataRowHeight = fontPequena ? 30 : 45
    ..headingTextStyle = TextStyle(fontSize: fontPequena ? 12 : 14);
}

getTheme(context, {Brightness brightness = Brightness.dark}) {
  DefaultDataViewerTheme().dataRowHeight = fontPequena ? 35 : 40;
  String schemaCores = LocalStorage().getKey('schema_cores') ?? '';

  var theme = (brightness == Brightness.dark)
      ? ThemeData.dark()
      : ThemeData(
          primarySwatch: createMaterialColor(
          ColorExtension.fromHex(
            schemaCores.isEmpty ? Colors.blue.lighten(50).toHex() : schemaCores,
          ),
        ));

  theme = theme.copyWith(
    textTheme: Theme.of(context).textTheme.apply(
          fontFamily: 'Inter',
          fontSizeFactor: fontPequena ? 0.80 : 1.0,
          fontSizeDelta: 0.8,
        ),
  );

  _base();

  if (theme.brightness == Brightness.dark) {
    scaffoldBackgroundColor = theme.scaffoldBackgroundColor;
  } else {
    scaffoldBackgroundColor = theme.primaryColor.lighten(90);
  }

  var t = theme.copyWith(
    scaffoldBackgroundColor: scaffoldBackgroundColor,
    indicatorColor: primaryColor.mix(Colors.amber),
    tabBarTheme: theme.tabBarTheme.copyWith(
        labelStyle: TextStyle(
      fontSize: UniversalPlatform.isAndroid ? 11 : 12,
      fontWeight: FontWeight.w500,
    )),
    textTheme: theme.textTheme
      ..caption!.copyWith(
        fontSize: fontPequena ? 14 : 16,
        fontWeight: FontWeight.w500,
      )
      ..bodyText1!.copyWith(
        fontWeight: FontWeight.w300,
        fontSize: fontPequena ? 11 : 14,
      )
      ..bodyText2!.copyWith(
        fontWeight: FontWeight.w300,
        fontSize: fontPequena ? 11 : 14,
      ),
    primaryTextTheme: theme.primaryTextTheme
      ..caption!.copyWith(
        fontWeight: FontWeight.w300,
        fontSize: fontPequena ? 12 : 14,
      )
      ..headline6!.copyWith(color: Colors.indigo)
      ..bodyText1!.copyWith(
        fontSize: getFontSize,
        fontWeight: FontWeight.w300,
      )
      ..bodyText2!.copyWith(
        fontSize: getFontSize,
        fontWeight: FontWeight.w300,
      ),
    inputDecorationTheme: InputDecorationTheme(
        hintStyle: theme.textTheme.caption!
            .copyWith(color: Colors.amber, fontSize: 11)),
  );

  scaffoldBackgroundColor = t.scaffoldBackgroundColor; //.withOpacity(0.9);
  backgroundColor = t.backgroundColor;
  cardColor = t.primaryColor; //.lighten(50);
  primaryColor = t.primaryColor;
  tabBarThemeLabelColor =
      t.appBarTheme.backgroundColor ?? theme.primaryTextTheme.bodyText1!.color!;
  textColor = t.textTheme.button!.color ?? theme.textTheme.bodyText1!.color!;
  primaryTextColor = t.primaryTextTheme.bodyText1!.color!;
  curvaColor = t.primaryColor;
  sidebarHeaderColor = t.primaryColor; //.lighten(50);
  sidebarBackgroundColor = t.scaffoldBackgroundColor.darken(40).withAlpha(5);

  // print(['Theme', schemaCores]);

  return t;
}

double get getFontSize => (fontPequena) ? 11.0 : 13.0;

bool get fontPequena =>
    UniversalPlatform.isLinux ||
    UniversalPlatform.isMacOS ||
    UniversalPlatform.isWeb;

extension ColorMix on Color {
  Color mix(Color color) {
    var r = (color.red + red) ~/ 2;
    var g = (color.green + green) ~/ 2;
    var b = (color.blue + blue) ~/ 2;
    int a = (color.alpha + alpha) ~/ 2;
    return Color.fromARGB(a, r, g, b);
  }

  double get luminance => (0.299 * red + 0.587 * green + 0.114 * blue) / 255;
}
