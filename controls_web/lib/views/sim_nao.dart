import 'package:flutter/material.dart';
import '../controls.dart';

class SimNaoDialog extends StatefulWidget {
  final String text;
  final Function(String) onPressed;
  SimNaoDialog(this.text,this.onPressed,{Key key}) : super(key: key);

  _SimNaoDialogState createState() => _SimNaoDialogState();
}

class _SimNaoDialogState extends State<SimNaoDialog> {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
       title: Text('Opção'),
       children: <Widget>[
         SizedBox(height: 10,),
         Text(widget.text),
         SizedBox(height: 10,),
         Divider(),
         Row(children: [

            RoundedButton(buttonName: 'Sim',onTap: (){
              widget.onPressed('S');
            }, )
,            RoundedButton(buttonName: 'Não',onTap: (){
              widget.onPressed('N');
            }, )

         ])
       ],
    );
  }
}