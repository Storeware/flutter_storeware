import 'package:controls/drivers.dart';

class UsuarioItem extends DataModelItem {
  String id = '';
  String email;
  String nome = '';
  String _perfil = '';
  String cargo = '';
  String proprietario = '';
  String loginId = '';
  String token = '';

  DateTime create_data = DateTime.now();

  fromMap(Map<String, dynamic> json) {
    this.id = json['id'];
    this.nome = json['nome'];
    this._perfil = json['perfil'];
    this.cargo = json['cargo'];
    this.email = json['email'];
    this.proprietario = json['proprietario'];
    this.token = json['token'];
    print(this.toJson());
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
    if ((this._perfil ?? '') == '') return 'all';
    return this._perfil ?? 'all';
  }
}

abstract class AuthUser extends UsuarioItem {
  bool isPerfil(String perfil_) {
    return this.perfil.contains(perfil_);
  }

  AuthUser setPerfil(perfil_) {
    this._perfil = perfil_;
    return this;
  }

  get logado => this.loginId != '';
}

class LoginModel extends AuthUser {
  static final LoginModel _instance = LoginModel._create();
  final _notifier = BlocModel<String>();
  Map<String, dynamic> _user = {};
  factory LoginModel() {
    return _instance;
  }
  get user => _user;
  LoginModel._create();
  get usuario => nome;
  get userName => _user['nome'] ?? '';
  get inativo => _user['inativo'] ?? true;
  get notifier => _notifier;

  logout() {
    loginId = '';
    _notifier.notify('Logout');
  }

  Future<bool> login(String userId, String senha, String email) async {
    nome = email;
    this.email = email;
    //loginId = await FireFunctionsApp()
    //    .getToken(user: userId, pass: senha, email: email);
    if (logado) {
      //var x = await getByEmail(email);
      //_user = x ?? {};
      if (inativo == false) {
        _notifier.notify('Login');
      } else {
       // BottomMessageEvent().notify('Usuário inativo');
      }
      return inativo == false;
    }
    return null;
  }

  getByEmail(email) async {
    return UsuarioModel().getByEmail(email);
  }

  novoUsuario(userId, email, nome, token, peril) {
    UsuarioModel().novoUsuario(userId, email, nome, token, peril);
  }

  static currentUser() {
    return _instance;
  }
}

class UsuarioModel extends DataModelClass<UsuarioItem> {
  Future<dynamic> getByEmail(email) async {
    /*var fb = FirestoreApp().instance;
    var x = await fb.collection('usuarios').where('email', '==', email).get();
    if (!x.empty) {
      return x.docs[0].data();
    } else {
      print('não achou usuario');
      return null;
    }
    */
  }

  novoUsuario(userId, email, nome, token, perfil) {
    UsuarioItem usr = UsuarioItem();
    usr.perfil = perfil;
    usr.email = email;
    usr.nome = nome;
    usr.id = userId;
    usr.token = token;
    usr.inserting();
    //return FirestoreApp().enviar('usuarios', usr.id, usr);
  }

  atualizarUsuario(UsuarioItem usr) {
    assert(usr.id != null, 'Não informou o id para atualizar usuário');
    usr.editing();
   // return FirestoreApp().enviar('usuarios', usr.id, usr);
  }

  currentUser() => LoginModel.currentUser();
}
