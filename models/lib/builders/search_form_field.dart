// @dart=2.12

import 'package:controls_web/controls.dart';
import 'package:flutter/material.dart';

final _suggestionStorage = {};

class SearchFormFieldController extends MaskedAutoCompleteTextFieldController {}

class SuggestionController {
  String? keyStorage;
  ValueNotifier<List>? suggestionsNotifier;
  add(List<dynamic> list) {
    bool changed = false;
    list.forEach((element) {
      if (!_suggestionStorage[keyStorage].contains(element)) {
        _suggestionStorage[keyStorage].add(element);
        changed = true;
      }
    });
    if (changed && suggestionsNotifier != null)
      suggestionsNotifier!.value = items;
    return items;
  }

  get items => _suggestionStorage[keyStorage] ??= [];
}

class SearchFormField extends StatefulWidget {
  final Function(dynamic)? onChanged;
  final String keyStorage;
  final String keyField;
  final String nameField;
  final String? initialValue;
  final Future<List<dynamic>> Function(String) future;
  final String? sublabel;
  final Future<Map<String, dynamic>?> Function(BuildContext context)? onSearch;
  final Widget? leadding;
  final String? label;
  final List<Widget>? actions;
  final int minChars;
  final int interval;
  final String? Function(String)? validator;
  final TextInputType? keyboardType;
  final ValueNotifier<List>? suggestionsNotifier;
  final int? suggestionsAmount;
  final TextEditingController? controller;
  final bool readOnly;
  final bool autofocus;
  final bool clearOnSubmit;
  final Widget? sufixIcon;
  final Widget? prefixIcon;
  final SearchFormFieldController? stateController;
  final Function(bool hasFocus, String value)? onFocusChanged;
  final SuggestionController? suggestionController;

  const SearchFormField({
    Key? key,
    required this.keyStorage,
    this.onChanged,
    required this.keyField,
    this.suggestionsNotifier,
    required this.nameField,
    required this.future,
    required this.controller,
    this.validator,
    this.label,
    this.suggestionsAmount = 8,
    this.readOnly = false,
    this.onFocusChanged,
    this.sublabel,
    this.clearOnSubmit = false,
    this.initialValue,
    this.leadding,
    this.sufixIcon,
    this.prefixIcon,
    this.actions,
    this.autofocus = false,
    this.minChars = 3,
    this.interval = 700,
    this.onSearch,
    this.stateController,
    this.keyboardType,
    this.suggestionController,
  }) : super(key: key);

  @override
  _SeartFormFieldState createState() => _SeartFormFieldState();
}

class _SeartFormFieldState extends State<SearchFormField> {
  get _suggestions => _suggestionController.items;

  final _initial = {};
  late ValueNotifier<List> _notifier;
  FocusNode? _focus;
  late SuggestionController _suggestionController;
  @override
  void initState() {
    super.initState();
    //_notifier = widget.suggestionsNotifier ?? ValueNotifier<List>([]);
    _closing = false;
    textController = widget.controller ?? TextEditingController();
    _focus = FocusNode();

    _notifier = widget.suggestionsNotifier ?? ValueNotifier<List>([]);

    _suggestionController =
        widget.suggestionController ?? SuggestionController();
    _suggestionController.keyStorage ??= widget.keyStorage;
    _suggestionController.suggestionsNotifier ??= _notifier;

    _initial[widget.nameField] = widget.initialValue;
    _focus!.addListener(() {
      if (widget.onFocusChanged != null) {
        widget.onFocusChanged!(_focus!.hasFocus, textController!.text);
      }
    });
  }

  late bool _closing;
  @override
  void dispose() {
    _closing = true;
    super.dispose();
  }

  TextEditingController? textController;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.leadding != null) widget.leadding!,
        Expanded(
          child: ValueListenableBuilder<List>(
            valueListenable: _notifier,
            builder: (a, b, c) {
              if (_closing) return Container();
              if ((b).isNotEmpty) addSugestions(b);
              return MaskedAutoCompleteTextField(
                controller: textController,
                keyboardType: widget.keyboardType ?? TextInputType.text,
                interval: widget.interval,
                minChars: widget.minChars,
                name: widget.nameField,
                readOnly: widget.readOnly,
                autofocus: widget.autofocus,
                clearOnSubmit: widget.clearOnSubmit,
                sufixIcon: widget.sufixIcon,
                prefixIcon: widget.prefixIcon,
                focusNode: _focus,
                future: widget.future,
                suggestions: _suggestions,
                onLoaded: (lst) => addSugestions(lst),
                onChanged: widget.onChanged,
                sublabel: widget.sublabel ?? '',
                label: widget.label,
                stateController: widget.stateController,
                initialValue: widget.initialValue ?? '',
                validator: (x) {
                  if (widget.validator != null) widget.validator!(x ?? '');
                  return null;
                },
                suggestionsAmount: widget.suggestionsAmount,
              );
            },
          ),
        ),
        if (widget.onSearch != null)
          IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                widget.onSearch!(context).then((rsp) {
                  if (rsp != null) {
                    addSugestions([rsp]);
                    widget.onChanged!(rsp);
                  }
                });
              }),
        if (widget.actions != null) ...widget.actions!,
      ],
    );
  }

  List addSugestions(List? lst) {
    if (lst != null) {
      if (lst.isNotEmpty) if (lst[0]['nome'] == null) {
        return _suggestionController.add(lst);
      } else {
        lst.forEach((item) {
          if (item == null || item['nome'] == null) {
            _suggestionController.add([item]);
          } else {
            var achou = false;
            _suggestions.forEach((element) {
              if (element['nome'] == item['nome']) achou = true;
            });
            if (!achou) {
              var s = '';
              item.keys.forEach((k) {
                s += ';${item[k]}';
              });
              item['key-search'] = s;
              _suggestions.add(item);
            }
          }
        });
      }
    }
    return _suggestions;
  }
}
