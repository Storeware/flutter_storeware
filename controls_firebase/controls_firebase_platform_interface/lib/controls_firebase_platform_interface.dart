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
  getDoc(collection, doc) {}
  setDoc(collection, doc, data, {merge = true}) {}
  getWhere(collection, Object Function(Object) where) {}
  getonSnapshot(collection, Object Function(Object) where) {}
  genId(collection) {}
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
