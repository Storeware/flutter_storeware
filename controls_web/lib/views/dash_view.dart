import 'package:controls_web/controls/dashboard_web.dart';
import 'package:flutter/material.dart';

class DashView extends StatelessWidget {
  final List<Widget> cards;
  final int colCount;
  const DashView({Key key, this.cards, this.colCount = 2}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DashboardView(
        backgroundColor: Colors.transparent,
        gridCrossAxisCount: 2,
        cards: cards,
        cardColor: Colors.transparent,
        cardElevation: 0,
        );
  }
}
