import 'package:flutter/material.dart';
import 'package:flutter_storeware/index.dart';

class Mix4View extends StatelessWidget {
  const Mix4View({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Wrap(
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
          /* const DotnutChartTile(
            percent: 52,
            elevation: 10,
            child: Text('child sample'),
            subtitle: Text('OK    '),
            title: Text('Faturamento'),
            value: 'BRL 10203.2',
          ),*/
          SizedBox(
            height: 120,
            child: Row(
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
          ),
          Wrap(
            children: [
              DashboardScore(
                color: Colors.blue[50],
                icon: const Icon(Icons.table_bar),
                score: '\$ 12,234',
                width: 180,
                tagColor: Colors.amber,
                title: const Text('DashboardScore'),
              ),
              DashboardScore(
                color: Colors.blue[50],
                //   icon: const Icon(Icons.table_bar),
                borderRadius: 30,
                tagWidth: 20,
                score: '\$ 12,234',
                width: 250,

                tagColor: Colors.blue,
                title: const Text('DashboardScore'),
              ),
              DashboardScore(
                color: Colors.blue[50],
                //   icon: const Icon(Icons.table_bar),
                borderRadius: 30,
                position: TagPosition.right,
                tagWidth: 20,
                score: '\$ 12,234',
                width: 250,

                tagColor: Colors.blue,
                title: const Text('DashboardScore'),
              ),
              DashboardScore(
                position: TagPosition.bottom,
                color: Colors.amber[50],
                //icon: const Icon(Icons.table_chart, color: Colors.red),
                //score: '\$ 12',
                width: 180,
                tagColor: Colors.blue,
                title: const Text('12.145',
                    style: TextStyle(
                      fontSize: 18,
                    )),
                topBar: AppBar(
                    elevation: 0,
                    toolbarHeight: 15,
                    title: const Text('DashboardScore.topBar',
                        style: TextStyle(
                          fontSize: 12,
                        ))),
                child: const Text('Revendas',
                    style: TextStyle(
                      fontSize: 11,
                    )),
                onPressed: () {
                  Dialogs.info(context, text: 'DashboardScore.onPressed');
                },
              )
            ],
          ),
          DashboardScore(
            position: TagPosition.none,
            //color: Colors.amber[50],
            icon: const Icon(Icons.table_chart, color: Colors.red),
            score: '125',
            //width: 180,
            tagColor: Colors.blue,
            title: const Text(
              'Shows Contratados',
              textAlign: TextAlign.center,
            ),
            scoreStyle: const TextStyle(
              color: Colors.red,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            trailing: Column(
              children: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.check),
                ),
              ],
            ),
            onPressed: () {
              Dialogs.info(context, text: 'DashboardScore.onPressed');
            },
          )
        ],
      ).singleChildScrollView(),
    );
  }
}
