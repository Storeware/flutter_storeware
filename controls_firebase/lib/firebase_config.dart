import 'dart:convert';
import 'package:flutter/services.dart';

String bdUserLogged = '';

class AssetsConfig {
  static final _config = AssetsConfig._create();

  AssetsConfig._create();
  factory AssetsConfig() => _config;

  Map<String, dynamic>? config;
  get cfg => config!['firebase'];
  get webhook => config!['webhook'];

  static String? get projectId => _config.cfg['projectId'];
  static String? get apiKey => _config.cfg['apiKey'];
  static String? get authDomain => _config.cfg['authDomain'];
  static String? get databaseURL => _config.cfg['databaseURL'];
  static String? get storageBucket => _config.cfg['storageBucket'];
  static String? get messagingSenderId => _config.cfg['messagingSenderId'];
  static String? get appId => _config.cfg['appId'];

  load() async {
    if (config != null) return config;
    try {
      await rootBundle.loadString('config.json').then((f) {
        config = jsonDecode(f);
        //print('Carregrou config: '+f);
        return config;
      });
    } catch (e) {}

    return config;
  }
}

class FirebaseConfig {
  static final _singleton = FirebaseConfig._create();
  bool _inited = false;
  FirebaseConfig._create();
  factory FirebaseConfig() => _singleton;
  static AssetsConfig get config => AssetsConfig();
  static get functionUrl {
    String id = AssetsConfig.projectId!;
    return 'https://us-central1-$id.cloudfunctions.net';
  }

  static init() async {
    if (!_singleton._inited) await AssetsConfig().load();
    _singleton._inited = true;
    return AssetsConfig().config;
  }
}
