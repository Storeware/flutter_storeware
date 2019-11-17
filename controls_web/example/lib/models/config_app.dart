

import 'package:controls_web/models/config_model.dart';

class ConfigApp extends ConfigModel{
  static final _singleton = ConfigApp._create();
  ConfigApp._create();
  factory ConfigApp(){
    return _singleton;
  }
}