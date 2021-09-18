// @dart=2.12
import 'package:controls_web/controls.dart';
import 'package:flutter/material.dart';
import '/views/home/home_navigator.dart' as hm;
import 'package:get/get.dart';
import '/settings/config.dart';
import 'package:console/views/opcoes/opcoes_choices.dart';

class DrawerView extends StatelessWidget {
  const DrawerView({Key? key, this.title, this.hideAppBar = false})
      : super(key: key);
  final String? title;
  final bool hideAppBar;
  @override
  Widget build(BuildContext context) {
    //ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: (!hideAppBar) ? AppBar(title: Text(title ?? 'Opções')) : null,
      body: Column(children: [
        ProfileUser(
          usuario: Usuario.fromJson(Config.instance.usuarioData.toJson()),
          versao: appVersao,
        ),
        // Divider(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                for (var item in opcoesChoices(context, showTitle: false))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: StrapButton(
                      text: item.label,
                      radius: 25,
                      minHeight: 50,
                      height: 91,
                      type: StrapButtonType.light,
                      onPressed: () {
                        //Navigator.popUntil(context, ModalRoute.withName('/'));
                        Get.offAllNamed('/');
                        Get.to(() => MobileScaffold(
                              appBar: AppBar(
                                automaticallyImplyLeading: false,
                                title: Text(item.label!),
                                actions: [
                                  if ((item.items != null) &&
                                      (item.builder != null))
                                    for (var sb in item.items!) sb.builder!()
                                ],
                              ),
                              body: item.builder!(),
                              bottomNavigationBar:
                                  hm.BarraNavegacaoPadrao(itemIndex: -1),
                            ));
                      },
                    ),
                  ),
                StrapButton(
                    text: 'Sair',
                    radius: 25,
                    minHeight: 50,
                    height: 91,
                    type: StrapButtonType.light,
                    onPressed: () {
                      Config().logout();
                      Get.offAllNamed('/');
                    }),
              ],
            ),
          ),
        ),
        Container(
            alignment: Alignment.centerRight,
            child: Text('Versão:   $appVersao')),
      ]),
    );
  }
}
