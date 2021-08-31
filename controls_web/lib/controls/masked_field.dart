import 'dart:async';

import 'package:controls_web/controls/flutter_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'flutter_masked_text.dart';
import 'package:intl/intl.dart';
import 'package:controls_web/controls/currency.dart';
//import 'package:controls_extensions/extensions.dart';

bool _showHelperText = true;

class MaskedTextField extends StatefulWidget {
  final String? label;
  final String? initialValue;
  final TextAlign? textAlign; //.center
  final Function(String)? onSaved;
  final Function(String)? validator;
  final int? maxLength;
  final bool? readOnly;

  final String? mask;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final Map<String, RegExp>? translator;
  final double? fontSize;
  final TextStyle? style;
  final String? match;
  final String? sample;
  final String? errorText;
  final bool? autofocus;
  final Function(String)? onChanged;
  final Widget? suffix;
  final Widget? prefix;
  final Color? fillColor;
  final Color? focusColor;
  final Color? hoverColor;
  final InputDecoration? decoration;

  final Function(bool)? onFocusChange;
  MaskedTextField({
    Key? key,
    this.validator,
    this.initialValue,
    this.textAlign = TextAlign.start,
    this.onSaved,
    this.decoration,
    this.fillColor,
    this.focusColor,
    this.hoverColor,
    @required this.label,
    this.mask,
    this.keyboardType,
    this.controller,
    this.translator,
    this.autofocus = false,
    this.style,
    this.match,
    this.sample,
    this.suffix,
    this.prefix,
    this.onFocusChange,
    this.errorText = 'Falta informar %1',
    this.fontSize = 16,
    this.readOnly = false,
    this.onChanged,
    this.maxLength,
  }) : super(key: key);

  @override
  _MaskedTextFieldState createState() => _MaskedTextFieldState();

  set showHelperText(bool x) {
    _showHelperText = x;
  }

  bool get showHelperText => _showHelperText;
  static phone1(
      {Key? key,
      String? label = 'Celular',
      String? initialValue,
      TextAlign? textAlign,
      controller,
      onSaved,
      String? mask = '(00)00000-0000',
      String? match = r"^\((\d{2})\)\s?(\d{4,5}\-?\d{4})",
      Function(String)? validator,
      bool? autofocus = false,
      TextStyle? style}) {
    //echo('valor inicial: $initialValue');
    return MaskedTextField(
        key: key,
        label: label,
        mask: mask,
        autofocus: autofocus,
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
      {Key? key,
      String label = 'Celular',
      String? initialValue,
      TextAlign? textAlign,
      onSaved,
      String mask = '*00(00)00000-0000',
      String match = r"^\+?\d{2,3}\((\d{2})\)\s?(\d{4,5}\-?\d{4})",
      Function(String)? validator,
      bool autofocus = false,
      TextStyle? style}) {
    //echo('valor inicial: $initialValue');
    return MaskedTextField(
        key: key,
        label: label,
        mask: mask,
        autofocus: autofocus,
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
          {Key? key,
          String label = 'Hora',
          String? initialValue,
          onSaved,
          Function(String)? validator,
          bool autofocus = false,
          TextStyle? style}) =>
      MaskedTextField(
          key: key,
          label: label,
          mask: "00:00",
          initialValue: initialValue,
          onSaved: onSaved,
          autofocus: autofocus,
          validator: validator,
          sample: '12:59',
          match: r"([01]?[0-9]|2[0-3]):[0-5][0-9]",
          keyboardType: TextInputType.phone,
          style: style);

  static date(
          {Key? key,
          String label = 'Data',
          String? initialValue,
          onSaved,
          String? mask = 'dd/mm/yyyy',
          Function(String)? validator,
          TextStyle? style}) =>
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
          {Key? key,
          String label = 'Text',
          String? initialValue,
          int? maxLength,
          onSaved,
          String? mask,
          TextInputType keyboardType = TextInputType.text,
          Function(String)? validator,
          TextStyle? style}) =>
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
          {Key? key,
          String label = 'Email',
          String? initialValue,
          Function(String)? onSaved,
          Function(String)? validator,
          controller,
          TextStyle? style}) =>
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
          {Key? key,
          String label = 'Host',
          String? initialValue,
          onSaved,
          Function(String)? validator,
          TextStyle? style}) =>
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
      {Key? key,
      String label = 'Valor',
      double? initialValue,
      String? errorText,
      Function(double)? onSaved,
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
  TextEditingController? _controller;
  bool _autoDispose = false;
  @override
  void initState() {
    super.initState();
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
    _controller ??= widget.controller ??
        TextEditingController(text: widget.initialValue ?? '');
  }

  @override
  void dispose() {
    if (_autoDispose && (_controller != null)) _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      child: Focus(
          onFocusChange: (x) {
            if (widget.onFocusChange != null) widget.onFocusChange!(x);
          },
          child: TextFormField(
            textAlign: widget.textAlign ?? TextAlign.start,
            maxLength: widget.maxLength,
            readOnly: widget.readOnly!,
            autofocus: widget.autofocus!,
            initialValue:
                (_controller == null) ? widget.initialValue ?? '' : null,
            controller: _controller,
            style: widget.style ??
                theme.textTheme.bodyText1!.copyWith(fontSize: widget.fontSize),
            decoration: widget.decoration ??
                InputDecoration(
                  fillColor: widget.fillColor,
                  focusColor: widget.focusColor,
                  hoverColor: widget.hoverColor,
                  labelText: '${widget.label}',
                  suffix: widget.suffix,
                  prefix: widget.prefix,
                  helperText: !_showHelperText
                      ? (widget.sample != null)
                          ? 'Ex: ${widget.sample}'
                          : null
                      : null,
                  hintStyle: theme.inputDecorationTheme.hintStyle,
                ),
            keyboardType: widget.keyboardType ?? TextInputType.text,
            onChanged: widget.onChanged,
            validator: (value) {
              if (widget.match != null) {
                var r = RegExp(widget.match!);
                if ((!r.hasMatch(value!)) || (r.stringMatch(value) != value))
                  return (widget.sample != null)
                      ? 'Inválido (ex: ${widget.sample}) Resp: ${r.stringMatch(value)}'
                      : 'Inválido';
              }
              return (widget.validator != null)
                  ? widget.validator!(value!)
                  : (value!.isEmpty)
                      ? widget.errorText!.replaceFirst('%1', widget.label!)
                      : null;
            },
            onSaved: (widget.onSaved == null)
                ? null
                : (String? x) {
                    if (x != null) widget.onSaved!(x);
                  },
          )),
    );
  }
}

