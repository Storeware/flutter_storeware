import 'dart:async';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';

class MaskedAutoCompleteTextField extends StatefulWidget {
  final Function(dynamic) onChanged;
  final String initialValue;
  final List<dynamic> suggestions;
  final String name;
  final String label;
  final Widget suffixIcon;
  //final Function(String) onSearch;
  final int interval;
  final int minChars;
  final TextInputType keyboardType;
  final String sublabel;

  /// [futureBulider] para carregar uma novo ciclo de dados
  final Future<List<dynamic>> Function(String) future;

  /// [onLoaded] evento chamado depois que gerou o ciclo de dados
  final List<dynamic> Function(List<dynamic>) onLoaded;

  const MaskedAutoCompleteTextField({
    Key key,
    this.initialValue,
    @required this.suggestions,
    @required this.onChanged,
    @required this.name,
    this.suffixIcon,
    this.label,
    this.sublabel,
    this.interval = 1000,
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
  DateTime lastTime;
  String lastValue;
  TextEditingController _controller;
  ValueNotifier<String> valueChanged = ValueNotifier<String>(null);
  List<dynamic> _suggestions;
  bool _loading;
  resetTimer() {
    createTimer();
    lastTime = DateTime.now();
  }

  Timer timer;
  @override
  void initState() {
    super.initState();
    _loading = false;
    lastTime = DateTime.now();
    lastValue = widget.initialValue ?? '';
    _controller = TextEditingController(text: lastValue);
    _suggestions = widget.suggestions ?? [];
    createTimer();
  }

  createTimer() {
    if (timer != null) {
      timer.cancel();
      timer = null;
    }
    timer ??= Timer(Duration(milliseconds: widget.interval), () {
      checkProcura(lastTime, widget.interval, widget.minChars, false);

      checkProcura(lastTime, widget.interval * 2, widget.minChars + 3, true);
    });
  }

  checkProcura(lstTime, interval, minChars, bool suplementar) {
    print([
      'checkProcura.enter',
      _controller.text,
      _controller.text.length,
      lastValue
    ]);
    if (_controller.text.length >= minChars) if (lastValue !=
        _controller.text) {
      if (DateTime.now().difference(lstTime).inMilliseconds > interval) {
        if (!_loading) {
          _loading = true;
          try {
            print('checkProcura.filtered');

            if (suplementar ||
                (key.currentState?.filteredSuggestions?.length ?? -1) == 0) {
              lastValue = _controller.text;
              lastTime = DateTime.now();
              valueChanged.value = _controller.text;
              print('checkProcura.value $lastValue');

              //setState(() {
              //_controller.text = lastValue;
              //});
            }
          } finally {
            _loading = false;
          }
        }
      }
    }
  }

  GlobalKey<AutoCompleteTextFieldState<dynamic>> key =
      GlobalKey<AutoCompleteTextFieldState<dynamic>>();

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Future<List<dynamic>> doFuture(String b) {
    if (b == null || widget.future == null) return Future.value([]);
    return widget.future(b);
  }

  get suggestions => _suggestions ?? key.currentState.suggestions;
  doOnLoaded(data) {
    if (data != null) {
      var l = _suggestions.length;
      if (widget.onLoaded != null) {
        addSuggestions(widget.onLoaded(data));
      } else
        addSuggestions(data);
      if (l != _suggestions.length)
        Timer.run(() {
          updateSuggestions();
        });
    }
  }

  addSuggestions(List<dynamic> data) {
    if ((data ?? []).length > 0) {
      data.forEach((elem) {
        if (_suggestions
                .where((it) => it[widget.name] == elem[widget.name])
                .length ==
            0) _suggestions.add(elem);
      });
      print(_suggestions);
    }
  }

  updateSuggestions() {
    print('updateSuggestions');
    if (key.currentState != null)
      key.currentState.updateSuggestions(_suggestions);
  }

  @override
  Widget build(BuildContext context) {
    _controller.text = widget.initialValue;
    return ValueListenableBuilder<String>(
      valueListenable: valueChanged,
      builder: (a, b, c) {
        print(_controller.text);
        return FutureBuilder<List<dynamic>>(
            future: doFuture(b),
            builder: (context, snapshot) {
              doOnLoaded(snapshot.data);
              print([
                widget.initialValue,
                b,
                _controller.text,
                _suggestions.length
              ]);
              return Stack(
                children: [
                  AutoCompleteTextField<dynamic>(
                    key: key,
                    decoration: new InputDecoration(
                        hintText: widget.label ?? "procurar por:",
                        contentPadding: EdgeInsets.all(0),
                        suffixIcon: widget.suffixIcon),
                    itemSorter: (a, b) => '$a'.compareTo('$b'),
                    suggestions: _suggestions,
                    itemSubmitted: (x) {
                      if (widget.onChanged != null) widget.onChanged(x);
                    },
                    itemFilter: (suggestion, input) {
                      var ret = ('${suggestion[widget.name]}')
                          .toLowerCase()
                          .contains(input.toLowerCase());
                      return ret;
                    },
                    keyboardType: widget.keyboardType,
                    textChanged: (x) => resetTimer(),
                    controller: _controller,
                    itemBuilder: (context, suggestion) => Padding(
                        child:
                            new Container(child: Text(suggestion[widget.name])),
//              trailing: new Text(suggestion}")),
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
