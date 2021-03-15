import 'package:controls_data/local_storage.dart';
import 'package:controls_web/services/routes.dart';
import '../views/left_menu.dart';
import 'package:flutter/material.dart';

class LeftMenuItems {
  static final _singleton = LeftMenuItems._create();
  LeftMenuItems._create() {
    _init();
  }
  factory LeftMenuItems() => _singleton;
  BuildContext? context;
  List<LeftMenuItem> items = [];
  bool get visible => (LocalStorage().getKey('leftMenu') ?? '1') == '1';
  set visible(bool x) {
    LocalStorage().setKey('leftMenu', x ? '1' : '0');
  }

  _init() {
    // inicialização
    items.add(LeftMenuItem(
        title: 'Produtos',
        icon: Icon(Icons.web),
        onPressed: () {
          Routes.pushNamed(context, '/produtos');
        }));
  }
}
