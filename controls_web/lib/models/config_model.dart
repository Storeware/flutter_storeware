import "dart:convert";
import "package:controls_data/local_storage.dart";

/// instance utilizada para criar ao entrar,
/// na sequencia usar a mesma instancia
/// do objeto
ConfigModel configModel;

/// ConfigModel é base um classe de aplicativo
///   fazer herança e implementar seus atributos
///   individuais.
/// Em aplicatiovos Web utilizad de LocalStorage
///   para persistir as configurações locais
/// ConfigModel a ser herdada,
/// instanciar na entrada e
/// na sequencia, usar configModel para acesso
/// Auth: AL - Agosto/2019
///       * 23/09/2019 - alterado para ser abstract
abstract class ConfigModel extends LocalStorageModel {
  ConfigModel() {
    assert(configModel == null, "Não pode utilizar ConfigModel direto");
    //print('create instance of ConfigModel');
    configModel = this;
    this.storageName = 'config';
    restore();
  }
  static instance() => configModel;
  fromMap(m) {
    appBarElevation = m['appBarElevation'] ?? 0;
    lang = m['lang'] ?? 'pt_br';
    return this;
  }

  toJson() {
    return {
      "appBarElevation": appBarElevation,
      "lang": lang,
      "langlist": json.encode(langList),
    };
  }

  int appBarElevation;
  String lang;
  List<String> langList = ['pt_br', 'en_us'];
}
