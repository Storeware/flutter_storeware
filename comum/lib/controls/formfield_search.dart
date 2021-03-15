import 'package:flutter/material.dart';

class FormFieldSearch extends StatefulWidget {
  const FormFieldSearch({
    Key? key,
    this.label = 'Nome',
    @required this.codigo,
    this.onSearch,
    this.icon,
    this.controller,
    this.btnClear = true,
  }) : super(key: key);

  final String? codigo;
  final String? label;
  final IconData? icon;
  final bool? btnClear;
  final TextEditingController? controller;
  final Function(String)? onSearch;

  @override
  _FormFieldSearchState createState() => _FormFieldSearchState();
}

class _FormFieldSearchState extends State<FormFieldSearch> {
  final _codigoController = TextEditingController();

  TextEditingController get controller {
    return widget.controller ?? _codigoController;
  }

  @override
  void initState() {
    controller.text = widget.codigo!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: TextStyle(fontSize: 16, fontStyle: FontStyle.normal),
      decoration: InputDecoration(
        //border: InputBorder.none,
        labelText: widget.label,
        suffixIcon: Wrap(
          children: <Widget>[
            if (widget.btnClear!)
              IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  controller.text = '';
                },
              ),
            if (widget.onSearch != null)
              IconButton(
                icon: Icon(widget.icon ?? Icons.search),
                onPressed: () {
                  if (widget.onSearch != null)
                    widget.onSearch!(controller.text);
                },
              )
          ],
        ),
      ), //suffixIcon: ,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Falta informar: ${widget.label}';
        }
        return null;
      },
      //onSaved: (x) {
      //  _codigoController.text = x;
      // }
    );
  }
}