enum MaskedDatePickerType { day, time, dayAndTime }

class MaskedDatePicker extends StatefulWidget {
  final DateTime? initialValue;
  final Function(DateTime)? validator;
  final String? labelText;
  final Function(DateTime)? onSaved;
  final Function(DateTime)? onChanged;
  final String? format;
  final Widget? prefix;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final MaskedDatePickerType? type;
  final TextEditingController? controller;
  final bool? readOnly;
  final int? dayFly;
  final bool? autofocus;
  MaskedDatePicker(
      {Key? key,
      this.labelText,
      this.initialValue,
      this.controller,
      this.format = "dd/MM/yyyy",
      this.validator,
      this.prefix,
      this.autofocus = true,
      this.type = MaskedDatePickerType.day,
      this.onChanged,
      this.firstDate,
      this.dayFly = 365,
      this.lastDate,
      this.readOnly = false,
      this.onSaved})
      : super(key: key);

  @override
  _MaskedDatePickerState createState() => _MaskedDatePickerState();
}

class _MaskedDatePickerState extends State<MaskedDatePicker> {
  var changed = StreamController<DateTime>.broadcast();
  DateFormat? formatter;
  TextEditingController? _dataController;
  DateTime? _lastDate;
  DateTime? _firstDate;
  bool? autodispose;
  @override
  void initState() {
    autodispose = widget.controller == null;
    _lastDate =
        widget.lastDate ?? DateTime.now().add(Duration(days: widget.dayFly!));
    _firstDate =
        widget.firstDate ?? DateTime.now().add(Duration(days: -widget.dayFly!));

    _dataController = widget.controller ?? TextEditingController();
    formatter = DateFormat(widget.format);
    if (widget.initialValue != null) {
      _dataController!.text = formatter!.format(widget.initialValue!);
      if (_lastDate != null && (_lastDate!.compareTo(widget.initialValue!) < 0))
        _lastDate = widget.initialValue;
      if (widget.initialValue!.compareTo(_firstDate!) < 0)
        _firstDate = widget.initialValue;
    }

    super.initState();
  }

