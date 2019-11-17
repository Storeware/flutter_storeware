import 'dart:html' hide VoidCallback;

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'FauiAuthState.dart';
import 'FauiExceptionAnalyser.dart';
import 'FbConnector.dart';
import 'faui_model.dart';
import '../services.dart';
import '../controls.dart';

var uuid = new Uuid();

final double btnWidth = 140;
final double btnRadius = 20;

class FauiAuthScreen extends StatefulWidget {
  final VoidCallback onExit;
  final Function(String, String) onLogin;
  final Function(String,String) onRegisterUser;
  final bool showTitle;
  final Color color;
  final String firebaseApiKey;
  final bool startWithRegistration;
  final Widget title;

  FauiAuthScreen(
      {@required VoidCallback this.onExit,
      @required String this.firebaseApiKey,
      this.title,
      @required this.onLogin,
      @required this.onRegisterUser,
      this.color,
      this.showTitle = true,
      bool this.startWithRegistration});

  @override
  _FauiAuthScreenState createState() => _FauiAuthScreenState();
}

enum AuthScreen {
  signIn,
  createAccount,
  forgotPassword,
  verifyEmail,
}

class _FauiAuthScreenState extends State<FauiAuthScreen> {
  AuthScreen _authScreen = AuthScreen.signIn;
  String _error;
  String _email;
  String _name;

  FocusNode _passwordFocus;
  FocusNode _emailFocus;

  @override
  void initState() {
    super.initState();

    if (this.widget.startWithRegistration) {
      this._authScreen = AuthScreen.createAccount;
    }

    _emailFocus = FocusNode();
    _passwordFocus = FocusNode();
  }

  @override
  void dispose() {
    _emailFocus.dispose();
    _passwordFocus.dispose();

    super.dispose();
  }

  void switchScreen(AuthScreen authScreen, String email) {
    setState(() {
      this._authScreen = authScreen;
      this._error = null;
      this._email = email;
    });
  }

  void afterAuthorized(BuildContext context, FauiUser user) {
    FauiAuthState.User = user;
    this.widget.onLogin(user.userId, user.token);
  }

