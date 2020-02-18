import 'dart:io';
import 'dart:typed_data';
// ignore_for_file:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as fs;
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'firebase_interfaces.dart';

class FirebaseAppDriver extends FirebaseAppDriverInterface {
  FirebaseAppDriver();
  FirebaseApp app;
  @override
  init(options) async {
    /* try {
      app = await FirebaseApp.configure(
          name: "selfandpay",
          options: FirebaseOptions(
            apiKey: "AIzaSyDXi7uALH0TIxeDoDvc_4VHVdp13BFFDNk",
            googleAppID: "1:858174338114:android:38fb65e736f1465236e9db",
            projectID: "selfandpay",
            storageBucket: "selfandpay.appspot.com",
          ));
    } catch (e) {
      print('$e');
    }*/
  }

  //var _storage;
  @override
  storage() {
    return fs.FirebaseStorage.instance;
    //return FirebaseStorageDriver();
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
  FirestoreDriver();
  @override
  collection(String path) {
    // TODO: implement collection
    throw UnimplementedError();
  }
}

class FirebaseStorageDriver extends FirebaseStorageDriverInterface {
  static final _singleton = FirebaseStorageDriver._create();
  FirebaseStorageDriver._create();
  factory FirebaseStorageDriver() => _singleton;

  @override
  init() {}

  buildPath(p) {
    return p;
  }

  @override
  Future<int> uploadFileImage(String path, rawPath) async {
    String _fileName = buildPath(path);
    fs.StorageReference firebaseStorageRef =
        FirebaseAppDriver().storage().ref().child(_fileName);
    print('$_fileName:$rawPath');
    final Directory systemTempDir = Directory.systemTemp;
    final File file = await new File('${systemTempDir.path}/temp.jpg').create();
    file.writeAsBytes(rawPath);
    fs.StorageUploadTask uploadTask = firebaseStorageRef.putFile(file);
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
    final FirebaseUser user = authResult.user;

    //assert(!user.isAnonymous);
    //assert(await user.getIdToken() != null);

    currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    return 'signInWithGoogle succeeded: $user';
  }

  @override
  void signOutGoogle() async {
    await googleSignIn.signOut();

    print("User Sign Out");
  }
}
