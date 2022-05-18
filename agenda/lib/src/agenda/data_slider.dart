// @dart=2.12

import 'package:flutter/material.dart';

import 'agenda_controller.dart';

class DataSlider extends StatelessWidget {
  const DataSlider({
    Key? key,
    required this.datas,
    required this.dataRef,
    required this.controller,
    this.activated,
    this.format,
  }) : super(key: key);

  final List<DateTime> datas;
  final DateTime? dataRef;
  final AgendaController? controller;
  final String? Function(DateTime)? format;
  final bool Function(DateTime)? activated;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      height: 40,
      color: theme.primaryColor.withAlpha(50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (var d in datas)
            InkWell(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: (activated != null)
                        ? (activated!(d)
                            ? theme.primaryColor.withAlpha(70)
                            : null)
                        : (d.day == dataRef!.day)
                            ? theme.primaryColor.withAlpha(70)
                            : null,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.all(4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text((format != null) ? format!(d)! : '',
                          style: ((d.day == dataRef!.day) ||
                                  ((activated != null) && activated!(d)))
                              ? TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)
                              : TextStyle(fontSize: 10)),
                      CircleAvatar(
                        radius: 3,
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () {
                controller!.dataChange(d);
              },
            ),
        ],
      ),
    );
  }
}
