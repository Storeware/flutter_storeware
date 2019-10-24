import "dart:convert";
import "package:controls/drivers/local_storage.dart";

/// instance utilizada para criar ao entrar,
/// na sequencia usar a mesma instancia
/// do objeto
ConfigModel configModel;

/// Class config a ser herdada,
/// instanciar na entrada e
/// na sequencia, usar configModel para acesso
class ConfigModel extends LocalStorageModel {
  ConfigModel() {
    assert(configModel==null,"Não pode utilizar ConfigModel direto");
    print('create instance of ConfigModel');
    configModel = this;
    this.storageName = 'config';
    restore();
  }
  static instance() => configModel;
  fromMap(m) {
    appBarElevation = m['appBarElevation'] ?? 0;
    lang = m['lang'] ?? 'pt_br';
    //langList = m['langlist'] ?? ['pt_br', 'en_us'];
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
