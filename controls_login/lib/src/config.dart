// @dart=2.12
import 'dart:async';
import 'package:comum/services/config_service.dart';
import '../socketio/v3_socketio.dart';
//import 'package:console/views/opcoes/models/checkout_config_model.dart';
import 'string_encryption.dart';
import 'package:controls_data/odata_client.dart';
import 'package:controls_data/odata_firestore.dart';
import 'package:controls_web/controls/colores.dart';
import 'package:controls_web/drivers/bloc_model.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../models/filial_model.dart';
import '../models/usuarios_model.dart';
import 'package:universal_platform/universal_platform.dart';
import 'register_usuario_params.dart';
import 'firebase_adapter.dart';
import 'package:controls_extensions/extensions.dart';
import 'cloud_config_model.dart';
//import 'diretivas.dart' as diretivas;
import '../models/acesso.dart';
export '../models/acesso.dart';
export 'acesso_const.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';

/// Configurações para ambiente de desenvolvimento
/// desabilita acesso v3 remoto (RestServer) e roteia para v3 local
var bInDev = false;
//endereco do Rest Dev.
final restInDev = "http://localhost:8886";

/// indica se é para mostrar no terminal dados carregado do servidor
/// carrega as respostas do servidor
var inLogDados = false;

/// indica se é para mostrar mensagens de interação da APP
///  mostra as mensagens de envio ao servidor
var inLog = false;

/// data de compilação da versão - alterado manualmente
const appVersao = '2021.10.28';

/// link de acesso aos videos de treinamento no youtube
const urlPlayListGoogle =
    'https://www.youtube.com/playlist?list=PLYVNF59aRdDZsDx0NnUPLWkA66nnHLDtc';

/// pagina de entrada - usado em dev para iniciar direto na pagina desejada.
final homeRoute =
    '/'; //'/entradaMercadorias'; //'/pagamento'; //'/mensagens'; //'/produtos'; //'/dashPieAgenda'; //'/dashComercial';

/// [AppResourcesConst] constantes de mapeamento das configurações utilizada pelo APP -
/// usado por APP herdados para mudar parametros de configuração
/// aqui é o ponto de configuração a ser mapeado nos aplicativos herdados mudando cargas ou configs.

void Function(String title, String body)? snackbarFunc;

class AppResourcesConst {
  static final _singleton = AppResourcesConst._create();
  static get instance => _singleton;
  AppResourcesConst._create();
  factory AppResourcesConst() => _singleton;

  static bool get pushEnabled =>
      UniversalPlatform.isWeb ||
      UniversalPlatform.isAndroid ||
      UniversalPlatform.isIOS;

  static bool get filePickerEnabled =>
      UniversalPlatform.isWeb ||
      UniversalPlatform.isAndroid; // inLog || bInDev; //  em implementação.
  get isMobile => (UniversalPlatform.isAndroid || UniversalPlatform.isIOS);
  get isDesktop => (UniversalPlatform.isWindows ||
      UniversalPlatform.isLinux ||
      UniversalPlatform.isMacOS);
  get isWeb => UniversalPlatform.isWeb;

  get pdfEnable => (UniversalPlatform.isAndroid ||
          //UniversalPlatform.isMacOS ||
          //UniversalPlatform.isIOS ||
          UniversalPlatform.isWeb ||
          UniversalPlatform.isWindows /*||
      UniversalPlatform.isLinux*/
      );

  /// indica se tem um leitor de codigo de barras via camera do dispositivo
  get cameraCodeBarReader =>
      (UniversalPlatform.isAndroid || UniversalPlatform.isIOS);
  get shareEnable => (UniversalPlatform.isAndroid || UniversalPlatform.isIOS);
  get shareWhatsWebEnable => !shareEnable;

  /// reservado - nao esta em uso
  static bool get stonePagementoEnabled => inLog || bInDev;
  bool darkEnabled = true;
  String appTitle = 'Console Storeware';
  String appTitleComercial = 'Storeware Negócios';
  String grupoProduto = 'Storeware';
  String? logoApp = 'assets/wba.png';
  Widget? logoAppWidget;
  String? subLogoApp = 'Storeware';
  String? verticalAppTitle = 'CONSOLE';
  Widget? loginBackgroundWidget;
  Color backgroundColor = pastelColors[5].lighten(80);
  double elevation = 0;
  List<Widget> loginChildren = [];
  Map<String, dynamic> _extended = {};
  operator [](String key) => _extended[key];
  operator []=(String key, dynamic value) => _extended[key] = value;
  String site = 'www.wbagestao.com.br';
  String powerBy = 'www.wbagestao.com.br';
  double menuSpaceRight = 60;
  Color primarySwatchColor = Colors.indigo;
  String fontFamily = 'Inter';
  String linkAbrirNovaConta = 'https://wbagestao.com';
  Map<String, String> contaDemo = {
    "conta": 'm0',
    'usuario': 'm0',
    'senha': 'm0'
  };
  String currencySymbol = 'R\$';
  String appType = 'console';
}

