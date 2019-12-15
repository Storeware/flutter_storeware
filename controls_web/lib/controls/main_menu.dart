import 'package:controls_data/data_model.dart';
import 'panel.dart';
import 'package:flutter/material.dart';
import '../services/routes.dart';
import '../models/login.model.dart';

/// MainMenu cria a navegação de um menu VERTICAL
/// extended -> um objeto para fazer identificação de usuário e outros
/// title -> titulo da grupo de menu;
/// userPerfil -> passa o perfil do usuario, utilizado para selecionar os itens a serem mostrados
/// items -> são os itens de menu a serem mostrados
class MainMenu extends StatefulWidget {
  final List<MenuItem> items;
  final Widget title;
  final Widget extended;
  final Function(BuildContext) init;
  final double appBarElevation;
  final List<Widget> actions;
  final String userPerfil;
  final Widget child;
  MainMenu(
      {Key key,
      this.title,
      this.child,
      this.items,
      this.init,
      this.extended,
      this.appBarElevation = 0,
      this.actions,
      this.userPerfil = 'all'})
      : super(key: key);
  _MainMenuState createState() => _MainMenuState();

  static MainMenu builder(context,
      {@required int itemCount,
      @required MenuItem Function(BuildContext, int) itemBuilder,
      Widget title,
      Widget extended,
      @required String userPerfil}) {
    List<MenuItem> l = [];
    for (var i = 0; i < itemCount; i++) {
      l.add(itemBuilder(context, i));
    }
    return MainMenu(
      items: l,
      title: title,
      extended: extended,
      userPerfil: userPerfil,
    );
  }
}

class _MainMenuState extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    if (widget.init != null) widget.init(context);
    return ListView(children: _create(widget.items));
  }

  List<Widget> _create(items) {
    List<Widget> rt = [
      AppBar(
        backgroundColor: Colors.transparent,
        elevation: widget.appBarElevation,
        title: widget.title ?? Text('Ações'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: widget.actions,
      ),
      DrawerHeader(
          padding: EdgeInsets.all(0),
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withAlpha(20)),
          child: Column(children: [
            widget.extended ??
                PanelUserTile(
                    user: widget.child, title: 'Ações', actions: widget.actions)
          ]))
    ];
    List<MenuItem> items = MenuModel().items;
    for (var i = 0; i < items.length; i++) {
      if (items[i].isPerfil(widget.userPerfil))
        rt.add(_menuItem(context, items[i]));
    }
    return rt;
  }

  Widget _menuItem(context, MenuItem item) {
    if (item.logged != null) {
      if (LoginModel().logado != item.logged) return Container();
    }
    List<MenuItem> items = item.items;
    if (items == null) {
      if (item.text == '-') {
        return menuDivider();
      } else
        return ListTile(
          title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Container(width: 30, child: item.icon),
            Text(item.text)
          ]),
          onTap: () {
            item.onclick(context);
          },
          trailing: Icon(Icons.chevron_right),
        );
    } else {
      List<Widget> menus = [];
      for (var i = 0; i < items.length; i++) {
        MenuItem item = items[i];
        if (item.text == '-') {
          menus.add(menuDivider());
        } else if (item.isPerfil(widget.userPerfil)) {
          Widget wg = PopupMenuItem<String>(
              value: item.text,
              child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                  dense: true,
                  selected: item.selected,
                  //leading: item.icon,
                  subtitle: item.subtitle,
                  title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(width: 30, child: item.icon),
                        Text(item.text)
                      ]),
                  onTap: () {
                    if (item.acesso > 0) {
                      if (!PermissionsList.enabled(item.acesso)) return;
                    }
                    item.onclick(context);
                  }));
          menus.add(wg);
        }
      }
      return ExpansionTile(
        //leading: item.icon,
        title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Container(width: 30, child: item.icon),
          Text(item.text)
        ]),
        children: menus,
      );
    }
  }

  menuDivider() {
    return Container(
        height: 1,
        width: double.maxFinite,
        color: Theme.of(context).dividerColor);
  }
}

class Permission {
  double acesso;
  int flag;
  Permission(double acesso, int flag) {
    this.acesso = acesso;
    this.flag = flag;
  }
}

class PermissionsList {
  static final _singleton = PermissionsList._create();
  List<Permission> _acessos = [];
  PermissionsList._create();
  factory PermissionsList() => _singleton;
  add(double acesso, int permission) {
    _acessos.add(Permission(acesso, permission));
  }

  clear() {
    _acessos.clear();
  }

  int indexOf(double acesso) {
    for (var i = 0; i < _acessos.length; i++) {
      if (_acessos[i].acesso == acesso) return i;
    }
    return -1;
  }

  get items => _acessos;
  static bool enabled(double acesso) {
    int r = _singleton.indexOf(acesso);
    if (r >= 0) return _singleton.items[r].flag == 0;
    return false;
  }
}

/// MenuItem representa as propriedades de um item de menu
/// perfil -> pode ser uma lista separado por "|" indicando quais perfis de usuarios tem acesso
/// acesso -> id de acesso do item de menu, reservado para implementar acessibilidade
class MenuItem extends DataModelItem {
  String text;
  String perfil;
  final Widget icon;
  Widget subtitle;
  final Function onclick;
  List<MenuItem> items;
  bool selected;
  double acesso;
  bool logged;
  MenuItem(this.text, this.onclick,
      {this.icon,
      this.logged,
      this.subtitle,
      this.perfil = 'all',
      this.selected = false,
      this.acesso = 0.0});
  MenuItem setPerfil(perfil) {
    this.perfil = perfil;
    return this;
  }

  bool isPerfil(perfil) {
    return this.perfil.contains(perfil);
  }

  MenuItem setAcesso(double acesso) {
    this.acesso = acesso;
    return this;
  }
}

class MenuModel {
  static MenuModel _instance;
  final List<MenuItem> _list = [];

  factory MenuModel({Function creator}) {
    if (_instance == null) {
      _instance = MenuModel._create(); // Causes singleton instantiation
      if (creator != null) creator();
    }
    return _instance;
  }
  static of() {
    return MenuModel();
  }

  get items => _list;
  MenuModel._create();
  item(int idx) => _list[idx];

  add(MenuItem item) {
    this._list.add(item);
    return this;
  }

  static MenuItem addDivider() {
    MenuItem item = MenuItem('-', (x) {});
    _instance.add(item);
    return item;
  }

  static MenuItem addItem(String text, Function(BuildContext) click,
      {Widget icon, String route, bool logged}) {
    MenuItem rt = MenuItem(text, click, icon: icon, logged: logged);
    _instance.add(rt);
    if (route != null) {
      Routes().add(route, (context) {
        return click(context); //????
      });
    }
    return rt;
  }

  get length => _list.length;
}
