// @dart=2.12

// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

/// [CodebarCameraField] de uso para Android e IOS (maybe)
/// uso interno para [CodebarTextField]
/// [CodebarTextField] usa [CodebarCameraField]
///
class CodebarCameraField extends StatefulWidget {
  final Function(String?)? callback;
  final Function(String?)? validator;
  final Function(String?)? onSaved;
  final String? labelText;
  final String? hintText;
  final bool autofocus;
  final String? initialValue;
  final Widget? suffixIcon;
  final InputBorder? border;
  final TextEditingController? controller;
  final TextInputType? keyboardType;

  const CodebarCameraField({
    Key? key,
    this.labelText,
    this.callback,
    this.validator,
    this.initialValue,
    this.hintText,
    this.autofocus = false,
    this.onSaved,
    this.suffixIcon,
    this.border,
    this.controller,
    this.keyboardType,
  }) : super(key: key);

  @override
  _CodebarCameraFieldState createState() => _CodebarCameraFieldState();
}

class _CodebarCameraFieldState extends State<CodebarCameraField> {
  String? _scanBarcode;
  String? codigo;
  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", false, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Falha ao localizar a plataforma';
    }

    if (!mounted) return;

    _scanBarcode = barcodeScanRes;
    if ((_scanBarcode ?? '').isNotEmpty) {
      if (_scanBarcode! != '-1') {
        codigoCtrl.text = _scanBarcode!;
        widget.callback!(_scanBarcode);
      }
    }
  }

  late TextEditingController codigoCtrl;
  @override
  void initState() {
    super.initState();
    codigoCtrl =
        widget.controller ?? TextEditingController(text: widget.initialValue);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: widget.autofocus,
      controller: codigoCtrl,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        border: widget.border,
        suffixIcon: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              child: Icon(FontAwesomeIcons.barcode),
              onPressed: () {
                initPlatformState();
              },
            ),
            if (widget.suffixIcon != null) widget.suffixIcon!,
          ],
        ),
      ),
      validator: (x) {
        if (widget.validator != null) return widget.validator!(x);
        return null;
      },
      onSaved: (x) {
        if (widget.onSaved != null) widget.onSaved!(x);
      },
    );
  }
}
