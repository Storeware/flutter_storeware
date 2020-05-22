import 'dart:async';

import 'package:controls_web/controls/flutter_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'flutter_masked_text.dart';
import 'package:intl/intl.dart';
import 'currency.dart';

bool _showHelperText = true;

class MaskedTextField extends StatefulWidget {
  final String label;
  final String initialValue;
  final TextAlign textAlign; //.center
  final Function(String) onSaved;
  final Function(String) validator;
  final int maxLength;

  final String mask;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final Map<String, RegExp> translator;
  final double fontSize;
  final TextStyle style;
  final String match;
  final String sample;
  final String errorText;
  final Function(String) onChanged;
  MaskedTextField({
    Key key,
    this.validator,
    this.initialValue,
    this.textAlign = TextAlign.start,
    @required this.onSaved,
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
    this.onChanged,
    this.maxLength,
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
      onSaved,
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
        onSaved: onSaved,
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
      onSaved,
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
        onSaved: onSaved,
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
          onSaved,
          Function(String) validator,
          TextStyle style}) =>
      MaskedTextField(
          key: key,
          label: label,
          mask: "00:00",
          initialValue: initialValue,
          onSaved: onSaved,
          validator: validator,
          sample: '12:59',
          match: r"([01]?[0-9]|2[0-3]):[0-5][0-9]",
          keyboardType: TextInputType.phone,
          style: style);

  static date(
          {Key key,
          String label = 'Data',
          String initialValue,
          onSaved,
          String mask = 'dd/mm/yyyy',
          Function(String) validator,
          TextStyle style}) =>
      MaskedTextField(
          key: key,
          label: label,
          mask: "00/00/0000",
          initialValue: initialValue,
          onSaved: onSaved,
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
          int maxLength,
          onSaved,
          String mask,
          TextInputType keyboardType = TextInputType.text,
          Function(String) validator,
          TextStyle style}) =>
      MaskedTextField(
          key: key,
          label: label,
          mask: mask,
          initialValue: initialValue,
          onSaved: onSaved,
          maxLength: maxLength,
          validator: validator,
          keyboardType: keyboardType,
          style: style);

  static email(
          {Key key,
          String label = 'Email',
          String initialValue,
          Function(String) onSaved,
          Function(String) validator,
          controller,
          TextStyle style}) =>
      MaskedTextField(
          key: key,
          label: label,
          controller: controller,
          mask: null,
          initialValue: initialValue,
          onSaved: onSaved,
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
          onSaved,
          Function(String) validator,
          TextStyle style}) =>
      MaskedTextField(
          key: key,
          label: label,
          mask: null,
          initialValue: initialValue,
          onSaved: onSaved,
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
      String errorText,
      Function(double) onSaved,
      leftSymbol = '',
      precision = 2}) {
    return MaskedMoneyFormField(
      key: key,
      label: label,
      initialValue: initialValue,
      onSaved: onSaved,
      errorText: errorText,
      leftSymbol: leftSymbol,
      precision: precision,
    );
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
          maxLength: widget.maxLength,
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
          onChanged: widget.onChanged,
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
            if (widget.onSaved != null) widget.onSaved(x);
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
  final Widget prefix;
  final DateTime firstDate;
  final DateTime lastDate;
  final TextEditingController controller;
  MaskedDatePicker(
      {Key key,
      this.labelText,
      this.initialValue,
      this.controller,
      this.format = "dd/MM/yyyy",
      this.validator,
      this.prefix,
      this.onChanged,
      this.firstDate,
      this.lastDate,
      this.onSaved})
      : super(key: key);

  @override
  _MaskedDatePickerState createState() => _MaskedDatePickerState();
}

class _MaskedDatePickerState extends State<MaskedDatePicker> {
  var changed = StreamController<DateTime>.broadcast();
  DateFormat formatter;
  TextEditingController _dataController;
  @override
  void initState() {
    _dataController = widget.controller ?? TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        //initialValue: data.format(widget.format),
        controller: _dataController,
        keyboardType: TextInputType.phone,
        style: TextStyle(fontSize: 16, fontStyle: FontStyle.normal),
        decoration: InputDecoration(
            labelText: widget.labelText,
            prefix: widget.prefix,
            suffixIcon: IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: () {
                  _dataController.text = formatter.format(widget.initialValue);
                })),
        validator: (x) {
          DateTime d = formatter.parse(x);
          DateTime b = formatter.parse(x);
          debugPrint('init Validate $x $d');
          if (widget.firstDate != null) if (widget.firstDate.isAfter(d))
            d = widget.firstDate;
          if (widget.lastDate != null) if (widget.lastDate.isBefore(d))
            d = widget.lastDate;

          if (widget.validator != null) return widget.validator(d);
          debugPrint('fim Validate $x $b $d');
          _dataController.text = formatter.format(d);
          return null;
        },
        onTap: () {
          getDate().then((x) {
            _dataController.text = formatter.format(x);

            if (widget.onChanged != null) widget.onChanged(x);
          });
        },
        onChanged: (x) {
          widget.onChanged(formatter.parse(x));
        },
        onSaved: (x) {
          if (widget.onSaved != null) return widget.onSaved(formatter.parse(x));
          return null;
        });
  }

  Future<DateTime> getDate() {
    // Imagine that this function is
    // more complex and slow.
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: widget.firstDate ?? DateTime.now().add(Duration(days: 180)),
      lastDate: widget.lastDate ?? DateTime(2030),
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
  final Color activeColor;
  final Color checkColor;
  final Color hoverColor;
  final Color focusColor;
  MaskedCheckbox({
    Key key,
    this.label,
    this.value = true,
    this.activeColor,
    this.checkColor,
    this.hoverColor,
    this.focusColor,
    this.onChanged,
    this.leading,
    this.trailing,
    this.tristate = false,
  }) : super(key: key);

  @override
  _MaskedCheckboxState createState() => _MaskedCheckboxState();
}

