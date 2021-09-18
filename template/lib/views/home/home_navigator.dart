// @dart=2.12
import 'package:console/views/dashboard/eventos/dashboard_eventos_page.dart';
import 'package:flutter/material.dart';
import 'package:controls_web/controls.dart';
import 'package:get/get.dart';

import 'drawer_view.dart';
//import 'package:controls_data/data.dart';

class BarraNavegacaoPadrao extends StatelessWidget {
  const BarraNavegacaoPadrao({
    Key? key,
    this.itemIndex = 0,
  }) : super(key: key);

  final int itemIndex;
  @override
  Widget build(BuildContext context) {
    return MobileBottonNavigatorButton(
      selected: itemIndex,
      hideSelected: itemIndex < 0,
      choices: [
        TabChoice(
          image: Icon(Icons.person_outline, size: 35, color: Colors.grey),
          onPressed: () {
            //configInstance.logout();
            Navigator.popUntil(context, ModalRoute.withName('/'));
            Get.to(() => MobileScaffold(
                  appBar: AppBar(
                    //automaticallyImplyLeading: false,
                    elevation: 0,
                    title: Text('Opções'),
                  ),
                  body: DrawerView(
                    title: null,
                    hideAppBar: true,
                  ),
                  bottomNavigationBar: BarraNavegacaoPadrao(
                    itemIndex: 0,
                  ),
                ));
          },
        ),
        TabChoice(
            image: Icon(Icons.home, size: 35, color: Colors.grey),
            onPressed: () {
              //Navigator.popUntil(context, ModalRoute.withName('/'));
              Navigator.popAndPushNamed(context, '/');
            }),
        TabChoice(
            image: Icon(Icons.notifications_none, size: 35, color: Colors.grey),
            onPressed: () {
              Navigator.popUntil(context, ModalRoute.withName('/'));
              Get.to(() => MobileScaffold(
                    appBar: AppBar(
                        elevation: 0,
// automaticallyImplyLeading: false,
                        title: Text('Alertas')),
                    body: DashEventosView(),
                    bottomNavigationBar: BarraNavegacaoPadrao(itemIndex: 2),
                  ));
            },
            builder: () {
              return StreamBuilder<int>(
                  initialData: _notificationCount,
                  stream: DashEventNotifier().stream,
                  builder: (context, value) {
                    _notificationCount = value.data ?? 0;
                    return Stack(
                      children: [
                        Center(
                          child: Icon(
                              (value.data ?? 0) > 0
                                  ? Icons.notifications_active
                                  : Icons.notifications_none,
                              size: 35,
                              color: Colors.grey),
                        ),
                        if ((value.data ?? 0) > 0)
                          Positioned(
                              right: 2,
                              top: 2,
                              child: Builder(builder: (_) {
                                //DefaultEventosItemPage.notificarNaoLidas(
                                //    value.data ?? 0);
                                return CircleAvatar(
                                  backgroundColor: Colors.red,
                                  child: Text(
                                      '${(value.data! > 9) ? '..' : value.data.toString()}',
                                      style: TextStyle(
                                          fontSize: 9, color: Colors.black87)),
                                  radius: 6,
                                );
                              })),
                      ],
                    );
                  });
            })
      ],
    );
  }
}

int _notificationCount = 0;
