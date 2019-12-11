import '../drivers/events_bloc.dart';
import '../drivers/firebase_functions.dart';

import '../drivers/firebase_firestore.dart';

import '../drivers/bloc_model.dart';

import '../drivers/local_storage.dart';

import '../drivers/data_model.dart';
import 'package:flutter/material.dart';
import '../views/logar_conta_view.dart';
import '../views/logout_view.dart';
import '../services.dart';

/// UsuarioItem
/// Model para a estrutura da tabela de Usuarios
class UsuarioItem extends DataModelItem {
  String id = '';
  String email;
  String nome = '';
  String _perfil;
  String cargo = '';
  String proprietario = '';
  String token = '';

  DateTime create_data = DateTime.now();
  UsuarioItem();
  UsuarioItem.fromJson(map) {
    fromMap(map);
  }
  fromMap(Map<String, dynamic> json) {
    this.id = json['id'];
    this.nome = json['nome'];
    this._perfil = json['perfil'];
    this.cargo = json['cargo'];
    this.email = json['email'];
    this.proprietario = json['proprietario'];
    this.token = json['token'];
    print('login.model->fromMap ${this.toJson()} ');
    return this;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> rt = {};
    rt['id'] = this.id;
    rt['nome'] = this.nome;
    rt['perfil'] = this._perfil;
    rt['cargo'] = this.cargo;
    rt['email'] = this.email;
    rt['proprietario'] = this.proprietario;
    rt['token'] = this.token;
    return rt;
  }

  set perfil(String v) {
    this._perfil = v ?? '';
  }

  String get perfil {
    return this._perfil ?? 'admin';
  }
}

/// AuthUser - Classe de autenticação a ser herdada
abstract class AuthUser extends UsuarioItem {
  bool isPerfil(String perfil_) {
    return this.perfil.contains(perfil_);
  }

  AuthUser setPerfil(perfil_) {
    this._perfil = perfil_;
    return this;
  }

  get loginId => LocalStorage().getKey('loginId') ?? '';
  set loginId(x) {
    LocalStorage().setKey('loginId', x);
  }

  get logado => (this.loginId ?? '') != '';
}

/// LoginModel - Classe de autenticação de usuario
class LoginModel extends LoginModelBase {
  static final LoginModel _instance = LoginModel._create();
  factory LoginModel() {
    return _instance;
  }
  LoginModel._create();
  static currentUser() {
    return _instance;
  }
}

class LoginModelBase extends AuthUser {
  LoginModelBase();
  final _notifier = BlocModel<String>();
  get conta => LocalStorage().getKey('conta');
  set conta(x) {
    print('setting conta: $x');
    if (x != null) {
      dbfirestoreSuffix = x;
      LocalStorage().setKey('conta', x);
    }
  }

  String get usuario => LocalStorage().getKey('usuario');
  set usuario(String x) {
    if (x != null) LocalStorage().setKey('usuario', x);
  }

  get nickName => usuario.split(' ').first.split('@').first;
  get nomeLoja => dadosConta['nome'] ?? '';
  get img => dadosConta['img'];
  get logo => dadosConta['logo'];
  get inativo => dadosConta['inativo'] ?? false;
  get notifier => _notifier;
  get dadosConta => LocalStorage().getJson('dadosConta') ?? {};
  set dadosConta(Map<String, dynamic> d) {
    LocalStorage().setJson('dadosConta', d);
  }

  logout(context) {
    loginId = '';
    _notifier.notify('Logout');
    Routes.go(context, LogoutView());
  }

  Future<bool> login(String userId, String senha, String email,
      {String conta}) async {
    usuario = userId;
    this.email = email;
    debug('login.model->login.email $email Get Token for');
    loginId = await FireFunctionsApp()
        .getToken(user: userId, pass: senha, email: email, conta: conta);
    debug(
        'login.model->login.login $loginId logado: $logado inativo: $inativo');
    if (logado) {
      this.conta = conta;
      LocalStorage().setKey('token', loginId);
      if (inativo == false) {
        _notifier.notify('Login');
      } else {
        BottomMessageEvent().notify('Usuário inativo');
      }
      return inativo == false;
    }
    return null;
  }

