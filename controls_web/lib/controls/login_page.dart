import 'package:clientes/setup/config_app.dart';
import 'package:controls_web/controls/rounded_button.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final bool Function(String, String) onValidate;
  final String usuarioLabel;
  final String senhaLabel;
  final int minUsuario;
  final int minSenha;
  final double maxWidth;
  final String buttonName;
  final Widget link;
  final Widget bottom;
  final Widget image;
  LoginPage({
    Key key,
    this.onValidate,
    this.usuarioLabel = 'Usuário',
    this.senhaLabel = 'Senha',
    this.minUsuario = 2,
    this.minSenha = 2,
    this.buttonName = 'Entrar',
    this.maxWidth = 340,
    this.link,
    this.bottom,
    this.image,
  }) : super(key: key);

  String cnpj;
  String senha;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final double brd = (MediaQuery.of(context).size.width - maxWidth) / 2;
    return Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.only(left: brd, right: brd),
          child: Card(
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListTile(
                //width: 200,
                //height: 170,
                title: Column(
                  children: <Widget>[
                    if (image != null) image,
                    TextFormField(
                        initialValue: cnpj,
                        //controller: _cnpjController,
                        style: TextStyle(
                            fontSize: 16, fontStyle: FontStyle.normal),
                        decoration: InputDecoration(
                          //border: InputBorder.none,
                          labelText: usuarioLabel,
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Falta informar: $usuarioLabel';
                          }
                          if (value.length < minUsuario) return 'Inválido';
                          return null;
                        },
                        onSaved: (x) {
                          cnpj = x;
                        }),
                    TextFormField(
                        obscureText: true,
                        initialValue: senha,
                        style: TextStyle(
                            fontSize: 16, fontStyle: FontStyle.normal),
                        decoration: InputDecoration(
                          labelText: senhaLabel,
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Falta informar: $senhaLabel';
                          }
                          if (value.length < minSenha) return 'Inválido';
                          return null;
                        },
                        onSaved: (x) {
                          senha = x;
                        }),
                    if (link != null) link,
                    SizedBox(
                      height: 10,
                    ),
                    RoundedButton(
                      width: 150,
                      buttonName: buttonName,
                      onTap: () {
                        validate();
                      },
                    ),
                    if (bottom != null) bottom
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  validate() {
    if (_formKey.currentState.validate()) {
      if (onValidate != null) if (onValidate(cnpj, senha)) {
        ConfigApp().cnpj = this.cnpj;
        ConfigApp().password = this.senha;
        return true;
      }
    }
    return false;
  }
}
