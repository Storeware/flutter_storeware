import 'package:flutter/material.dart';
import 'package:flutter_storeware/index.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Controls - Exemplos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return VerticalTabView(choices: [
      TabChoice(
          label: 'Home',
          child: HomeView(
              //child: Text('xxxxx'),
              )),
      TabChoice(
        label: 'Opções',
        child: Container(
          child: TabViewBottom(choices: [
            TabChoice(
              label: 'Op1',
            ),
            TabChoice(
              label: 'Op2',
            ),
          ]),
        ),
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
      color: Colors.blue[100],
      indicatorColor: Colors.blue[200],
      tabColor: Colors.blue[100],
      tagColor: Colors.amber,
      topBar: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        InkButton(
          child: Icon(Icons.menu),
          onTap: () {
            MenuDialog.show(context, choices: [
              for (var i = 0; i < 10; i++)
                MenuChoice(
                  title: 'Opção $i',
                  onPressed: (x) {
                    print('Opção $i');
                  },
                ),
            ]);
          },
        )
      ]),
      choices: [
        TabChoice(
          title: Text('StrapButton'),
          child: pagina1Builder(notifier, context),
        ),
        TabChoice(
            title: Text('Dialogs.info'),
            image: Icon(Icons.ac_unit_outlined),
            child: Container(
                child: StrapButton(
                    text: 'Button Info',
                    type: StrapButtonType.warning,
                    onPressed: () {
                      Dialogs.info(context,
                          text: 'Titulo', content: Text('Mensagem'));
                    }))),
        TabChoice(
          title: Text('Opções3'),
//          child: Container(),
          items: [TabChoice(label: 'Sub1'), TabChoice(label: 'Sub2')],
        ),
        TabChoice(
          title: Text('Opções4'),
          child: Container(),
        ),
        TabChoice(
          title: Text('Opções5'),
          child: Container(),
        ),
        TabChoice(
          title: Text('Opções6'),
          child: Container(),
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
                Spacer(),
                Text('Radius'),
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
                SizedBox(height: 5),
                Spacer(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
