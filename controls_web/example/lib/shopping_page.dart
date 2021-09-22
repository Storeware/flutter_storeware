// @dart=2.12
import 'package:app/widget/button_double.dart';
import 'package:flutter/material.dart';
import 'package:controls_web/controls/shopping.dart';

class ShoppingViewDemo extends StatefulWidget {
  ShoppingViewDemo({Key? key, this.title = ''}) : super(key: key);
  final String? title;

  @override
  _ShoppingViewDemoState createState() => _ShoppingViewDemoState();
}

class _ShoppingViewDemoState extends State<ShoppingViewDemo> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: ShoppingScrollView(
        body: Container(
          child: Text('Categorias'),
        ),
        children: <Widget>[
          Container(
            height: 40,
            child: ShoppingListView(color: Colors.greenAccent, children: [
              for (var i = 0; i < 10; i++)
                ShoppingCategory(
                    color: Colors.amber, title: 'Categoria ' + i.toString())
            ]),
          ),
          Text('produtos'),
          ShoppingTile(
            elevation: 0,
            //width: 250,
            color: Colors.amber,
            image: Image.asset(
              'assets/images/atende.png',
              color: Colors.transparent,
              height: 80,
            ),
            title: 'User Interface Design',
            subTitle: '24 lessons',
            rank: 4.3,
            // stars: 1,
            price: '\$ 25,00',
            onPressed: (id) {},
          ),
          ShoppingTile(
            position: MainImagePosition.rigth,
            //width: 250,
            color: Colors.amber,
            image: Image.asset(
              'assets/images/atende.png',
              color: Colors.transparent,
              height: 80,
            ),
            title: 'User Interface Design',
            subTitle: '24 lessons',
            rank: 4.3,
            stars: 1,
            price: '\$ 25',
            onPressed: (id) {},
          ),
          Text('ofertas'),
          Container(
            height: 30,
            child: ShoppingListView(color: Colors.lime, children: <Widget>[
              for (var i = 0; i < 10; i++)
                ShoppingCategory(color: Colors.orange, title: '$i'),
            ]),
          ),
          Text('Destaques'),
          ShoppingTile(
            position: MainImagePosition.top,
            //  width: 250,
            color: Colors.amber,
            image: Image.asset(
              'assets/images/atende.png',
              color: Colors.transparent,
              height: 80,
            ),
            title: 'User Interface Design',
            subTitle: '24 lessons',
            rank: 4.3,
            stars: 1,
            price: '\$ 25',
            onPressed: (id) {},
          ),
          ShoppingTile(
            position: MainImagePosition.bottom,
            width: 250,
            color: Colors.amber,
            image: Image.asset(
              'assets/images/atende.png',
              color: Colors.transparent,
              height: 80,
            ),
            title: 'User Interface Design',
            subTitle: '24 lessons',
            rank: 4.3,
            stars: 1,
            price: '\$ 25',
            onPressed: (id) {},
          ),
          Text(
            'You have pushed the button this many times:',
          ),
          Text(
            '$_counter',
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 60,
        color: Colors.grey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DoubleButton(),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
