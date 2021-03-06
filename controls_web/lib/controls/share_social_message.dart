import 'dart:typed_data';

import 'package:controls_web/controls/goto.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:universal_io/io.dart';

class ShareSocial {
  static Future<void> shareMessage(String name, String text) async {
    return await Share.share(
      text,
      subject: name,
    );
  }

  static Future<void> shareFile(
      String name, String text, Uint8List bytes) async {
    if (bytes == null) return shareMessage(name, text);

    final documentDirectory = (await getExternalStorageDirectory()).path;
    File imgFile = new File('$documentDirectory/$name.png');
    imgFile.writeAsBytesSync(bytes);

    return await Share.shareFiles(
      ['$documentDirectory/$name.png'],
      text: text,
      subject: name,
    );
  }
}

class ShareWhatsAppWebButton extends StatelessWidget {
  final String? fone;
  final Future<String> Function()? builder;
  final String? texto;

  const ShareWhatsAppWebButton({Key? key, this.texto, this.fone, this.builder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!validar()) return Container();

    //      if (canWhatsWeb(
    //      '${_item.sigcadCodigo}')) // TODO: mudar para fone (celular)
    return IconButton(
        icon: Icon(FontAwesomeIcons.whatsapp),
        onPressed: () {
          compartilharAgendaWhatsWeb();
        });
  }

  bool validar() {
    return (fone!.validarCelular().length == 0);
  }

  void compartilharAgendaWhatsWeb() {
    // chamar o whats.
    if (builder != null)
      builder!().then((texto) => GoTo().goWhats(fone!, texto: texto));
  }
}

extension StringExCelular on String {
  String numberOnly() {
    String value = '';
    for (var k in this.characters) {
      if ('0123456789'.contains(k)) value += k;
    }
    return value;
  }

  String validarCelular() {
    var value = '';
    for (var k in this.characters) {
      if ('0123456789'.contains(k)) value += k;
    }
    String pattern =
        r'\^1\d\d(\d\d)?$|^0800 ?\d{3} ?\d{4}$|^(\(0?([1-9a-zA-Z][0-9a-zA-Z])?[1-9]\d\) ?|0?([1-9a-zA-Z][0-9a-zA-Z])?[1-9]\d[ .-]?)?(9|9[ .-])?[2-9]\d{3}[ .-]?\d{4}$';
    RegExp regExp = new RegExp(pattern);
    print(regExp.stringMatch(value));
    if (value.length == 0) {
      return 'Entre com o número do celular';
    } else if (!regExp.hasMatch(value)) {
      return 'Não é um número de celular válido';
    }
    return '';
  }
}