  @override
  void dispose() {
    if (autodispose!) _dataController!.dispose();
    changed.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Padding(
        padding: EdgeInsets.only(top: 3),
        child: TextFormField(
            readOnly: widget.readOnly!,
            autofocus: widget.autofocus!,
            controller: _dataController,
            keyboardType: TextInputType.phone,
            style: theme.textTheme
                .bodyText1, //TextStyle(fontSize: 16, fontStyle: FontStyle.normal),
            decoration: InputDecoration(
                labelText: widget.labelText,
                prefix: widget.prefix,
                suffixIcon: GestureDetector(
                    child: Icon(Icons.calendar_today),
                    onTap: (widget.readOnly!)
                        ? null
                        : () {
                            _dataController!.text =
                                formatter!.format(widget.initialValue!);
                          })),
            validator: (x) {
              DateTime d = formatter!.parse(x!);
              //DateTime b = formatter.parse(x);
              // debugPrint('init Validate $x $d');
              if (_firstDate != null) if (_firstDate!.isAfter(d))
                d = _firstDate!;
              if (_lastDate != null) if (_lastDate!.isBefore(d)) d = _lastDate!;

              if (widget.validator != null) return widget.validator!(d);
              //debugPrint('fim Validate $x $b $d');
              _dataController!.text = formatter!.format(d);
              return null;
            },
            onTap: () {
              if (widget.readOnly!) return;
              DateTime d = formatter!.parse(_dataController!.text);

              if (widget.type == MaskedDatePickerType.day)
                getDate(context, d).then((x) {
                  _dataController!.text = formatter!.format(x!);

                  if (widget.onChanged != null) widget.onChanged!(x);
                });
              /*       if (widget.type == MaskedDatePickerType.time)
                getTime(context).then((TimeOfDay h) {
                  var d1 = formatter.parse(_dataController.text);
                  var d = DateTime(d1.year, d1.month, d1.day)
                      .add(Duration(hours: h.hour))
                      .add(Duration(minutes: h.minute));
                  _dataController.text = formatter.format(d);
                  if (widget.onChanged != null) widget.onChanged(d);
                });
         */
              if (widget.type == MaskedDatePickerType.dayAndTime)
                getDate(context, d).then((x) {
                  var d1 = x;
                  /*             getTime(context).then((h) {
                    var d = DateTime(d1.year, d1.month, d1.day)
                        .add(Duration(hours: h.hour))
                        .add(Duration(minutes: h.minute));
                    _dataController.text = formatter.format(d);
                    if (widget.onChanged != null) widget.onChanged(d);
                  });
     */
                });
            },
            onChanged: (x) {
              widget.onChanged!(formatter!.parse(x));
            },
            onSaved: (x) {
              if (widget.onSaved != null)
                return widget.onSaved!(formatter!.parse(x!));
              return null;
            }));
  }

  Future<DateTime?> getDate(BuildContext context, DateTime data) {
    // Imagine that this function is
    // more complex and slow.
    return showDatePicker(
      context: context,
      initialDate: data,
      firstDate: _firstDate!,
      lastDate: _lastDate!,
      builder: (BuildContext context, Widget? child) {
        return Theme(data: ThemeData.light(), child: child!);
      },
    );
  }
/*
  Future<TimeOfDay> getTime(BuildContext context) {
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay(
          hour: widget.initialValue.hour, minute: widget.initialValue.minute),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light(),
          child: child,
        );
      },
    );
  }*/
}

class MaskedCheckbox extends StatefulWidget {
  final String? label;
  final bool? value;
  final Widget? leading;
  final Widget? trailing;
  final Function(bool)? onChanged;
  final bool? tristate;
  final Color? activeColor;
  final Color? checkColor;
  final Color? hoverColor;
  final Color? focusColor;
  MaskedCheckbox({
    Key? key,
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
    bool? value = widget.value ?? false;
    ThemeData theme = Theme.of(context);
    return Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        direction: Axis.horizontal,
        children: [
          if (widget.leading != null) widget.leading!,
          StatefulBuilder(builder: (context, _setState) {
            return SizedBox(
              height: 24.0,
              width: 24.0,
              child: Checkbox(
                activeColor: widget.activeColor,
                checkColor: widget.checkColor,
                hoverColor: widget.hoverColor,
                focusColor: widget.focusColor,
                tristate: widget.tristate!,
                value: (widget.tristate ?? false) ? value : value ?? false,
                onChanged: (x) {
                  if (widget.onChanged != null) widget.onChanged!(x!);
                  if (mounted)
                    _setState(() {
                      value = x;
                    });
                },
              ),
            );
          }),
          if (widget.label != null)
            Text(widget.label!, style: theme.inputDecorationTheme.hintStyle),
          if (widget.trailing != null) widget.trailing!
        ]);
  }
}

