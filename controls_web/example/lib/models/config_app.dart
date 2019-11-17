

import 'package:controls_web/controls/defaults.dart';
import 'package:controls_web/models/config_model.dart';

class ConfigApp extends ConfigModel{
  static final _singleton = ConfigApp._create();
  ConfigApp._create(){
    _init();
  }
  factory ConfigApp(){
    return _singleton;
  }
  _init(){
    default_topScaffoldRadius = 0;
    default_elevation = 0;
  }
}