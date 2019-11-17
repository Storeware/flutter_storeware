import 'package:flutter/material.dart';
import 'package:controls_web/models/resources.dart';

import '../controls.dart';
import '../models.dart';

class LogoutView extends StatefulWidget {
  LogoutView({Key key}) : super(key: key);

  _LogoutViewState createState() => _LogoutViewState();
}

class _LogoutViewState extends State<LogoutView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      children: <Widget>[
        SizedBox(
          height: 80,
        ),
        Image.network(
          Resources.sair,
          height: 200,
        ),
        SizedBox(
          height: 40,
        ),
        Text('Gratidão'),
        SizedBox(
          height: 20,
        ),
        RoundedButton(
            child: Text('Iniciar'),
            onTap: () {
              LoginModel().goEnter(context, '/main');
            })
      ],
    )));
  }
}
