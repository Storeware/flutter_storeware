library controls_firebase_platform_interface;
//import 'dart:typed_data';

enum FirebasePlatform { android, windows, webbrowser }

abstract class FirebaseAppDriverInterface {
  FirebasePlatform platform = FirebasePlatform.webbrowser;
  get isAndroid => platform == FirebasePlatform.android;
  get isWebBrowser => platform == FirebasePlatform.webbrowser;
  get isWindows => platform == FirebasePlatform.windows;
  init(options);
  storage();
  firestore();
  auth();
  dispose() {}
}

abstract class FirestoreDriverInterface {
  init() {}
  collection(String path) {}
  getDoc(String collection, String doc) {}
  setDoc(String collection, String doc, Map<String, dynamic> data,
      {merge = true}) {}
  getWhere(String collection, Object Function(Object) where) {}
  getonSnapshot(String collection, Object Function(Object) where) {}
  genId(String collection) {}
}

abstract class FirebaseStorageDriverInterface {
  FirebaseStorageDriverInterface();
  init() {}
  Future<int> uploadFileImage(String path, bytes,
      {Map<String, String> metadata});
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
  getCurrentUser() {
    return {};
  }
}
