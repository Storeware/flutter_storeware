library controls_firebase_platform_interface;
//import 'dart:typed_data';

abstract class FirebaseAppDriverInterface {
  init(options);
  storage();
  firestore();
  auth();
  dispose() {}
}

abstract class FirestoreDriverInterface {
  init() {}
  collection(String path);
}

abstract class FirebaseStorageDriverInterface {
  FirebaseStorageDriverInterface();
  init() {}
  Future<int> uploadFileImage(String path, bytes);
  Future<String> getDownloadURL(String path);
}

abstract class FirebaseAuthDriverInterface {
  init() {}
  signInAnonymously();
  signInWithEmail(String email, String senha);
  isSignedIn();
  createLoginByEmail(email, senha);
  logout();
  signInWithGoogle();
  signOutGoogle();
}
