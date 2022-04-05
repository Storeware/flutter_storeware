import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_storeware/index.dart';

class Mix1View extends StatefulWidget {
  const Mix1View({Key? key}) : super(key: key);

  @override
  State<Mix1View> createState() => _Mix1ViewState();
}

class _Mix1ViewState extends State<Mix1View> {
  List<String>? lista;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        const RadioGrouped(
          title: Text('RadioGrouped'),
          children: ['<10', '10', '20', '>20'],
        ),
        const Divider(),
        Column(
          children: [
            const Text('GroupButtons'),
            GroupButtons(
              itemIndex: 1,
              options: lista ??= ['vencidos', 'hoje', 'este mês', 'a vencer'],
              onChanged: (i) {
                //Dialogs.alert(context, text: lista![i]);
                switch (i) {
                  case 0:
                    Dialogs.info(context,
                        content: const Text('Dialogs.info(..)'),
                        text: lista![i]);
                    break;
                  case 1:
                    Dialogs.okDlg(context,
                        content: const Text('Dialogs.okDlg(..)'));
                    break;
                  case 2:
                    Dialogs.simNao(context,
                        content: const Text('Dialogs.simNao(...)'),
                        text: 'Sim / Não');
                    break;
                  default:
                    Dialogs.alert(context,
                        title: Text(lista![i]),
                        content: const Text('Dialogs.alert(..)'));
                }
              },
            ),
            const Divider(),
            const Text('ApplienceValue'),
            ApplienceValue(
              titleColor: Colors.orange,
              title: 'ApplienceValue',
              value: Random(10).nextInt(100).toString(),
            ),
            const Divider(),
            ApplienceContainer(
              color: Colors.red,
              radius: 5,
              child: const Center(child: Text('ApplienceContainer')),
              height: 100,
              elevation: 10,
            ),
            const Divider(),
            const ApplienceBody(
              child: Text('ApplienceBody'),
            ),
            const DashboardTile(
              title: 'DashboardTile',
              counter: Text(' 123 '),
              avatarColor: Colors.amber,
              color: Colors.indigo,
              value: '10',
              avatarChild: Text('99'),
              image: Icon(Icons.headphones),
            ),
          ],
        ),
      ]).singleChildScrollView(),
    );
  }
}
