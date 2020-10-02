import 'package:controls_web/controls/image_links.dart';
//import 'package:controls_web/controls/responsive.dart';
import 'package:flutter/material.dart';

class Usuario {
  String codigo, nome, grupo, caixa;
  Usuario.fromJson(json) {
    codigo = json['codigo'];
    nome = json['nome'];
    grupo = json['grupo'];
    caixa = json['caixa'];
  }
  toJson() {
    return {"codigo": codigo, "nome": nome, "grupo": grupo, "caixa": caixa};
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text('Opções')),
    );
  }
}

class ProfileUser extends StatelessWidget {
  final Widget image;
  final Usuario usuario;
  final double filial;
  final String versao;
  const ProfileUser(
      {Key key, this.image, this.usuario, this.filial, this.versao})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    // ResponsiveInfo responsive = ResponsiveInfo(context);
    return LayoutBuilder(
      builder: (a, b) => Container(
        alignment: Alignment.topCenter,
        width: b.maxWidth,
        height: 150, // responsive.size.height - 70,
        color: theme.primaryColor.withAlpha(40),
        child: Stack(children: [
          Positioned(
            top: 40,
            child: Container(
                height: 120,
                color: theme.primaryColor.withAlpha(70),
                width: b.maxWidth,
                child: Column(children: [
                  SizedBox(
                    height: 30,
                  ),
                  Text(usuario.nome ?? ''),
                  Text(usuario.grupo ?? ''),
                  Text(usuario.codigo ?? ''),
                ])),
          ),
          Positioned(
            top: 20,
            child: Container(
              width: b.maxWidth,
              child: Align(
                alignment: Alignment.center,
                child: CircleAvatar(
                  child: image ?? ImageLinks.image('Avatar'),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class DrawerTile extends StatelessWidget {
  final Widget leading;
  final Widget trailing;

  final Widget image;
  final String title;
  final Widget subtitle;
  final bool enabled;
  final Function() onPressed;

  DrawerTile(
      {this.image,
      @required this.title,
      this.onPressed,
      this.leading,
      this.trailing,
      this.enabled = true,
      this.subtitle});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color _color = (enabled) ? theme.popupMenuTheme.color : theme.dividerColor;

    return ListTile(
      onTap: (!enabled)
          ? null
          : () {
              if (onPressed != null) onPressed();
            },
      leading: leading ?? image,
      title: Text(
        title,
        style: theme.textTheme.caption.copyWith(
          fontSize: 14,
          color: _color,
        ),
      ),
      subtitle: subtitle,
      trailing: trailing ?? Icon(Icons.chevron_right),
    );
  }
}
