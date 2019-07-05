import 'package:flutter/material.dart';
import 'package:sliver_scaffold/sliver_scaffold.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Sample SliverScaffold'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new SliverScaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text('SliverScaffold'),
      ),
      //radius: 0.0,
      //slivers: <Widget>[],
      //grid:<Widget>[],
      backgroundColor: Colors.orange[200],

      sliverAppBar: SliverAppBar(
        actions: <Widget>[Icon(Icons.access_alarms)],
        floating: true,
        centerTitle: true,
        backgroundColor: Colors.orange,
        expandedHeight: 280.0,
        title: Text('SliverAppBar Title'),
        flexibleSpace: FlexibleSpaceBar(
          title: Text('FlexibleSpaceBar Title'),
          background: Image.asset('assets/spacebar.jpg'),
        ),
      ),
      body: DashboardView(
          radius: 0.0,
          cardColor: Colors.blue.withAlpha(150),
          appBar: AppBar(title: Text('Dashboard')),
          cards: [
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              IconButton(
                color: Colors.black,
                icon: Icon(Icons.access_alarm),
                onPressed: () {},
              ),
              Text('Alarm'),
            ]),
            Container(
              width: 50.0,
              child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.home),
              ),
            )
          ],
          listView: <Widget>[
            ListTile(
              title: Text('Dashboard.listView to show childrens...'),
            ),
            Center(
              child: new Text(
                'You have pushed the button this many times:',
              ),
            ),
            Center(
              child: new Text(
                '$_counter',
                style: Theme.of(context).textTheme.display1,
              ),
            ),
          ]),

      floatingActionButton: new FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
