//import "web_firebase_driver.dart";
import "web_firebase_driver.dart"
    if (dart.library.io) 'android_firebase_driver.dart';

class FirebaseApp extends FirebaseAppDriver {
  static final FirebaseApp _singleton = FirebaseApp._create();
  int callStack = 0;
  FirebaseApp._create();
  factory FirebaseApp() {
    return _singleton;
  }
  @override
  init(options) {
    if (callStack == 0) {
      callStack++;
      //print('iniciando firebase');
      super.init(options);
    }
  }

  @override
  FirebaseAuth auth() {
    return FirebaseAuth();
  }

  @override
  Firestore firestore() {
    return Firestore();
  }

  @override
  FirebaseStorage storage() {
    //print('sstorage');
    return FirebaseStorage();
  }
}

class Firestore extends FirestoreDriver {
  static final Firestore _singleton = Firestore._create();
  Firestore._create();
  factory Firestore() {
    return _singleton;
  }
}

class FirebaseAuth extends FirebaseAuthDriver {
  static final FirebaseAuth _singleton = FirebaseAuth._create();
  FirebaseAuth._create();
  factory FirebaseAuth() {
    return _singleton;
  }
}

class FirebaseStorage extends FirebaseStorageDriver {
  static FirebaseStorage _singleton = FirebaseStorage._create();
  FirebaseStorage._create();
  factory FirebaseStorage() {
    return _singleton;
  }
}
