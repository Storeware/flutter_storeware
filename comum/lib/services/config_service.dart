import 'dart:async';

import 'package:controls_data/data_model.dart';
import 'package:controls_data/local_storage.dart' as ls;
import 'package:controls_data/odata_client.dart';
import 'package:controls_data/odata_firestore.dart';
import 'package:controls_web/drivers/bloc_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:comum/services/firebase_service.dart';
import 'package:get/get.dart';

bool isFirebase = false;

class UsuarioRecarregarNotifier extends BlocModel<bool> {
  static final _singleton = UsuarioRecarregarNotifier._create();
  UsuarioRecarregarNotifier._create();
  factory UsuarioRecarregarNotifier() => _singleton;
}

class LoginChanged extends ChangeNotifier {
  ConfigAppBase? config;
  static final _singleton = LoginChanged._create();
  LoginChanged._create();
  factory LoginChanged() => _singleton;
  notify(ConfigAppBase value) {
    config = value;
    notifyListeners();
  }
}

class ConfigFilialChanged extends BlocModel<double> {
  static final _singleton = ConfigFilialChanged._create();
  ConfigFilialChanged._create();
  factory ConfigFilialChanged() => _singleton;
}

abstract class ConfigBase {
  String restServer = 'https://estouentregando.com';
  ConfigBase();
  init();
  setup();
  String imagemEntradaUrl = 'https://wbagestao.com/w3/resources/entrar.png';
}

var defaultElevation = 1;

/// Configurações do APP
/// de uso interno para controle dos recursos o APP
/// Não usar para configurações da loja   LojaConfig() - configurações do usuário
class ConfigNotifier extends BlocModel<String> {
  static final _singleton = ConfigNotifier._create();
  ConfigNotifier._create();
  factory ConfigNotifier() => _singleton;
}

class Themechanged extends BlocModel<bool> {
  static final _singleton = Themechanged._create();
  Themechanged._create();
  factory Themechanged() => _singleton;
}

class SnakbarNotifier extends BlocModel<String> {
  static final _singleton = SnakbarNotifier._create();
  SnakbarNotifier._create();
  factory SnakbarNotifier() => _singleton;
}

abstract class ConfigAppBase extends ConfigBase {
  int instanceCount = 0;
  bool inited = false;
  var queryParameters = {};
  double? _filial;
  double? get filial {
    final String? r = ls.LocalStorage().getString('filialCorrente');
    if (r == null) return null;
    return double.tryParse(r);
  }

  set filial(double? x) {
    final v = x ?? _filial ?? 1.0;
    ConfigFilialChanged().notify(v);
    ls.LocalStorage().setString('filialCorrente', '$v');
  } // mudar depois que inicializou os dados;

  var _backgroundColor = 'azure';
  get backgroudColor => _backgroundColor;
  set backgroundColor(x) {
    _backgroundColor = x;
  }

  afterLoaded(a, b) {
    /// chamado ao  configuraçao concluida
  }
  afterConfig() {
    /// chamado depois de carregar as configurações do servidor cloud
    /// carregar dadosLoja
    return cloudV3.checkoutItemDados().then((rsp) {
      dadosLoja = rsp ?? {};
      return rsp != null;
    });
  }

  bool inDev = false;

  LoginChanged loginChanged = LoginChanged();

  checkInited() async {
    if (!inited)
      return await init().then((x) async {
        //print('inited');
        await setup();
        // print('setuped');
        return true;
      });
    return inited;
  }

  StreamSubscription? errorNotifier;
  dispose() {
    if (errorNotifier != null) errorNotifier!.cancel();
  }

  /// Chamar antes de iniciado o App
  @override
  init() async {
    try {
      await ls.LocalStorage().init();
    } catch (e) {
      //TODO_: windows - erro ao carregar configruação inicial...
    }
    load();

    var p = Uri.base.queryParameters;
    p.forEach((k, v) {
      //if (v != null)
      queryParameters[k] = v;
    });
    loginChanged.config = this;
    inited = true;

    defaultElevation = 0;
    return this;
  }

  recarregar() {
    if (loja.length > 0) // carrega as configurações da loja
      setLoja(loja);
  }

