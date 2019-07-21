import 'package:controls/controls.dart';
import 'package:example/views/demo_page_view.dart';
import 'package:example/views/demo_scaffold_view.dart';
import 'package:flutter/material.dart';
//import 'package:controls/controls.dart' hide SliverScaffold;
//import 'sliver_scaffold_teste.dart' as t;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Controls Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Controls Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return SliverScaffold(
      //radius: 30,
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.title),
      ),
/*      sliverAppBar: SliverAppBar(
        expandedHeight: 70,
        title: Text('Sliver AppBar title'),
        pinned: true,
        backgroundColor: Colors.cyan,
        centerTitle: true ,
        floating: true,
      ),
      extendedBar: ExtendedAppBar(
        color: Colors.red.withAlpha(50),
        child: Center(child:Text('ExtendedAppBar',style:TextStyle(fontSize: 24,color:Colors.red))),
      ),
  */    topRadius: 10,
      bottomRadius: 10,
      bodyTop: -30,
      slivers: [Container(height: 20), Text('xxxxxxxxxxxxxxxxxx')],
      gridCrossAxisCount: 2,
      grid: [
        Container(child: Text('yyyyy'), color: Colors.red),
        Container(child: Text('zzzzz'), color: Colors.green),
        Container(child: Text('zzzzasdfqwer'), color: Colors.amber)
      ],
      body: Column(children: [
        navigateButton(
            context, 'SliverScaffold grid: WidgetList', () => ScaffoldView()),
        navigateButton(context, 'Pageview', () => DemoPageView()),
        StyledButton(
          text: "StyledButton",
          icon: Icon(Icons.account_circle),
          onPressed: () {},
        ),
        DateTimePickerFormField(
          dateOnly: true,
          firstDate: DateTime.now(),
          format: 'dd/MM/yyyy HH:mm',
        ),
        RoundedButton(
          icon: Icons.ac_unit,
          badgeValue: 10,
          buttonName: 'RoundedButton',
          onTap: () {},
        )
      ]),
      //bottomSlivers:[Text('grid bottom')],
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

Widget navigateButton(context, txt, f) {
  return RaisedButton(
      child: Text(txt),
      onPressed: () {
        navigateTo(context, f);
      });
}
