import 'package:controls_web/controls/notice_activities.dart';
import 'package:controls_web/controls/responsive.dart';
import 'package:controls_web/controls/rounded_button.dart';
import 'package:flutter/material.dart';
import 'models/constantes.dart';
import 'package:controls_web/services/routes.dart';

class MainView extends StatefulWidget {
  MainView({Key? key, this.title}) : super(key: key);
  final String? title;
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ResponsiveBuilder(
      builder: (context, info) => Center(
        child: Column(children: [
          SizedBox(
            height: 70,
          ),
          NoticeTile(
            title: 'Olá Galera baljqçwelrkjçerk;s,fm erkj çqlwekrj oweiruç nm ',
          ),
          Container(
              child: Center(
            child: Image.asset('images/entrar.png'),
          )),
          SizedBox(
            height: 40,
          ),
          Text(widget.title!),
          SizedBox(
            height: 30,
          ),
          RoundedButton(
            height: 40,
            width: info.isDesktop ? 250 : 180,
            buttonName: 'Entrar',
            onTap: () {
              Routes.pushNamed(context, '/menu');
            },
          )
        ]),
      ),
    ));
  }
}
