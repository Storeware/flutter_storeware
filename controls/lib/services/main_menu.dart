import 'package:controls/drivers/data_model.dart';
import 'package:controls/framework.dart';
import 'package:controls/controls.dart';
import 'package:controls/services/routes.dart';
import 'package:controls/models/login.model.dart';
//import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

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
  final Widget logo;
  MainMenu(
      {Key key,
      this.title,
      this.items,
      this.init,
      this.extended,
      this.appBarElevation = 0,
      this.actions,
      this.logo,
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
    return SliverScaffold(
        body: ListView(children: _create(widget.items)),
        bottomNavigationBar:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          InkWell(
            onTap: () {
             /* WebviewScaffold(
                url: "http://wbagestao.com.br",
                appBar: new AppBar(
                  title: new Text("Storeware"),
                ),
              );*/
            },
            child: Container(
                width: MediaQuery.of(context).size.width * 0.7,
                alignment: Alignment.center,
                height: 60,
                child: widget.logo ??
                    Image.asset('assets/wba.png',
                        height: 50,
                        color: Theme.of(context).primaryColor.withAlpha(200))),
          )
        ]));
  }

  List<Widget> _create(items) {
    List<Widget> rt = [
      AppBar(
          elevation: widget.appBarElevation,
          title: widget.title ?? Text('Ações'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      DrawerHeader(
          padding: EdgeInsets.all(0),
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withAlpha(20)),
          child: widget.extended ??
              PanelUserTile(title: 'Ações', actions: widget.actions))
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
  MenuItem setPerfil(perfil_) {
    this.perfil = perfil_;
    return this;
  }

  bool isPerfil(perfil_) {
    return this.perfil.contains(perfil_);
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
  MenuModel._create() {}
  item(int idx) => _list[idx];

  add(MenuItem item) {
    this._list.add(item);
    return this;
  }

  static MenuItem addDivider() {
    of().add(MenuItem('-', (x) {}));
  }

  static MenuItem addItem(String text, Function(BuildContext) click,
      {Widget icon, String route, bool logged}) {
    MenuItem rt = MenuItem(text, click, icon: icon, logged: logged);
    of().add(rt);
    if (route != null) {
      Routes().add(route, click);
    }
    return rt;
  }

  get length => _list.length;
}
