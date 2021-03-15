import 'package:flutter/material.dart';

class WidgetConfigView extends StatefulWidget {
  WidgetConfigView({Key? key}) : super(key: key);

  @override
  _WidgetConfigViewState createState() => _WidgetConfigViewState();
}

class _WidgetConfigViewState extends State<WidgetConfigView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Configuração')),
      body: Container(),
    );
  }
}