  bool autoLogin = false;
  logout() {
    _authorization = '';
    password = '';
    loginChanged.notify(this);
  }

  /// chamar depois de inicado o App
  @override
  setup({bool autoLogin = false}) async {
    if (errorNotifier == null)
      errorNotifier = ErrorNotify().stream.listen((String x) {
        SnakbarNotifier().notify(x);
      });
    //_initFirebase();

    if (instanceCount == 0) {
      instanceCount++;
      //queryParameters['q'] ??= 'm5'; // entra em demo
      restServer = queryParameters['h'] ?? 'https://estouentregando.com';

      //print(queryParameters['q']);

      ODataInst().baseUrl = restServer;
      ODataInst().prefix = '/v3/';

      if (autoLogin)
        firebaseLogin(loja);
      else {
        /// usado inDev
        cloudV3.token =
            'eyJjb250YWlkIjoibTUiLCJ1c3VhcmlvIjoiXHUwMDA177+9XCJx77+977+977+977+977+977+977+977+977+977+9IiwiZGF0YSI6IjIwMjAtMDUtMTZUMDI6MTA6MjMuNjUxWiJ9';
      }

      return await ls.LocalStorage().init().then((x) async {
        load();
        if (!autoLogin) {
          loginChanged.notify(this);
        }
        CloudV3();
        return this;
      });
    }
  }

  bool lembrarSenha = false;
  String userUid = '';
  //get userUid => _userUid;

  Map<String, dynamic> configDados = {};
  Map<String, dynamic> dadosLoja = {};

  firebaseLogin(loja, [usuario, senha]) async {
    var cloudV3 = FirebaseService();
    //DateTime d = DateTime.now();
    // if (isFirebase) firebaseAuth(usuario, senha).then((resp) {});
    return cloudV3.login(loja, usuario, senha).then((xCloud) {
      print("1 $loja");
      print("2 $usuario");
      print("3 $senha");
      print("4 $xCloud");
      if (xCloud == null) {
        print('não conectou no CloudV3');
        Get.snackbar(
          'Ops... estou só.',
          'Falha na conexão, tente novamente',
          snackPosition: SnackPosition.BOTTOM,
        );

        return false;
      }
      return cloudV3.configDados(loja).then((xConfig) {
        return initConfigDados(xConfig);
      });
    }).catchError((err) => {print(err)});
  }

  initConfigDados(xConfig) {
    if (xConfig == null) return false;
    //print(xConfig);
    configDados.addAll(xConfig);
    restServer = queryParameters['h'] ?? xConfig['restserver'];
    ODataInst().baseUrl = restServer;
    ODataInst().prefix = xConfig['restserverPrefix'];

    final double r = toDouble(xConfig['filial'] ?? 0);

    /// [Filial] se a filial foi indicada na configuração, então a filial é fixa com base no configurado
    /// caso não seja configurado no servidor, pega a ultima logada.
    if (r > 0) filial = toDouble(xConfig['filial'] ?? 1);

    afterConfig();
    setLoja(loja).then((fsp) {
      afterLoaded(xConfig, fsp);
    }); // faz login no v3
    return logado; // inicia acesso o cloud
  }

  get baseUrl => ODataInst().baseUrl;
  get basePrefix => ODataInst().prefix;

  get firebaseOptions => {
        "apiKey": "AIzaSyAV0c4MPfug-hSJYU8bT5pADkpaUadCYGU",
        "authDomain": "selfandpay.firebaseapp.com",
        "databaseURL": "https://selfandpay.firebaseio.com",
        "projectId": "selfandpay",
        "storageBucket": "selfandpay.appspot.com",
        "messagingSenderId": "858174338114",
        "appId": "1:858174338114:web:1f7773702de59dc336e9db",
        "measurementId": "G-G1ZWS0D01G"
      };

  initFirebase() async {
    try {
      //return FirebaseApp().init(firebaseOptions).then((rsp) {});
    } catch (e) {
      print('Erro ao conectar firebase: $e');
    }
  }

  firebaseAuth(usuario, senha) async {
    //var r = await FirebaseApp().auth().signInAnonymously();
    //_userUid = FirebaseApp().auth().uid;
    //return r;
  }

