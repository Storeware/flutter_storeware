import 'package:flutter/material.dart';
import 'package:controls_web/controls.dart';

class ControlsCleanView extends StatefulWidget {
  const ControlsCleanView({Key? key}) : super(key: key);

  @override
  _ControlsCleanViewState createState() => _ControlsCleanViewState();
}

class _ControlsCleanViewState extends State<ControlsCleanView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UI - Clean'),
      ),
      body: Wrap(runSpacing: 10, spacing: 10, children: [
        TabButton(
          child: const Text('TabButton'),
          onPressed: () => Dialogs.simNao(context, text: 'Ops...'),
        ),
        CleanButton(
          label: 'CleanButton',
          //radius: 10,
          onPressed: () {},
          //width: 80,
          //color: Colors.blue,
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: CleanContainer(
            width: 150,
            child: Text('CleanContainer'),
            padding: EdgeInsets.all(10),
            color: Colors.red,
          ),
        ),
        const ActionButton(
          child: Text('ActionButton'),
          label: 'label',
          selected: false,
        ),
        const Labeled(
          label: 'Labeled - Axis.vertical',
          direction: Axis.vertical,
          children: [
            Text('Labeled1'),
            Text('Labeled2'),
          ],
        ),
        const SizedBox(
          width: 220,
          child: LabeledRow(
            label: 'LabeledRow',
            //title: Text('LabledRow'),
            spacing: 10,
            children: [Text('children1'), Text('children2')],
          ),
        ),
        const SizedBox(
          width: 220,
          height: 120,
          child: LabeledColumn(
            label: 'LabeledColumn',
            children: [
              Text('LabeledColumn1'),
              Text('LabeledColumn2'),
            ],
          ),
        ),
        const SizedBox(
          width: 150,
          child: ButtonAvatar(
            icon: Icon(Icons.link_off_outlined),
            color: Colors.amber,
            width: 120,
            child: Text('ButtonAvatar'),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const ActionText(
          radius: 30.0,
          label: 'ActionText',
        ),
        const ActionCounter(
          label: 'ActionCounter',
          value: '123',
        ),
        const ActionTimer(
          label: 'ActionTimer',
        ),
      ]),
    );
  }
}
