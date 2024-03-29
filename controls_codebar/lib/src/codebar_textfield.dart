// @dart=2.12
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';

import 'codebar_field.dart';
import 'package:controls_web/drivers.dart';

/// [CodigoBarrasCodigoChange] é chamado quando recebe um código de barras pela camera do dispositivo;
/// ´´´´dart
/// ex: CodigoBarrarCodigoChanged.stream.listen((codigo){});
/// ´´´´
class CodigoBarrarCodigoChanged extends BlocModel<String> {
  static final _singleton = CodigoBarrarCodigoChanged._create();
  CodigoBarrarCodigoChanged._create();
  factory CodigoBarrarCodigoChanged() => _singleton;
}

/// [CodebarTextField] seleciona o dispositivo para leitura de código de barras, quando houver camera
/// * para android, ativa a camera do dispositivo;
/// * para web, mostra o TextField
class CodebarTextField extends StatefulWidget {
  final String? initialValue;
  final Function(String)? onChanged;
  final Function(String) onScan;

  /// [onScan] é chamado quando o código de barras é lido
  final bool maybeUseCamera;
  final bool enabled;
  final String? Function(String)? validator;
  final String? labelText;
  final String? hintText;
  final TextEditingController? controller;
  final bool autofocus;
  final TextInputType? keyboardType;
  final InputDecoration? decoration;
  final InputBorder? border;
  final Widget? suffixIcon;
  const CodebarTextField({
    Key? key,
    this.validator,
    this.initialValue,
    this.labelText,
    this.autofocus = false,
    this.hintText,
    this.controller,
    this.keyboardType,
    required this.onScan,
    this.onChanged,
    this.decoration,
    this.border,
    this.maybeUseCamera = false,
    this.suffixIcon,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<CodebarTextField> createState() => _CodebarTextFieldState();
}

class _CodebarTextFieldState extends State<CodebarTextField> {
  late StreamSubscription novoCodigo;
  late TextEditingController controller;
  @override
  void initState() {
    super.initState();
    controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
    novoCodigo = CodigoBarrarCodigoChanged().stream.listen((String codigo) {
      if ((codigo != '-1') && codigo.isNotEmpty) {
        String? codigoValidado;
        if (widget.validator != null) widget.validator!(codigo);
        if (codigoValidado == null) widget.onScan(codigo);
      }
    });
  }

  @override
  void dispose() {
    novoCodigo.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if ((UniversalPlatform.isAndroid || widget.maybeUseCamera) &&
        (widget.enabled)) {
      return CodebarCameraField(
        initialValue: widget.initialValue,
        autofocus: widget.autofocus,
        labelText: widget.labelText,
        hintText: widget.hintText,
        suffixIcon: widget.suffixIcon,
        keyboardType: widget.keyboardType,
        controller: controller,
        callback: (x) {
          CodigoBarrarCodigoChanged().notify(x ?? '');
        },
        onSaved: widget.onChanged == null ? null : (x) => widget.onChanged!(x!),
        border: widget.border,
        validator: (widget.validator == null)
            ? null
            : (x) => widget.validator!(x ?? ''),
      );
    }
    return TextFormField(
      enabled: widget.enabled,
      autofocus: widget.autofocus,
      keyboardType: widget.keyboardType ?? TextInputType.number,
      validator:
          (widget.validator == null) ? null : (x) => widget.validator!(x ?? ''),
      decoration: widget.decoration ??
          InputDecoration(
            hintText: widget.hintText, //?? 'Digite um código',
            labelText: widget.labelText,
            border: widget.border,
            suffixIcon: widget.suffixIcon,
          ),
      controller: widget.controller,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (x) {
        if (widget.onChanged != null) widget.onChanged!(x);
      },
    );
  }
}
