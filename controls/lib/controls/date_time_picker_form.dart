import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimePickerFormField extends StatefulWidget {
  final String format;
  final bool dateOnly;
  final DateTime initialValue;
  final DateTime firstDate;
  final Function(DateTime) validator;
  final Function(DateTime) onChanged;
  final bool extended;
  DateTimePickerFormField(
      {Key key,
      this.format,
      this.dateOnly,
      this.extended = false,
      this.initialValue,
      this.firstDate,
      this.validator,
      this.onChanged})
      : super(key: key);
  @override
  _DateTimePickerFormFieldState createState() =>
      _DateTimePickerFormFieldState();
}

class _DateTimePickerFormFieldState extends State<DateTimePickerFormField> {
  DateFormat format;
  final initialValue = DateTime.now();

  bool autoValidate = false;
  bool readOnly = true;
  bool showResetIcon = true;
  DateTime value = DateTime.now();
  int changedCount = 0;
  int savedCount = 0;

  @override
  void initState() {
    format = DateFormat(widget.format??"dd-MM-yyyy HH:mm");
    super.initState();
  } 

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      //Text('Complex date & time field (${format.pattern})'),
      DateTimeField(
        format: format,
        onShowPicker: (context, currentValue) async {
          final date = await showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100));
          if (date != null) {
            final time = await showTimePicker(
              context: context,
              initialTime:
                  TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
            );
            return DateTimeField.combine(date, time);
          } else {
            return currentValue;
          }
        },
        autovalidate: autoValidate,
        validator: (date) => date == null ? 'Invalid date' : null,
        initialValue: initialValue,
        onChanged: (date) => setState(() {
          value = date;
          changedCount++;
        }),
        onSaved: (date) => setState(() {
          value = date;
          savedCount++;
        }),
        resetIcon: showResetIcon ? Icon(Icons.delete) : null,
        readOnly: readOnly,
        //decoration: InputDecoration(
        //    helperText: 'Changed: $changedCount, Saved: $savedCount, $value'),
      ),
      widget.extended
          ? CheckboxListTile(
              title: Text('autoValidate'),
              value: autoValidate,
              onChanged: (value) => setState(() => autoValidate = value),
            )
          : Container(),
      widget.extended
          ? CheckboxListTile(
              title: Text('readOnly'),
              value: readOnly,
              onChanged: (value) => setState(() => readOnly = value),
            )
          : Container(),
      widget.extended
          ? CheckboxListTile(
              title: Text('showResetIcon'),
              value: showResetIcon,
              onChanged: (value) => setState(() => showResetIcon = value),
            )
          : Container(),
    ]);
  }
}
