import 'dart:async';

import 'package:controls_data/local_storage.dart';
import 'package:controls_web/controls/card_panel.dart';
import 'package:controls_web/controls/dialogs_widgets.dart';
import 'package:controls_web/controls/masked_field.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const hideListAtividadeIniciais = 'hideListAtividadeIniciais';

class VerAtividadesIniciaisPage extends StatefulWidget {
  final String? urlYourtube;
  final List<Widget>? children;
  final Widget? child;
  final int? delay;
  const VerAtividadesIniciaisPage(
      {Key? key, this.child, this.urlYourtube, this.delay = 500, this.children})
      : super(key: key);

  @override
  _VerAtividadesIniciaisPageState createState() =>
      _VerAtividadesIniciaisPageState();
}

class _VerAtividadesIniciaisPageState extends State<VerAtividadesIniciaisPage> {
  bool inited = false;
  Timer? timer;
  @override
  Widget build(BuildContext context) {
    if (!inited) {
      timer = Timer(Duration(milliseconds: widget.delay!), () {
        inited = true;
        if (!LocalStorage().getBool(hideListAtividadeIniciais))
          Dialogs.showPage(context,
              height: 350,
              width: 250,
              child: _VerPalyListaPage(
                urlYourtube: widget.urlYourtube!,
                children: widget.children!,
              ));
        timer!.cancel();
      });
    }

    return widget.child!;
  }
}

class _VerPalyListaPage extends StatefulWidget {
  final String? urlYourtube;
  final List<Widget>? children;
  _VerPalyListaPage({Key? key, this.urlYourtube, this.children})
      : super(key: key);

  @override
  __VerPalyListaPageState createState() => __VerPalyListaPageState();
}

class __VerPalyListaPageState extends State<_VerPalyListaPage> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return CardPanel(
      title: Text('Atividades Iniciais'),
      children: [
        if (widget.urlYourtube != null)
          Container(
            color: theme.primaryColor.withAlpha(30),
            child: ListTile(
              title: Text('Ver treinamentos'),
              trailing: Icon(FontAwesomeIcons.youtube, color: Colors.red),
              onTap: () {
                launch(widget.urlYourtube!);
              },
            ),
          ),
        ...widget.children ?? []
      ],
      hideOption: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MaskedSwitchFormField(
          label: 'ver',
          value: !LocalStorage().getBool(hideListAtividadeIniciais),
          onChanged: (b) =>
              LocalStorage().setBool(hideListAtividadeIniciais, !b),
        ),
      ),
    );
  }
}
