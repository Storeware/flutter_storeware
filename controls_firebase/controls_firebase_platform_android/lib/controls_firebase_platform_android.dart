library controls_firebase_platform_android;

import 'dart:io';

/// A Calculator.import 'dart:io';
import 'dart:typed_data';
// ignore_for_file:
import 'package:controls_firebase_platform_interface/controls_firebase_platform_interface.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart' as api;
import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as fs;
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';

export 'package:firebase_auth/firebase_auth.dart';

class FirebaseAppDriver extends FirebaseAppDriverInterface {
  FirebaseAppDriver() {
    platform = FirebasePlatform.android;
  }
  api.FirebaseApp app;
  @override
  init(options) async {
    try {
      /// a configuração é feita no ambiente
      app = api.FirebaseApp.instance;
      if (app == null)
        app = await api.FirebaseApp.configure(
            name: 'DEFAULT',
            options: api.FirebaseOptions(
              gcmSenderID: options['858174338114'],
              databaseURL: options['databaseURL'],
              apiKey: options['apiKey'],
              googleAppID: options['appId'],
              projectID: options['projectId'],
              storageBucket: options['storageBucket'],
            ));
      print('Firebase Android Inited');
      return app;
    } catch (e) {
      print('$e');
    }
  }

  //var _storage;
  @override
  storage() {
    return fs.FirebaseStorage.instance;
  }

  @override
  auth() {
    return FirebaseAuthDriver();
  }

  @override
  firestore() {
    return FirestoreDriver();
  }
}

class FirestoreDriver extends FirestoreDriverInterface {
  var store = fb.firestore();
  FirestoreDriver();
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
  setDoc(collection, doc, data, {merge = true}) {
    Map<String, dynamic> d = data.removeWhere((k, v) => k == "id");
    d['dtatualiz'] = DateTime.now().toIso8601String();
    return store
        .collection(collection)
        .doc(doc)
        .set(d, SetOptions(merge: merge));
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
  FirebaseStorageDriver();
  @override
  init() {}

  buildPath(p) {
    return p;
  }

  @override
  Future<int> uploadFileImage(String path, rawPath, {metadata}) async {
    String _fileName = buildPath(path);
    fs.StorageReference firebaseStorageRef =
        FirebaseAppDriver().storage().ref().child(_fileName);
    print('$_fileName:$rawPath');
    final Directory systemTempDir = Directory.systemTemp;
    final File file = await new File('${systemTempDir.path}/temp.jpg').create();
    file.writeAsBytes(rawPath);
    fs.StorageMetadata md;
    md = fs.StorageMetadata(
        cacheControl: "Public, max-age=12345", customMetadata: metadata ?? {});

    fs.StorageUploadTask uploadTask = firebaseStorageRef.putFile(file, md);
    fs.StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    return taskSnapshot.bytesTransferred;
  }

  @override
  Future<String> getDownloadURL(String path) async {
    String _fileName = buildPath(path);
    fs.StorageReference firebaseStorageRef =
        FirebaseAppDriver().storage().ref().child(_fileName);
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
