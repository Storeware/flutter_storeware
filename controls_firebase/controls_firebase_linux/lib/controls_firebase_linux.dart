library controls_firebase_linux;

import 'package:controls_firebase_platform_interface/controls_firebase_platform_interface.dart';

class FirebaseAppDriver extends FirebaseAppDriverInterface {
  FirebaseAppDriver() {
    platform = FirebasePlatform.linux;
  }

  @override
  auth() {
    // TODO: implement auth
    //throw UnimplementedError();
  }

  @override
  firestore() {
    // TODO: implement firestore
    //throw UnimplementedError();
  }

  @override
  init(options) {
    // TODO: implement init
    //throw UnimplementedError();
  }

  @override
  storage() {
    // TODO: implement storage
    //throw UnimplementedError();
  }
}

class FirebaseFirestoreDriver extends FirestoreDriverInterface {}

class FirebaseStorageDriver extends FirebaseStorageDriverInterface {
  @override
  Future<String> getDownloadURL(String path) {
    // TODO: implement getDownloadURL
    //throw UnimplementedError();
  }

  @override
  // ignore: missing_return
  Future<int> uploadFileImage(String path, bytes,
      {Map<String, String> metadata}) async {
    // TODO: implement uploadFileImage
    //throw UnimplementedError();
  }
}

class FirebaseAuthDriver extends FirebaseAuthDriverInterface {
  @override
  createLoginByEmail(email, senha) {
    // TODO: implement createLoginByEmail
    //throw UnimplementedError();
  }

  @override
  isSignedIn() {
    // TODO: implement isSignedIn
    //throw UnimplementedError();
  }

  @override
  logout() {
    // TODO: implement logout
    //throw UnimplementedError();
  }

  @override
  signInAnonymously() {
    // TODO: implement signInAnonymously
    //throw UnimplementedError();
  }

  @override
  signInWithEmail(String email, String senha) {
    // TODO: implement signInWithEmail
    //throw UnimplementedError();
  }

  @override
  signInWithGoogle() {
    // TODO: implement signInWithGoogle
    //throw UnimplementedError();
  }

  @override
  signOutGoogle() {
    // TODO: implement signOutGoogle
    //throw UnimplementedError();
  }
}
