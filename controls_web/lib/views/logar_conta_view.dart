//import 'package:controls_firebase/firebase_firestore.dart';
import 'package:controls_web/controls.dart';
import 'package:controls_web/drivers.dart';
import 'package:controls_web/models/resources.dart';
import 'package:flutter/material.dart';
import 'package:controls_web/services.dart';
import 'package:controls_web/drivers/events_bloc.dart';
import '../models.dart';

String defaultLoginImagemSrc;

class LogarContaView extends StatefulWidget {
  final Widget image;
  final Widget appBar;
  final Widget bottom;
  final String pushNamed;
  final Widget background;
  final Color backgroundColor;
  final Function(String, String, String) onLogin;
  LogarContaView(
      {Key key,
      this.pushNamed,
      this.image,
      this.background,
      this.backgroundColor,
      this.bottom,
      this.appBar,
      this.onLogin})
      : super(key: key);
  _LogarContaViewState createState() => _LogarContaViewState();
}

class _LogarContaViewState extends State<LogarContaView> {
  @override
  Widget build(BuildContext context) {
    //debug('LogarContaView');
    return (widget.appBar == null)
        ? SliverScaffold(
            backgroundColor: widget.backgroundColor,
            topRadius: 0.0,
            //appBar: _createAppBar(),
            body: _createBody(),
          )
        : Scaffold(
            backgroundColor: widget.backgroundColor,
            appBar: _createAppBar(),
            body: StreamBuilder<String>(
                initialData: '',
                stream: BottomMessageEvent().stream,
                builder: (x, s) {
                  if (s.hasData) mensagem = s.data;
                  return _createBody();
                }),
          );
  }

  bool processando = false;
  _createAppBar() {
    return widget.appBar ?? appBarLight(title: Text(Translate.string('Conta')));
  }

  String conta;
  String usuario;
  String senha;
  double maxHeight = 300;
  String mensagem = '';
  final _formKey = GlobalKey<FormState>();
  _createBody() {
    conta = LoginModel().conta ?? '';
    usuario = LoginModel().usuario ?? '';
    var size = MediaQuery.of(context).size;
    return Stack(children: [
      if (widget.background != null)
        Positioned(
            top: 1, left: 1, bottom: 1, right: 1, child: widget.background),
      Positioned(
          top: size.height / 12,
          left: 20,
          right: 20,
          child: Center(
            child: widget.image ??
                Image.network(defaultLoginImagemSrc ?? Resources.entrar,
                    height: size.height / 5, fit: BoxFit.fill),
          )),
      Positioned(
          top: 200,
          left: size.width / 4,
          right: size.width / 4,
          child: Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: 300),
              child: Card(
                elevation: 0,
                color:
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Container(
                            //height: 380,
                            child: Column(children: [
                          TextFormField(
                              autofocus: true,
                              initialValue: conta,
                              decoration: InputDecoration(
                                labelText: Translate.string('conta'),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Falta informar: conta';
                                }
                                return null;
                              },
                              onSaved: (x) {
                                conta = x;
                              }),
                          TextFormField(
                              initialValue: usuario,
                              decoration: InputDecoration(
                                labelText: Translate.string('E-mail'),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Falta informar: email';
                                }
                                return null;
                              },
                              onSaved: (x) {
                                usuario = x;
                              }),
                          TextFormField(
                              obscureText: true,
                              initialValue: senha,
                              decoration: InputDecoration(
                                labelText: Translate.string('Senha'),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Falta informar: senha';
                                }
                                return null;
                              },
                              onSaved: (x) {
                                senha = x;
                              }),
                          SizedBox(
                            height: 10,
                          ),
                          Text(mensagem, style: TextStyle(color: Colors.red)),
                          SizedBox(
                            height: 3,
                          ),
                          RoundedButton(
                            width: 120,
                            buttonName: 'Entrar',
                            onTap: () {
                              _save();
                              setState(() {
                                processando = true;
                              });
                            },
                          ),
                          if (processando) Waiting()
                        ]))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ))
    ]);
  }

  _save() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      String u = usuario, s = senha, c = conta;
      LoginModel().validarConta(c).then((existe) {
        //print('Conta <$dbfirestoreSuffix> existe: $existe');
        if (!existe) {
          setState(() {
            mensagem = 'Conta não encontrada';
          });
          return;
        }
        if (widget.onLogin != null) {
          // print('Validando onLogin event conta $dbfirestoreSuffix');
          if (widget.onLogin(u, s, c)) {
            LoginModel().conta = c;
            Routes.pushNamed(context, widget.pushNamed);
          }
        } else {
          //print('Buscando login para $dbfirestoreSuffix');
          LoginModel().login(u, s, u, conta: c).then((x) {
            //print('login ok $x $dbfirestoreSuffix go: ${widget.pushNamed}');
            Routes.pushNamed(context, widget.pushNamed ?? '/main');
          });
        }
      });
    } else {
      setState(() {
        //maxHeight = 380;
      });
    }
  }
}
