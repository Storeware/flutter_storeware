import 'package:flutter/material.dart';

class FormFieldSearch extends StatefulWidget {
  const FormFieldSearch({
    Key? key,
    this.label = 'Nome',
    @required this.text,
    this.onSearch,
    this.icon,
    this.controller,
    this.btnClear = true,
    this.color,
  }) : super(key: key);
  final Color? color;
  final String? text;
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
    controller.text = widget.text!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (widget.color == null)
        ? buildTextFormField()
        : Container(
            color: widget.color,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
              ),
              child: buildTextFormField(),
            ));
  }

  TextFormField buildTextFormField() {
    return TextFormField(
      controller: controller,

      style: TextStyle(fontSize: 16, fontStyle: FontStyle.normal),
      decoration: InputDecoration(
        //border: InputBorder.none,
        labelText: widget.label,
        fillColor: widget.color,
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
