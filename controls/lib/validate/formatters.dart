

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';



class CurrencyFormatter extends TextInputFormatter {
  final int dec;

  CurrencyFormatter({this.dec=2});
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {



    if(newValue.selection.baseOffset == 0){
      //print(true);
      return newValue;
    }

    String newText = CurrencyFormatter.format(newValue.text,dec:dec);
    return newValue.copyWith(
        text: newText,
//        selection: new TextSelection.collapsed(offset: newText.length)
    );
  }


  static String format(String value,{int dec=2, bool empty=true}){
    double v = double.tryParse(value);
    if (empty && v==0) return '';
    final formatter = NumberFormat.currency(symbol: '', decimalDigits: dec);
    String newText = formatter.format(v);
    return  newText;
  }

  static String get symbol{
    return 'R\$';
}


}



class MaskedTextInputFormatter extends TextInputFormatter {
  final String mask;
  final String separator;

  MaskedTextInputFormatter({
    @required this.mask,
    @required this.separator,
  }) { assert(mask != null); assert (separator != null); }

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if(newValue.text.length > 0) {
      if(newValue.text.length > oldValue.text.length) {
        if(newValue.text.length > mask.length) return oldValue;
        if(newValue.text.length < mask.length && mask[newValue.text.length - 1] == separator) {
          return TextEditingValue(
            text: '${oldValue.text}$separator${newValue.text.substring(newValue.text.length-1)}',
            selection: TextSelection.collapsed(
              offset: newValue.selection.end + 1,
            ),
          );
        }
      }
    }
    return newValue;
  }
}