class MaskedSwitchFormField extends StatefulWidget {
  final bool? value;
  final String? label;
  final Color? activeTrackColor, inactiveTrackColor;
  final Color? activeColor;
  final bool? autofocus;
  final Function(bool)? onChanged;
  final Widget? leading;
  final Widget? trailing;
  final bool? readOnly;
  MaskedSwitchFormField({
    Key? key,
    this.value,
    this.label,
    this.activeTrackColor,
    this.activeColor,
    this.inactiveTrackColor,
    this.autofocus = false,
    this.readOnly = false,
    this.onChanged,
    this.leading,
    this.trailing,
  }) : super(key: key);

  @override
  _MaskedSwitchFormFieldState createState() => _MaskedSwitchFormFieldState();
}

class _MaskedSwitchFormFieldState extends State<MaskedSwitchFormField>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    ValueNotifier<bool> initialValue = ValueNotifier<bool>(widget.value!);

    return Container(
        width: 180,
        height: kToolbarHeight,
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          if (widget.leading != null) widget.leading!,
          if (widget.label != null)
            Expanded(
              child: Text(
                widget.label ?? '' + '  ',
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ValueListenableBuilder(
              valueListenable: initialValue,
              builder: (
                BuildContext context,
                bool value,
                Widget? child,
              ) {
                return Switch(
                    value: initialValue.value,
                    activeColor: widget.activeColor,
                    activeTrackColor: widget.activeTrackColor,
                    inactiveTrackColor: widget.inactiveTrackColor,
                    autofocus: widget.autofocus!,
                    onChanged: (b) {
                      if (!widget.readOnly!) {
                        if (widget.onChanged != null) widget.onChanged!(b);
                        initialValue.value = b;
                      }
                    });
              }),
          if (widget.trailing != null) widget.trailing!
        ]));
  }

  @override
  bool get wantKeepAlive => true;
}

class MaskedDropDownFormField extends StatelessWidget {
  final List<String>? items;
  final String? hintText;
  final TextStyle? style;
  final String? value;
  final Function? onChanged;
  final Function? onSaved;
  final Function? validator;
  final String? errorMsg;
  final Color? hintColor;
  final Widget? trailing;
  final Widget? leading;
  final bool? readOnly;

  final Function(dynamic)? onItemChanged;
  final EdgeInsetsGeometry? padding;
  final double? top;
  final double? bottom;
  const MaskedDropDownFormField(
      {Key? key,
      this.items,
      this.hintText,
      this.style,
      this.value,
      this.onChanged,
      this.onSaved,
      this.validator,
      this.errorMsg,
      this.hintColor,
      this.padding,
      this.trailing,
      this.top = 4,
      this.bottom = 8,
      this.onItemChanged,
      this.readOnly = false,
      this.leading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    if (items!.length == 0) items!.add('');
    String _value = value ?? '';

    /// regulariza value que não consta da lista ;
    if (!items!.contains(_value)) {
      /// se item não existe na lista, por branco
      _value = '';

      /// se branco não tem na lista, adicionar
      if (!items!.contains(_value)) items!.insert(0, _value);
    }
    // remover repetidos
    List<String> _items = [];
    for (var i = 0; i < items!.length; i++) {
      if (!_items.contains(items![i])) _items.add(items![i]);
    }

    ValueNotifier<String> valueChange = ValueNotifier<String>(_value);
    return Container(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 10),
      child: ValueListenableBuilder(
        valueListenable: valueChange,
        builder: (a, v, w) {
          if (onItemChanged != null) onItemChanged!(v);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leading != null) leading!,
              if (hintText != null)
                Container(
                    padding: EdgeInsets.only(top: top!, bottom: 1),
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      hintText ?? '',
                      style: theme.inputDecorationTheme.hintStyle,
                    )),
              DropdownButtonHideUnderline(
                key: UniqueKey(),
                child: Theme(
                  data: theme.copyWith(canvasColor: theme.primaryColorLight),
                  child: DropdownButton(
                    items: _items.map((String label) {
                      return DropdownMenuItem(
                        key: UniqueKey(),
                        value: label,
                        child: Container(
                          child: Text(
                            label,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      );
                    }).toList(),
                    isDense: true,
                    isExpanded: true,
                    onChanged: (x) {
                      if (readOnly!) return;

                      if (validator != null) if ((validator!(x!) != null)) {
                        return;
                      }
                      if (onChanged != null) onChanged!(x);
                      if (onSaved != null) onSaved!(x);
                      valueChange.value = x as String;
                    },
                    hint: (hintText == null)
                        ? null
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(hintText!),
                          ),
                    value: v,
                  ),
                ),
              ),
              if (trailing != null) trailing!,
              SizedBox(
                height: bottom,
              ),
              Container(height: 2, color: theme.dividerColor),
            ],
          );
        },
      ),
    );
  }
}

