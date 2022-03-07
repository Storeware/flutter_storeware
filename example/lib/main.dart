import 'package:flutter/material.dart';
import 'package:controls_web/controls.dart';

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
          title: Text('Opções1'),
          child: Container(
            //color: Colors.white,
            child: Column(
              children: [
                Spacer(),
                Container(
                    width: 200,
                    height: 60,
                    child: StrapButton(height: 60, text: 'StrapButton')),
                Spacer(),
              ],
            ),
          ),
        ),
        TabChoice(
            title: Text('Opções2'),
            child: Container(),
            image: Icon(Icons.ac_unit_outlined),
            onPressed: () => Dialogs.info(context, content: Text('OK'))),
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
}
