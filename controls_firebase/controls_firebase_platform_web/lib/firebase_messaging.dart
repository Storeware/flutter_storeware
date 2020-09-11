import 'dart:async';
import 'package:firebase/firebase.dart' as firebase;
import 'package:controls_firebase_platform_interface/firebase_messaging_interface.dart';

class FBMessaging extends FBMessagingInterface {
  FBMessaging();
  firebase.Messaging _mc;
  String _token;

  final _controller = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get stream => _controller.stream;

  @override
  void close() {
    _controller?.close();
  }

  @override
  Future<void> init(String keyPair) async {
    _mc = firebase.messaging();
    _mc.usePublicVapidKey(keyPair); // 'FCM_SERVER_KEY');
    _mc.onMessage.listen((event) {
      //_controller.add(event?.data);
      goMessage(event);
    });
  }

  Future<void> goMessage(message) async {
    try {
      var notification = message.notification;
      var title = notification.title;
      var body = notification.body;
      var data = message.data;

      _controller.add({
        "notification": {"title": title, "body": body},
        "show": true
        //"data": data - web retorna objeto nao compativel
      });

      //if (this.localNotification != null)
      //  this.localNotification.showNotification(title: title, body: body);

    } catch (err) {
      print('$err');
    }
  }

  @override
  Future requestPermission() {
    return _mc.requestPermission();
  }

  @override
  Future<String> getToken([bool force = false]) async {
    if (force || _token == null) {
      await requestPermission();
      _token = await _mc.getToken();
    }
    return _token;
  }
}
