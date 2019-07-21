import 'cnpj.dart';
import 'cpf.dart';
import 'package:flutter/material.dart';


void showSnackBar(BuildContext scaffoldContext, String value) {
  try {
    ScaffoldState sc = Scaffold.of(scaffoldContext);
    if (sc != null) {
      //print('scaffold snackbar');
      sc.showSnackBar(new SnackBar(content: new Text(value)));
    } else {
      // nao é um scaffoldContext
      //new SnackBar(content: new Text(value));
      //print('não tem um scaffold');
      new SnackBar(content:new Text(value));
    }
  } catch (e) { print(e);}
}


class Validations {
  String validateName(String value) {
    if (value.isEmpty) return 'Hummm, faltou o nome.';
    final RegExp nameExp = new RegExp(r'^[A-za-z ]+$');
    if (!nameExp.hasMatch(value))
      return 'Desculpe, algo deu errado - entendo somente caracteres alfa [a-Z].';
    return null;
  }

  String min(String value, int minLenght){
    if (value.length<minLenght)
      return 'mínimo ($minLenght) caracteres';
    return null;
  }

  String minMax(String value, int minLenght, int maxLenght){
    if (value.length<minLenght)
      return 'mínimo ($minLenght) caracteres';
    if (value.length>maxLenght)
      return 'máximo ($minLenght) caracteres';
    return null;
  }


  String email(String value) {
    if (value.isEmpty) return 'não entendi o email.';
    value = value.trimRight().trimLeft();
    final RegExp nameExp = new RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    //new RegExp(r'^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$');
    if (!nameExp.hasMatch(value)) return 'Ops, não parece ser um email';
    return null;
  }


  String validatePassword(String value) {
    if (value.isEmpty) return 'humm, para segurança indique uma senha.';
    if (value.length<4) return 'senha muito curta fácil de decorar';
    return null;
  }

  String telefone(String value){
    return null;
  }

  String cpfCnpj(
      String numero
      ) {
      if (numero.length>11){
        if (!validarCNPJ(numero))
           return 'CNPJ inválido.';
        /// eh um cnpj
      } else {
        if (!validarCPF(numero))
           return 'CPF inválido.';
      }
     return null;
  }

  String dateMin(DateTime dt, DateTime dateTime) {
    //DateTime dt = DateTime.tryParse(x);
    if (dt==null) return 'não definou a data';
    if (dt.isBefore(dateTime)){
      //print([dt,dateTime]);
      return 'data não permitida';
    }
    return null;
  }

  String dateMax(String x, DateTime dateTime) {
    DateTime dt = DateTime.tryParse(x);
    if (dt==null) return 'Não definou a data';
    if (dt.isAfter(dateTime)){
      return 'Data não permitida';
    }
    return null;
  }

}
