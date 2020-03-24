import 'package:controls_web/controls.dart';
import 'package:controls_web/controls/notice_activities.dart';
import 'package:flutter/material.dart';

class Dialogs {
  static Future<void> showLoadingDialog(BuildContext context, GlobalKey key,
      {Widget title, Widget content}) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  title: title,
                  key: key,
                  backgroundColor: Colors.black54,
                  children: <Widget>[
                    Center(
                      child: Column(children: [
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Processando....",
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                        if (content != null) content,
                      ]),
                    )
                  ]));
        });
  }

  static show(context,
      {Widget title, List<Widget> children, List<Widget> actions}) {
    showDialog(
        context: context,
        builder: (ctx) {
          return SimpleDialog(
            title: title,
            children: <Widget>[...children ?? [], ...actions ?? []],
          );
        });
  }

  static info(context, {String text}) {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (x) => NoticeTag(
              text: text,
              content: RoundedButton(
                buttonName: 'ok',
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ));
  }
}
