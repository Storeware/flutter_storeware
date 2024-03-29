// @dart=2.12
import 'package:flutter/material.dart';
import 'package:controls_extensions/extensions.dart';
import 'package:controls_web/controls/responsive.dart';
import 'package:controls_web/controls/group_buttons.dart';
import 'package:controls_web/controls/masked_field.dart';

class DateIntervalPickerValues {
  DateTime de;
  DateTime ate;
  DateIntervalPickerValues({required this.de, required this.ate});
}

class DateIntervalPicker extends StatefulWidget {
  const DateIntervalPicker(
      {Key? key,
      required this.startDate,
      required this.endDate,
      this.onChanged,
      this.onSaved,
      this.color,
      this.options,
      this.onChangeValues,
      this.itemIndex = -1,
      this.extendedOptions = false,
      this.width})
      : super(key: key);
  final Function(DateTime dataDe, DateTime dataAte)? onChanged;
  final Function(DateTime dataDe, DateTime dataAte)? onSaved;
  final DateTime startDate;
  final DateTime endDate;
  final double? width;
  final int itemIndex;
  final bool extendedOptions;
  final Color? color;
  final List<String>? options;
  final DateIntervalPickerValues Function(
      int index, DateIntervalPickerValues values)? onChangeValues;
  @override
  _DateIntervalPickerState createState() => _DateIntervalPickerState();
}

class _DateIntervalPickerState extends State<DateIntervalPicker> {
  late DateTime de;
  late DateTime ate;
  @override
  void initState() {
    super.initState();
    options =
        widget.options ?? ['Ultimo ano', 'Ultimo Mês', 'Na semana', 'No Dia'];
    de = widget.startDate;
    ate = widget.endDate;
    formatar();
  }

  late List<String> options;

  final TextEditingController _deController = TextEditingController();
  final TextEditingController _ateController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    ResponsiveInfo responsive = ResponsiveInfo(context);
    double dw = ((widget.width ?? responsive.size.width) - 80) / 2;
    if (dw > 250) dw = 250.0;
    return Container(
      color: widget.color,
      constraints: BoxConstraints(maxWidth: responsive.size.width),
      child: Column(
        children: [
          if (widget.extendedOptions)
            Container(
              width: double.infinity,
              height: 40,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: GroupButtons(
                    color: widget.color,
                    options: options,
                    itemIndex: widget.itemIndex,
                    onChanged: (i) {
                      if (widget.onChangeValues != null) {
                        var values = DateIntervalPickerValues(de: de, ate: ate);
                        var rt = widget.onChangeValues!(i, values);
                        de = rt.de;
                        ate = rt.ate;
                        return;
                      }
                      switch (i) {
                        case 1:
                          de = DateTime.now().addMonths(-1).startOfMonth();
                          ate = DateTime.now().addMonths(-1).endOfMonth();
                          break;
                        case 2:
                          de = DateTime.now().startOfWeek();
                          ate = DateTime.now().endOfWeek();
                          break;
                        case 3:
                          de = DateTime.now().startOfDay();
                          ate = DateTime.now().endOfDay();
                          break;
                        case 0:
                          int ano_atual = DateTime.now().year;
                          de = DateTime(ano_atual - 1, 1, 1);
                          ate = DateTime(ano_atual, 1, 1).addDays(-1);
                          break;

                        default:
                          de = DateTime.now().startOfDay();
                          ate = DateTime.now().endOfDay();
                      }

                      saved(i);
                    }),
              ),
            ),
          Row(
            children: [
              Container(
                height: 60,
                width: dw,
                child: MaskedDatePicker(
                  labelText: 'De',
                  controller: _deController,
                  onChanged: (v) {
                    if (de != v) {
                      de = v;
                      if (widget.onChanged != null) widget.onChanged!(de, ate);
                    }
                  },
                ),
              ),
              SizedBox(width: 15),
              Container(
                height: 60,
                width: dw,
                child: MaskedDatePicker(
                  labelText: 'Até',
                  controller: _ateController,
                  onChanged: (v) {
                    if (ate != v) {
                      ate = v;
                      if (widget.onChanged != null) widget.onChanged!(de, ate);
                    }
                  },
                ),
              ),
              IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    if (widget.onSaved != null) widget.onSaved!(de, ate);
                  })
            ],
          )
        ],
      ),
    );
  }

  saved(int index) {
    if (widget.onSaved != null) widget.onSaved!(de, ate);
    formatar();
  }

  formatar() {
    _deController.text = de.format('dd/MM/yyyy');
    _ateController.text = ate.format('dd/MM/yyyy');
  }
}

extension StringMofi on String {
  String removeLeftChar(String char) {
    String r = '';
    forEach((x) {
      if (!(x == char && r == '')) {
        r += x;
      }
    });
    return r;
  }

  forEach(Function(String) value) {
    for (var i = 0; i < this.length; i++) {
      value(this.substring(i, i + 1));
    }
  }
}
