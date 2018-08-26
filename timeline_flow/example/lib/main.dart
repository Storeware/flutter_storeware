import 'package:flutter/material.dart';
import 'package:timeline_flow/timeline_flow.dart';
//import 'timeline.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Timeline Flow',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Timeline Flow Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          TimelineProfile(
              margin: EdgeInsets.only(top: 5.0),
              image: AssetImage( 'assets/foto_face.jpg'),
              title: Text('Timeline Flow'),
              subTitle: Text('sample'),
              color: Colors.black12,
          ),
          Expanded(child:Stack(
            children: <Widget>[
              TimelineView.builder( bottom: 40.0, left: 30.0, leftLine: 45.0, bottomLine:40.0,  itemCount: 20, itemBuilder: (index){
                return TimelineTile(
                  title: Text('text $index',),
                  subTitle: Text(' sub-title $index'),
                  icon: Icon( (index.isEven?Icons.history:Icons.check),color: (index.isEven?Colors.red:Colors.blue),),
                  gap: 0.0,
                  trailing: Text('15:00'),
                  );
              }),
            ],
          )),
        ],
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
