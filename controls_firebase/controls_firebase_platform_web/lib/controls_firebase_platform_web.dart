library controls_firebase_platform_android;

import 'dart:async';
import 'dart:io';

import 'dart:typed_data';
// ignore_for_file:
import 'package:controls_firebase_platform_interface/controls_firebase_platform_interface.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_web/firebase.dart' as api;
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';
export 'package:firebase_auth/firebase_auth.dart';

class FirebaseAppDriver extends FirebaseAppDriverInterface {
  FirebaseAppDriver() {
    platform = FirebasePlatform.android;
  }
  var app;
  var options;
  @override
  init(options) async {
    this.options = options;
    try {
      /// a configuração é feita no ambiente
      app = api.initializeApp(
        // name: "selfandpay",
        messagingSenderId: options['858174338114'],
        databaseURL: options['databaseURL'],
        apiKey: options['apiKey'],
        //googleAppID: options['appId'],
        projectId: options['projectId'],
        storageBucket: options['storageBucket'],
      );
      print('carregou firebase');
    } catch (e) {
      print('$e');
    }
  }

  //var _storage;
  @override
  FirebaseStorageDriver storage() {
    return FirebaseStorageDriver();
  }

  @override
  FirebaseAuthDriver auth() {
    return FirebaseAuthDriver();
  }

  @override
  FirestoreDriver firestore() {
    return FirestoreDriver();
  }
}

class FirestoreDriver extends FirestoreDriverInterface {
  FirestoreDriver();
  @override
  collection(String path) {
    return api.firestore().collection(path);
  }
}

class FirebaseStorageDriver extends FirebaseStorageDriverInterface {
  @override
  init() {}

  buildPath(p) {
    return p;
  }

  @override
  Future<int> uploadFileImage(String path, rawPath, {metadata}) async {
    String _fileName = buildPath(path);
    api.StorageReference firebaseStorageRef = api.storage().ref(_fileName);
    api.UploadMetadata md;
    md = api.UploadMetadata(
        cacheControl: "Public, max-age=12345", customMetadata: metadata ?? {});
    api.UploadTask uploadTask = firebaseStorageRef.put(rawPath, md);
    return uploadTask.future.then((resp) {
      //firebaseStorageRef.updateMetadata(md);
      api.UploadTaskSnapshot taskSnapshot = uploadTask.snapshot;
      return taskSnapshot.bytesTransferred;
    });
  }

  @override
  Future<String> getDownloadURL(String path) async {
    String _fileName = buildPath(path);
    api.StorageReference firebaseStorageRef = api.storage().ref(_fileName);
    try {
      return firebaseStorageRef.getDownloadURL().then((x) {
        return x.toString();
      });
    } catch (e) {
      print('$e');
      return '';
    }
  }

  List<String> naoTem = [];
  clear() {
    naoTem.clear();
  }

  Future<File> _getSingleFile(context, path) async {
    var url;
    if (naoTem.indexOf(path) < 0) {
      try {
        url = await getDownloadURL(path);
        if (url == '')
          naoTem.add(path);
        else
          naoTem.remove(path);
      } catch (e) {
        naoTem.add(path);
      }
    } else {
      url = path;
    }
    return DefaultCacheManager().getSingleFile(url);
  }

  Widget download(BuildContext context,
      {String path,
      double width,
      double height,
      Widget Function(File) builder,
      Function(Uint8List) onComplete}) {
    if ((path ?? '') == '') return Container();
    return FutureBuilder<File>(
        future: _getSingleFile(context, path),
        builder: (x, y) {
          if ((!y.hasData))
            return (builder != null) ? builder(null) : Container();
          if (onComplete != null)
            y.data.readAsBytes().then((x) {
              onComplete(x);
            });
          return ClipRRect(
            borderRadius: new BorderRadius.circular(50),
            child: (builder != null)
                ? builder(y.data)
                : Image.file(y.data, width: width, height: height),
          );
        });
  }
}

class FirebaseAuthDriver extends FirebaseAuthDriverInterface {
  FirebaseAuth get instance => FirebaseAuth.instance;
  FirebaseAuthDriver();
  @override
  signInWithEmail(email, senha) {
    return instance.signInWithEmailAndPassword(email: email, password: senha);
  }

  @override
  signInAnonymously() => instance.signInAnonymously();
  @override
  createLoginByEmail(email, senha) =>
      instance.createUserWithEmailAndPassword(email: email, password: senha);
  @override
  logout() => instance.signOut();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  Future<bool> isSignedIn() async {
    return await googleSignIn.isSignedIn();
  }

  FirebaseUser currentUser;
  @override
  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    final AuthResult authResult = await _auth.signInWithCredential(credential);
    FirebaseUser user = authResult.user;
    currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    return 'signInWithGoogle succeeded: $user';
  }

  @override
  FirebaseUser getCurrentUser() {
    return currentUser;
  }

  @override
  void signOutGoogle() async {
    await googleSignIn.signOut();

    print("User Sign Out");
  }
}
