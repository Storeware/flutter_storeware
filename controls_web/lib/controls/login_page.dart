import 'package:controls_web/controls/rounded_button.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
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
  final String userName;
  final String userPassword;
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
    this.userName,
    this.userPassword,
  }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String usuario;

  String senha;

  @override
  void initState() {
    super.initState();
    usuario = widget.userName ?? '';
    senha = widget.userPassword ?? '';
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final double brd =
        (MediaQuery.of(context).size.width - widget.maxWidth) / 2;
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
                    if (widget.image != null) widget.image,
                    TextFormField(
                      autofocus: true,
                        initialValue: usuario,
                        //controller: _cnpjController,
                        style: TextStyle(
                            fontSize: 16, fontStyle: FontStyle.normal),
                        decoration: InputDecoration(
                          //border: InputBorder.none,
                          labelText: widget.usuarioLabel,
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Falta informar: ${widget.usuarioLabel}';
                          }
                          if (value.length < widget.minUsuario)
                            return 'Inválido';
                          return null;
                        },
                        onSaved: (x) {
                          usuario = x;
                        }),
                    TextFormField(
                        obscureText: true,
                        initialValue: senha,
                        style: TextStyle(
                            fontSize: 16, fontStyle: FontStyle.normal),
                        decoration: InputDecoration(
                          labelText: widget.senhaLabel,
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Falta informar: ${widget.senhaLabel}';
                          }
                          if (value.length < widget.minSenha) return 'Inválido';
                          return null;
                        },
                        onSaved: (x) {
                          senha = x;
                        }),
                    if (widget.link != null) widget.link,
                    SizedBox(
                      height: 10,
                    ),
                    RoundedButton(
                      width: 150,
                      buttonName: widget.buttonName,
                      onTap: () {
                        validate();
                      },
                    ),
                    if (widget.bottom != null) widget.bottom
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  validate() {
    if (_formKey.currentState.validate()) {
      if (widget.onValidate != null) if (widget.onValidate(usuario, senha)) {
        return true;
      }
    }
    return false;
  }
}
