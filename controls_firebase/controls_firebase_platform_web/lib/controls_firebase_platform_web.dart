library controls_firebase_platform_web;

import 'package:controls_firebase_platform_interface/controls_firebase_platform_interface.dart';
import 'package:firebase_web/firebase.dart' as fb;

export 'package:firebase_web/firebase.dart';

abstract class FirebaseAppDriver extends FirebaseAppDriverInterface {
  FirebaseAppDriver() {
    platform = FirebasePlatform.webbrowser;
  }
  static fb.App app;
  @override
  init(options) {
    app = fb.initializeApp(
      authDomain: options['authDomain'],
      storageBucket: options['storageBucket'],
      apiKey: options['apiKey'],
      databaseURL: options['databaseURL'],
      projectId: options['projectId'],
      messagingSenderId: options['messagingSenderId'],
      name: options['name'],
    );
  }
}

abstract class FirestoreDriver extends FirestoreDriverInterface {
  FirestoreDriver();
  @override
  collection(String path) {
    return fb.firestore().collection(path);
  }
}

abstract class FirebaseStorageDriver extends FirebaseStorageDriverInterface {
  FirebaseStorageDriver();
  @override
  Future<String> getDownloadURL(String path) async {
    //print('ref: $path');
    fb.StorageReference firebaseStorageRef = fb.storage().ref(path);
    try {
      //print('carregou: $path');
      return firebaseStorageRef.getDownloadURL().then((x) {
        //print('Retorno: $x');
        return x.toString();
      });
    } catch (e) {
      print('$e');
      return '';
    }
  }

  @override
  Future<int> uploadFileImage(String path, rawPath, {metadata}) async {
    fb.StorageReference firebaseStorageRef =
        fb.storage(FirebaseAppDriver.app).ref(path);
    //print('$path:$rawPath');

    fb.UploadMetadata md;
    md = fb.UploadMetadata(
        cacheControl: "Public, max-age=12345", customMetadata: metadata ?? {});

    fb.UploadTask uploadTask = firebaseStorageRef.put(rawPath, md);
    fb.UploadTaskSnapshot taskSnapshot = uploadTask.snapshot;
    return taskSnapshot.bytesTransferred;
  }
}

abstract class FirebaseAuthDriver extends FirebaseAuthDriverInterface {
  FirebaseAuthDriver();
  @override
  createLoginByEmail(email, senha) {
    return fb.auth().createUserWithEmailAndPassword(email, senha);
  }

  fb.User currentUser;
  @override
  isSignedIn() {
    return currentUser != null;
  }

  @override
  fb.User getCurrentUser() {
    return currentUser;
  }

  @override
  logout() {
    return fb.auth().signOut();
  }

  @override
  Future<fb.UserCredential> signInAnonymously() async {
    //print('signInAnonymously()');
    return fb.auth().signInAnonymously().then((user) {
      //print('${user.user}');
      this.currentUser = user.user;
      return user;
    });
  }

  @override
  signInWithEmail(String email, String senha) {
    return fb.auth().signInWithEmailAndPassword(email, senha);
  }

  @override
  signInWithGoogle() {
    // TODO: implement signInWithGoogle
    throw UnimplementedError();
  }

  @override
  signOutGoogle() {}
}
