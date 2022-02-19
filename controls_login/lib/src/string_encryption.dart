// @dart=2.12

import 'package:encrypt/encrypt.dart';

String globalRandomKey = '2021';

class StringEncryption {
  late String randomKey;
  late Encrypter cryptor;
  late var iv;
  late var key;
  StringEncryption({String? randomKey}) {
    this.randomKey = randomKey ?? globalRandomKey;
    key = Key.fromUtf8(this.randomKey.padRight(32, '.'));
    iv = IV.fromLength(16);
    cryptor = Encrypter(AES(key));
  }
  decrypt(String text) {
    return cryptor.decrypt64(text, iv: iv);
  }

  encrypt(String text) {
    var encrypted = cryptor.encrypt(text, iv: iv);
    return encrypted.base64;
  }
}