  List<Widget> getActions() {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.close),
        onPressed: this.widget.onExit,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    checkRedirect((widget.firebaseApiKey??'').isEmpty);
    switch (this._authScreen) {
      case AuthScreen.signIn:
        return _buildSignInScreen(context);
      case AuthScreen.createAccount:
        return _buildCreateAccountScreen(context);
      case AuthScreen.forgotPassword:
        return _buildForgotPasswordScreen(context, this._email);
      case AuthScreen.verifyEmail:
        return _buildVerifyEmailScreen(context, this._email);
      default:
        throw Translate.string('resultado_inesperado') + " $_authScreen";
    }
  }

  Widget _buildCreateAccountScreen(BuildContext context) {
    final TextEditingController emailController =
        new TextEditingController(text: this._email);

    final TextEditingController nameController =
        new TextEditingController(text: this._name);

    @override
    dispose(){
      emailController.dispose();
      nameController.dispose();
      super.dispose();
    }

    return Scaffold(
      backgroundColor: widget.color,
      appBar: widget.showTitle
          ? AppBar(
              title: Text(Translate.string('Criar conta')),
              actions: this.getActions(),
            )
          : null,
      body: Column(
        children: <Widget>[
          TextField(
            autofocus: true,
            controller: emailController,
            decoration: InputDecoration(
              labelText: Translate.string("email"),
            ),
          ),
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: Translate.string("Nome"),
            ),
          ),
          Text(
            this._error ?? "",
            style: TextStyle(color: Colors.red),
          ),
          StyledButton(
            width: btnWidth,
            radius: btnRadius,
            child: Text(translate['Criar conta']),
            onPressed: () async {
              try {
                await FbConnector.RegisterUser(
                  apiKey: this.widget.firebaseApiKey,
                  email: emailController.text,
                );

                await FbConnector.SendResetLink(
                  apiKey: this.widget.firebaseApiKey,
                  email: emailController.text,
                );

                widget.onRegisterUser(emailController.text,nameController.text);

                this.switchScreen(AuthScreen.verifyEmail, emailController.text);
              } catch (e) {
                this.setState(() {
                  this._error = FauiExceptionAnalyser.ToUiMessage(e);
                  this._email = emailController.text;
                });
              }
            },
          ),
          FlatButton(
            child:
                Text(Translate.concat(['Tem uma conta', '_?', 'entrar', '_.'])),
            onPressed: () {
              this.switchScreen(AuthScreen.signIn, emailController.text);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSignInScreen(BuildContext context) {
    final TextEditingController emailController =
        new TextEditingController(text: this._email);
    final TextEditingController passwordController =
        new TextEditingController();

    document.addEventListener('keydown', (dynamic event) {
      if (event.code == 'Tab') {
        event.preventDefault();
      }
    });

    Widget _body = Column(
      children: <Widget>[
        RawKeyboardListener(
          child: TextField(
            autofocus: true,
            controller: emailController,
            decoration: InputDecoration(
              labelText: "EMail",
            ),
          ),
          onKey: (dynamic key) {
            if (key.data.keyCode == 9) {
              FocusScope.of(context).requestFocus(_passwordFocus);
            }
          },
          focusNode: _emailFocus,
        ),
        TextField(
          controller: passwordController,
          obscureText: true,
          focusNode: _passwordFocus,
          decoration: InputDecoration(
            labelText: Translate.string('Senha'),
          ),
        ),
        Text(
          this._error ?? "",
          style: TextStyle(color: Colors.red),
        ),
        StyledButton(
          width: btnWidth,
          radius: btnRadius,
          child: Text(Translate.string('Entrar')),
          onPressed: () async {
            try {
              FauiUser user = await FbConnector.SignInUser(
                apiKey: this.widget.firebaseApiKey,
                email: emailController.text,
                password: passwordController.text,
              );
              this.afterAuthorized(context, user);
            } catch (e) {
              this.setState(() {
                this._error = FauiExceptionAnalyser.ToUiMessage(e);
                this._email = emailController.text;
              });
            }
          },
        ),
        FlatButton(
          child: Text(Translate.string('Criar conta')),
          onPressed: () {
            this.switchScreen(AuthScreen.createAccount, emailController.text);
          },
        ),
        FlatButton(
          child: Text(Translate.concat(['Esqueci a senha', '_?'])),
          onPressed: () {
            this.switchScreen(AuthScreen.forgotPassword, emailController.text);
          },
        ),
      ],
    );

    if (widget.title == null) return _body;

    return Scaffold(
      backgroundColor: widget.color,
      appBar: widget.showTitle
          ? AppBar(
              title: widget.title ?? Text(Translate.string('Entrar')),
              actions: this.getActions(),
            )
          : null,
      body: _body,
    );
  }

  Widget _buildVerifyEmailScreen(BuildContext context, String email) {
    return Scaffold(
      backgroundColor: widget.color,
      appBar: widget.showTitle
          ? AppBar(
              title: Text(Translate.string('Consultar o email')),
              actions: this.getActions(),
            )
          : null,
      body: Column(
        children: <Widget>[
          Text(Translate.string("Enviei um link para o email") + " $email"),
          StyledButton(
            width: btnWidth + 90,
            radius: btnRadius,
            child: Text(Translate.string('Entrar')),
            onPressed: () {
              this.switchScreen(AuthScreen.signIn, email);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildForgotPasswordScreen(BuildContext context, String email) {
    final TextEditingController emailController =
        new TextEditingController(text: this._email);

    return Scaffold(
      backgroundColor: widget.color,
      appBar: widget.showTitle
          ? AppBar(
              title: Text(Translate.string('Trocar a senha')),
              actions: this.getActions(),
            )
          : null,
      body: Column(
        children: <Widget>[
          TextField(
            autofocus: true,
            controller: emailController,
            decoration: InputDecoration(
              labelText: "EMail",
            ),
          ),
          Text(
            this._error ?? "",
            style: TextStyle(color: Colors.red),
          ),
          StyledButton(
            width: btnWidth + 90,
            radius: btnRadius,
            child: Text(Translate.string('Enviei um link para trocar a senha')),
            onPressed: () {
              FbConnector.SendResetLink(
                apiKey: this.widget.firebaseApiKey,
                email: emailController.text,
              );
              this.switchScreen(AuthScreen.signIn, email);
            },
          ),
          FlatButton(
            child: Text(Translate.string('Entrar')),
            onPressed: () {
              this.switchScreen(AuthScreen.signIn, email);
            },
          ),
          FlatButton(
            child: Text(Translate.string('Criar conta')),
            onPressed: () {
              this.switchScreen(AuthScreen.createAccount, email);
            },
          ),
        ],
      ),
    );
  }
}
