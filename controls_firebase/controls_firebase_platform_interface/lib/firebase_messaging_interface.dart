import 'dart:async';
//import 'package:firebase/firebase.dart' as firebase;

// replicado do WEB
abstract class FBMessagingInterface {
  //String _token;
  final _controller = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get stream => _controller.stream;
  void close() {
    _controller?.close();
  }

  Future<void> init(String keyPair);
  Future requestPermission();
  Future<String> getToken([bool force = false]);
  Function(String) onTokenRefresh;
}
