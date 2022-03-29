import 'package:flutter/material.dart';
import 'package:controls_web/controls/activities.dart' as ac;
import 'package:flutter_storeware/index.dart';

class ControlsActivitiesView extends StatelessWidget {
  const ControlsActivitiesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        runSpacing: 10,
        spacing: 10,
        children: [
          ActivityBuyButton(
            onQtdePressed: (a) {},
            onComprar: (v) {},
          ),
          const ac.ActivityAvatar(
            icon: Icons.av_timer_sharp,
            iconColor: Colors.blue,
          ),
          ac.ActivityBar(
            value: 10.1,
            backgroundColor: Colors.red,
          ),
          const ac.ActivityButton(
            textStyle: TextStyle(fontSize: 10),
            title: 'Activity Button',
          ),
          const ac.ActivityCount(
            title: 'ActivityCount',
            value: '10.0',
          ),
          ac.ActivityPanel(
            leftRadius: 0,
            rightRadius: 30,
            height: 60,
            color: Colors.blue,
            child: const Text('ActivityPanel').center(),
          )
        ],
      ),
    ));
  }
}
