import 'dart:async';
import 'package:controls_firebase_platform_interface/firebase_messaging_interface.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:universal_io/io.dart';
import 'local_notifications.dart';

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
    /// inicializa  LocalNotification
    this.localNotification = LocalNotifications();

    // no android o keyPair vem do arquivo de configuração google-services.json
    _mc = FirebaseMessaging();
    if (Platform.isIOS) iOSPermission();

    _mc.setAutoInitEnabled(true);
    _mc.configure(
      onMessage: (Map<String, dynamic> message) async {
        //_controller.sink.add(message);
        goMessage(message);
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onResume: (Map<String, dynamic> message) async {
        print('onResumo $message');
        _controller.sink.add(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch $message');
        _controller.sink.add(message);
      },
    );
  }

  var localNotification;
  Future<void> goMessage(message) async {
    try {
      var notification = message['notification'];
      var title = notification['title'];
      var body = notification['body'];
      var data = message['data'];
      notification.showNotification(title: title, body: body);
      _controller.add({
        "notification": {"title": title, "body": body},
        "data": data,
        "show": false,
      });
    } catch (err) {
      print('$err');
    }
  }
  @override
  notification(title,body){
      if (this.localNotification != null)
        this.localNotification.showNotification(title: title, body: body);
    
  }

  Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) async {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
      _controller.add(data);
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
      _controller.add(notification);
    }

    // Or do other work.
  }

  @override
  Future requestPermission() {
    return null;
  }

  /// para android

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
