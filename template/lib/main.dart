// @ dart=2.12
import 'package:comum/services/config_service.dart';
import 'package:controls_web/controls/injects.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'main_view.dart';
import 'package:universal_io/io.dart';
import 'config/config.dart';
import 'main_js.dart' if (dart.library.io) 'main_io.dart';

void main() {
/* if (Platform.isAndroid)
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.light,
    ));
*/
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = new MyHttpOverrides();

  Intl.defaultLocale = 'pt_BR';
  //CurrencyExtension.setDefaultLocale('pt_BR');

  Config().init().then((r) {
    runApp(InjectBuilder(
      child: ChangeNotifierProvider<LoginChanged>(
          create: (x) => LoginChanged(),
          lazy: false,
          builder: (a, b) => mainApp(() => MyApp())),
    ));
  });
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) {
        print(host);
        return true;
      });
  }
}
