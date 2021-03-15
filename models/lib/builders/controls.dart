import 'package:controls_web/controls/flutter_masked_text.dart';
import 'package:controls_web/controls/masked_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormComponents {
  static Widget createFormFieldContainer(
      {int? maxLenght,
      String? labelText,
      String? errorMsg,
      bool? enable,
      bool? autofocus,
      double? width,
      EdgeInsetsGeometry? padding,
      Function? validator,
      TextInputType? keyboardType,
      List<TextInputFormatter>? inputFormatters,
      Function? onSaved,
      int? maxLines,
      Function(bool, String? codigo)? onFocusChanged,
      TextEditingController? controller}) {
    var node = FocusNode();
    return Container(
        width: width,
        padding: padding ?? EdgeInsets.symmetric(horizontal: 10),
        child: FocusScope(
            //node: node,
            onFocusChange: (b) {
              if (onFocusChanged != null) onFocusChanged(b, controller?.text);
            },
            child: TextFormField(
              controller: controller,
              maxLength: maxLenght,
              enabled: enable ?? true,
              autofocus: autofocus ?? false,
              maxLines: ((maxLines ?? 0) > 0) ? maxLines : 1,
              keyboardType: keyboardType,
              inputFormatters: inputFormatters,
              decoration: InputDecoration(labelText: labelText),
              onSaved: (x) => onSaved!(x),
              focusNode: node,
              validator: (String? value) {
                if (validator != null) {
                  if (value!.isEmpty) {
                    return errorMsg;
                  }
                }
                return null;
              },
            )));
  }

  static Widget createSwitchFormField({
    bool? value,
    String? label,
    Color? activeTrackColor,
    Color? activeColor,
    bool? autofocus = false,
    Function(bool)? onChanged,
  }) {
    return MaskedSwitchFormField(
      value: value,
      label: label,
      activeColor: activeColor,
      activeTrackColor: activeTrackColor,
      autofocus: autofocus,
      onChanged: onChanged,
    );
  }

  static Widget createCheckBoxFormField({
    bool? value,
    String? label,
    Function(bool)? onChanged,
  }) {
    return MaskedCheckbox(
      value: value,
      label: label,
      onChanged: onChanged,
    );
  }

  static Widget createDropDownFormFieldContainer(
      {List<String>? items,
      String? hintText,
      TextStyle? style,
      String? value,
      Function? onChanged,
      Function? onSaved,
      Function? validator,
      String? errorMsg,
      bool? readOnly = false,
      Color? hintColor,
      EdgeInsetsGeometry? padding}) {
    return MaskedDropDownFormField(
      items: items,
      hintText: hintText,
      style: style,
      value: value,
      onChanged: onChanged,
      readOnly: readOnly,
      onSaved: onSaved,
      validator: validator,
      errorMsg: errorMsg,
      hintColor: hintColor,
      padding: padding,
    );
  }

  static createMoneyFormField(
      {int? precision = 2,
      String? label,
      MoneyMaskedTextController? controller,
      double? initialValue = 0,
      String? symbol = 'R\$',
      int? maxLength,
      String? errorMsg,
      bool? readOnly = false,
      Function(double)? onSaved}) {
    return MaskedMoneyFormField(
      precision: precision,
      label: label,
      controller: controller,
      initialValue: initialValue,
      leftSymbol: symbol,
      errorText: errorMsg,
      maxLength: maxLength,
      onSaved: onSaved,
      readOnly: readOnly,
    );
  }
}