class MaskedMoneyFormField extends StatelessWidget {
  final String? label; //= 'Valor',
  final double? initialValue; //,
  final Function(double)? onSaved;
  final String? leftSymbol; // = '';
  final String? rightSymbol;
  final int? precision; // = 2
  final MoneyMaskedTextController? controller;
  final String? errorText;
  final int? maxLength;
  final dynamic Function(double)? validator;
  final Function(double)? onFocusChanged;
  final bool? readOnly;
  final Function(double)? onChanged;
  final double? width;
  const MaskedMoneyFormField({
    Key? key,
    this.width,
    this.label,
    this.initialValue,
    this.onChanged,
    this.onSaved,
    this.leftSymbol = '',
    this.precision,
    this.controller,
    this.readOnly = false,
    this.onFocusChanged,
    this.errorText,
    this.validator,
    this.maxLength,
    this.rightSymbol,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //ThemeData theme = Theme.of(context);
    var _controller = controller ??
        MoneyMaskedTextController(
            initialValue: initialValue!,
            decimalSeparator: ',',
            thousandSeparator: '.',
            leftSymbol: leftSymbol! + '  ',
            rightSymbol: rightSymbol ?? '',
            precision: precision ?? 2);
    _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length));
    _controller.afterChange = (mask, value) {
      //debugPrint(' mask: $mask , value: $value ');
    };
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /*if (label != null)
            Text(
              label,
              style: theme.textTheme.caption, //TextStyle(
              //fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
            ),*/
          Container(
            constraints: BoxConstraints(minWidth: 100),
            height: kToolbarHeight + 3,
            width: width,
            child: Focus(
              canRequestFocus: false,
              onFocusChange: (b) {
                if (!b && (onFocusChanged != null))
                  onFocusChanged!(_controller.numberValue);
              },
              child: Row(children: [
                Expanded(
                    child: TextFormField(
                        key: key,
                        controller: _controller,
                        readOnly: readOnly!,
                        keyboardType: TextInputType.number,
                        autofocus: true,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          //hintText: label,
                          labelText: label,
                        ),
                        validator: (x) {
                          if (validator != null)
                            return validator!(_controller.numberValue);
                          if ((errorText != null) && (x == '')) {
                            return errorText;
                          }
                          return null;
                        },
                        maxLength: maxLength,
                        onChanged: (x) {
                          if (onChanged != null)
                            onChanged!(_controller.numberValue);
                        },
                        onSaved: (x) {
                          if (onSaved != null)
                            onSaved!(_controller.numberValue);
                        })),
                if (rightSymbol != null) Text(rightSymbol!),
              ]),
            ),
          )
        ]);
  }
}

class MaskedLabeled extends StatelessWidget {
  const MaskedLabeled({
    Key? key,
    this.label,
    this.sublabel,
    this.value,
    this.padding,
  }) : super(key: key);

