import 'package:flutter/material.dart';
import 'package:flutter_storeware/index.dart';

import 'charts_view.dart';
import 'controls_activities_view.dart';
import 'controls_clean_view.dart';
import 'extra_view.dart';
import 'mix2_view.dart';
import 'mix1_view.dart';
import 'mix3_view.dart';
import 'mix4_view.dart';
import 'sales_view.dart';
import 'horizontal.dart' as hz;

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ValueNotifier<double> notifier = ValueNotifier(5);
    return hz.HorizontalTabView(
      //minWidth: 180,
      activeIndex: 4,
      color: Colors.blue[100],
      indicatorColor: Colors.blue[200],
      tabColor: Colors.blue[100],
      tagColor: Colors.amber,
      topBar: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        InkButton(
          child: const Icon(Icons.menu),
          onTap: () {
            MenuDialog.show(context, choices: [
              for (var i = 0; i < 10; i++)
                MenuChoice(
                  title: 'Opção $i',
                  onPressed: (x) {
                    // ignore: avoid_print
                    print('Opção $i');
                  },
                ),
            ]);
          },
        )
      ]),
      choices: [
        TabChoice(
          title: const Text('StrapButton'),
          child: pagina1Builder(notifier, context),
        ),
        TabChoice(
          title: const Text('Clean'),
          child: const ControlsCleanView(),
        ),
        TabChoice(
          title: const Text('Activities'),
          child: const ControlsActivitiesView(),
        ),
        TabChoice(
          label: 'charts',
          child: const ChartsView(),
        ),
        TabChoice(
          label: 'Applience',
          child: const Mix1View(),
        ),
        TabChoice(
          label: 'Light',
          child: const Mix2View(),
        ),
        TabChoice(
          label: 'Window',
          child: const Mix3View(),
        ),
        TabChoice(
          label: 'Dashboard',
          child: const Mix4View(),
        ),
        TabChoice(
          label: 'Dashlets',
          child: const SalesView(),
        ),
        TabChoice(label: 'Extra', child: const ExtraView())
      ],
    );
  }

  Row pagina1Builder(ValueNotifier<double> notifier, BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ValueListenableBuilder<double>(
            valueListenable: notifier,
            builder: (z, b, d) => Column(
              children: [
                const Spacer(),
                const Text('Radius'),
                Container(
                  alignment: Alignment.center,
                  child: GroupButtons(
                    itemIndex: 0,
                    options: ['5', '10', '15'],
                    onChanged: (x) {
                      notifier.value = (x.toDouble() + 1) * 5;
                    },
                  ),
                ).box(width: 150),
                for (var i = 0; i < StrapButtonType.values.length; i++)
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: StrapButton(
                      height: 60,
                      width: 220,
                      radius: b,
                      type: StrapButtonType.values[i],
                      text: StrapButtonType.values[i].toString().split('.')[1],
                      onPressed: () {
                        Scaffold(
                          body: Container(
                            color: strapColor(StrapButtonType.values[i]),
                          ),
                        ).showDialog(context,
                            title: StrapButtonType.values[i].toString(),
                            desktop: true);
                      },
                    ),
                  ),
                const SizedBox(height: 5),
                const Spacer(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
