import 'dart:async';
import 'package:controls_firebase_platform_interface/firebase_messaging_interface.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:universal_io/io.dart';

class FBMessaging extends FBMessagingInterface {
  FBMessaging();

  FirebaseMessaging _mc;
  String token;

  final _controller = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get stream => _controller.stream;

  //@override
  void close() {
    _controller?.close();
  }

  //@override
  Future<void> init(String keyPair) async {
    // no android o keyPair vem do arquivo de configuração google-services.json
    _mc = FirebaseMessaging();
    if (Platform.isIOS) iOSPermission();

    //_mc.setAutoInitEnabled(true);
    _mc.configure();
    /* _mc.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("on message $message");
        _controller.add(message);
      },
      onResume: (Map<String, dynamic> message) async {},
      onLaunch: (Map<String, dynamic> message) async {},
    );*/
  }

  @override
  Future requestPermission() {
    return null;
  }

  void iOSPermission() {
    _mc.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _mc.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  @override
  Future<String> getToken([bool force = false]) async {
    return _mc.getToken().then((tkn) {
      token = tkn;
      return tkn;
    });
  }
}
