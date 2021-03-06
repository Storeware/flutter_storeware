import 'package:flutter/material.dart';

ShowMessage(context, text) {
  Messages(context).alert(text: text);
}

class Messages {
  final BuildContext context;
  Messages(this.context);
  alert({String? title, String? text}) {
    var alertDialog = AlertDialog(
      title: Text(title!),
      content: Text(text!),
      elevation: 10.0,
      contentPadding: EdgeInsets.all(10.0),
    );
    showDialog(
        context: this.context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }
}