class _MaskedCheckboxState extends State<MaskedCheckbox> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool value = widget.value ?? false;
    return FittedBox(
      fit: BoxFit.cover,
      child: Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
        if (widget.leading != null) widget.leading,
        StatefulBuilder(builder: (context, _setState) {
          return Checkbox(
            activeColor: widget.activeColor,
            checkColor: widget.checkColor,
            hoverColor: widget.hoverColor,
            focusColor: widget.focusColor,
            tristate: widget.tristate,
            value: (widget.tristate) ? value : value ?? false,
            onChanged: (x) {
              if (widget.onChanged != null) widget.onChanged(x);
              _setState(() {
                value = x;
              });
            },
          );
        }),
        if (widget.label != null) Text(widget.label),
        if (widget.trailing != null) widget.trailing
      ]),
    );
  }
}

class MaskedSwitchFormField extends StatelessWidget {
  final bool value;
  final String label;
  final Color activeTrackColor;
  final Color activeColor;
  final bool autofocus;
  final Function(bool) onChanged;
  final Widget leading;
  final Widget trailing;
  MaskedSwitchFormField({
    Key key,
    this.value,
    this.label,
    this.activeTrackColor,
    this.activeColor,
    this.autofocus = false,
    this.onChanged,
    this.leading,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool initialValue = value;
    return Row(mainAxisSize: MainAxisSize.min, children: [
      if (leading != null) leading,
      if (label != null) Text(label ?? '' + '  '),
      StatefulBuilder(builder: (context, _setState) {
        return Switch(
            value: initialValue ?? false,
            activeColor: activeColor,
            activeTrackColor: activeTrackColor,
            autofocus: autofocus,
            onChanged: (b) {
              if (onChanged != null) onChanged(b);
              _setState(() {
                initialValue = b;
              });
            });
      }),
      if (trailing != null) trailing
    ]);
  }
}

class MaskedDropDownFormField extends StatelessWidget {
  final List<String> items;
  final String hintText;
  final String value;
  final Function onChanged;
  final Function onSaved;
  final Function validator;
  final String errorMsg;
  final Color hintColor;
  final Widget trailing;
  final Widget leading;
  final EdgeInsetsGeometry padding;
  const MaskedDropDownFormField(
      {Key key,
      this.items,
      this.hintText,
      this.value,
      this.onChanged,
      this.onSaved,
      this.validator,
      this.errorMsg,
      this.hintColor,
      this.padding,
      this.trailing,
      this.leading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (items.length == 0) items.add('');
    String _value = value ?? '';

    /// regulariza value que não consta da lista ;
    if (!items.contains(_value)) {
      /// se item não existe na lista, por branco
      _value = '';

      /// se branco não tem na lista, adicionar
      if (!items.contains(_value)) items.insert(0, _value);
    }

    return Container(
        padding: padding ?? EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leading != null) leading,
            if (hintText != null)
              Container(
                alignment: Alignment.bottomLeft,
                height: 15,
                child: Text(hintText ?? '',
                    style: TextStyle(
                        fontSize: 12, color: hintColor ?? Colors.black54)),
              ),
            DropdownButtonFormField(
              key: UniqueKey(),
              items: items.map((String label) {
                return new DropdownMenuItem(
                    key: UniqueKey(),
                    value: label ?? '',
                    child: Row(
                      children: <Widget>[
                        Text(label ?? ''),
                      ],
                    ));
              }).toList(),
              isDense: true,
              isExpanded: true,
              onChanged: onChanged,
              validator: validator,
              onSaved: onSaved,
              value: _value,
              // decoration: InputDecoration(hintText: hintText),
            ),
            if (trailing != null) trailing
          ],
        ));
  }
}

