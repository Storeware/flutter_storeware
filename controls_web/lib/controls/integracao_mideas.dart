import 'package:url_launcher/url_launcher.dart';

class IntegracoesMideas {
  static goUrl(String url) async {
    if (url.startsWith('http')) await launch(url);
  }

  static goEmail(email, String subject, String body) async {
    await launch('mailto:$email?subject=$subject&body=$body');
  }

  static goTel(fone) async {
    await launch('tel:$fone');
  }

  static goWhats(String numero, String texto) async {
    var s = '';
    for (var i = 0; i < numero.length; i++) {
      var k = numero[i];
      if ('0123456789'.indexOf(k) >= 0) s += k;
    }
    if (s.length <= 11) {
      if (s.startsWith('55'))
        s = '+' + s;
      else if (!s.startsWith('+55')) s = '+55' + s;
    }
    String url = 'https://api.whatsapp.com/send?phone=$s&text=$texto';
    //print(s);
    await launch(url);
  }
}
