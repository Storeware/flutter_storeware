// @dart=2.12

import 'config.dart';
import 'package:controls_data/odata_firestore.dart';

import 'dummy_platform.dart'
    if (dart.library.io) 'package:controls_firebase/firebase.dart'
    if (dart.library.js) 'package:controls_firebase/firebase.dart' as fb;
//import 'package:controls_firebase/firebase.dart'
//    if (dart.library.macos) 'dummy_platform.dart' as fb;
import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../models/eventos_item_model.dart';

ValueNotifier<String?> pushMessageId = ValueNotifier<String?>(null);

bool _initedNotification = false;

class Firebase {
  static get isFirebase {
    if (GetPlatform.isWeb || GetPlatform.isAndroid) return true;
    return false;
  }

  static /*fb.FirebaseAppDriver*/ get app =>
      (isFirebase) ? fb.FirebaseApp() : null;

  static signInWithGoogle() {
    if (Firebase.isFirebase) {
      return Firebase.app.auth().signInWithGoogle().then((rsp) {
        // ignore: missing_required_param
        return Firebase.app.auth().currentUser;
      });
    } else
      return null;
  }

  static localNotification(title, body) {
    //fb.FBPushNotification.notification(title, body);
  }

  static pushNotification(usuario, conta, userUid) async {
    if (Firebase.isFirebase) {
      try {
        if (!_initedNotification) {
          _initedNotification = true;
          await fb.FBPushNotification().init(
              'BMcLfnBZPFsvJBNNWw5CLVkh3DX6USkZJQrKp458A2xcefw5w9enmn-tjVHj9t6skSaPmbdiOXCKYqBgp1ezGkg');
        }
      } catch (e) {}

      /* fb.FBPushNotification().onTokenRefresh = (token) {
        CloudV3().client.put('usuarios', {
          "id": usuario,
          "codigo": usuario,
          "conta_uid": conta,
          'messageId': token,
          "uid": userUid
        });
      };
*/
      return fb.FBPushNotification().getToken().then((tkn) {
        pushMessageId.value = tkn;
        CloudV3().client.put('usuarios', {
          "id": usuario,
          "codigo": usuario,
          "conta_uid": conta,
          'messageId': tkn,
          "uid": userUid
        });
        fb.FBPushNotification().stream.listen((v) {
          //print(v);
          bool show = v['show'] ?? true;
          var notification = v['notification'];
          if (notification != null && notification['body'] != null) {
            if (show) {
              Get.snackbar(notification['title'], notification['body'],
                  duration: const Duration(minutes: 5),
                  isDismissible: true,
                  overlayBlur: 0,
                  icon: const Icon(Icons.alarm),
                  mainButton: TextButton(
                    child: const Text('OK'),
                    //shape: new RoundedRectangleBorder(
                    //    borderRadius: new BorderRadius.circular(30.0)),
                    onPressed: () {
                      Navigator.pop(Get.context!);
                    },
                  ),
                  maxWidth: 450,
                  snackPosition: SnackPosition.BOTTOM);
            }

            var data = v['data'] ?? {};

            /// cada dispositivo recebe o seu, se registrar aqui, vai duplicar.
            if (data['id'] != null) {
              EventosItemItem item = EventosItemItem.fromJson({});
              item.arquivado = 'N';
              item.id = data['id'];
              item.data = DateTime.now();
              item.autor = 'PUSH';
              item.pessoa = configInstance!.usuario;

              ///item.dcto = v['data'] ?? '';
              item.idestado = 0;
              item.titulo = notification['title'];
              item.obs = notification['body'];
              EventosItemItemModel().put(item.toJson());
            }
          }
        });

        return tkn;
      });
    } else
      return null;
  }
}
