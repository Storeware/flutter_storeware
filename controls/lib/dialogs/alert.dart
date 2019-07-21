import 'package:flutter/material.dart';
import '../controls/rounded_button.dart';

typedef AsyncAlertBuilder<T> = T Function(BuildContext context);

class Alert {
  static Future<T> dialog<T>(BuildContext context,
      {Widget title,
      List<Widget> content,
      List<Widget> actions,
      bool dismissible = false}) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: dismissible, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: title,
          content: SingleChildScrollView(
            child: ListBody(
              children: content ?? [],
            ),
          ),
          actions: actions ?? [],
        );
      },
    );
  }

  static Future<int> okDlg(BuildContext context,
      {String title, String content}) {
    return Alert.dialog<int>(context, title: Text(title), content: [
      Text(content)
    ], actions: [
      RoundedButton(
        buttonName: 'OK',
        icon: Icons.check,
        onTap: () {
          return 1;
        },
      )
    ]);
  }

  static Future<String> simNao(BuildContext context,
      {String title, String content}) {
    return Alert.dialog<String>(context, title: Text(title), content: [
      Text(content)
    ], actions: [
      RoundedButton(
        buttonName: 'Sim',
        icon: Icons.check,
        onTap: () {
          return 'S';
        },
      ),
      RoundedButton(
        buttonName: 'Não',
        icon: Icons.not_interested,
        onTap: () {
          return 'N';
        },
      )
    ]);
  }

  static showSnackBar(BuildContext context, String texto) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(texto)));
  }

  static Future<dynamic> wait(BuildContext context, Future<dynamic> future,
      {String title = '', String error, String success}) {
    future.then((rsp) {
      Navigator.pop(context);
      if (success != null) showSnackBar(context, success);
      return rsp;
    }).catchError((err) {
      Navigator.pop(context);
      if (error != null) showSnackBar(context, error);
      throw err;
    });
    return Alert.dialog<dynamic>(context,
        title: Text(title), content: [new LinearProgressIndicator()]);
  }
}
