import 'package:controls_web/controls/main_menu.dart';

import 'package:flutter/material.dart';
import '../views/left_menu.dart';
import 'left_menu_items.dart';

class MainMenuDrawerApp {
  static final _singleton = MainMenuDrawerApp._create();
  MenuModel get menu => MenuModel();
  MainMenuDrawerApp._create() {
    _init();
  }
  factory MainMenuDrawerApp() => _singleton;

  /// inicializa os items do drawer
  _init() {
    menu.add(MenuItem('Mostrar/Esconder Menu', (c) {
      Navigator.of(c).pop();
      LeftMenuItems().visible = !LeftMenuItems().visible;
      LeftMenuVisibleNotifier().notify(LeftMenuItems().visible);
    }));
  }
}
