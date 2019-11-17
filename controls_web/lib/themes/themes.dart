import 'dart:async';
//import '../drivers.dart';
import "../drivers/local_storage.dart";
import 'package:flutter/material.dart';
import '../controls.dart';



typedef ThemedWidgetBuilder = Widget Function(
    BuildContext context, ThemeData data);

typedef ThemeDataWithBrightnessBuilder = ThemeData Function(
    Brightness brightness);




themeLight(brightness) {
  //defaultTextStyleButton = produtoTextStyle(context);
  defaultScaffoldBackgroudColor = Color.fromRGBO(252, 252, 252, 1);
  /*var r = ThemeData(
      fontFamily: 'Sans',
      scaffoldBackgroundColor: defaultScaffoldBackgroudColor,
      brightness: brightness);*/
  return ThemeData.light() ;
}

themeBlack(bightness) {
//  defaultTextStyleButton = produtoTextStyle(context);
  var r = ThemeData(
    fontFamily: 'Sans',
    brightness: Brightness.dark
    );
  defaultScaffoldBackgroudColor = r.scaffoldBackgroundColor;
  return r;
}

ThemeData changedTheme(brightness) {
  return (brightness == Brightness.light)
          ? themeLight(Brightness.light)
          : themeBlack( Brightness.dark);
}


class DynamicTheme extends StatefulWidget {
  const DynamicTheme(
      {Key key, this.onData, this.builder, this.initial})
      : super(key: key);

  final ThemedWidgetBuilder builder;
  final ThemeDataWithBrightnessBuilder onData;
  final Brightness initial;

  @override
  DynamicThemeState createState() => DynamicThemeState();

  static DynamicThemeState of(BuildContext context) {
    return context.ancestorStateOfType(const TypeMatcher<DynamicThemeState>());
  }
}

class DynamicThemeState extends State<DynamicTheme> {
  ThemeData _data;

  Brightness _brightness;

  static const String _sharedPreferencesKey = 'isDark';

  ThemeData get data => _data;

  Brightness get brightness => _brightness;

  Color get backColor=> (brightness==Brightness.light)?defaultScaffoldBackgroudColor:Colors.black; 
  Color get color=> (brightness==Brightness.light)?Colors.black:Colors.white; 

  onData(b){
    return (widget.onData!=null)? widget.onData(b):changedTheme(b);
  }

  @override
  void initState() {
    super.initState();
    _brightness = widget.initial??Brightness.light ;
    _data = onData(_brightness);

    loadBrightness().then((bool dark) {
      _brightness = dark ? Brightness.dark : Brightness.light;
      _data = onData(_brightness);
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _data = onData(_brightness);
  }

  @override
  void didUpdateWidget(DynamicTheme oldWidget) {
    super.didUpdateWidget(oldWidget);
    _data = onData(_brightness);
  }

  Future<void> setBrightness(Brightness brightness) async {
    setState(() {
      _data = onData(brightness);
      _brightness = brightness;
    });
    setBool(brightness);
  }
 static Brightness getBrightness(){
    //return Brightness.light;
    return LocalStorage().getBool(_sharedPreferencesKey)?Brightness.dark:Brightness.light;
  }

  setBool(Brightness brightness) {
    LocalStorage().setBool(
      _sharedPreferencesKey, brightness == Brightness.dark ? true : false);
  }

  void setThemeData(ThemeData data) {
    setState(() {
      _data = data;
    });
  }

  Future<bool> loadBrightness() async {
    return LocalStorage().getBool(_sharedPreferencesKey) ??
        widget.initial == Brightness.dark;
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _data);
  }
}