// @dart=2.12

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class VejaNossosProdutos extends StatelessWidget {
  final TextStyle? style;
  const VejaNossosProdutos({
    Key? key,
    //@required this.theme,
    this.style,
  }) : super(key: key);

  //final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          launch('https://wbagestao.com');
        },
        child: Column(
          children: [
            Image.asset(
              'assets/package.png',
              width: 70,
            ),
            DefaultTextStyle(
                style: theme.primaryTextTheme.bodyText1!,
                child: Container(
                  width: 80,
                  child: Text('Conheça nossos outros produtos',
                      textAlign: TextAlign.center,
                      style: style ??
                          TextStyle(color: Colors.white, fontSize: 10)),
                )),
            //         SizedBox(
            //           height: 20,
            //         )
          ],
        ),
      ),
    );
  }
}
