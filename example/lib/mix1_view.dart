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
              height: 100,
              elevation: 10,
              child: const Center(
                child: Text('ApplienceContainer'),
              ),
            ),
            const Divider(),
            const ApplienceBody(
              child: Text('ApplienceBody'),
            ),
            SizedBox(
              height: 110,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 180,
                        height: 50,
                        color: Colors.blue,
                        child: const LightTile(
                          title: Text('Sample'),
                          tagColor: Colors.orange,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const ApplienceInfoTagged(
              // color: Color.fromARGB(255, 124, 93, 35),
              title: Text('ApplienceInfoTagged'),
              content: Text(
                '''Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum''',
              ),
              bottom: Text('Bottom Child'),
              tagColor: Color.fromARGB(255, 81, 157, 187),
            ),
            Container(
              height: 80,
            )
          ],
        ),
      ]).singleChildScrollView(),
    );
  }
}