/// [AppRealoadNotifier] stream de notificação para recarregar dados do APP
class AppRealoadNotifier extends BlocModel<int> {
  static final _singleton = AppRealoadNotifier._create();
  AppRealoadNotifier._create();
  factory AppRealoadNotifier() => _singleton;
}

/// [AgendaReloadNotifier] stream para notificar que requer recarga da agenda
/// TODO: avaliar passar para a pasta da agenda
class AgendaReloadNotifier extends BlocModel<dynamic> {
  static final _singleton = AgendaReloadNotifier._create();
  AgendaReloadNotifier._create();
  factory AgendaReloadNotifier() => _singleton;
}

/// [MensagemNotifier] stream para despachar mensagens para o usuário
class MensagemNotifier extends BlocModel<String> {
  static final _singleton = MensagemNotifier._create();
  MensagemNotifier._create();
  factory MensagemNotifier() => _singleton;
  bool showDevMessage = false;
  notify(String message) {
    var p = message.split('|');
    //  print(p);
    if (!showDevMessage && (bInDev || inLog || inLogDados))
      Timer.run(() {
        showDevMessage = true;
        final m = ['Info Dev/Log', 'Mode desenvolvimento ativado'];

        if (snackbarFunc != null) {
          snackbarFunc!(m[0], m[1]);
        } else
          Get.snackbar(
            m[0],
            m[1],
            snackPosition: SnackPosition.BOTTOM,
          );
      });
    if (p.length < 2) return super.notify(message);
    try {
      if (snackbarFunc != null) {
        snackbarFunc!(p[0], p[1]);
      } else
        Get.snackbar(
          p[0],
          p[1],
          icon: Icon(Icons.alarm),
          shouldIconPulse: true,
          snackPosition: SnackPosition.BOTTOM,
          barBlur: 20,
          isDismissible: true,
          duration: Duration(seconds: 5),
        );
    } catch (e) {
      return super.notify(message);
    }
  }
}

/// [UsuarioNotifier] stream para notificar mudança de usuário
class UsuarioNotifier extends BlocModel<SenhasItem> {
  static final _singleton = UsuarioNotifier._create();
  UsuarioNotifier._create();
  factory UsuarioNotifier() => _singleton;
}

/// [ConfigX] é de uso interno. Utitilizado somente na inciialização - usar configInstance para obter dados do [Config]
/// usado somente na inicialização - chamadas externas fazer chamada para configInstance ;
/// cria um singleton local para uso no CONSOLE - não herdar
///@selead
class ConfigX extends ConsoleConfig {
  static final _singleton = ConfigX._create();
  ConfigX._create();
  factory ConfigX() => _singleton;
  static get url => _singleton.baseUrl + _singleton.basePrefix;
  static get contaId => _singleton.conta;
}

Future<void> _configureLocalTimeZone() async {
  Intl.defaultLocale = 'pt_BR';
  tz.initializeTimeZones();
  final String timeZoneName = 'America/Sao_Paulo';
  //await platform.invokeMethod<String>('getTimeZoneName');
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}

/// instancia corrente utilizado para as configurações
/// é populada na primeira no init da estrutura
ConsoleConfig? _instance;
ConsoleConfig? get configInstance => _instance;

/// [ConsoleConfig] Informações de configuração utilizado para o CONSOLE
///
abstract class ConsoleConfig extends ConfigAppBase {
  _assert() {
    assert(_instance != null,
        'Utilize xxxx.init() antes de consumir informações de configuração ');
  }

  // get filial => _singleton.super.filial;
  ConfigItem get configuracao => ConfigItem.fromJson(super.configDados);
  set configuracao(ConfigItem row) {
    row.toJson().forEach((k, v) {
      super.configDados[k] = v;
    });
  }

  set debug(bool x) => inLog = x;
  bool get debug => inLog;

  SenhasItem get usuarioData => ((dadosUsuario.codigo != null)
      ? dadosUsuario
      : SenhasItem(
          codigo: usuario,
        ));
  static get instance => _instance;
  error(txt) {
    // developer.log(txt);
    print(txt);
    MensagemNotifier().notify(txt);
  }

