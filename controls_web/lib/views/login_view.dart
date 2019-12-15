import 'dart:async';

import '../models.dart';
import '../auth.dart';
import '../controls.dart';
import '../services.dart';
import '../drivers.dart';
import 'package:flutter/material.dart';

String loginAPIKey;

class LoginNotify extends BlocModel<FauiUser> {
  static final _singleton = LoginNotify._create();
  factory LoginNotify() => _singleton;
  LoginNotify._create();
  final _s = StreamController<String>.broadcast();
  get messageSink => _s.sink;
  get messageStream => _s;
  get changeSink => super.sink;
  get changeStream => super.stream;

  LoginNotify send(String text) {
    _s.sink.add(text);
    return this;
  }

  LoginNotify logar(userId, password) {
    FauiUser user = Faui.user;
    LoginModel().login(userId, password, user.email).then((x) {
      print(['login response:', x]);
      return change();
    });
  }

  LoginNotify change() {
    //FauiUser user = Faui.user;
    print('login change');
    changeSink.add(Faui.user);
    Translate().log();
    return this;
  }
}

class LoginView extends StatefulWidget {
  final bool canPop;
  LoginView({Key key, this.canPop = true}) : super(key: key);

  _LoginViewState createState() => _LoginViewState();

  static Widget build(context,
      {Widget title, Color color, bool canPop = true}) {
    return TranslateNotify(
        builder: () => FauiAuthScreen(
              showTitle: false,
              color: color,
              firebaseApiKey: loginAPIKey,
              title: title,
              onLogin: (user, pass) {
                LoginNotify().logar(user, pass);
              },
              onExit: () {
                LoginNotify().send('exit').change();
                if (canPop) Navigator.of(context).pop();
              },
              onRegisterUser: (email, nome) {
                FauiUser user = Faui.user;
                LoginModel().novoUsuario(
                    user.userId, user.email, nome, user.token, 'usuario');
              },
              startWithRegistration: false,
            ));
  }
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    print(['LoginView, build']);
    return Scaffold(
      body: Center(
        child: Container(
          width: 350,
          height: 400,
          child: Panel(
            title: Text(Translate.string('login')),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: LoginView.build(context, canPop: widget.canPop),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginWidget extends StatelessWidget {
  final onPressed;
  const LoginWidget({Key key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RebuildNotify(builder: (snapshot) {
      print(['LoginView, notify']);
      return Container(
        color: Colors.transparent,
        width: 350,
        height: 400,
        child: Panel(
          title: Text(Translate.string('login')),
          color: Theme.of(context).primaryColor.withAlpha(50),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: LoginView.build(context,
                canPop: false, color: Colors.transparent),
          ),
        ),
      );
    });
  }
}
