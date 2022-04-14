import 'package:flutter/material.dart';
import 'package:flutter_storeware/index.dart';

class Mix2View extends StatelessWidget {
  const Mix2View({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Wrap(
        children: [
          ExpansionGroup(
            children: [
              ExpansionItem(
                title: 'ExpansionGroup-1',
                body: const Text('ExpansionItem'),
                isExpanded: true,
              ),
              ExpansionItem(
                title: 'ExpansionGroup-2',
                body: const Text('ExpansionItem'),
              )
            ],
          ),
          const Divider(),
          GroupBox(
            title: const Text('GroupBox'),
            children: [
              for (var item in ['Widget1', 'Widget2', 'Widget3']) Text(item),
            ],
          ),
          const LightTile(
            tagColor: Colors.red,
            title: Text('LightTile'),
            subtitle: Text('sub-title'),
            trailing: Icon(Icons.airline_stops),
          ),
          LightContainer(
            height: 100,
            label: 'LightContainer',
            sublabel: 'sub-label',
            children: [
              for (var item in ['ok', 'nok']) Text(item)
            ],
            onPressed: () {
              Dialogs.showTimedDialog(
                context,
                seconds: 5,
                child: const Text('Dialogs.showTimedDialog'),
              );
            },
          ),
          const LightAmmount(value: '1111', label: 'LightAmmount'),
          LightButton(
            title: const Text('LightButton.title'),
            value: '222',
            sublabel: 'sub-label',
            height: 110,
            label: 'label',
            backgroundColor: Colors.amber,
            color: Colors.red,
            onPressed: () {},
          ),
          const Divider(),
          LightValueButton(
            image: const Icon(Icons.mail),
            label: 'LightValueButton',
            sublabel: 'sub-label',
            onPressed: () {},
          ),
          const SizedBox(
            height: 100,
          )
        ],
      ).singleChildScrollView(),
    );
  }
}
