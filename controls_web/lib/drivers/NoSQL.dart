//import 'package:controls_firebase/firebase_firestore.dart';
import 'package:firebase_web/firestore.dart';

class NoSQL {
  String _collection;
  set(key, values) {
    /*return FirestoreApp()
        .collection(_collection)
        .doc(key)
        .set(values, SetOptions(merge: true));
        */
  }

  collection(collectionName) {
    _collection = collectionName;
    return this;
  }

  String insert(values) {
    /* var qry = FirestoreApp().collection(_collection);
    var key = qry.id;
    qry.doc(key).set(values);
    */
    // return key;
  }

  get(key) {
    //return FirestoreApp().collection(_collection).doc(key).get();
  }

  delete(key) {
    // return FirestoreApp().collection(_collection).doc(key).delete();
  }

  find(fieldPath, opStr, value, {num limit}) {
    /* Query qry = FirestoreApp()
        .collection(_collection)
        .where(fieldPath, opStr, value)
        .limit(limit ?? 1000);
    return qry.get();
    */
  }
}

class Preferences extends NoSQL {
  static final _singleton = Preferences._create();
  Preferences._create() {
    this._collection = 'preferences';
  }
  factory Preferences() => _singleton;
}
