// @dart=2.12
//import 'package:universal_platform/universal_platform.dart';
//import 'package:console/config/config.dart';
//import 'package:desktoasts/desktoasts.dart';

//ToastService? service;

mainApp(Function() func) {
  print('IO plataform');
  /*if (UniversalPlatform.isAndroid) {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
  }*/
  /*if (UniversalPlatform.isWindows) {
    service = new ToastService(
      appName: 'Console',
      companyName: 'Storeware',
      productName: 'Console',
    );
    snackbarFunc = (a, b) {
      final Toast toast = new Toast(
        type: ToastType.text02,
        title: a,
        subtitle: b,
      );
      service!.show(toast);
    };
  }*/
  // incluir codigo excluisive para a plataforma
  return func();
}
