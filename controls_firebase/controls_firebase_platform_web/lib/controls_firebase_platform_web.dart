library controls_firebase_platform_web;

import 'package:cloud_firestore/cloud_firestore.dart' as cf;
import 'package:controls_firebase_platform_interface/controls_firebase_platform_interface.dart';
import 'package:firebase_core/firebase_core.dart' as fc;
import 'package:firebase_storage/firebase_storage.dart' as fs;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

fc.FirebaseApp _app;
String _gs;

abstract class FirebaseAppDriver extends FirebaseAppDriverInterface {
  FirebaseAppDriver() {
    platform = FirebasePlatform.webbrowser;
  }
  @override
  init(o) async {
    _gs = 'gs://' + o['storageBucket'];
    var options = fc.FirebaseOptions(
      apiKey: o['apiKey'],
      projectID: o['projectId'],
      databaseURL: o['databaseURL'],
      storageBucket: o['storageBucket'],
      googleAppID: o["appId"],
      gcmSenderID: o["messagingSenderId"],
    );
    _app = await fc.FirebaseApp.configure(name: 'DEFAULT', options: options);
  }
}

abstract class FirestoreDriver extends FirestoreDriverInterface {
  FirestoreDriver();
  @override
  collection(String path) {
    return cf.Firestore.instance.collection(path);
  }
}

abstract class FirebaseStorageDriver extends FirebaseStorageDriverInterface {
  FirebaseStorageDriver();
  final fs.FirebaseStorage storage =
      fs.FirebaseStorage(app: _app, storageBucket: _gs);
  @override
  Future<String> getDownloadURL(String path) async {
    //print('ref: $path');
    fs.StorageReference firebaseStorageRef = this.storage.ref().child(path);
    try {
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
    fs.StorageReference firebaseStorageRef = storage.ref().child(path);
    //print('$path:$rawPath');

    fs.StorageMetadata md = fs.StorageMetadata(
        cacheControl: "Public, max-age=12345", customMetadata: metadata ?? {});
    fs.StorageUploadTask uploadTask = firebaseStorageRef.putData(rawPath, md);
    fs.StorageTaskSnapshot taskSnapshot = uploadTask.lastSnapshot;
    return taskSnapshot.bytesTransferred;
  }
}

abstract class FirebaseAuthDriver extends FirebaseAuthDriverInterface {
  FirebaseAuthDriver();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  @override
  createLoginByEmail(email, senha) {
    return _auth.createUserWithEmailAndPassword(email: email, password: senha);
  }

  UserInfo currentUser;
  @override
  isSignedIn() {
    return currentUser != null;
  }

  @override
  Future<FirebaseUser> getCurrentUser() async {
    return _auth.currentUser();
  }

  @override
  logout() {
    return _auth.signOut();
  }

  @override
  Future<FirebaseUser> signInAnonymously() async {
    return _auth.signInAnonymously().then((user) {
      this.currentUser = user.user;
      return user.user;
    });
  }

  @override
  signInWithEmail(String email, String senha) {
    return _auth.signInWithEmailAndPassword(email: email, password: senha);
  }

  @override
  signInWithGoogle() {
    return _googleSignIn.signIn();
  }

  @override
  signOutGoogle() {
    _googleSignIn.signOut();
  }
}