  params(nome) {
    return queryParameters[nome];
  }

  /// pega o endereço de acesso da loja
  /// estabelece qual o banco de dados acesso no cloud
  ///

  get conta => loja;
  set conta(x) {
    //print('nova conta: $x');
    if ((queryParameters['q'] ?? '') != x) logado = false;
    queryParameters['q'] = x;
  }

  get loja {
    var r = params('q');
    return r ?? '';
  }

  String? _authorization;
  String? _usuario;
  String get usuario => _usuario ?? ((inDev) ? 'checkout' : '');
  set usuario(x) {
    _usuario = x;
  }

  String? password;
  Future<String> checkToken() async {
    if (_authorization != null) return _authorization!;
    return await ODataInst().login(loja, usuario, password ?? loja).then((x) {
      _authorization = x;
      loginChanged.notify(this);
      return x;
    });
  }

  bool get logado => (((_authorization ?? '').length) > 0);
  set logado(bool x) {
    (!x) ? _authorization = '' : null;
    loginChanged.notify(this);
  }

  setLoja(String value, {bool inDev = false}) async {
    //print('setLoja $value');
    queryParameters['q'] = value;

    ODataInst().baseUrl = restServer;
    final rsp =
        await ODataInst().login(loja, usuario, password ?? loja).then((x) {
      if (x != null) {
        _authorization = x;
        save();
        loginChanged.notify(this);
      }
      return x;
    });
    return rsp;
  }

  loginSignInByEmail(String loja, email) {
    // procura se o email é valido
    // TODO_: repensar login - usar web-usuarios para pegar o codigo do usuario - depende de alteração na view

    this.usuario = 'checkout';
    this.password = loja;
    return cloudV3.login(loja, usuario, password ?? loja).then((xCloud) {
      return cloudV3.configDados(loja).then((xConfig) {
        //ok - conta existe
        configDados.addAll(xConfig);
        restServer = queryParameters['h'] ?? xConfig['restserver'];
        ODataInst().baseUrl = restServer;
        ODataInst().prefix = xConfig['restserverPrefix'];
        filial = toDouble(xConfig['filial'] ?? 1);
        // TODO_:fazer login na conta cliente
        setLoja(loja).then((fsp) {
          afterLoaded(xConfig, fsp);
        }); // faz login no v3
        return logado; // inicia acesso o cloud
        //});
      });
    });
  }

  String encrypt(txt) => txt;
  String decrypt(txt) => txt;

  load() async {
    try {
      _celular = decrypt(ls.LocalStorage().getKey('celular'));
      usuario = decrypt(ls.LocalStorage().getKey('usuario') /*?? '*/);
      conta = queryParameters['q'] ?? ls.LocalStorage().getKey('contaid') ?? '';
      lembrarSenha = ls.LocalStorage().getBool('lembrarSenha') /*?? false*/;
      password = decrypt(ls.LocalStorage().getKey('usuario1'));
    } catch (e) {}
  }

  save() async {
    try {
      ls.LocalStorage().setKey('usuario', encrypt(usuario));
      ls.LocalStorage().setKey('contaid', conta);
      ls.LocalStorage().setBool('lembrarSenha', lembrarSenha /*?? false*/);
      if (_celular != null)
        ls.LocalStorage().setKey('celular', encrypt(_celular));
      ls.LocalStorage().setKey('usuario1', encrypt(password));
    } catch (e) {}
  }

  /// dados do cliente (comprador) que identifica a sua conta
  /// TODO_: Mapear para enviar o codigo de confirmação pelo SMS
  /// o celular é usado para recuperar a conta do usuario;
  String? _celular;
  set celular(String? numero) {
    _celular = numero;
  }

  String? get celular => _celular;

  /// token a ser enviado para o servidor nas requisições
  //set token(String text) {}

  /// link de acesso ao cloud function
  ODataClient get restCloudAPI => CloudV3().client;

  /// link de acesso local ao RestServer
  ODataClient get restLocalAPI => ODataInst();
  FirebaseService get cloudV3 => FirebaseService();
}
