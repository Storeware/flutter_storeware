import 'package:app/models/constantes.dart';
import 'package:flutter/material.dart';

class Menu {
  static final _singleton = Menu._create();
  factory Menu()=>_singleton;
  Menu._create() {
    init();
  }
  init(){
  }

  static builder(){
    return ListView(children:[]);
  }

  static Widget profile() {
    return Column(
     children:[
       Image.network(Constantes.imagemEntrar),
       Text('Nome:')
     ]
    );
  }


}
