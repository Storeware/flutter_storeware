import 'package:flutter/material.dart';

class EntradaView extends StatefulWidget {
  EntradaView({Key key}) : super(key: key);
  @override
  _EntradaViewState createState() => _EntradaViewState();
}

class _EntradaViewState extends State<EntradaView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Text('entrada view'),
    );
  }
}