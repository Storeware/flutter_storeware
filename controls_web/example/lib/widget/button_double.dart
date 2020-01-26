import 'package:flutter/material.dart';

class DoubleButton extends StatelessWidget {
  final String label1;
  final String label2;
  final Function onPressed1;
  final Function onPressed2;
  final IconData icon;
  final Color color;
  final double fontSize;
  const DoubleButton({
    Key key,
    this.label1 = 'Voltar',
    this.label2 = 'Pagar',
    this.onPressed1,
    this.onPressed2,
    this.color,
    this.fontSize = 16,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: color ?? Colors.indigo,
      ),

      child: Row(
        children: <Widget>[
          FlatButton(
            child: Text(label1,
                style: TextStyle(
                  fontSize: fontSize,
                  color: Colors.white,
                )),
            onPressed: onPressed1,
          ),
          CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(icon ?? Icons.monetization_on, size: 35)),
          FlatButton(
            child: Text(label2,
                style: TextStyle(
                  fontSize: fontSize,
                  color: Colors.white,
                )),
            onPressed: onPressed2,
          ),
        ],
      ),
    );
  }
}
