import 'dart:async';
import 'package:controls_data/local_storage.dart';
import 'package:controls_web/controls/defaults.dart';
import 'package:flutter/material.dart';

typedef ThemedWidgetBuilder = Widget Function(
    BuildContext context, ThemeData data);

typedef ThemeDataWithBrightnessBuilder = ThemeData Function(
    Brightness brightness);

ThemeData themeLight(b) => DynamicTheme.light();
ThemeData themeBlack(b) => DynamicTheme.dark();

ThemeData changedTheme(brightness) {
  return (brightness == Brightness.light)
      ? themeLight(Brightness.light)
      : themeBlack(Brightness.dark);
}

class DynamicTheme extends StatefulWidget {
  const DynamicTheme({Key? key, this.onData, this.builder, this.initial})
      : super(key: key);

  final ThemedWidgetBuilder? builder;
  final ThemeDataWithBrightnessBuilder? onData;
  final Brightness? initial;

  @override
  DynamicThemeState createState() => DynamicThemeState();

  static DynamicThemeState? of(BuildContext context) {
    return context.findAncestorStateOfType<
        DynamicThemeState>(); //ancestorStateOfType(const TypeMatcher<DynamicThemeState>());
  }

  static light({fontFamily}) {
    var th = ThemeData(fontFamily: fontFamily, brightness: Brightness.light);
    return th.copyWith(
        appBarTheme: th.appBarTheme.copyWith(
      textTheme: TextTheme(
        headline6: TextStyle(color: Colors.black),
      ),
      elevation: 0,
      color: th.scaffoldBackgroundColor,
      iconTheme: th.iconTheme.copyWith(color: Colors.black),
    ));
  }

  static dark({fontFamily}) {
    var th = ThemeData(fontFamily: fontFamily, brightness: Brightness.dark);
    return th.copyWith(
        appBarTheme: th.appBarTheme.copyWith(
            elevation: 0,
            color: th.scaffoldBackgroundColor,
            iconTheme: th.iconTheme.copyWith(color: Colors.white)));
  }

  static ThemeData changeTo(Brightness b, {fontFamily}) {
    if (b == Brightness.light) {
      return light(fontFamily: fontFamily);
    }
    return dark(fontFamily: fontFamily);
  }
}

class DynamicThemeNotifier {
  static final _singleton = DynamicThemeNotifier._create();
  var notifier = StreamController<Brightness>.broadcast();
  DynamicThemeNotifier._create();
  factory DynamicThemeNotifier() => _singleton;
  notify(Brightness b) {
    notifier.sink.add(b);
  }

  get stream => notifier.stream;
  dispose() {
    notifier.close();
  }
}

class DynamicThemeState extends State<DynamicTheme> {
  ThemeData? _data;

  Brightness? _brightness;

  static const String _sharedPreferencesKey = 'isDark';

  ThemeData? get data => _data;

  Brightness? get brightness => _brightness;

  Color get backColor => (brightness == Brightness.light)
      ? defaultScaffoldBackgroudColor!
      : Colors.black;
  Color get color =>
      (brightness == Brightness.light) ? Colors.black : Colors.white;

  onData(b) {
    //print('onData $b');
    return (widget.onData != null) ? widget.onData!(b) : changedTheme(b);
  }

  @override
  void initState() {
    super.initState();
    //print('initState $_brightness');
    _brightness = widget.initial ?? Brightness.light;
    _data = onData(_brightness);

    loadBrightness().then((bool dark) {
      //print('loadBrightness $dark');
      _brightness = dark ? Brightness.dark : Brightness.light;
      _data = onData(_brightness);
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //print('didChangeDependencies');
    _data = onData(_brightness);
  }

  @override
  void didUpdateWidget(DynamicTheme oldWidget) {
    super.didUpdateWidget(oldWidget);
    //print('didUpdateWidget $_brightness');
    _data = onData(_brightness);
  }

  Future<void> setBrightness(Brightness brightness) async {
    setBool(brightness);
    setState(() {
      _brightness = brightness;
      _data = onData(brightness);
    });
  }

  static Brightness getBrightness() {
    //return Brightness.light;
    //print('getBrightness');
    return LocalStorage().getBool(_sharedPreferencesKey)
        ? Brightness.dark
        : Brightness.light;
  }

  setBool(Brightness brightness) {
    //print('setBool $brightness');
    LocalStorage().setBool(
        _sharedPreferencesKey, brightness == Brightness.dark ? true : false);
  }

  void setThemeData(ThemeData data) {
    //print('setTheme $data');
    setState(() {
      _data = data;
    });
  }

  Future<bool> loadBrightness() async {
    //print('loadBrightness');
    return LocalStorage().getBool(_sharedPreferencesKey);
  }

  @override
  Widget build(BuildContext context) {
    //print('build $_brightness');
    return widget.builder!(context, _data!);
  }
}
