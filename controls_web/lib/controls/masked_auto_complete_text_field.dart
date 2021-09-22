// @dart=2.12

import 'dart:async';

import 'package:flutter/material.dart';

import 'autocomplete_textformfield.dart';

class MaskedAutoCompleteTextFieldController
    extends AutoCompleteTextFormFieldController {
  late _MaskedAutoCompleteTextFieldState maskedState;
  @override
  closeOverlay(String text) {
    maskedState.resetTimer();
    maskedState.lastValue = text;
    super.closeOverlay(text);
  }
}

class MaskedAutoCompleteTextField extends StatefulWidget {
  final Function(dynamic)? onChanged;
  final String? initialValue;
  final List<dynamic>? suggestions;
  final String name;
  final String? label;
  final Widget? prefixIcon, sufixIcon;

  final int interval;
  final int minChars;
  final TextInputType? keyboardType;
  final String? sublabel;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Widget Function(BuildContext, String)? itemBuilder;
  final int? suggestionsAmount;
  final bool readOnly;
  final bool autofocus;
  final FocusNode? focusNode;
  final bool clearOnSubmit;
  final MaskedAutoCompleteTextFieldController? stateController;

  /// [futureBulider] para carregar uma novo ciclo de dados
  final Future<List<dynamic>> Function(String)? future;

  /// [onLoaded] evento chamado depois que gerou o ciclo de dados
  final List<dynamic> Function(List<dynamic>)? onLoaded;

  const MaskedAutoCompleteTextField({
    Key? key,
    this.initialValue,
    required this.suggestions,
    required this.onChanged,
    required this.name,
    this.controller,
    this.stateController,
    this.validator,
    this.sufixIcon,
    this.prefixIcon,
    this.label,
    this.readOnly = false,
    this.autofocus = true,
    this.focusNode,
    this.itemBuilder,
    this.sublabel,
    this.interval = 1000,
    this.suggestionsAmount = 5,
    this.clearOnSubmit = false,
    //this.onSearch,
    this.minChars = 3,
    this.future,
    this.keyboardType,
    this.onLoaded,
  }) : super(key: key);

  @override
  _MaskedAutoCompleteTextFieldState createState() =>
      _MaskedAutoCompleteTextFieldState();
}

