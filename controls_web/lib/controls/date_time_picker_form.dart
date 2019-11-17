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
  final Function(DateTime) onSaved;
  final bool extended;
  final Widget suffix;
  final InputDecoration decoration;
  DateTimePickerFormField(
      {Key key,
      this.format,
      this.decoration,
      this.dateOnly,
      this.extended = false,
      this.initialValue,
      this.firstDate,
      this.validator,
      this.onChanged,
      this.onSaved, this.suffix})
      : super(key: key);
  @override
  _DateTimePickerFormFieldState createState() =>
      _DateTimePickerFormFieldState();
}

class _DateTimePickerFormFieldState extends State<DateTimePickerFormField> {
  DateFormat format;
  DateTime initialValue;

  bool autoValidate = false;
  bool readOnly = true;
  bool showResetIcon = true;
  DateTime value = DateTime.now();
  int changedCount = 0;
  int savedCount = 0;

  @override
  void initState() {
    format = DateFormat(widget.format ?? "dd-MM-yyyy HH:mm");
    if (widget.initialValue != null) {
      initialValue = widget.initialValue;
    } else {
      initialValue = DateTime.now();
    }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
   return
   Column(
       children:[
     DateTimeField(
      decoration: widget.decoration ,
      format: format,
      onShowPicker: (context, currentValue) async {
        print('date_time_picker_form->CurrentValue: $currentValue');
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
      validator: (date) {
        if (widget.validator != null) return widget.validator(date);
        return date == null ? 'Data inválida' : null;
      },
      initialValue: initialValue,
      onChanged: (date) => setState(() {
        value = date;
        changedCount++;
        if (widget.onChanged != null) widget.onChanged(value);
      }),
      onSaved: (date) => setState(() {
        value = date;
        savedCount++;
        if (widget.onSaved != null) widget.onSaved(value);
      }),
      resetIcon: showResetIcon ? Icon(Icons.delete) : null,
      readOnly: readOnly,
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
