library controls_firebase_platform_web;

import 'dart:async';
import 'dart:io';

import 'dart:typed_data';
// ignore_for_file:
import 'package:controls_firebase_platform_interface/controls_firebase_platform_interface.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_web/firebase.dart' as api;
import 'package:firebase_web/firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';

// temporario para testes
//class FirebaseApp extends FirebaseAppDriver {}

class FirebaseAppDriver extends FirebaseAppDriverInterface {
  FirebaseAppDriver() {
    platform = FirebasePlatform.webbrowser;
  }
  var app;
  var options;
  @override
  init(options) async {
    if (options != null) this.options = options;
    try {
      /// a configuração é feita no ambiente
      if ((api.apps != null) || api.apps.isNotEmpty) {
        app = api.apps[0];
      } else
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
      return app;
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
  FirebaseFirestoreDriver firestore() {
    return FirebaseFirestoreDriver();
  }
}

class FirebaseFirestoreDriver extends FirestoreDriverInterface {
  static final _singleton = FirebaseFirestoreDriver._create();
  FirebaseFirestoreDriver._create();
  factory FirebaseFirestoreDriver() => _singleton;

  var store = api.firestore();
  @override
  collection(String path) {
    return store.collection(path);
  }

  @override
  Future<Map<String, dynamic>> getDoc(collection, doc) {
    return store
        .collection(collection)
        .doc(doc)
        .get()
        .then((DocumentSnapshot x) {
      if (!x.exists) return null;
      return {"id": x.id, ...x.data()};
    });
  }

  @override
  genId(collection) {
    store.collection(collection).doc().id;
  }

  @override
  setDoc(String collection, String doc, Map<String, dynamic> data,
      {merge = true}) {
    Map<String, dynamic> d = data; //data.removeWhere((k, v) => k == "id");
    d['dtatualiz'] = DateTime.now().toIso8601String();
    d.remove('id');
    var ref = api.firestore().collection(collection);
    if (doc == null) return ref.add(d);
    var refx = ref.doc(doc);
    // print(['enviando', data]);
    return refx.set(d, SetOptions(merge: merge));
  }

  @override
  getWhere(collection, Function(CollectionReference) where) {
    CollectionReference ref = store.collection(collection);
    Query rst = (where != null) ? where(ref) : ref;
    return rst.get().then((QuerySnapshot doc) {
      return doc.docs.map((f) {
        return {"id": f.id, ...f.data()};
      }).toList();
    });
  }

  @override
  Stream<QuerySnapshot> getonSnapshot(
      collection, Function(CollectionReference) where) {
    CollectionReference ref = store.collection(collection);
    Query rst = (where != null) ? where(ref) : ref;
    return rst.onSnapshot;
  }
}

class FirebaseStorageDriver extends FirebaseStorageDriverInterface {
  static final _singleton = FirebaseStorageDriver._create();
  factory FirebaseStorageDriver() => _singleton;
  FirebaseStorageDriver._create();

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
  static final _singleton = FirebaseAuthDriver._create();
  factory FirebaseAuthDriver() => _singleton;

  FirebaseAuth get instance => FirebaseAuth.instance;
  FirebaseAuthDriver._create();

  @override
  signInWithEmail(email, senha) {
    return instance.signInWithEmailAndPassword(email: email, password: senha);
  }

  get uid => currentUser?.uid;
  @override
  signInAnonymously() {
    instance.onAuthStateChanged.listen((user) {
      currentUser = user;
    });
    return instance.signInAnonymously();
  }

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

  User currentUser;
  @override
  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    final authResult = await _auth.signInWithCredential(credential);
    var user = authResult.user;
    currentUser = await _auth.currentUser;
    assert(user.uid == currentUser.uid);
    return 'signInWithGoogle succeeded: $user';
  }

  @override
  User getCurrentUser() {
    return currentUser;
  }

  @override
  void signOutGoogle() async {
    await googleSignIn.signOut();

    print("User Sign Out");
  }
}