  get currentInstance => configInstance;
  AppResourcesConst get resources => AppResourcesConst();
  start() {
    _instance ??= this;
    CloudV3().client.client.receiveTimeout = 15000;
    ODataInst().client.receiveTimeout = 15000;
    ODataInst().log((x) {
      if (inLog) {
        print('V3.log: $x');
      }
    });
    ODataInst().error((x) {
      // developer.log(x);
      print(x);
      MensagemNotifier().notify('$x');
    });
    CloudV3().client.log((x) {
      if (inLog) {
        print('CloudV3.log: $x');
      }
    });
    CloudV3().client.error((x) {
      print('CloudV3.Error: $x');
      MensagemNotifier().notify('CloudV3: Ops!|$x');
    });
  }

  get codigoVendedor => dadosUsuario.vendedor;
  get nomeVendedor => dadosUsuario.nome;

  String? messageId;
  SenhasItem dadosUsuario = SenhasItem.fromJson({"aplicacao": ''});

  /// init é chamada antes de iniciar a estrutura do APP
  @override
  Future<ConsoleConfig> init() async {
    if (_instance != null) return _instance!;
    _configureLocalTimeZone();
    await super.init();
    _instance ??= this;
    ODataInst().loginNotifier.stream.listen((rsp) {
      SenhasItemModel().listCached(filter: "codigo eq '$usuario'").then((r) {
        if (r.length > 0) {
          dadosUsuario = SenhasItem.fromJson(r[0]);
          Acessos().dadosUsuario = dadosUsuario;
          loginChanged.notify(this);
          UsuarioNotifier().notify(dadosUsuario);
        }
      });
    });
    this.inDev = inDev;
    if (Firebase.isFirebase) Firebase.app.init(firebaseOptions);
    pushMessageId.addListener(() {
      messageId = pushMessageId.value;
      //print(['messageId', messageId]);
    });
    return this;
  }

  /// [setLoja] de uso interno carregado apos receber dados da loja do servidor
  @override
  setLoja(String loja, {bool inDev = false}) async {
    _assert();
    if (bInDev) restServer = restInDev;
    final rst = await super.setLoja(loja, inDev: false);
    if (rst == null)
      MensagemNotifier().notify('Não logou|Usuário e/ou senha não valido(s).');
    return rst;
  }

  @override
  dispose() {
    super.dispose();
    pushMessageId.dispose();
  }

  /// [setup] executa procedimentos para concluir a estrutura de chamada. É acionado após a carga do APP e ante
  /// de iniciar a  apresentação da homeview
  @override
  setup({bool autoLogin = false}) async {
    _assert();
    //if (!inDev) {
    //initFirebase();
    //} else {
    //  queryParameters['h'] ??= 'http://localhost:8886';
    //  usuario = configInstance!.resources.contaDemo['usuario'];
    //  password = configInstance!.resources.contaDemo['senha'];
    //  conta = configInstance!.resources.contaDemo['conta'];
    //}

    if (!inLog) {
      String dbg = queryParameters['debug'] ?? '';
      inLog = dbg.contains('on') || dbg.contains('0') || dbg.contains('1');
      inLogDados = dbg.contains('1');
    }

    return super.setup(autoLogin: autoLogin).then((rsp) {
      //if (autoLogin) setLoja(loja, inDev: false);
      return this;
    });
  }

  @override
  firebaseLogin(loja, [usuario, senha]) {
    /*if (bInDev)
      return initConfigDados({
        "ativarFinancas": true,
        "agenda_intervalo": 60,
        "ativarPagamentoNoPedido": true,
        "ativarOrdemServico": true,
        "app_pet": true,
        "id": "m5",
        "agenda_horafim": "22:00",
        "ativarPedidoVenda": true,
        "ativarAgendaContato": true,
        "filial": 1,
        "nome": "Loja Teste M5",
        "ativarPrecoPorFilial": true,
        "ativarEstoque": true,
        "inativo": false,
        "ativarAgendaVeiculo": false,
        "dtatualiz": "2021-01-19T12:30:27",
        "restserver": "http://localhost:8886",
        "restserverPrefix": "/v3/",
        "agenda_horainicio": "09:00",
        "ativarControlePorFilial": true,
        "ativarAgendaPET": true,
        "smsserver": "http://sms.estouentregando.com:8080"
      });
    else */
    return super.firebaseLogin(loja, usuario, senha);
  }

  @override
  afterConfig() {
    if (super.configDados['db-driver'] != null) {
      ODataInst()
          .client
          .addHeader('db-driver', super.configDados['db-driver'] ?? 'fb');
      print(super.configDados['db-connection']);
      if (super.configDados['db-connection'] != null)
        ODataInst()
            .client
            .addHeader('db-connection', super.configDados['db-connection']);
    }
  }

  //CheckoutConfigItem? checkoutConfigItem;
  FilialItem? dadosFilial;

