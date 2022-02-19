// @dart=2.12

//import 'package:console/views/favoritos/register_favoritos.dart';

/// carrega configuções personalizadas do usuario apos login;
String? _ultimoUsuario;
registerUsuarioParams(String usuario) {
  if (_ultimoUsuario == null) {
    //print('carregando configurações do usuario  $usuario ');
    //  favoritosLoad(usuario);
    _ultimoUsuario = usuario;
  }
}
