import 'firebase_interfaces.dart';
import 'package:firebase_web/firebase.dart' as fb;
//import 'package:firebase_auth/firebase_auth.dart' as fa;

abstract class FirebaseAppDriver extends FirebaseAppDriverInterface {
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
  @override
  collection(String path) {
    return fb.firestore().collection(path);
  }
}

abstract class FirebaseStorageDriver extends FirebaseStorageDriverInterface {
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
  Future<int> uploadFileImage(String path, rawPath) async {
    fb.StorageReference firebaseStorageRef =
        fb.storage(FirebaseAppDriver.app).ref(path);
    //print('$path:$rawPath');
    fb.UploadTask uploadTask = firebaseStorageRef.put(rawPath);
    fb.UploadTaskSnapshot taskSnapshot = uploadTask.snapshot;
    return taskSnapshot.bytesTransferred;
  }
}

abstract class FirebaseAuthDriver extends FirebaseAuthDriverInterface {
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
