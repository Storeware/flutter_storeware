import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

bool _initedFirestore;


class FirebaseModel {
  FirebaseModel() {
    init();
  }

  init() async {
    if (!_initedFirestore ?? false) {
      final Firestore firestoreX = Firestore(app: FirebaseApp.instance);
      await firestoreX.settings(timestampsInSnapshotsEnabled: true);
      _initedFirestore = true;
    }
  }

  static Firestore firestore() {
    return Firestore.instance;
  }

  static Future<FirebaseOptions> options() async {
    return await FirebaseApp.instance.options;
  }

  static FirebaseApp app() {
    return FirebaseApp.instance;
  }

  static Future<String> getCloudFunctionUrl(servico) async {
    return await options().then((FirebaseOptions r) {
      return "https://us-central1-" +
          r.projectID +
          ".cloudfunctions.net" +
          servico;
    }).catchError((e) {
      throw (e.message);
    });
  }

  static Future<String> getFirehostUrl(servico) async {
    return options().then((FirebaseOptions r) {
      return "https://" +
          r.projectID +
          ".firebaseapp.com" +
          servico; // "https://us-central1-"+r.projectID+".cloudfunctions.net"+servico;
    }).catchError((e) {
      throw (e.message);
    });
  }
}