  final String? label;
  final String? value;
  final String? sublabel;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Padding(
        padding: padding ?? EdgeInsets.only(left: 4), //, bottom: 2),
        child: Container(
          height: kToolbarHeight + 3,
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
              Row(children: [
                Expanded(
                    child: Text(label ?? '',
                        style: theme.inputDecorationTheme
                            .hintStyle)), //TextStyle(fontSize: 12, color: Colors.grey))),
                if (sublabel != null)
                  Text(sublabel!, style: theme.inputDecorationTheme.hintStyle),
              ]),
              Padding(
                  padding: EdgeInsets.only(bottom: 8, top: 4),
                  child: Text(value ?? '',
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme
                          .bodyText1) // TextStyle(fontSize: 14, color: Colors.grey)),
                  ),
            ],
          ),
        ));
  }
}

class MaskedLabeledFormField extends StatelessWidget {
  final String? labelText;
  final String? initialValue;
  final TextEditingController? controller;

  const MaskedLabeledFormField(
      {Key? key, this.labelText, this.initialValue, this.controller})
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
  final T? initialValue;
  final TextEditingController? controller;
  final String Function(T)? onGetValue;
  final T Function(String)? onSetValue;
  final InputDecoration? decoration;
  final Function(T)? validator;
  final Function(T)? onSaved;
  final bool? autofocus;
  final TextStyle? style;
  final Future<T?>? Function()? onSearch;
  final IconData? iconSearch;
  final bool? readOnly;
  final String? labelText;
  final int? maxLines;
  final Function(T)? onChanged;
  final Function(bool, T)? onFocusChange;
  final TextInputType? keyboardType;
  final bool required;

  const MaskedSearchFormField(
      {Key? key,
      this.initialValue,
      this.onGetValue,
      this.decoration,
      this.keyboardType,
      this.validator,
      this.onSaved,
      this.autofocus = false,
      this.onSetValue,
      //this.controller,
      this.style,
      this.onSearch,
      this.onFocusChange,
      this.iconSearch = Icons.search,
      this.readOnly = false,
      this.required = true,
      this.labelText,
      this.maxLines = 1,
      this.onChanged,
      this.controller})
      : super(key: key);

  String getValue(T? v) {
    if (onGetValue != null)
      return onGetValue!(v ?? initialValue!);
    else
      return '${v ?? initialValue ?? ''}';
  }

  Type typeOf<T>() => T;
  T setValue(String value) {
    if (onSetValue != null) {
      return onSetValue!(value);
    }

    if (typeOf<T>() == typeOf<Money>()) return Money.tryParse(value) as T;
    if (typeOf<T>() == typeOf<int>()) return int.tryParse(value) as T;
    if (typeOf<T>() == typeOf<double>()) return double.tryParse(value) as T;
    if (typeOf<T>() == typeOf<num>()) return double.tryParse(value) as T;
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
    ThemeData theme = Theme.of(context);
    final TextEditingController _controller = this.controller ??
        TextEditingController(text: getValueStr(getValue(initialValue!)));
    return Focus(
        canRequestFocus: false,
        onFocusChange: (x) {
          if (onFocusChange != null)
            onFocusChange!(x, setValue(_controller.text));
        },
        child: TextFormField(
            autofocus: autofocus!,
            controller: _controller,
            keyboardType: keyboardType ?? getKeyboardType(),
            style: style ??
                theme.textTheme
                    .bodyText1, //TextStyle(fontSize: 16, fontStyle: FontStyle.normal),
            decoration: decoration ??
                InputDecoration(
                    labelText: labelText,
                    suffixIcon: (readOnly!)
                        ? null
                        : GestureDetector(
                            //focusNode: FocusNode(
                            //    canRequestFocus: false, onKey: (a, b) => false),
                            child: Icon(iconSearch),
                            onTap: () async {
                              if (onSearch != null) if (!readOnly!) {
                                var item = await onSearch!();
                                if (item != null) {
                                  _controller.text = getValue(item);
                                  if (onChanged != null) onChanged!(item);
                                }
                              }
                            })),
            enableSuggestions: true,
            expands: maxLines! > 1,
            maxLines: maxLines,
            minLines: 1,
            readOnly: readOnly!,
            onChanged: (value) {
              if (onChanged != null) onChanged!(setValue(value));
            },
            validator: (value) {
              if (validator != null) return validator!(setValue(value!));
              return (setValue(value!) == null) ? 'Valor inválido' : null;
            },
            onSaved: (x) {
              T v = setValue(x!);
              onSaved!(v);
            }));
  }

  getValueStr(value) {
    var v = '$value';
    if (v == '0' || v == '0.0') return '';
    return value;
  }
}
