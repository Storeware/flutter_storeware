import 'dart:async';
import 'package:firebase/firebase.dart' as firebase;
import 'package:controls_firebase_platform_interface/firebase_messaging_interface.dart';

class FBMessaging extends FBMessagingInterface {
  FBMessaging._();
  static FBMessaging _instance = FBMessaging._();
  static FBMessaging get instance => _instance;
  firebase.Messaging _mc;
  String _token;

  final _controller = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get stream => _controller.stream;

  @override
  void close() {
    _controller?.close();
  }

  @override
  Future<void> init() async {
    _mc = firebase.messaging();
    _mc.usePublicVapidKey('FCM_SERVER_KEY');
    _mc.onMessage.listen((event) {
      _controller.add(event?.data);
    });
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
