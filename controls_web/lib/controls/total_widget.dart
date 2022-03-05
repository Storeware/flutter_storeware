import 'package:flutter/material.dart';

String doubleMoneyStr(double total, {int? dec = 2}) {
  return (total).toStringAsFixed(dec!).replaceAll('.', ',');
}

class TotalWidget extends StatelessWidget {
  const TotalWidget({
    Key? key,
    @required this.total,
    this.fontSize = 20,
    this.fontColor,
  }) : super(key: key);

  final double? total;
  final double? fontSize;
  final Color? fontColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 6.0),
          child: Text('R\$',
              style: TextStyle(
                  color: fontColor,
                  fontSize: fontSize! * 0.5,
                  fontWeight: FontWeight.bold)),
        ),
        Container(
          child: Text(
            ' ${doubleMoneyStr(total ?? 0)}',
            style: TextStyle(
              color: fontColor,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class TotalPainel extends StatelessWidget {
  const TotalPainel({
    Key? key,
    this.label,
    required this.total,
  }) : super(key: key);

  final double? total;
  final String? label;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                label ?? 'VALOR TOTAL: ',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 20, color: theme.textTheme.bodyText1!.color),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: TotalWidget(
                fontColor: Colors.indigo,
                fontSize: 28,
                total: total,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
