import 'package:exemple/controls_activities_view.dart';
import 'package:exemple/controls_clean_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_storeware/index.dart';

import 'charts_view.dart';
import 'controls_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Controls - Exemplos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return VerticalTabView(choices: [
      TabChoice(
          label: 'Home',
          child: const HomeView(
              //child: Text('xxxxx'),
              )),
      TabChoice(
        label: 'Opções',
        child: TabViewBottom(choices: [
          TabChoice(
            label: 'Op1',
          ),
          TabChoice(
            label: 'Op2',
          ),
        ]),
      ),
    ]);
  }
}

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ValueNotifier<double> notifier = ValueNotifier(5);
    return HorizontalTabView(
      //minWidth: 180,
      activeIndex: 4,
      color: Colors.blue[100],
      indicatorColor: Colors.blue[200],
      tabColor: Colors.blue[100],
      tagColor: Colors.amber,
      topBar: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        InkButton(
          child: const Icon(Icons.menu),
          onTap: () {
            MenuDialog.show(context, choices: [
              for (var i = 0; i < 10; i++)
                MenuChoice(
                  title: 'Opção $i',
                  onPressed: (x) {
                    // ignore: avoid_print
                    print('Opção $i');
                  },
                ),
            ]);
          },
        )
      ]),
      choices: [
        TabChoice(
          title: const Text('StrapButton'),
          child: pagina1Builder(notifier, context),
        ),
        TabChoice(
            title: const Text('Dialogs.info'),
            image: const Icon(Icons.ac_unit_outlined),
            child: StrapButton(
                text: 'Button Info',
                type: StrapButtonType.warning,
                onPressed: () {
                  Dialogs.info(context,
                      text: 'Titulo', content: const Text('Mensagem'));
                })),
        TabChoice(
          title: const Text('SubMenus'),
          items: [TabChoice(label: 'Sub1'), TabChoice(label: 'Sub2')],
        ),
        TabChoice(
          title: const Text('Controls-Web'),
          child: const ControlsView(),
        ),
        TabChoice(
          title: const Text('Clean'),
          child: const ControlsCleanView(),
        ),
        TabChoice(
          title: const Text('Activities'),
          child: const ControlsActivitiesView(),
        ),
        TabChoice(
          label: 'charts',
          child: const ChartsView(),
        ),
      ],
    );
  }

  Row pagina1Builder(ValueNotifier<double> notifier, BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ValueListenableBuilder<double>(
            valueListenable: notifier,
            builder: (z, b, d) => Column(
              children: [
                const Spacer(),
                const Text('Radius'),
                Container(
                  alignment: Alignment.center,
                  child: GroupButtons(
                    itemIndex: 0,
                    options: ['5', '10', '15'],
                    onChanged: (x) {
                      notifier.value = (x.toDouble() + 1) * 5;
                    },
                  ),
                ).box(width: 150),
                for (var i = 0; i < StrapButtonType.values.length; i++)
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: StrapButton(
                      height: 60,
                      width: 220,
                      radius: b,
                      type: StrapButtonType.values[i],
                      text: StrapButtonType.values[i].toString().split('.')[1],
                      onPressed: () {
                        Scaffold(
                          body: Container(
                            color: strapColor(StrapButtonType.values[i]),
                          ),
                        ).showDialog(context,
                            title: StrapButtonType.values[i].toString(),
                            desktop: true);
                      },
                    ),
                  ),
                const SizedBox(height: 5),
                const Spacer(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