  Future<bool> validarConta(String conta, {Function(bool) next}) async {
    if ((conta ?? '') == '') return false;
    debug('login.model->pre-validarConta( $conta ) logado: $logado ');
    return FirestoreApp().collection('lojas').doc(conta).get().then((doc) {
      bool rt = (doc != null) && doc.id == conta && doc.exists;
      if (rt) dadosConta = doc.data();
      if (conta != null) dbfirestoreSuffix = conta;
      debug('login.model->validarConta( $conta ) $rt ${doc.id} ${doc}');
      if (next != null) return next(rt);
      return rt;
    });
  }

  get requerLogin {
    bool r = (!logado || (conta == '') || (loginId == ''));
    print('Conta de operação: $dbfirestoreSuffix');
    if (dbfirestoreSuffix == null) r = true;
    return r;
  }

  static Widget builder(context, {child}) {
    return FutureBuilder<bool>(
        initialData: !LoginModel().requerLogin,
        future: LoginModel().checaAndEnter(context, pushOnOk: null),
        builder: (x, y) {
          if (!y.hasData) return Scaffold(body: Text('....'));
          LoginModel().lastResult = y.data;
          if (!y.data) return Scaffold(body: Text('Não autorizado'));
          return child ?? Scaffold(body: Text('não há conteúdo'));
        });
  }

  String lastCheckAndEnter = '';
  bool lastResult = false;
  Future<bool> checaAndEnter(BuildContext context,
      {String pushOnOk = '/main', String pushNotOk = '/login'}) async {
    try {
      if (lastCheckAndEnter == pushOnOk) return lastResult;
      print('checkLogin');
      lastCheckAndEnter = pushOnOk;
      if (requerLogin) {
        print('pedir login');
        goEnter(context, pushOnOk);
        return false;
      }
      return validarConta(conta).then((bool existe) {
        print('validarConta: $existe');
        String goto = existe ? pushOnOk : pushNotOk;
        if (goto != null) Routes.pushNamed(context, goto);
        return existe;
      });
    } catch (e) {
      goEnter(context, pushOnOk);
      return false;
    }
    return true;
  }

  getByEmail(email) async {
    return UsuarioModel().getByEmail(email);
  }

  novoUsuario(userId, email, nome, token, peril, {String conta}) {
    UsuarioModel().novoUsuario(userId, email, nome, token, peril);
  }

  goLogar(context, String pushNext,
      {Widget background, Color backgroundColor}) {
    Routes.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => LogarContaView(
                background: background,
                backgroundColor: backgroundColor,
                pushNamed: pushNext,
              )),
    );
  }

  goEnter(context, String pushNext,
      {Widget background, Color backgroundColor}) {
    if (requerLogin) {
      return goLogar(context, pushNext,
          background: background, backgroundColor: backgroundColor);
    }
    LoginModel().validarConta(conta).then((exist) {
      if (exist) Routes.pushNamed(context, pushNext);
    });
  }
}

/// UsarioModel - Classe de acesso de usuario no banco de dados
class UsuarioModel extends FirestoreModelClass<UsuarioItem> {
  UsuarioModel() {
    super.collectionName = 'usuarios';
  }
  @override
  createItem() => UsuarioItem();
  Future<dynamic> getByEmail(email) async {
    var fb = FirestoreApp().instance;
    var x = await fb.collection('usuarios').where('email', '==', email).get();
    if (!x.empty) {
      return x.docs[0].data();
    } else {
      print('não achou usuario');
      return null;
    }
  }

  novoUsuario(userId, email, nome, token, perfil, {String conta}) {
    UsuarioItem usr = UsuarioItem();
    usr.perfil = perfil;
    usr.email = email;
    usr.nome = nome;
    usr.id = userId;
    usr.token = token;
    usr.inserting();
    return FirestoreApp().enviar('usuarios', usr.id, usr, conta: conta);
  }

  atualizarUsuario(UsuarioItem usr) {
    assert(usr.id != null, 'Não informou o id para atualizar usuário');
    usr.editing();
    return FirestoreApp().enviar('usuarios', usr.id, usr);
  }

  currentUser() => LoginModel.currentUser();
}
