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
          const DotnutChartTile(
            //percent: 24,
            chart: Text('OK    '),
            title: Text('Faturamento'),
            value: '\$ 1.002.000',
            icon: Icons.air_sharp,
            subtitle: Text('agosto/2021'),
          ),
          const DotnutChartTile(
            percent: 52,
            elevation: 10,
            child: Text('child sample'),
            subtitle: Text('OK    '),
            title: Text('Faturamento'),
            value: 'BRL 10203.2',
          ),
          Row(
            children: const [
              DashboardTile(
                maxWidth: 180,
                title: 'DashboardTile',
                counter: Text(' 123 '),
                avatarColor: Colors.amber,
                color: Colors.indigo,
                value: '10',
                avatarChild: Text('99'),
                image: Icon(Icons.headphones),
              ),
              DashboardTile(
                maxWidth: 180,
                title: 'DashboardTile',
                avatarColor: Colors.amber,
                color: Colors.amber,
                value: '\$ 10,34',
                image: Icon(Icons.headphones),
              ),
            ],
          ),
        ],
      ).singleChildScrollView(),
    );
  }
}
