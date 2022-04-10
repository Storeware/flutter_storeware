import 'package:flutter/material.dart';
import 'package:flutter_storeware/index.dart';

class Mix4View extends StatelessWidget {
  const Mix4View({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          DotnutChartTile(
            color: Colors.amber,
            title: const Text('Total Expenses'),
            value: 'R\$ 14,160',
            percent: 62,
            subtitle: const Text('nas ultimas 24 horas'),
            icon: Icons.dashboard,
            onPressed: () {
              Dialogs.info(context, text: 'DotnutChartTile.onPressed');
            },
          ),
          const DotnutChartTile()
        ],
      ).singleChildScrollView(),
    );
  }
}
