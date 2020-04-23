import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'flutter_masked_text.dart';
import 'package:intl/intl.dart';

bool _showHelperText = true;

class MaskedTextField extends StatefulWidget {
  final String label;
  final String initialValue;
  final TextAlign textAlign; //.center
  final Function(String) onSave;
  final Function(String) validator;
  final String mask;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final Map<String, RegExp> translator;
  final double fontSize;
  final TextStyle style;
  final String match;
  final String sample;
  final String errorText;
  MaskedTextField({
    Key key,
    this.validator,
    this.initialValue,
    this.textAlign = TextAlign.start,
    @required this.onSave,
    @required this.label,
    @required this.mask,
    this.keyboardType,
    this.controller,
    this.translator,
    this.style,
    this.match,
    this.sample,
    this.errorText = 'Falta informar %1',
    this.fontSize = 16,
  }) : super(key: key);

  @override
  _MaskedTextFieldState createState() => _MaskedTextFieldState();

  set showHelperText(bool x) {
    _showHelperText = x;
  }

  get showHelperText => _showHelperText;
  static phone1(
      {Key key,
      String label = 'Celular',
      String initialValue,
      TextAlign textAlign,
      controller,
      onSave,
      String mask = '(00)00000-0000',
      String match = r"^\((\d{2})\)\s?(\d{4,5}\-?\d{4})",
      Function(String) validator,
      TextStyle style}) {
    //echo('valor inicial: $initialValue');
    return MaskedTextField(
        key: key,
        label: label,
        mask: mask,
        textAlign: textAlign,
        initialValue: initialValue ?? '',
        onSave: onSave,
        validator: validator,
        sample: '(99)99999-9999',
        match: match,
        //controller: controller,
        keyboardType: TextInputType.phone,
        style: style);
  }

  static phone2(
      {Key key,
      String label = 'Celular',
      String initialValue,
      TextAlign textAlign,
      onSave,
      String mask = '*00(00)00000-0000',
      String match = r"^\+?\d{2,3}\((\d{2})\)\s?(\d{4,5}\-?\d{4})",
      Function(String) validator,
      TextStyle style}) {
    //echo('valor inicial: $initialValue');
    return MaskedTextField(
        key: key,
        label: label,
        mask: mask,
        textAlign: textAlign,
        initialValue: initialValue ?? '+55(11)',
        onSave: onSave,
        validator: validator,
        sample: '+55(11)99999-9999',
        match: match,
        keyboardType: TextInputType.phone,
        style: style);
  }

  static time(
          {Key key,
          String label = 'Hora',
          String initialValue,
          onSave,
          Function(String) validator,
          TextStyle style}) =>
      MaskedTextField(
          key: key,
          label: label,
          mask: "00:00",
          initialValue: initialValue,
          onSave: onSave,
          validator: validator,
          sample: '12:59',
          match: r"([01]?[0-9]|2[0-3]):[0-5][0-9]",
          keyboardType: TextInputType.phone,
          style: style);

  static date(
          {Key key,
          String label = 'Data',
          String initialValue,
          onSave,
          String mask = 'dd/mm/yyyy',
          Function(String) validator,
          TextStyle style}) =>
      MaskedTextField(
          key: key,
          label: label,
          mask: "00/00/0000",
          initialValue: initialValue,
          onSave: onSave,
          validator: validator ??
              (value) {
                var formatter = DateFormat(mask);
                var d = formatter.parse(value);
                var s = formatter.format(d);
                if (s != value) return 'Data inválida (' + s + ')';
                return null;
              },
          sample: '29/02/2020',
          match: r"^([0-3][0-9]/[0-1][0-9]/[0-9]{4})",
          keyboardType: TextInputType.datetime,
          style: style);

  static text(
          {Key key,
          String label = 'Text',
          String initialValue,
          onSave,
          String mask,
          TextInputType keyboardType = TextInputType.text,
          Function(String) validator,
          TextStyle style}) =>
      MaskedTextField(
          key: key,
          label: label,
          mask: mask,
          initialValue: initialValue,
          onSave: onSave,
          validator: validator,
          keyboardType: keyboardType,
          style: style);

  static email(
          {Key key,
          String label = 'Email',
          String initialValue,
          Function(String) onSave,
          Function(String) validator,
          TextStyle style}) =>
      MaskedTextField(
          key: key,
          label: label,
          mask: null,
          initialValue: initialValue,
          onSave: onSave,
          validator: validator,
          match:
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
          sample: 'meu.nome@provedor.com.br',
          keyboardType: TextInputType.emailAddress,
          style: style);

  static http(
          {Key key,
          String label = 'Host',
          String initialValue,
          onSave,
          Function(String) validator,
          TextStyle style}) =>
      MaskedTextField(
          key: key,
          label: label,
          mask: null,
          initialValue: initialValue,
          onSave: onSave,
          validator: validator,
          sample: 'http://servidor.com.br:8886',
          match:
              r'http[s]?://(([.]|[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\(\),])+):[0-9]+',
          keyboardType: TextInputType.url,
          style: style);

