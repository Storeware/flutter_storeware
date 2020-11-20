import 'package:url_launcher/url_launcher.dart';

class GoTo {
  go(String path) async {
    var s = path.split(':');
    if (path.startsWith('whats')) return goWhats(s[1]);

    await launch(path);
  }

  goUrl(String url) async {
    if (url.startsWith('http')) await launch(url);
  }

  goEmail(email) async {
    await launch(
        'mailto:$email?subject=Aplicativo Estou Entregando&body=Vi no aplicativo que vocês estão entregando em casa, poderia:...');
  }

  goTel(fone) async {
    await launch('tel:$fone');
  }

  goWhats(String numero, {String texto}) async {
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
    // TODO: no estouentregando usa este link e foi alterado a mensagem - refazer no estou entregando para enviar um texto..
    String url =
        'https://api.whatsapp.com/send?phone=$s&text=${texto ?? 'Olá, '}  ';
    //print(s);
    await launch(url);
  }
}