  /// [afterLoaded] evento executado após a confirmação do [login] indicando que tudo esta ok e pode dar sequência a inicialização
  @override
  afterLoaded(dadosLoja, lojaLogin) {
    _assert();
    //CheckoutConfigItemModel().listNoCached().then((rsp) {
    //  checkoutConfigItem = CheckoutConfigItem.fromJson(
    //      (rsp.length > 0) ? rsp[0] : {"id": configInstance!.loja});
    //});

    FilialItemModel().buscarByCodigo(filial, select: '*').then((rsp) {
      dadosFilial = FilialItem.fromJson(rsp);
    });

    // inicialia a estrutra do V3WebSocket para escutar mudança no banco de dados
    V3SocketIOConfig().init(
        url: restServer,
        contaid: conta,
        token: ODataInst().token,
        usuarioSender: this.usuario,
        driver: this.configDados['db-driver'] ?? 'fb');

    initPush();
    registerUsuarioParams(configInstance!.usuario);
    //diretivas.AppTypesList(); // init
    //if (dadosLoja['ativarAgendaPET'] ?? false) {
    //  diretivas.AppTypesList.add(diretivas.AppTypes.pet);
    //}
    //if (dadosLoja['ativarAgendaContato'] ?? false) {
    //  diretivas.AppTypesList.add(diretivas.AppTypes.agendaContato);
    //}

    DiretivasBloc().notify(DateTime.now().millisecond);
  }

  /// [initPush] Inicializa a estsrutur de PUSH
  initPush() async {
    if (!Firebase.isFirebase || !AppResourcesConst.pushEnabled) return;
    return Firebase.pushNotification(usuario, conta, userUid);
  }

  /// [firebaseAuth] realiza a autenticação no servidor google
  @override
  firebaseAuth(usuario, senha) async {
    _assert();
    var r = await Firebase.app.auth().signInAnonymously();
    userUid = Firebase.app.auth().uid;
    //print(r);
    return r;
  }

  /// [initFirebase]  iniicaliza a estrutura de acesso ao banco de dados google
  @override
  initFirebase() async {
    try {
      //return FirebaseApp().init(firebaseOptions).then((rsp) {});
    } catch (e) {
      print('Erro ao conectar firebase: $e');
    }
  }

  /// verificação de permissões com base na funçaõ
  bool get isAdmin => dadosUsuario.isAdmin ?? false;
  bool get isGestor => dadosUsuario.isGestor ?? false;
  bool get isOperador => dadosUsuario.isOperador ?? false;
  bool get isReadOnly => dadosUsuario.isReadOnly ?? true;
  bool get isVendedor => (dadosUsuario.vendedor ?? '').isNotEmpty;

  /// indica as contas que sao de DEMO.
  /// para incluir um nova conta, inserir na checagem
  bool get isDemo => (',m0,storepet,'.contains(',$conta,'));
  bool get ativarControlePorFilial => configuracao.ativarControlePorFilial;

  checkAdmin(Function() callback) {
    if (isAdmin) return callback();
    return MensagemNotifier()
        .notify('Opps... solicite a um administrador para acesso ao recurso');
  }

  checkGestor(Function() callback) {
    if (isAdmin) return callback();
    return MensagemNotifier()
        .notify('Opps... solicite a um gestor para acesso ao recurso');
  }

  checkOperador(Function() callback) {
    if (isOperador) return callback();
    return MensagemNotifier()
        .notify('Opps... solicite a um operador para acesso ao recurso');
  }

  @override
  String encrypt(txt) {
    if (txt == null) return txt;
    try {
      var x = StringEncryption(randomKey: 'console').encrypt(txt);
      //print('encrypt $txt $x');
      return x;
    } catch (e) {
      return txt;
    }
  }

  @override
  String decrypt(txt) {
    try {
      var x = StringEncryption(randomKey: 'console').decrypt(txt);
      //print('decrypt $txt $x');
      return (x == 'null' ? null : x);
    } catch (e) {
      return txt;
    }
  }
}

class DiretivasBloc extends BlocModel<int> {
  static final _singleton = DiretivasBloc._create();
  DiretivasBloc._create();
  factory DiretivasBloc() => _singleton;
}

class UsuarioAcesso {
  static bool get isFinanceiro =>
      configInstance!.dadosUsuario.aplicacao!.contains('FIN');

  static bool get isEstoque =>
      configInstance!.dadosUsuario.aplicacao!.contains('EST') ||
      configInstance!.dadosUsuario.aplicacao!.contains('SUP');
  static bool get isSupervisor =>
      configInstance!.dadosUsuario.aplicacao!.contains('SUP');
  static bool get isVendas {
    return configInstance!.dadosUsuario.aplicacao!.contains('VEN') ||
        configInstance!.dadosUsuario.aplicacao!.contains('PDV');
  }

  static bool get isWEB =>
      configInstance!.dadosUsuario.aplicacao!.contains('WEB');
}
