import 'firebase_interfaces.dart';

class FirebaseAppDriver extends FirebaseAppDriverInterface {
  @override
  auth() {
    // TODO: implement auth
    throw UnimplementedError();
  }

  @override
  firestore() {
    // TODO: implement firestore
    throw UnimplementedError();
  }

  @override
  init(options) {
    // TODO: implement init
    throw UnimplementedError();
  }

  @override
  storage() {
    // TODO: implement storage
    throw UnimplementedError();
  }
}

class FirestoreDriver extends FirestoreDriverInterface {
  @override
  collection(String path) {
    // TODO: implement collection
    throw UnimplementedError();
  }
}

class FirebaseAuthDriver extends FirebaseAuthDriverInterface {
  @override
  createLoginByEmail(email, senha) {
    // TODO: implement createLoginByEmail
    throw UnimplementedError();
  }

  @override
  isSignedIn() {
    // TODO: implement isSignedIn
    throw UnimplementedError();
  }

  @override
  logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  signInAnonymously() {
    // TODO: implement signInAnonymously
    throw UnimplementedError();
  }

  @override
  signInWithEmail(String email, String senha) {
    // TODO: implement signInWithEmail
    throw UnimplementedError();
  }

  @override
  signInWithGoogle() {
    // TODO: implement signInWithGoogle
    throw UnimplementedError();
  }

  @override
  signOutGoogle() {
    // TODO: implement signOutGoogle
    throw UnimplementedError();
  }
}

class FirebaseStorageDriver extends FirebaseStorageDriverInterface {
  @override
  Future<String> getDownloadURL(String path) {
    // TODO: implement getDownloadURL
    throw UnimplementedError();
  }

  @override
  Future<int> uploadFileImage(String path, bytes) {
    // TODO: implement uploadFileImage
    throw UnimplementedError();
  }
}
