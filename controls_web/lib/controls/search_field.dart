// @dart=2.12
import 'package:flutter/material.dart';

import 'group_buttons.dart';

class SearchField extends StatefulWidget {
  final String? initialValue;
  final Function(String)? onChanged;
  final Function(String)? onSearchPressed;
  final Widget? bottom;
  final Widget? header;
  final List<String>? options;
  final ValueNotifier<int>? optionsNotifier;
  final Function(int)? onPressed;
  final String? label;
  final double radius;
  final int itemIndex;
  final Function()? onResetPressed;
  final TextEditingController? controller;
  SearchField({
    Key? key,
    this.onChanged,
    this.onSearchPressed,
    this.options,
    this.optionsNotifier,
    this.onPressed,
    this.header,
    this.label,
    this.bottom,
    this.itemIndex = 0,
    this.controller,
    this.onResetPressed,
    this.radius = 30.0,
    this.initialValue,
  }) : super(key: key);

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late TextEditingController _searchController;
  //late int _selected;
  @override
  void initState() {
    super.initState();
    //_selected = widget.itemIndex;
    _searchController = widget.controller ?? TextEditingController();
    _searchController.text = widget.initialValue ?? '';
  }

  @override
  Widget build(BuildContext context) {
    //var theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 1.0, right: 1.0),
      child: Column(
        children: [
          if (widget.header != null) widget.header!,
          TextFormField(
            controller: _searchController,
            onChanged: (value) {
              if (widget.onChanged != null) widget.onChanged!(value);
            },
            decoration: InputDecoration(
              labelText: widget.label,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.radius),
              ),
              suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    if (widget.onSearchPressed != null)
                      widget.onSearchPressed!(_searchController.text);
                  }),
              prefixIcon: (widget.onResetPressed == null)
                  ? null
                  : IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        widget.onResetPressed!();
                      }),
            ),
          ),
          if (widget.options != null)
            Padding(
              padding: const EdgeInsets.only(left: 1.0),
              child: GroupButtons(
                  notifier: widget.optionsNotifier,
                  itemIndex: widget.itemIndex,
                  options: widget.options!,
                  onChanged: (index) {
                    if (widget.onPressed != null) widget.onPressed!(index);
                  }),
            ),
          if (widget.bottom != null) widget.bottom!,
        ],
      ),
    );
  }
}
