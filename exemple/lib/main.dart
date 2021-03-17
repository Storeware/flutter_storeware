import 'package:flutter/material.dart';
import 'package:controls/index.dart';

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
  MyHomePage({Key key}) : super(key: key);

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
              label: 'OK',
            ),
            TabChoice(
              label: 'Yes',
            ),
          ]),
        ),
      ),
    ]);
  }
}

class HomeView extends StatelessWidget {
  const HomeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HorizontalTabView(
      //minWidth: 180,
      color: Colors.blue[100],
      indicatorColor: Colors.blue[200],
      tabColor: Colors.blue[100],
      tagColor: Colors.amber,
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
                  child: StrapButton(text: 'Click aqui')),
              Spacer(),
            ],
          )),
        ),
        TabChoice(
            title: Text('Opções2'),
            child: Container(),
            image: Icon(Icons.ac_unit_outlined),
            onPressed: () => Dialogs.info(context, content: Text('OK'))),
        TabChoice(
          title: Text('Opções3'),
          child: Container(),
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