class MaskedMoneyFormField extends StatelessWidget {
  final String label; //= 'Valor',
  final double initialValue; //,
  final Function(double) onSaved;
  final String leftSymbol; // = '';
  final int precision; // = 2
  final MoneyMaskedTextController controller;
  final String errorText;
  final int maxLength;
  final dynamic Function(double) validator;
  const MaskedMoneyFormField({
    Key key,
    this.label,
    this.initialValue,
    this.onSaved,
    this.leftSymbol,
    this.precision,
    this.controller,
    this.errorText,
    this.validator,
    this.maxLength,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _controller = controller ??
        MoneyMaskedTextController(
            initialValue: initialValue,
            decimalSeparator: ',',
            thousandSeparator: '.',
            leftSymbol: leftSymbol + '  ',
            precision: precision ?? 2);

    _controller.afterChange = (mask, value) {
      //debugPrint(' mask: $mask , value: $value ');
    };
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Text(
            label,
            style: TextStyle(
                fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
          ),
        Container(
          constraints: BoxConstraints(minWidth: 100, minHeight: 40),
          child: TextFormField(
              key: key,
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: label,
              ),
              validator: (x) {
                if (validator != null)
                  return validator(_controller.numberValue);
                if ((errorText != null) && (x == '')) {
                  return errorText;
                }
                return null;
              },
              maxLength: maxLength,
              onSaved: (x) {
                if (onSaved != null) onSaved(_controller.numberValue);
              }),
        ),
      ],
    );
  }
}




class MaskedLabeled extends StatelessWidget {
  const MaskedLabeled({
    Key key,
    this.label,
    this.value,
  }) : super(key: key);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 2.0,
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label ?? '', style: TextStyle(fontSize: 12, color: Colors.grey)),
          Padding(
            padding: const EdgeInsets.only(bottom: 8, top: 4),
            child: Text(value ?? ''),
          ),
        ],
      ),
    );
  }
}

class MaskedLabledFormField extends StatelessWidget {
  final String labelText;
  final String initialValue;
  final TextEditingController controller;

  const MaskedLabledFormField(
      {Key key, this.labelText, this.initialValue, this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller =
        this.controller ?? TextEditingController();
    if (this.controller == null) _controller.text = initialValue ?? '';
    return TextFormField(
      controller: _controller,
      decoration: InputDecoration(labelText: labelText),
      readOnly: true,
    );
  }
}

class MaskedSearchFormField<T> extends StatelessWidget {
  final T initialValue;
  final TextEditingController controller;
  final String Function(T) onGetValue;
  final T Function(String) onSetValue;
  final InputDecoration decoration;
  final Function(T) validator;
  final Function(T) onSaved;
  final bool autofocus;
  final TextStyle style;
  final Future<T> Function() onSearch;
  final IconData iconSearch;
  final bool readOnly;
  final String labelText;
  final int maxLines;
  final Function(T) onChanged;

  const MaskedSearchFormField(
      {Key key,
      this.initialValue,
      this.onGetValue,
      this.decoration,
      this.validator,
      this.onSaved,
      this.autofocus = false,
      this.onSetValue,
      //this.controller,
      this.style,
      this.onSearch,
      this.iconSearch = Icons.search,
      this.readOnly = false,
      this.labelText,
      this.maxLines = 1,
      this.onChanged,
      this.controller})
      : super(key: key);

  String getValue(T v) {
    if (onGetValue != null)
      return onGetValue(initialValue);
    else
      return (initialValue == null) ? '' : '$initialValue';
  }

  Type typeOf<T>() => T;
  T setValue(String value) {
    if (onSetValue != null) {
      return onSetValue(value);
    }

    if (typeOf<T>() == typeOf<Money>()) return Money.tryParse(value) as T;
    if (typeOf<T>() == typeOf<int>()) return int.tryParse(value) as T;
    if (typeOf<T>() == typeOf<double>()) return double.tryParse(value) as T;
    if (typeOf<T>() == typeOf<DateTime>()) return DateTime.tryParse(value) as T;
    if (typeOf<T>() == typeOf<bool>()) return (value == 'true') as T;
    return value as T;
  }

  getKeyboardType() {
    if (typeOf<T>() == typeOf<Money>()) return TextInputType.phone;
    if (typeOf<T>() == typeOf<int>()) return TextInputType.phone;
    if (typeOf<T>() == typeOf<double>()) return TextInputType.number;

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller =
        this.controller ?? TextEditingController();

    controller.text = getValue(initialValue);

    return TextFormField(
        autofocus: autofocus,
        controller: controller,
        keyboardType: getKeyboardType(),
        style: style ?? TextStyle(fontSize: 16, fontStyle: FontStyle.normal),
        decoration: decoration ??
            InputDecoration(
                labelText: labelText,
                suffixIcon: IconButton(
                    icon: Icon(iconSearch),
                    onPressed: () {
                      onSearch().then((item) {
                        controller.text = getValue(item);
                      });
                    })),
        enableSuggestions: true,
        expands: maxLines > 1,
        maxLines: maxLines,
        minLines: 1,
        readOnly: readOnly,
        onChanged: (value) {
          if (onChanged != null) onChanged(setValue(value));
        },
        validator: (value) {
          if (validator != null) return validator(setValue(value));
          return (setValue(value) == null) ? 'Valor inválido' : null;
        },
        onSaved: (x) {
          T v = setValue(x);
          onSaved(v);
        });
  }
}
