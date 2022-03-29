import 'package:flutter/material.dart';
import 'package:flutter_storeware/index.dart';
import 'package:controls_web/controls/notice_activities.dart';

class ControlsView extends StatelessWidget {
  const ControlsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Controls_web-samples')),
        body: ResponsiveBuilder(
          builder: (context, info) => Center(
            child: Column(children: [
              const SizedBox(
                height: 70,
              ),
              const NoticeTile(
                title:
                    'Olá Galera baljqçwelrkjçerk;s,fm erkj çqlwekrj oweiruç nm ',
              ),
              Center(
                child: Container(), // Image.asset('assets/images/entrar.png'),
              ).sizedBox(width: 100, height: 100).shadow(),
              const SizedBox(
                height: 40,
              ),
              const Text('box()').paddingAll().box(),
              const SizedBox(
                height: 30,
              ),
              RoundedButton(
                height: 40,
                width: info.isDesktop ? 250 : 180,
                buttonName: 'Entrar',
                onTap: () {
                  //Routes.pushNamed(context, '/menu');
                },
              )
            ]),
          ),
        ));
  }
}
