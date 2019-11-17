
import 'package:controls_web/services.dart';
import 'package:flutter/material.dart';

import 'views/entrada_view.dart';


class AppRouting{
  static final _singleton = AppRouting._create();
    AppRouting._create(){
    Routes().add('/menu', (ctx)=>EntradaView()  );
  }
  factory AppRouting()=> _singleton;
}