  static money(
      {Key key,
      String label = 'Valor',
      double initialValue,
      Function(String) onSave,
      leftSymbol = '',
      precision = 2}) {
    var controller = MoneyMaskedTextController(
        initialValue: initialValue,
        decimalSeparator: ',',
        thousandSeparator: '.',
        leftSymbol: leftSymbol,
        precision: precision);
    return MaskedTextField(
        key: key,
        controller: controller,
        keyboardType: TextInputType.number,
        label: label,
        mask: null,
        onSave: onSave);
  }
}

class _MaskedTextFieldState extends State<MaskedTextField> {
  TextEditingController _controller;
  bool _autoDispose = false;
  @override
  void initState() {
    if (widget.controller != null) {
      _autoDispose = false;
    } else {
      if (widget.mask != null) {
        //echo('mask ${widget.mask} initial: ${widget.initialValue}');
        _controller = MaskedTextController(
            text: widget.initialValue ?? '',
            mask: widget.mask,
            translator: widget.translator);
        _autoDispose = true;
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    if (_autoDispose && (_controller != null)) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
          textAlign: widget.textAlign ?? TextAlign.start,
          initialValue: (_controller == null) ? widget.initialValue : null,
          controller: _controller,
          style: widget.style ??
              TextStyle(fontSize: widget.fontSize, fontStyle: FontStyle.normal),
          decoration: InputDecoration(
            labelText: '${widget.label}',
            helperText: !_showHelperText
                ? (widget.sample != null) ? 'Ex: ${widget.sample}' : null
                : null,
          ),
          keyboardType: widget.keyboardType,
          validator: (value) {
            if (widget.match != null) {
              var r = RegExp(widget.match);
              if ((!r.hasMatch(value)) || (r.stringMatch(value) != value))
                return (widget.sample != null)
                    ? 'Inválido (ex: ${widget.sample}) Resp: ${r.stringMatch(value)}'
                    : 'Inválido';
            }
            return (widget.validator != null)
                ? widget.validator(value)
                : (value.isEmpty)
                    ? widget.errorText.replaceFirst('%1', widget.label)
                    : null;
          },
          onSaved: (x) {
            if (widget.onSave != null) widget.onSave(x);
          }),
    );
  }
}

class MaskedDatePicker extends StatefulWidget {
  final DateTime initialValue;
  final Function(DateTime) validator;
  final String labelText;
  final Function(DateTime) onSaved;
  final Function(DateTime) onChanged;
  final String format;
  MaskedDatePicker(
      {Key key,
      this.labelText,
      this.initialValue,
      this.format = "dd/MM/yyyy",
      this.validator,
      this.onChanged,
      this.onSaved})
      : super(key: key);

  @override
  _MaskedDatePickerState createState() => _MaskedDatePickerState();
}

class _MaskedDatePickerState extends State<MaskedDatePicker> {
  var changed = StreamController<DateTime>.broadcast();
  DateFormat formatter;

  @override
  void initState() {
    formatter = DateFormat(widget.format);
    if (widget.initialValue != null)
      _dataController.text = formatter.format(widget.initialValue);
    super.initState();
  }

  @override
  void dispose() {
    changed.close();
    super.dispose();
  }

  final TextEditingController _dataController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        //initialValue: data.format(widget.format),
        controller: _dataController,
        keyboardType: TextInputType.phone,
        style: TextStyle(fontSize: 16, fontStyle: FontStyle.normal),
        decoration: InputDecoration(
            labelText: widget.labelText,
            suffixIcon: IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: () {
                  _dataController.text = formatter.format(widget.initialValue);
                })),
        validator: (x) {
          if (widget.validator != null)
            return widget.validator(DateTime.tryParse(x));
          return null;
        },
        onTap: () {
          getDate().then((x) {
            _dataController.text = formatter.format(x);

            if (widget.onChanged != null) widget.onChanged(x);
          });
        },
        onChanged: (x) {
          widget.onChanged(DateTime.tryParse(x));
        },
        onSaved: (x) {
          if (widget.onSaved != null)
            return widget.onSaved(DateTime.tryParse(x));
          return null;
        });
  }

  Future<DateTime> getDate() {
    // Imagine that this function is
    // more complex and slow.
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light(),
          child: child,
        );
      },
    );
  }
}

class MaskedCheckbox extends StatefulWidget {
  final String label;
  final bool value;
  final Widget leading;
  final Widget trailing;
  final Function(bool) onChanged;
  final bool tristate;
  MaskedCheckbox({
    Key key,
    this.label,
    this.value = true,
    this.onChanged,
    this.leading,
    this.trailing,
    this.tristate = false,
  }) : super(key: key);

  @override
  _MaskedCheckboxState createState() => _MaskedCheckboxState();
}

class _MaskedCheckboxState extends State<MaskedCheckbox> {
  StreamController<bool> notifier = StreamController<bool>.broadcast();

  @override
  void dispose() {
    notifier.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.cover,
      child: Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
        if (widget.leading != null) widget.leading,
        StreamBuilder<bool>(
            initialData:
                (widget.tristate) ? widget.value : widget.value ?? false,
            stream: notifier.stream,
            builder: (context, snapshot) {
              return Checkbox(
                tristate: widget.tristate,
                value: snapshot.data,
                onChanged: (x) {
                  if (widget.onChanged != null) widget.onChanged(x);
                  notifier.add(x);
                },
              );
            }),
        if (widget.label != null) Text(widget.label),
        if (widget.trailing != null) widget.trailing
      ]),
    );
  }
}