class _MaskedAutoCompleteTextFieldState
    extends State<MaskedAutoCompleteTextField> {
  DateTime? lastTime;
  String? lastValue;
  TextEditingController? _controller;
  ValueNotifier<String?> valueChanged = ValueNotifier<String?>(null);
  List<dynamic>? _suggestions;
  late bool _loading;
  resetTimer() {
    createTimer();
    lastTime = DateTime.now();
  }

  Timer? timer;
  @override
  void initState() {
    super.initState();
    if (widget.stateController != null)
      widget.stateController!.maskedState = this;
    _loading = false;
    lastTime = DateTime.now();
    lastValue = widget.initialValue ?? '';
    _controller = widget.controller ?? TextEditingController(text: lastValue);
    _suggestions = widget.suggestions ?? [];
    if (_controller!.text != lastValue) _controller!.text = lastValue!;
    createTimer();
  }

  createTimer() {
    if (timer != null) {
      timer!.cancel();
      timer = null;
    }
    timer ??= Timer(Duration(milliseconds: widget.interval), () {
      checkProcura(lastTime, widget.interval, widget.minChars, false);

      checkProcura(lastTime, widget.interval * 2, widget.minChars + 3, true);
    });
  }

  checkProcura(lstTime, interval, minChars, bool suplementar) {
    if (_controller!.text.length >= minChars) if (lastValue !=
        _controller!.text) {
      if (DateTime.now().difference(lstTime).inMilliseconds > interval) {
        if (!_loading) {
          _loading = true;
          try {
            if (suplementar ||
                (key.currentState?.filteredSuggestions?.length ?? -1) == 0) {
              lastValue = _controller!.text;
              lastTime = DateTime.now();
              valueChanged.value = _controller!.text;
            }
          } finally {
            _loading = false;
          }
        }
      }
    }
  }

  GlobalKey<AutoCompleteTextFormFieldState<dynamic>> key =
      GlobalKey<AutoCompleteTextFormFieldState<dynamic>>();

  @override
  void dispose() {
    timer!.cancel();
    if (widget.controller == null) _controller!.dispose();
    super.dispose();
  }

  Future<List<dynamic>> doFuture(String? b) {
    if (b == null || widget.future == null) return Future.value([]);
    return widget.future!(b).then((rsp) {
      return rsp;
    });
  }

  get suggestions => _suggestions ?? key.currentState!.suggestions;
  doOnLoaded(data) {
    if (data != null) {
      var l = _suggestions!.length;
      if (widget.onLoaded != null) {
        addSuggestions(widget.onLoaded!(data));
      } else
        addSuggestions(data);
      if (l != _suggestions!.length)
        Timer.run(() {
          updateSuggestions();
        });
    }
  }

  addSuggestions(List<dynamic> data) {
    if (data.length > 0) {
      data.forEach((elem) {
        if (_suggestions!
                .where((it) => it[widget.name] == elem[widget.name])
                .length ==
            0) {
          var s = '';
          elem.keys.forEach((k) {
            s += ';' + '${elem[k]}';
          });
          elem['key-search'] = s;
          _suggestions!.add(elem);
        }
      });
    }
  }

  updateSuggestions() {
    if (key.currentState != null)
      key.currentState!.updateSuggestions(_suggestions);
  }

  validating(tx) {
    if (widget.validator != null) return widget.validator!(tx);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: valueChanged,
      builder: (a, b, c) {
        return FutureBuilder<List<dynamic>>(
            future: doFuture(b),
            builder: (context, snapshot) {
              doOnLoaded(snapshot.data);
              return Stack(
                children: [
                  AutoCompleteTextFormField<dynamic>(
                    key: key,
                    readOnly: widget.readOnly,
                    suggestionsAmount: widget.suggestionsAmount,
                    validator: widget.validator,
                    autofocus: widget.autofocus,
                    focusNode: widget.focusNode,
                    decoration: new InputDecoration(
                        labelText: widget.label ?? "procurar por:",
                        contentPadding: EdgeInsets.all(0),
                        // errorText: validating(_controller.text),
                        // errorStyle:
                        //     TextStyle(color: theme.textTheme.bodyText1.color),
                        prefixIcon: widget.prefixIcon,
                        suffixIcon: widget.sufixIcon),
                    itemSorter: (a, b) => '$a'.compareTo('$b'),
                    suggestions: _suggestions,
                    itemSubmitted: (x) {
                      if (widget.onChanged != null) widget.onChanged!(x);
                    },
                    clearOnSubmit: widget.clearOnSubmit,
                    itemFilter: (suggestion, input) {
                      var ret = ('${suggestion[widget.name]}')
                          .toLowerCase()
                          .contains(input.toLowerCase());
                      if (!ret)
                        ret = ('${suggestion['key-search'] ?? ''}')
                            .toLowerCase()
                            .contains(input.toLowerCase());
                      return ret;
                    },
                    //textSubmitted: widget.validator,
                    keyboardType: widget.keyboardType,
                    textChanged: (x) => resetTimer(),
                    controller: _controller,
                    stateController: widget.stateController,
                    itemBuilder: widget.itemBuilder as Widget Function(
                            BuildContext, dynamic)? ??
                        (context, suggestion) => Padding(
                            child: new Container(
                                child: Text(suggestion[widget.name])),
                            padding: EdgeInsets.all(8.0)),
                  ),
                  if ((widget.sublabel ?? '').length > 0)
                    Positioned(
                        right: 0,
                        child: Text('(${widget.sublabel})',
                            style: TextStyle(fontSize: 12))),
                ],
              );
            });
      },
    );
  }
}
