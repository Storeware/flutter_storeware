// @dart=2.12
import 'package:controls_web/controls/masked_field.dart';
import 'package:flutter/material.dart';

import 'models/agenda_item_model.dart';

class ReplicarAgendaWidget extends StatefulWidget {
  ///[ replicar, dias, vezes]
  final Function(bool?, int?, int?)? onChange;
  final int? dias, vezes;
  final AgendaItem? item;
  const ReplicarAgendaWidget(
      {Key? key, this.item, this.onChange, this.dias, this.vezes})
      : super(key: key);

  @override
  _ReplicarAgendaWidgetState createState() => _ReplicarAgendaWidgetState();
}

class _ReplicarAgendaWidgetState extends State<ReplicarAgendaWidget> {
  changed(b, _dias, _vezes) {
    if (widget.onChange != null) widget.onChange!(b, _dias, _vezes);
  }

  bool? replicar;
  int? _dias;
  int? _vezes;
  @override
  void initState() {
    super.initState();
    replicar = false;
    _dias = widget.dias ?? 1;
    _vezes = widget.vezes ?? 1;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return DefaultTextStyle(
        style: theme.inputDecorationTheme.hintStyle ??
            const TextStyle(fontSize: 12),
        child: Wrap(
          children: [
            SizedBox(
              width: 60,
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Replicar'),
                    SizedBox(
                      height: 25,
                      child: MaskedSwitchFormField(
                        value: replicar,
                        onChanged: (b) {
                          setState(() {
                            replicar = b;
                            changed(replicar, _dias, _vezes);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (replicar!)
              SizedBox(
                height: kToolbarHeight + 8,
                width: 40,
                child: MaskedTextField(
                  label: 'Dias',
                  mask: '00',
                  //controller: TextEditingController(text: _dias.toString()),
                  initialValue: _dias.toString(),
                  keyboardType: TextInputType.phone,
                  onSaved: (b) {
                    setState(() {
                      _dias = int.tryParse(b);
                      changed(replicar, _dias, _vezes);
                    });
                  },
                ),
              ),
            const SizedBox(
              width: 2,
            ),
            if (replicar!)
              SizedBox(
                height: kToolbarHeight + 8,
                width: 40,
                child: MaskedTextField(
                  label: 'Vezes',
                  mask: '00',
                  //controller: TextEditingController(text: _vezes.toString()),
                  initialValue: _vezes.toString(),
                  keyboardType: TextInputType.phone,
                  onSaved: (b) {
                    setState(() {
                      _vezes = int.tryParse(b);
                      changed(
                        replicar,
                        _dias,
                        _vezes,
                      );
                    });
                  },
                ),
              ),
          ],
        ));
  }
}
